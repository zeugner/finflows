# OPTIMIZED EXPORT OF FILTERED aa DATA TO CSV FILES WITH PRECISE ROUNDING
# This code processes the data in optimized chunks with memory management

library(MDecfin)
library(data.table)
library(bit64)  # For more efficient memory handling

# Set data directory
#data_dir= file.path(getwd(),'data')
if (!exists("data_dir")) data_dir = '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/data/'
source('\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/routines/utilities.R')
gc()


## load filled iip bop
aa=readRDS(file.path(data_dir,'aa_iip_agg.rds')); gc()
ll=readRDS(file.path(data_dir,'ll_iip_agg.rds')); gc()

# Base output directory for CSV files
csv_dir <- "CSVs"

cat("Starting optimized data export process with precise rounding...\n")

# Create directory if it doesn't exist
if (!dir.exists(csv_dir)) {
  dir.create(csv_dir, recursive = TRUE)
  cat("Created output directory:", csv_dir, "\n")
}

# ---------- performance tweaks ----------
data.table::setDTthreads(0)   # use all available threads
gc_aggressive <- function() for (i in 1:3) gc(full = TRUE, verbose = FALSE)

# ---------- time grouping ----------
ll_dims    <- dimcodes(ll)
time_dim   <- ll_dims$TIME
time_codes <- if (is.character(time_dim)) time_dim else {
  if (is.data.frame(time_dim)) time_dim$code else
    if (is.list(time_dim) && "code" %in% names(time_dim)) time_dim$code else
      as.character(unlist(time_dim))
}
time_by_year_ll <- split(time_codes, sub("q[1-4]$", "", time_codes))

# Keep only 2023 & 2022 (newest first)
years_ll <- intersect(c("2023","2022"), names(time_by_year_ll))
years_ll <- years_ll[order(years_ll, decreasing = TRUE)]
cat("LL:Processing only years:", paste(years_ll, collapse = ", "), "\n")

# ---------- what to export ----------
STO_VALUES_LL   <- c("LE","F")                             # split files by STO
FUNC_CATS_LL    <- c("_T","_F","_D","_O","_P","Tx7")  # adjust if you want fewer
COMPRESS_GZIP_LL <- FALSE                                   # TRUE -> write .csv.gz

# ---------- consistent column order ----------
DIM_COLS <- c("INSTR","REF_AREA","REF_SECTOR","COUNTERPART_SECTOR",
              "STO","FUNCTIONAL_CAT","TIME","COUNTERPART_AREA","obs_value")

# ---------- tiny helper: slice -> cleaned DT ----------
slice_to_dt_ll <- function(slice, sto, func_cat, quarter) {
  dt <- data.table::as.data.table(as.list(slice))  # materialises only non-empty obs
  if (!nrow(dt)) return(NULL)
  
  # value column
  valcol <- if ("obs_value" %in% names(dt)) "obs_value" else names(dt)[ncol(dt)]
  if (valcol != "obs_value") data.table::setnames(dt, valcol, "obs_value")
  
  # fast rounding + filter
  dt[, obs_value := round(as.numeric(obs_value), 2)]
  dt <- dt[!is.na(obs_value) & obs_value != 0]
  if (!nrow(dt)) return(NULL)
  
  # ensure metadata (sometimes missing from as.list())
  if (!"STO" %in% names(dt))            dt[, STO := sto]
  if (!"FUNCTIONAL_CAT" %in% names(dt)) dt[, FUNCTIONAL_CAT := func_cat]
  if (!"TIME" %in% names(dt))           dt[, TIME := quarter]
  
  # enforce column order
  miss <- setdiff(DIM_COLS, names(dt))
  if (length(miss)) for (m in miss) dt[, (m) := NA]
  data.table::setcolorder(dt, DIM_COLS)
  dt
}

# ---------- streaming exporter (split by STO; W2=all CP-sectors; non-W2=S1 only) ----------
stream_export_year_ll <- function(x, year, prefix = "ll",
                                  sto_values = STO_VALUES_LL,
                                  func_cats  = FUNC_CATS_LL,
                                  compress_gzip = COMPRESS_GZIP_LL) {
  
  quarters <- sort(time_by_year_ll[[year]], decreasing = TRUE)
  cp_all   <- dimnames(x)$COUNTERPART_AREA
  cp_nonw2 <- setdiff(cp_all, "W2")
  
  for (sto in sto_values) {
    out_file <- file.path(
      csv_dir,
      sprintf("Finflows_%s_%s_%s.csv%s", year, prefix, sto, if (compress_gzip) ".gz" else "")
    )
    if (file.exists(out_file)) file.remove(out_file)
    wrote_header <- FALSE
    total_rows   <- 0L
    
    cat(sprintf("\nLL Jahr %s — STO=%s → %s\n", year, sto, normalizePath(out_file, mustWork = FALSE)))
    
    for (func_cat in func_cats) {
      cat("  FUNC:", func_cat, "\n")
      
      for (quarter in quarters) {
        # 1) W2: keep ALL counterpart sectors
        slice_w2 <- x[ TRUE, "W2", TRUE, TRUE, sto, func_cat, quarter, TRUE, drop = FALSE ]
        dt1 <- slice_to_dt_ll(slice_w2, sto, func_cat, quarter)
        if (!is.null(dt1)) {
          data.table::fwrite(
            dt1, out_file,
            append   = wrote_header,
            col.names = !wrote_header,
            compress = if (compress_gzip) "gzip" else "none"
          )
          if (!wrote_header) wrote_header <- TRUE
          total_rows <- total_rows + nrow(dt1)
        }
        
        # 2) non-W2: keep ONLY CP_SECTOR == "S1"
        if (length(cp_nonw2)) {
          slice_nonw2_s1 <- x[ TRUE, cp_nonw2, "S1", TRUE, sto, func_cat, quarter, TRUE, drop = FALSE ]
          dt2 <- slice_to_dt_ll(slice_nonw2_s1, sto, func_cat, quarter)
          if (!is.null(dt2)) {
            data.table::fwrite(
              dt2, out_file,
              append   = TRUE,
              col.names = FALSE,
              compress = if (compress_gzip) "gzip" else "none"
            )
            total_rows <- total_rows + nrow(dt2)
          }
        }
        
        # light GC as we go
        if ((total_rows %% 1e6) < 50000) gc(FALSE)
      } # quarters
    }   # func_cats
    
    cat(sprintf("  WROTE %s rows to %s\n", format(total_rows, big.mark = ","), out_file))
  }     # sto
}

# ---------- run ----------
for (yr in years_ll) {
  stream_export_year_ll(ll, yr, prefix = "ll")
  gc_aggressive()
}
cat("\nDone. Files in:\n")
print(list.files(csv_dir, pattern = "^Finflows_\\d{4}_ll_(LE|F)\\.csv(\\.gz)?$", full.names = TRUE))
