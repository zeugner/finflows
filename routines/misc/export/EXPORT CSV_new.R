# OPTIMIZED EXPORT OF FILTERED aa DATA TO CSV FILES WITH PRECISE ROUNDING
# This code processes the data in optimized chunks with memory management
# Starting from 2024 and working backwards

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
aa_dims    <- dimcodes(aa)
time_dim   <- aa_dims$TIME
time_codes <- if (is.character(time_dim)) time_dim else {
  if (is.data.frame(time_dim)) time_dim$code else
    if (is.list(time_dim) && "code" %in% names(time_dim)) time_dim$code else
      as.character(unlist(time_dim))
}
time_by_year <- split(time_codes, sub("q[1-4]$", "", time_codes))

# Keep only 2023 & 2022 (newest first)
years <- intersect(c("2023","2022"), names(time_by_year))
years <- years[order(years, decreasing = TRUE)]
cat("Processing only years:", paste(years, collapse = ", "), "\n")

# ---------- what to export ----------
STO_VALUES   <- c("LE","F")                             # split files by STO
FUNC_CATS    <- c("_T","_F","_D","_R","_O","_P","Tx7")  # adjust if you want fewer
COMPRESS_GZIP <- FALSE                                   # TRUE -> write .csv.gz

# ---------- consistent column order ----------
DIM_COLS <- c("INSTR","REF_AREA","REF_SECTOR","COUNTERPART_SECTOR",
              "STO","FUNCTIONAL_CAT","TIME","COUNTERPART_AREA","obs_value")

# ---------- tiny helper: slice -> cleaned DT ----------
slice_to_dt <- function(slice, sto, func_cat, quarter) {
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
stream_export_year <- function(x, year, prefix = "aa",
                               sto_values = STO_VALUES,
                               func_cats  = FUNC_CATS,
                               compress_gzip = COMPRESS_GZIP) {
  
  quarters <- sort(time_by_year[[year]], decreasing = TRUE)
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
    
    cat(sprintf("\nYear %s — STO=%s → %s\n", year, sto, normalizePath(out_file, mustWork = FALSE)))
    
    for (func_cat in func_cats) {
      cat("  FUNC:", func_cat, "\n")
      
      for (quarter in quarters) {
        # 1) W2: keep ALL counterpart sectors
        slice_w2 <- x[ TRUE, TRUE, TRUE, TRUE, sto, func_cat, quarter, "W2", drop = FALSE ]
        dt1 <- slice_to_dt(slice_w2, sto, func_cat, quarter)
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
          slice_nonw2_s1 <- x[ TRUE, TRUE, TRUE, "S1", sto, func_cat, quarter, cp_nonw2, drop = FALSE ]
          dt2 <- slice_to_dt(slice_nonw2_s1, sto, func_cat, quarter)
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
for (yr in years) {
  stream_export_year(aa, yr, prefix = "aa")
  gc_aggressive()
}

cat("\nDone. Files in:\n")
print(list.files(csv_dir, pattern = "^Finflows_\\d{4}_aa_(LE|F)\\.csv(\\.gz)?$", full.names = TRUE))
