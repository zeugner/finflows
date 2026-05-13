######################### F51M LP BALANCER FUNCTION #########################
# Source this script from your main pipeline script.
#
# Usage:
#   source(file.path(script_dir, "domestic/f51m_lp_balancer.R"))
#   aall <- balance_f51m(aall, countries, periods, w_disc=100, w_pen=1, verbose=TRUE)
#
# Arguments:
#   aall      : the md3 matrix object
#   countries : character vector of REF_AREA codes
#   periods   : character vector of TIME periods (e.g. "1999q4", "2000q1", ...)
#   w_disc    : weight on row/col discrepancies in objective (default 100)
#   w_pen     : weight on deviation from observed values (default 1)
#   verbose   : if TRUE, print per-country-period results; if FALSE, only summary
#
# Returns:
#   aall with balancing cells updated for all countries and periods
# ============================================================================

library(lpSolve)
library(data.table)

balance_f51m <- function(aall,
                         countries,
                         periods,
                         w_disc   = 100,
                         w_pen    = 1,
                         verbose  = TRUE) {
  
  sub_sectors <- c("S1M","S11","S13","S121","S12T","S124","S12Q","S12O")
  all_sectors <- c("S1", sub_sectors)
  n_sec       <- length(sub_sectors)
  
  # =================================================================
  # (A) BALANCING CELLS — edit here
  # =================================================================
  balancing_cells <- c(
    "S1M.S11",
    "S11.S12T",
    "S1M.S12O",
    "S124.S11",
    "S121.S11",
    "S12T.S12O",
    "S11.S12O",
    "S12O.S11",
    "S12O.S12T",
    "S12O.S12Q",
    "S13.S12O"
  )
  
  n_bal <- length(balancing_cells)
  
  # -----------------------------------------------------------------
  # HELPER: run balancer for one country/period
  # Returns list(aall, status, disc_before, disc_after)
  # -----------------------------------------------------------------
  balance_one <- function(aall, country, period) {
    
    zf <- function(x) ifelse(is.na(x), 0, x)
    
    # --- extract matrix ---
    slice_id <- sprintf(
      "F51M.%s.%s.%s.LE._S.%s",
      country,
      paste(all_sectors, collapse="+"),
      paste(all_sectors, collapse="+"),
      period
    )
    
    slice_dt <- tryCatch(
      as.data.table(aall[slice_id], .simple=TRUE),
      error = function(e) NULL
    )
    
    if (is.null(slice_dt) || nrow(slice_dt) == 0)
      return(list(aall=aall, status="no_data",
                  disc_before=NA, disc_after=NA))
    
    m_wide <- dcast(slice_dt, REF_SECTOR ~ COUNTERPART_SECTOR,
                    value.var="obs_value")
    m      <- as.matrix(m_wide[, -1, with=FALSE])
    rownames(m) <- m_wide$REF_SECTOR
    
    # ensure all expected sectors present
    missing_r <- setdiff(all_sectors, rownames(m))
    missing_c <- setdiff(all_sectors, colnames(m))
    if (length(missing_r) > 0) {
      extra <- matrix(NA, nrow=length(missing_r), ncol=ncol(m),
                      dimnames=list(missing_r, colnames(m)))
      m <- rbind(m, extra)
    }
    if (length(missing_c) > 0) {
      extra <- matrix(NA, nrow=nrow(m), ncol=length(missing_c),
                      dimnames=list(rownames(m), missing_c))
      m <- cbind(m, extra)
    }
    m <- m[all_sectors, all_sectors]
    
    g <- function(r, c) zf(m[r, c])
    
    # --- observed balancing cell values ---
    obs_vals <- numeric(n_bal)
    for (i in seq_along(balancing_cells)) {
      parts        <- strsplit(balancing_cells[i], "\\.")[[1]]
      obs_vals[i]  <- g(parts[1], parts[2])
    }
    
    # --- fixed sums (non-balancing cells) per row and col ---
    fixed_row <- setNames(numeric(n_sec), sub_sectors)
    fixed_col <- setNames(numeric(n_sec), sub_sectors)
    for (r in sub_sectors)
      fixed_row[r] <- sum(sapply(sub_sectors, function(c)
        if (paste(r,c,sep=".") %in% balancing_cells) 0 else g(r,c)))
    for (c in sub_sectors)
      fixed_col[c] <- sum(sapply(sub_sectors, function(r)
        if (paste(r,c,sep=".") %in% balancing_cells) 0 else g(r,c)))
    
    # --- discrepancy helper (raw anchors, NA preserved) ---
    discrepancy_table <- function(mat) {
      sub     <- mat[sub_sectors, sub_sectors]
      row_sum <- rowSums(zf(sub))
      col_sum <- colSums(zf(sub))
      row_tot <- m[sub_sectors, "S1"]
      col_tot <- m["S1", sub_sectors]
      rbind(
        rows = row_sum - zf(row_tot),
        cols = col_sum - zf(col_tot)
      )
    }
    
    disc_before <- discrepancy_table(m)
    
    # --- variable indices ---
    x_idx <- seq_len(n_bal)
    d_idx <- n_bal + seq_len(n_bal)
    e_idx <- 2*n_bal + seq_len(n_sec)
    f_idx <- 2*n_bal + n_sec  + seq_len(n_sec)
    p_idx <- 2*n_bal + 2*n_sec + seq_len(n_sec)
    q_idx <- 2*n_bal + 3*n_sec + seq_len(n_sec)
    n_lp_vars <- 2*n_bal + 4*n_sec
    
    obj        <- rep(0, n_lp_vars)
    obj[d_idx] <- w_pen
    obj[e_idx] <- w_disc
    obj[f_idx] <- w_disc
    obj[p_idx] <- w_disc
    obj[q_idx] <- w_disc
    
    con_mat <- matrix(0, nrow=0, ncol=n_lp_vars)
    con_dir <- character(0)
    con_rhs <- numeric(0)
    
    add_con <- function(row, dir, rhs) {
      con_mat <<- rbind(con_mat, row)
      con_dir <<- c(con_dir, dir)
      con_rhs <<- c(con_rhs, rhs)
    }
    
    # row constraints (skip if anchor is NA)
    for (j in seq_along(sub_sectors)) {
      r <- sub_sectors[j]
      if (is.na(m[r, "S1"])) next
      row <- rep(0, n_lp_vars)
      for (i in seq_along(balancing_cells)) {
        parts <- strsplit(balancing_cells[i], "\\.")[[1]]
        if (parts[1] == r) row[x_idx[i]] <- 1
      }
      row[e_idx[j]] <- -1
      row[f_idx[j]] <-  1
      add_con(row, "=", m[r,"S1"] - fixed_row[r])
    }
    
    # col constraints (skip if anchor is NA)
    for (k in seq_along(sub_sectors)) {
      c <- sub_sectors[k]
      if (is.na(m["S1", c])) next
      row <- rep(0, n_lp_vars)
      for (i in seq_along(balancing_cells)) {
        parts <- strsplit(balancing_cells[i], "\\.")[[1]]
        if (parts[2] == c) row[x_idx[i]] <- 1
      }
      row[p_idx[k]] <- -1
      row[q_idx[k]] <-  1
      add_con(row, "=", m["S1",c] - fixed_col[c])
    }
    
    # penalty linearisation |x_i - obs_i| <= d_i
    for (i in seq_len(n_bal)) {
      r1 <- rep(0, n_lp_vars); r1[x_idx[i]] <-  1; r1[d_idx[i]] <- -1
      r2 <- rep(0, n_lp_vars); r2[x_idx[i]] <- -1; r2[d_idx[i]] <- -1
      add_con(r1, "<=",  obs_vals[i])
      add_con(r2, "<=", -obs_vals[i])
    }
    
    # non-negativity of balancing cells
    for (i in seq_len(n_bal)) {
      row <- rep(0, n_lp_vars); row[x_idx[i]] <- -1
      add_con(row, "<=", 0)
    }
    
    # non-negativity of slacks
    for (idx in c(d_idx, e_idx, f_idx, p_idx, q_idx)) {
      row <- rep(0, n_lp_vars); row[idx] <- -1
      add_con(row, "<=", 0)
    }
    
    # --- solve ---
    lp_res <- lp("min", obj, con_mat, con_dir, con_rhs)
    
    if (lp_res$status != 0)
      return(list(aall=aall, status="lp_failed",
                  disc_before=disc_before, disc_after=NA))
    
    sol_vals <- lp_res$solution[x_idx]
    
    # --- build solved matrix ---
    m_sol <- m
    for (i in seq_along(balancing_cells)) {
      parts <- strsplit(balancing_cells[i], "\\.")[[1]]
      m_sol[parts[1], parts[2]] <- sol_vals[i]
    }
    
    disc_after <- discrepancy_table(m_sol)
    
    # --- write back to aall ---
    for (fc_apply in c("_T","_S")) {
      for (i in seq_along(balancing_cells)) {
        parts <- strsplit(balancing_cells[i], "\\.")[[1]]
        sid   <- sprintf("F51M.%s.%s.%s.LE.%s.%s",
                         country, parts[1], parts[2], fc_apply, period)
        aall[sid] <- sol_vals[i]
      }
    }
    
    list(aall        = aall,
         status      = "ok",
         disc_before = disc_before,
         disc_after  = disc_after,
         m           = m,
         m_sol       = m_sol,
         sol_vals    = sol_vals)
  }
  
  # =================================================================
  # MAIN LOOP
  # =================================================================
  total_pairs    <- length(countries) * length(periods)
  n_ok           <- 0
  n_no_data      <- 0
  n_lp_failed    <- 0
  sum_disc_before <- 0
  sum_disc_after  <- 0
  
  cat(sprintf(
    "\n=== F51M LP BALANCER: %d countries x %d periods = %d runs ===\n",
    length(countries), length(periods), total_pairs
  ))
  
  for (country in countries) {
    for (period in periods) {
      
      res <- balance_one(aall, country, period)
      aall <- res$aall
      
      if (res$status == "no_data") {
        n_no_data <- n_no_data + 1
        if (verbose)
          cat(sprintf("  [%-6s %s] no data\n", country, period))
        next
      }
      
      if (res$status == "lp_failed") {
        n_lp_failed <- n_lp_failed + 1
        cat(sprintf("  [%-6s %s] LP FAILED\n", country, period))
        next
      }
      
      n_ok <- n_ok + 1
      
      db <- sum(abs(res$disc_before), na.rm=TRUE)
      da <- sum(abs(res$disc_after),  na.rm=TRUE)
      sum_disc_before <- sum_disc_before + db
      sum_disc_after  <- sum_disc_after  + da
      
      if (verbose) {
        cat(sprintf(
          "  [%-6s %s] disc before=%.2f  after=%.2f  improvement=%.2f\n",
          country, period, db, da, db - da
        ))
        
        if (db > 0 && da > db) {
          cat(sprintf(
            "  WARNING: discrepancy increased for %s %s\n",
            country, period
          ))
        }
      }
    }
  }
  
  cat(sprintf("\n=== SUMMARY ===\n"))
  cat(sprintf("  Runs OK:        %d\n", n_ok))
  cat(sprintf("  No data:        %d\n", n_no_data))
  cat(sprintf("  LP failed:      %d\n", n_lp_failed))
  cat(sprintf("  Total |disc| before: %.2f\n", sum_disc_before))
  cat(sprintf("  Total |disc| after:  %.2f\n", sum_disc_after))
  cat(sprintf("  Total improvement:   %.2f\n", sum_disc_before - sum_disc_after))
  
  invisible(aall)
}