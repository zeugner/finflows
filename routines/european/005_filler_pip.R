# filler_pip.R
# Fills aa (assets) and ll (liabilities) with PIP data (formerly CPIS)
# Processes country-by-country to avoid memory issues
# Finflows 3.0
# -----------------------------------------------------------
#
# KNOWN MD3 QUIRK: any subsetting operation (string-based or positional)
# drops ALL singleton dimensions. This script calls ensure_dims() after
# every subsetting step to re-add them and guarantee a fixed dim structure.
# -----------------------------------------------------------

library(MDstats); library(MD3)

# Set data directory
if (!exists("data_dir")) data_dir = 'Z:/FinFlows/githubrepo/data/'

source('Z:/FinFlows/githubrepo/finflows/routines/utilities.R')

gc()

#############################################################################
# --- Load aa, ll ---
#############################################################################

aa <- readRDS(file.path(data_dir, 'aa_iip_shss.rds')); gc()
ll <- readRDS(file.path(data_dir, 'll_iip_shss.rds')); gc()

#############################################################################
# --- Load PIP country list ---
#############################################################################

whatctries <- readRDS(file.path(data_dir, 'pipbuffer/whatctries_pip.rds'))
ccc <- dimcodes(whatctries)[[1]]
AREA <- ccc[, 1]  # ISO3 codes
rm(whatctries); gc()

#############################################################################
# --- Exchange rate: fetch once before the loop ---
#############################################################################

exra <- mds('ECB/EXR/A.USD.EUR.SP00.E')
exrs <- mds('ECB/EXR/Q.USD.EUR.SP00.E')
exrs <- aggregate(exrs, 'S', FUN = end)
exr  <- merge(exra, exrs)
rm(exra, exrs); gc()

#############################################################################
# --- Indicator recoding map ---
#############################################################################

map_indicator <- c(
  "P_TOTINV_P_USD" = "F",
  "P_F51_P_USD"    = "F51",
  "P_F3_P_USD"     = "F3",
  "P_F3_S_P_USD"   = "F3S",
  "P_F3_L_P_USD"   = "F3L"
)

#############################################################################
# --- Helper: ensure exactly the expected dims exist, in order ---
# Re-adds any singleton dims that MD3 dropped, then reorders.
# Works with EITHER pre-rename (PIP) or post-rename (Finflows) names.
#############################################################################

ensure_dims <- function(obj, dim_names, dim_codes) {
  # dim_names: character vector of expected dimension names, in order
  # dim_codes: named list mapping dim_name -> character vector of codes
  #            (used to re-add dropped singletons)
  for (dname in dim_names) {
    if (!(dname %in% names(dimnames(obj)))) {
      obj <- add.dim(obj, .dimname = dname,
                     .dimcodes = dim_codes[[dname]],
                     .fillall = FALSE)
    }
  }
  obj <- aperm(obj, dim_names)
  return(obj)
}

#############################################################################
# --- Helper: string-based TIME subsetting ---
# Builds the right dot-prefix for any number of dims, subsets TIME
# at the last position, then re-ensures dimensions.
#############################################################################

subset_time <- function(obj, time_codes, dim_names, dim_codes) {
  ndim <- length(dim(obj))
  dot_prefix <- paste(rep("", ndim), collapse = ".")
  obj <- obj[dot_prefix %&% paste(time_codes, collapse = "+")]
  obj <- ensure_dims(obj, dim_names, dim_codes)
  return(obj)
}


#############################################################################
# --- Main loop: process each country and fill aa, ll ---
#############################################################################

cat('Processing PIP data for', length(AREA), 'countries\n')

for (cc in AREA) {
  
  cachefile <- file.path(data_dir, 'pipbuffer/pip_' %&% cc %&% '.rds')
  if (!file.exists(cachefile)) { cat(cc, ': no cache file, skipping\n'); next }
  
  cat(as.character(Sys.time()), ': ', match(cc, AREA), '/', length(AREA),
      ' ', cc, '... ')
  
  pip_cc <- readRDS(cachefile)
  
  # Get ISO2 code for this country (for filling aa/ll)
  cc2 <- ccode(cc, 'iso3c', 'iso2m', leaveifNA = TRUE, warn = FALSE)
  if (cc2 == 'CN') cc2 <- 'CN_X_HK'
  
  # Save original dim codes for re-adding dropped singletons (PIP names)
  orig_codes <- list(
    INDICATOR           = dimnames(pip_cc)$INDICATOR,
    SECTOR              = dimnames(pip_cc)$SECTOR,
    COUNTERPART_SECTOR  = dimnames(pip_cc)$COUNTERPART_SECTOR,
    COUNTERPART_COUNTRY = dimnames(pip_cc)$COUNTERPART_COUNTRY
  )
  orig_names <- c("INDICATOR", "SECTOR", "COUNTERPART_SECTOR",
                  "COUNTERPART_COUNTRY", "TIME")
  
  # --- Slice by ACCOUNTING_ENTRY ---
  has_assets <- "A" %in% dimnames(pip_cc)$ACCOUNTING_ENTRY
  has_liab   <- "L" %in% dimnames(pip_cc)$ACCOUNTING_ENTRY
  
  pip_a <- if (has_assets) ensure_dims(pip_cc[, "A", , , , , ], orig_names, orig_codes) else NULL
  pip_l <- if (has_liab)   ensure_dims(pip_cc[, "L", , , , , ], orig_names, orig_codes) else NULL
  rm(pip_cc); gc()
  
  # =====================================================================
  # PROCESS pip_a (assets)
  # =====================================================================
  if (!is.null(pip_a)) {
    
    # Currency: USD -> EUR, then MEUR
    pip_a <- pip_a / exr
    pip_a <- pip_a / 1e6
    pip_a <- round(pip_a, 2)
    
    # Rename dimensions
    nms <- names(dimnames(pip_a))
    nms[nms == "INDICATOR"]           <- "INSTR"
    nms[nms == "SECTOR"]              <- "REF_SECTOR"
    nms[nms == "COUNTERPART_COUNTRY"] <- "COUNTERPART_AREA"
    names(dimnames(pip_a)) <- nms
    
    # Recode INSTR
    for (old in names(map_indicator)) {
      dimnames(pip_a)$INSTR[dimnames(pip_a)$INSTR == old] <- map_indicator[old]
    }
    
    # Convert counterpart country codes ISO3 -> ISO2
    dimnames(pip_a)$COUNTERPART_AREA <- ccode(
      dimnames(pip_a)$COUNTERPART_AREA, 'iso3c', 'iso2m',
      leaveifNA = TRUE, warn = FALSE)
    dimnames(pip_a)$COUNTERPART_AREA[
      dimnames(pip_a)$COUNTERPART_AREA == 'CN'] <- 'CN_X_HK'
    
    # Build renamed dim codes for re-ensuring after freq adjustment
    renamed_names <- c("INSTR", "REF_SECTOR", "COUNTERPART_SECTOR",
                       "COUNTERPART_AREA", "TIME")
    renamed_codes <- list(
      INSTR              = dimnames(pip_a)$INSTR,
      REF_SECTOR         = dimnames(pip_a)$REF_SECTOR,
      COUNTERPART_SECTOR = dimnames(pip_a)$COUNTERPART_SECTOR,
      COUNTERPART_AREA   = dimnames(pip_a)$COUNTERPART_AREA
    )
    
    # Frequency adjustment: A+S -> Q
    all_times    <- dimnames(pip_a)$TIME
    annual_times <- all_times[!grepl("s", all_times)]
    semi_times   <- all_times[grepl("s", all_times)]
    
    if (length(annual_times) > 0 & length(semi_times) > 0) {
      Apip <- subset_time(pip_a, annual_times, renamed_names, renamed_codes)
      Spip <- subset_time(pip_a, semi_times,   renamed_names, renamed_codes)
      frequency(Apip) <- 'Q'
      frequency(Spip) <- 'Q'
      Spip[onlyna = TRUE] <- Apip
      pip_a <- Spip
      rm(Apip, Spip)
    } else if (length(semi_times) > 0) {
      pip_a <- subset_time(pip_a, semi_times, renamed_names, renamed_codes)
      frequency(pip_a) <- 'Q'
    } else if (length(annual_times) > 0) {
      pip_a <- subset_time(pip_a, annual_times, renamed_names, renamed_codes)
      frequency(pip_a) <- 'Q'
    }
    
    # Filter from 2001q4 onwards
    pip_a <- subset_time(pip_a, "2001q4:", renamed_names, renamed_codes)
  }
  
  # =====================================================================
  # PROCESS pip_l (liabilities) - same steps as pip_a
  # =====================================================================
  if (!is.null(pip_l)) {
    
    pip_l <- pip_l / exr
    pip_l <- pip_l / 1e6
    pip_l <- round(pip_l, 2)
    
    nms <- names(dimnames(pip_l))
    nms[nms == "INDICATOR"]           <- "INSTR"
    nms[nms == "SECTOR"]              <- "REF_SECTOR"
    nms[nms == "COUNTERPART_COUNTRY"] <- "COUNTERPART_AREA"
    names(dimnames(pip_l)) <- nms
    
    for (old in names(map_indicator)) {
      dimnames(pip_l)$INSTR[dimnames(pip_l)$INSTR == old] <- map_indicator[old]
    }
    
    dimnames(pip_l)$COUNTERPART_AREA <- ccode(
      dimnames(pip_l)$COUNTERPART_AREA, 'iso3c', 'iso2m',
      leaveifNA = TRUE, warn = FALSE)
    dimnames(pip_l)$COUNTERPART_AREA[
      dimnames(pip_l)$COUNTERPART_AREA == 'CN'] <- 'CN_X_HK'
    
    renamed_names_l <- c("INSTR", "REF_SECTOR", "COUNTERPART_SECTOR",
                         "COUNTERPART_AREA", "TIME")
    renamed_codes_l <- list(
      INSTR              = dimnames(pip_l)$INSTR,
      REF_SECTOR         = dimnames(pip_l)$REF_SECTOR,
      COUNTERPART_SECTOR = dimnames(pip_l)$COUNTERPART_SECTOR,
      COUNTERPART_AREA   = dimnames(pip_l)$COUNTERPART_AREA
    )
    
    all_times    <- dimnames(pip_l)$TIME
    annual_times <- all_times[!grepl("s", all_times)]
    semi_times   <- all_times[grepl("s", all_times)]
    
    if (length(annual_times) > 0 & length(semi_times) > 0) {
      Apip <- subset_time(pip_l, annual_times, renamed_names_l, renamed_codes_l)
      Spip <- subset_time(pip_l, semi_times,   renamed_names_l, renamed_codes_l)
      frequency(Apip) <- 'Q'
      frequency(Spip) <- 'Q'
      Spip[onlyna = TRUE] <- Apip
      pip_l <- Spip
      rm(Apip, Spip)
    } else if (length(semi_times) > 0) {
      pip_l <- subset_time(pip_l, semi_times, renamed_names_l, renamed_codes_l)
      frequency(pip_l) <- 'Q'
    } else if (length(annual_times) > 0) {
      pip_l <- subset_time(pip_l, annual_times, renamed_names_l, renamed_codes_l)
      frequency(pip_l) <- 'Q'
    }
    
    pip_l <- subset_time(pip_l, "2001q4:", renamed_names_l, renamed_codes_l)
  }
  
  # =====================================================================
  # At this point, pip_a and pip_l each have EXACTLY 5 dims:
  #   INSTR(1), REF_SECTOR(2), COUNTERPART_SECTOR(3), COUNTERPART_AREA(4), TIME(5)
  # This is GUARANTEED by ensure_dims inside subset_time.
  # =====================================================================
  
  
  #########################################################################
  # FILL AA (assets) from ACCOUNTING_ENTRY = A
  #########################################################################
  # pip_a: INSTR(1), REF_SECTOR(2), COUNTERPART_SECTOR(3), COUNTERPART_AREA(4), TIME(5)
  # aa[, cc2, , , "LE", "_P", , ]: INSTR, REF_SECTOR, COUNTERPART_SECTOR, TIME, COUNTERPART_AREA
  # -> aperm c(1,2,3,5,4)
  if (!is.null(pip_a)) {
    aa[, cc2, , , "LE", "_P", , , usenames = TRUE, onlyna = TRUE] <-
      aperm(pip_a, c(1, 2, 3, 5, 4))
  }
  
  #########################################################################
  # FILL LL (liabilities) from ACCOUNTING_ENTRY = L (direct)
  #########################################################################
  # pip_l: INSTR(1), REF_SECTOR(2), COUNTERPART_SECTOR(3), COUNTERPART_AREA(4), TIME(5)
  # ll[, , , , "LE", "_P", , cc2]: INSTR, COUNTERPART_AREA, COUNTERPART_SECTOR, REF_SECTOR, TIME
  # -> aperm c(1,4,3,2,5)
  if (!is.null(pip_l)) {
    ll[, , , , "LE", "_P", , cc2, usenames = TRUE, onlyna = TRUE] <-
      aperm(pip_l, c(1, 4, 3, 2, 5))
  }
  
  #########################################################################
  # FILL LL (liabilities) from ACCOUNTING_ENTRY = A (mirror)
  #########################################################################
  # cc2's assets vis-a-vis B = B's liabilities vis-a-vis cc2
  # pip_a: INSTR(1), REF_SECTOR(2), COUNTERPART_SECTOR(3), COUNTERPART_AREA(4), TIME(5)
  # Mirror mapping:
  #   REF_SECTOR(2)       -> COUNTERPART_SECTOR in ll
  #   COUNTERPART_SECTOR(3) -> REF_SECTOR in ll
  #   COUNTERPART_AREA(4) -> REF_AREA in ll
  #   cc2                 -> COUNTERPART_AREA in ll
  # ll[, cc2, , , "LE", "_P", , ]: COUNTERPART_SECTOR, REF_SECTOR, TIME, REF_AREA
  # -> aperm c(1,2,3,5,4) then rename dims
  if (!is.null(pip_a)) {
    pip_mirror <- aperm(pip_a, c(1, 2, 3, 5, 4))
    nms_m <- names(dimnames(pip_mirror))
    nms_m[nms_m == "REF_SECTOR"]         <- "COUNTERPART_SECTOR_TEMP"
    nms_m[nms_m == "COUNTERPART_SECTOR"] <- "REF_SECTOR"
    nms_m[nms_m == "COUNTERPART_SECTOR_TEMP"] <- "COUNTERPART_SECTOR"
    nms_m[nms_m == "COUNTERPART_AREA"]   <- "REF_AREA"
    names(dimnames(pip_mirror)) <- nms_m
    ll[, cc2, , , "LE", "_P", , , usenames = TRUE, onlyna = TRUE] <- pip_mirror
    rm(pip_mirror)
  }
  
  #########################################################################
  # Special S124 adjustment: F52 liabilities from F51 data
  #########################################################################
  # Use pip_l's F51+S124 data to fill ll's F52+S124
  if (!is.null(pip_l) &&
      "F51" %in% dimnames(pip_l)$INSTR &&
      "S124" %in% dimnames(pip_l)$REF_SECTOR) {
    
    # Subset F51 + S124 using dot syntax
    # pip_l has 5 dims: INSTR.REF_SECTOR.COUNTERPART_SECTOR.COUNTERPART_AREA.TIME
    # "F51.S124..." = 5 segments -> drops INSTR and REF_SECTOR -> 3 dims
    # But MD3 may parse "S124" oddly. Use safe dot prefix approach:
    ndim_l <- length(dim(pip_l))
    dots_after_2 <- paste(rep("", ndim_l - 2), collapse = ".")  # "..." for 5 dims
    s124_slice <- pip_l["F51" %&% "." %&% "S124" %&% "." %&% dots_after_2]
    
    # Re-ensure 3 dims: COUNTERPART_SECTOR, COUNTERPART_AREA, TIME
    s124_names <- c("COUNTERPART_SECTOR", "COUNTERPART_AREA", "TIME")
    s124_codes <- list(
      COUNTERPART_SECTOR = dimnames(pip_l)$COUNTERPART_SECTOR,
      COUNTERPART_AREA   = dimnames(pip_l)$COUNTERPART_AREA
    )
    s124_slice <- ensure_dims(s124_slice, s124_names, s124_codes)
    
    # ll["F52", , , "S124", "LE", "_P", , cc2]: COUNTERPART_AREA, COUNTERPART_SECTOR, TIME
    # -> aperm c(2,1,3)
    ll["F52", , , "S124", "LE", "_P", , cc2, usenames = TRUE, onlyna = TRUE] <-
      aperm(s124_slice, c(2, 1, 3))
    rm(s124_slice)
  }
  
  rm(pip_a, pip_l)
  gc()
  cat('done\n')
}


#############################################################################
# --- Save outputs ---
#############################################################################

saveRDS(aa, file.path(data_dir, 'aa_iip_pip.rds'))
saveRDS(ll, file.path(data_dir, 'll_iip_pip.rds'))

saveRDS(aa, file.path(data_dir, 'vintages/aa_iip_pip_' %&% format(Sys.time(), '%F') %&% '_.rds'))
saveRDS(ll, file.path(data_dir, 'vintages/ll_iip_pip_' %&% format(Sys.time(), '%F') %&% '_.rds'))

cat('Done. Saved aa_iip_pip.rds and ll_iip_pip.rds\n')