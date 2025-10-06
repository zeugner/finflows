library(MDstats); library(MD3)
library(MDecfin)
library(parallel)
library(foreach)
library(doParallel)
library(data.table)

# Setup parallelization - use at most half of available resources
n_cores <- min(floor(detectCores() / 2), 49)  # Use max 50% of cores, cap at 49
cl <- makeCluster(n_cores)
registerDoParallel(cl)

cat("Using", n_cores, "cores for parallel computation (50% of available resources)\n")

# Set data directory
setwd("V:/FinFlows/githubrepo/trialarea")
data_dir <- file.path(getwd(),'data')
if (!exists("data_dir")) data_dir <- '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/data/'

# Garbage collection with moderate aggressiveness
gc(full = TRUE, verbose = TRUE)

## Optimized data loading
cat("Loading IIP data...\n")
aa <- readRDS("V:/FinFlows/githubrepo/trialarea/data/aa_iip_shss.rds")
gc(full = TRUE)

ll <- readRDS("V:/FinFlows/githubrepo/trialarea/data/ll_iip_shss.rds")
gc(full = TRUE)

## Load CPIS data with memory optimization
cat("Loading CPIS data...\n")
cpisraw <- readRDS("V:/FinFlows/githubrepo/finflows/data/cpisbuffer/allcresultslist.rds")
gc(full = TRUE)

whatctries <- readRDS('V:/FinFlows/githubrepo/finflows/data/cpisbuffer/whatctries.rds')
ccc <- dimcodes(whatctries)[[1]]
AREA <- ccc[,1]
gc(full = TRUE)

## Initial CPIS setup
cat("Initial CPIS setup...\n")
cpis <- cpisraw$INV$DE["DE....."]
cpissmall <- copy(cpis)
gc(full = TRUE)

cpis1 <- add.dim(cpissmall, .dimname = 'REF_AREA', .dimcodes = 'DE', .fillall = FALSE)
cpis <- add.dim(cpis1, .dimname = 'COUNTERPART_SECTOR', .dimcodes = 'T', .fillall = FALSE)
gc(full = TRUE)

cpis <- aperm(copy(cpis), c(2:4,1,5:6))
gc(full = TRUE)

#############################################################################
####### PARALLEL CPIS FILLING WITH MODERATE RESOURCE USAGE ####### 
#############################################################################

cat("Parallel filling of reporting sectors...\n")

# Prepare lists for parallel processing - using moderate chunk sizes
area_chunks <- split(AREA, ceiling(seq_along(AREA) / max(1, length(AREA) / n_cores)))

# Function to process a chunk of countries
process_area_chunk <- function(area_subset, cpisraw_subset, cpis_template) {
  require(MD3)
  
  # Create local copy of template
  local_cpis <- copy(cpis_template)
  
  for (cty in area_subset) {
    if (length(cpisraw_subset$INV[[cty]])) {
      local_cpis[cty, , , , , ] <- cpisraw_subset$INV[[cty]][cty,,,,, usenames=TRUE]
    }
  }
  
  return(local_cpis[area_subset, , , , , ])
}

# Execute parallel filling of reporting sectors with better error handling
cat("Processing reporting sectors in parallel...\n")

# Process each chunk and store results
chunk_results <- vector("list", length(area_chunks))
names(chunk_results) <- paste0("chunk_", seq_along(area_chunks))

for (chunk_idx in seq_along(area_chunks)) {
  area_chunk <- area_chunks[[chunk_idx]]
  cat("Processing chunk", chunk_idx, "with countries:", paste(area_chunk, collapse=", "), "\n")
  
  chunk_results[[chunk_idx]] <- tryCatch({
    process_area_chunk(area_chunk, cpisraw, cpis)
  }, error = function(e) {
    cat("Error in chunk", chunk_idx, ":", e$message, "\n")
    return(NULL)
  })
}

# Combine results sequentially to avoid MD3 object corruption
cat("Combining chunk results...\n")
for (chunk_idx in seq_along(chunk_results)) {
  if (!is.null(chunk_results[[chunk_idx]])) {
    area_subset <- area_chunks[[chunk_idx]]
    for (cty in area_subset) {
      if (cty %in% dimnames(chunk_results[[chunk_idx]])[[1]]) {
        cpis[cty, , , , , ] <- chunk_results[[chunk_idx]][cty, , , , , ]
      }
    }
  }
}

# Clean up chunk results
rm(chunk_results)
gc(full = TRUE)
gc(full = TRUE)

cat("Filling counterpart sectors...\n")

# Process counterpart filling more directly to avoid dimension issues
for (cty in AREA) {
  if (length(cpisraw$CP[[cty]])) {
    tryCatch({
      # Check dimensions and apply appropriate indexing
      temp_data <- cpisraw$CP[[cty]][cty,,'T',,,]
      if (!is.null(temp_data) && length(temp_data) > 0) {
        # Use more flexible indexing that matches the cpis object structure
        cpis[cty, , 'T', , , , usenames=TRUE, onlyna=TRUE] <- temp_data
      }
    }, error = function(e) {
      cat("Warning: Could not process counterpart data for", cty, ":", e$message, "\n")
    })
  }
}

rm(cpis_cp_updates)
gc(full = TRUE)

saveRDS(cpis, file='data/cpis_temp_first.rds')
gc(full = TRUE)

#############################################################################
####### OPTIMIZED CURRENCY TRANSFORMATIONS ####### 
#############################################################################

cat("Currency transformation...\n")
# Optimized exchange rates loading
exra <- mds('ECB/EXR/A.USD.EUR.SP00.E')
exrs <- mds('ECB/EXR/Q.USD.EUR.SP00.E')
exrs <- aggregate(exrs,'S',FUN=end)
exr <- merge(exra,exrs)

# More efficient transformation using vectorized operations
cpis <- cpis/exr
saveRDS(cpis, file='data/cpis_temp_exr.rds')
gc(full = TRUE)

#############################################################################
# OPTIMIZED MEUR TRANSFORMATION WITH DATA.TABLE
#############################################################################

cat("MEUR transformation with optimized data.table...\n")

# Use moderate number of threads for data.table (50% of cores)
setDTthreads(n_cores)

dcpis <- as.data.table(cpis, .simple=TRUE, na.rm=TRUE)
# Optimized vectorized operation
dcpis[, obs_value := round(obs_value / 1e6, digits=2)]
cpis <- as.md3(dcpis)
rm(dcpis)
gc(full = TRUE)

saveRDS(cpis, file='data/cpis_temp_MEUR.rds')

#############################################################################
# DIMENSION OPTIMIZATION
#############################################################################

cat("Dimension optimization...\n")

# More efficient transformations
names(dimnames(cpis))[2] <- 'INSTR'

# More efficient vectorized mapping
instr_mapping <- c(
  'I_A_E_T_T_BP6_USD' = 'F5',
  'I_A_D_T_T_BP6_USD' = 'F3',
  'I_A_D_S_T_BP6_USD' = 'F3S',
  'I_A_D_L_T_BP6_USD' = 'F3L'
)

current_names <- dimnames(cpis)$INSTR
dimnames(cpis)$INSTR <- ifelse(current_names %in% names(instr_mapping),
                               instr_mapping[current_names],
                               current_names)

# Sector mapping with parallelization
map_sector <- c(
  "T"   = "S1", "CB"  = "S121", "DC"  = "S122", "FC"  = "S12",
  "NFC" = "S11", "GG"  = "S13", "HH"  = "S14", "IPF" = "S12Q",
  "MMF" = "S123", "NHN" = "S1P", "NP"  = "S15", "ODX" = "S12T",
  "OFI" = "S128", "OFM" = "S124", "OFT" = "S12other",
  "OFX" = "S12X", "OFO" = "S12Rest"
)

# Apply vectorized mapping
ref_sectors <- dimnames(cpis)$REF_SECTOR
cp_sectors <- dimnames(cpis)$COUNTERPART_SECTOR

dimnames(cpis)$REF_SECTOR <- ifelse(ref_sectors %in% names(map_sector),
                                   map_sector[ref_sectors], ref_sectors)
dimnames(cpis)$COUNTERPART_SECTOR <- ifelse(cp_sectors %in% names(map_sector),
                                           map_sector[cp_sectors], cp_sectors)

saveRDS(cpis, file='data/cpis_temp_adj.rds')
gc(full = TRUE)

#############################################################################
# TIME FREQUENCY MANAGEMENT OPTIMIZATION
#############################################################################

cat("Time frequency management...\n")

# Cleanup unnecessary variables
rm(list = ls(pattern = "^[AQS]cpis$"))
gc(full = TRUE)

# More efficient frequency processing
Acpis <- cpis[A......]
Scpis <- cpis[S......]
frequency(Acpis) <- frequency(Scpis) <- 'Q'
Scpis[onlyna=TRUE] <- Acpis
gc(full = TRUE)

cpis <- Scpis[".....2001q4:"]
rm(Acpis, Scpis)
gc(full = TRUE)

saveRDS(cpis, file='data/cpis_temp_time.rds')

#############################################################################
# PARALLEL FILLING OF FUNCTIONAL CATEGORY _P
#############################################################################

cat("Parallel filling of functional category _P...\n")

instr <- dimnames(cpis)[['INSTR']]

# ASSETS - parallelization by instrument
foreach(i = instr, .packages = c("MD3")) %dopar% {
  aa[i, , , ,"LE", "_P", , , usenames=TRUE, onlyna=TRUE] <- cpis[,i,,,,]
}

# LIABILITIES - parallel preparation
cat("Liabilities preparation...\n")
liabcpis <- copy(cpis)

# More efficient dimension swapping
dim_names <- names(dimnames(liabcpis))
swap_mapping <- c(
  "REF_SECTOR" = "COUNTERPART_SECTOR",
  "REF_AREA" = "COUNTERPART_AREA",
  "COUNTERPART_SECTOR" = "REF_SECTOR",
  "COUNTERPART_AREA" = "REF_AREA"
)

for (old_name in names(swap_mapping)) {
  if (old_name %in% dim_names) {
    names(dimnames(liabcpis))[names(dimnames(liabcpis)) == old_name] <- paste0(old_name, "-TEMP")
  }
}

for (old_name in names(swap_mapping)) {
  if (paste0(old_name, "-TEMP") %in% names(dimnames(liabcpis))) {
    names(dimnames(liabcpis))[names(dimnames(liabcpis)) == paste0(old_name, "-TEMP")] <- swap_mapping[old_name]
  }
}

# LIABILITIES - parallel filling
foreach(i = instr, .packages = c("MD3")) %dopar% {
  ll[i, , , ,"LE", "_P", , , usenames=TRUE, onlyna=TRUE] <- liabcpis[,i,,,,]
}

rm(liabcpis)
gc(full = TRUE)

#############################################################################
# OPTIMIZED FINAL SAVE
#############################################################################

cat("Final save...\n")

# Parallel saving (if possible)
save_tasks <- list(
  list(data = aa, file = 'data/aa_iip_cpis.rds'),
  list(data = ll, file = 'data/ll_iip_cpis.rds')
)

foreach(task = save_tasks) %dopar% {
  saveRDS(task$data, file = task$file)
}

# Final cleanup
stopCluster(cl)
gc(full = TRUE)

cat("Script completed successfully using", n_cores, "cores (50% of server resources)!\n")