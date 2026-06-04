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
#   aall with balancing cells updated for all countries and periods.
#   A data.frame named 'f51m_error_log' is assigned to the GLOBAL environment,
#   containing one row per failed country-period combination with columns:
#     REF_AREA, TIME, stage, error_message
#   Print or inspect it after the call:
#     print(f51m_error_log)
#     write.csv(f51m_error_log, "f51m_errors.csv", row.names=FALSE)
#
# Error handling:
#   - balance_one()  : wrapped in tryCatch; failures logged, loop continues
#   - as.md3()       : wrapped in tryCatch; write-back failures logged separately
#   - Both stages assign a 'stage' label so you know exactly where the error occurred
#
# Performance notes:
#   - strsplit results are cached at startup (not recomputed per solve)
#   - constraint matrix is pre-allocated (no rbind in loop)
#   - row/col membership maps are pre-computed
#   - Inf values are coerced to NA before solving
#   - write-back is batched: all results accumulated during the loop,
#     then written to aall in a single md3 assignment at the end
#     (avoids ~90s per solve from repeated individual md3 writes)
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
  # PRE-COMPUTE: cache strsplit and membership maps once (not per solve)
  # -----------------------------------------------------------------
  bal_parts <- strsplit(balancing_cells, "\\.", fixed = FALSE)
  bal_rows  <- vapply(bal_parts, `[[`, character(1), 1)
  bal_cols  <- vapply(bal_parts, `[[`, character(1), 2)
  
  bal_row_map <- lapply(sub_sectors, function(r) which(bal_rows == r))
  bal_col_map <- lapply(sub_sectors, function(c) which(bal_cols == c))
  names(bal_row_map) <- sub_sectors
  names(bal_col_map) <- sub_sectors
  
  # -----------------------------------------------------------------
  # PRE-COMPUTE: LP variable layout (constant across all solves)
  # -----------------------------------------------------------------
  x_idx <- seq_len(n_bal)
  d_idx <- n_bal + seq_len(n_bal)
  e_idx <- 2*n_bal + seq_len(n_sec)
  f_idx <- 2*n_bal + n_sec   + seq_len(n_sec)
  p_idx <- 2*n_bal + 2*n_sec + seq_len(n_sec)
  q_idx <- 2*n_bal + 3*n_sec + seq_len(n_sec)
  n_lp_vars <- 2*n_bal + 4*n_sec
  
  obj        <- rep(0, n_lp_vars)
  obj[d_idx] <- w_pen
  obj[e_idx] <- w_disc
  obj[f_idx] <- w_disc
  obj[p_idx] <- w_disc
  obj[q_idx] <- w_disc
  
  n_con_max <- 2*n_sec + 2*n_bal + n_bal + (2*n_bal + 4*n_sec)
  
  zf <- function(x) ifelse(is.na(x), 0, x)
  
  # =================================================================
  # ERROR LOG — accumulated throughout; written to global env at end
  # =================================================================
  error_log <- data.table(
    REF_AREA      = character(),
    TIME          = character(),
    stage         = character(),   # "solve" | "writeback_md3" | "writeback_assign"
    error_message = character()
  )
  
  log_error <- function(country, period, stage, msg) {
    error_log <<- rbind(error_log, data.table(
      REF_AREA      = country,
      TIME          = period,
      stage         = stage,
      error_message = as.character(msg)
    ))
    cat(sprintf("  [%-6s %s] ERROR in %-20s: %s\n",
                country, period, stage, msg))
  }
  
  # -----------------------------------------------------------------
  # HELPER: run balancer for one country/period
  # Returns a named list; status is one of: "ok", "no_data", "lp_failed"
  # -----------------------------------------------------------------
  balance_one <- function(aall, country, period) {
    
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
      return(list(status="no_data"))
    
    m_wide <- dcast(slice_dt, REF_SECTOR ~ COUNTERPART_SECTOR,
                    value.var="obs_value")
    m      <- as.matrix(m_wide[, -1, with=FALSE])
    rownames(m) <- m_wide$REF_SECTOR
    
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
    
    m[is.infinite(m)] <- NA
    
    obs_vals <- numeric(n_bal)
    for (i in seq_len(n_bal))
      obs_vals[i] <- zf(m[bal_rows[i], bal_cols[i]])
    
    fixed_row <- setNames(numeric(n_sec), sub_sectors)
    fixed_col <- setNames(numeric(n_sec), sub_sectors)
    for (r in sub_sectors) {
      non_bal_cols <- setdiff(sub_sectors, bal_cols[bal_row_map[[r]]])
      fixed_row[r] <- sum(zf(m[r, non_bal_cols]))
    }
    for (c in sub_sectors) {
      non_bal_rows <- setdiff(sub_sectors, bal_rows[bal_col_map[[c]]])
      fixed_col[c] <- sum(zf(m[non_bal_rows, c]))
    }
    
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
    
    con_mat <- matrix(0, nrow = n_con_max, ncol = n_lp_vars)
    con_dir <- character(n_con_max)
    con_rhs <- numeric(n_con_max)
    crow    <- 0L
    
    for (j in seq_along(sub_sectors)) {
      r <- sub_sectors[j]
      if (is.na(m[r, "S1"])) next
      crow <- crow + 1L
      con_mat[crow, x_idx[bal_row_map[[r]]]] <- 1
      con_mat[crow, e_idx[j]] <- -1
      con_mat[crow, f_idx[j]] <-  1
      con_dir[crow] <- "="
      con_rhs[crow] <- m[r, "S1"] - fixed_row[r]
    }
    
    for (k in seq_along(sub_sectors)) {
      c <- sub_sectors[k]
      if (is.na(m["S1", c])) next
      crow <- crow + 1L
      con_mat[crow, x_idx[bal_col_map[[c]]]] <- 1
      con_mat[crow, p_idx[k]] <- -1
      con_mat[crow, q_idx[k]] <-  1
      con_dir[crow] <- "="
      con_rhs[crow] <- m["S1", c] - fixed_col[c]
    }
    
    for (i in seq_len(n_bal)) {
      crow <- crow + 1L
      con_mat[crow, x_idx[i]] <-  1
      con_mat[crow, d_idx[i]] <- -1
      con_dir[crow] <- "<="
      con_rhs[crow] <-  obs_vals[i]
      
      crow <- crow + 1L
      con_mat[crow, x_idx[i]] <- -1
      con_mat[crow, d_idx[i]] <- -1
      con_dir[crow] <- "<="
      con_rhs[crow] <- -obs_vals[i]
    }
    
    for (i in seq_len(n_bal)) {
      crow <- crow + 1L
      con_mat[crow, x_idx[i]] <- -1
      con_dir[crow] <- "<="
      con_rhs[crow] <- 0
    }
    
    for (idx in c(d_idx, e_idx, f_idx, p_idx, q_idx)) {
      crow <- crow + 1L
      con_mat[crow, idx] <- -1
      con_dir[crow] <- "<="
      con_rhs[crow] <- 0
    }
    
    con_mat <- con_mat[seq_len(crow), , drop = FALSE]
    con_dir <- con_dir[seq_len(crow)]
    con_rhs <- con_rhs[seq_len(crow)]
    
    lp_res <- lp("min", obj, con_mat, con_dir, con_rhs)
    
    if (lp_res$status != 0)
      return(list(status="lp_failed",
                  disc_before=disc_before))
    
    sol_vals <- lp_res$solution[x_idx]
    
    m_sol <- m
    for (i in seq_len(n_bal))
      m_sol[bal_rows[i], bal_cols[i]] <- sol_vals[i]
    
    disc_after <- discrepancy_table(m_sol)
    
    list(status      = "ok",
         disc_before = disc_before,
         disc_after  = disc_after,
         sol_vals    = sol_vals)
  }
  
  # =================================================================
  # MAIN LOOP — solve only, accumulate results
  # =================================================================
  total_pairs     <- length(countries) * length(periods)
  n_ok            <- 0
  n_no_data       <- 0
  n_lp_failed     <- 0
  n_solve_error   <- 0
  sum_disc_before <- 0
  sum_disc_after  <- 0
  
  results_list <- vector("list", total_pairs)
  n_results    <- 0L
  
  cat(sprintf(
    "\n=== F51M LP BALANCER: %d countries x %d periods = %d runs ===\n",
    length(countries), length(periods), total_pairs
  ))
  
  for (country in countries) {
    for (period in periods) {
      
      # ---- wrap the entire solve in tryCatch ----
      res <- tryCatch(
        balance_one(aall, country, period),
        error = function(e) {
          list(status = "solve_error", msg = conditionMessage(e))
        }
      )
      
      if (res$status == "solve_error") {
        n_solve_error <- n_solve_error + 1
        log_error(country, period, "solve", res$msg)
        next
      }
      
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
      
      # status == "ok"
      n_ok      <- n_ok + 1
      n_results <- n_results + 1L
      
      results_list[[n_results]] <- data.table(
        REF_AREA           = country,
        REF_SECTOR         = bal_rows,
        COUNTERPART_SECTOR = bal_cols,
        TIME               = period,
        obs_value          = res$sol_vals
      )
      
      db <- sum(abs(res$disc_before), na.rm=TRUE)
      da <- sum(abs(res$disc_after),  na.rm=TRUE)
      sum_disc_before <- sum_disc_before + db
      sum_disc_after  <- sum_disc_after  + da
      
      if (verbose) {
        cat(sprintf(
          "  [%-6s %s] disc before=%.2f  after=%.2f  improvement=%.2f\n",
          country, period, db, da, db - da
        ))
        if (db > 0 && da > db)
          cat(sprintf("  WARNING: discrepancy increased for %s %s\n",
                      country, period))
      }
    }
  }
  
  # =================================================================
  # BULK WRITE-BACK — per-country, each wrapped in tryCatch
  # =================================================================
  if (n_results > 0) {
    cat("\nWriting back results...\n")
    
    all_results_dt <- rbindlist(results_list[seq_len(n_results)])
    
    n_wb_ok    <- 0L
    n_wb_error <- 0L
    
    for (ctry in countries) {
      
      ctry_dt <- all_results_dt[REF_AREA == ctry]
      if (nrow(ctry_dt) == 0) next
      
      ctry_periods <- unique(ctry_dt$TIME)
      
      # ---- build the write-back md3 object ----
      writeback_md3 <- tryCatch({
        
        writeback_dt <- rbindlist(lapply(c("_T", "_S"), function(fc) {
          dt <- copy(ctry_dt)
          dt[, INSTR          := "F51M"]
          dt[, STO            := "LE"]
          dt[, FUNCTIONAL_CAT := fc]
          dt
        }))
        
        as.md3(writeback_dt,
               id.vars = c("INSTR","REF_AREA","REF_SECTOR",
                           "COUNTERPART_SECTOR","STO",
                           "FUNCTIONAL_CAT","TIME"))
        
      }, error = function(e) {
        # log every period for this country individually
        for (p in ctry_periods)
          log_error(ctry, p, "writeback_md3", conditionMessage(e))
        NULL
      })
      
      if (is.null(writeback_md3)) {
        n_wb_error <- n_wb_error + length(ctry_periods)
        next
      }
      
      # ---- assign into aall ----
      assign_ok <- tryCatch({
        aall[sprintf("F51M.%s.%s.%s.LE._T+_S.%s",
                     ctry,
                     paste(sub_sectors, collapse = "+"),
                     paste(sub_sectors, collapse = "+"),
                     paste(ctry_periods, collapse = "+")),
             usenames = TRUE] <- writeback_md3
        TRUE
      }, error = function(e) {
        for (p in ctry_periods)
          log_error(ctry, p, "writeback_assign", conditionMessage(e))
        FALSE
      })
      
      if (isTRUE(assign_ok)) {
        n_wb_ok <- n_wb_ok + 1L
      } else {
        n_wb_error <- n_wb_error + length(ctry_periods)
      }
    }
    
    cat(sprintf(
      "Write-back complete: %d countries OK, %d country-periods with errors.\n",
      n_wb_ok, n_wb_error
    ))
  }
  
  # =================================================================
  # SUMMARY
  # =================================================================
  cat(sprintf("\n=== SUMMARY ===\n"))
  cat(sprintf("  Runs OK:             %d\n", n_ok))
  cat(sprintf("  No data:             %d\n", n_no_data))
  cat(sprintf("  LP failed:           %d\n", n_lp_failed))
  cat(sprintf("  Solve errors:        %d\n", n_solve_error))
  cat(sprintf("  Total |disc| before: %.2f\n", sum_disc_before))
  cat(sprintf("  Total |disc| after:  %.2f\n", sum_disc_after))
  cat(sprintf("  Total improvement:   %.2f\n", sum_disc_before - sum_disc_after))
  
  if (nrow(error_log) > 0) {
    cat(sprintf("\n  *** %d error(s) logged — inspect 'f51m_error_log' ***\n",
                nrow(error_log)))
    # write to global environment so the caller can inspect it
    assign("f51m_error_log", as.data.frame(error_log), envir = .GlobalEnv)
    # also dump a CSV next to the working directory for safety
    tryCatch(
      write.csv(as.data.frame(error_log),
                file.path(getwd(), "f51m_error_log.csv"),
                row.names = FALSE),
      error = function(e) invisible(NULL)
    )
    cat("  Full log saved to f51m_error_log (global) and f51m_error_log.csv\n")
  } else {
    cat("  No errors.\n")
    assign("f51m_error_log",
           data.frame(REF_AREA=character(), TIME=character(),
                      stage=character(), error_message=character()),
           envir = .GlobalEnv)
  }
  
  invisible(aall)
}