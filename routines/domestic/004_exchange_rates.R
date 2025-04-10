
library(tidyr)

# Set data directory
data_dir <- if (exists("data_dir")) data_dir else "data"

# directory in Brussels
#setwd('U:/Topics/Spillovers_and_EA/flowoffunds/finflows2024/gitcodedata')
aall=readRDS(file.path(data_dir,'aall2.rds'))

# Purpose: Calculate exchange rates between national currencies and euro using debt securities data,
# then use these rates to convert all financial instruments from national currency to euro

# SECTION 1: Calculate Exchange Rates for Stocks
# Load quarterly financial stock data in national currency (NAC) and euro (EUR)
# Using debt securities (F3) held by total economy (S1) as the benchmark

# Load data 
aaF3_STO=mds("Estat/nasq_10_f_bs/Q.MIO_NAC+MIO_EUR.S1.ASS.F3.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
# Calculate exchange rates by dividing EUR values by NAC values
# This gives us EUR per unit of national currency
xrates_STO=aaF3_STO[".MIO_EUR."]/aaF3_STO[".MIO_NAC."]

# Verification checks for specific countries and periods
xrates_STO['IT.2020']  # Verify Italy's exchange rate for 2020
xrates_STO['RO.']      # Verify Romania's complete time series

# Save stock exchange rates for future use
saveRDS(xrates_STO, file.path(data_dir, 'xrates_sto_1.rds'))

# SECTION 2: FLOW EXCHANGE RATES (Period average rates)
# Load quarterly financial flow data in both national currency and euro
# Using debt securities (F3) held by total economy (S1) as benchmark
aaF3_FLO=mds("Estat/nasq_10_f_tr/Q.MIO_NAC+MIO_EUR.S1.ASS.F3.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Calculate average exchange rates for flows
xrates_FLO=aaF3_FLO[".MIO_EUR."]/aaF3_FLO[".MIO_NAC."]

# Verification checks
xrates_FLO['DK.2020']  # Verify Denmark's rate for 2020
xrates_FLO['RO.']      # Verify Romania's complete time series

# Save flow exchange rates
saveRDS(xrates_FLO, file.path(data_dir, 'xrates_flo.rds'))

############ FILL GAPS USING DATA PROVIDED BY STEFAN

# Read supplementary exchange rate data from IMF and ECB
# This data is used to fill gaps in Eurostat-derived exchange rates
fxpppQ <- read.csv(file.path(data_dir,'fxpppQ.csv'))

# Transform data from wide to long format for easier processing
# Each row will contain: country, indicator, time, and exchange rate
fxpppQ_long <- fxpppQ %>%
  pivot_longer(
    cols = starts_with("X"),  # Columns starting with X contain time periods
    names_to = "TIME",        # Name of the new time column
    values_to = "EXCHANGE_RATE"  # Name of the new value column
  )

# Clean time column by removing 'X' prefix from period identifiers
fxpppQ_long$TIME <- gsub("X", "", fxpppQ_long$TIME)

# Convert to data.table format and ensure data cleanliness
fxpppQ_dt <- as.data.table(fxpppQ_long)

# Remove any rows with NA values in key columns to ensure data integrity
fxpppQ_dt <- fxpppQ_dt[!is.na(COUNTRY) & !is.na(INDICATOR) & !is.na(TIME)]

# Create structure for dimensions
dim_struct <- list(
  COUNTRY = unique(fxpppQ_dt$COUNTRY),
  INDICATOR = unique(fxpppQ_dt$INDICATOR),
  TIME = sort(unique(fxpppQ_dt$TIME))  # Sort time periods
)

# Create md3 object with explicit dimension structure
fxppmd3 <- as.md3(
  fxpppQ_dt,
  id.vars = 1:3,
  dcstruct = dim_struct,
  timeid = "TIME",  # Explicitly specify time dimension
  na.rm = TRUE
)


fxppXRE=fxppmd3[,2,]
fxppXRA=fxppmd3[,1,]

# Standardize dimension names across all arrays to ensure compatibility
# 'REF_AREA' is used as the standard name for geographical dimension

names(dimnames(xrates_STO))[[1]] = 'REF_AREA'
names(dimnames(xrates_FLO))[[1]] = 'REF_AREA'


names(dimnames(fxppXRE))[[1]] = 'REF_AREA'
names(dimnames(fxppXRA))[[1]] = 'REF_AREA'

names(dimnames(fxppmd3))[[1]] = 'REF_AREA'

# Define function to fill NA values with a specified value (default: 0)
zerofiller=function(x, fillscalar=0){
  temp=copy(x)
  temp[onlyna=TRUE]=fillscalar
  temp
}

# Get common dimensions between datasets to ensure proper alignment
# For stock exchange rates
common_countries <- dimcodes(xrates_STO)$REF_AREA$code  # Get countries from stock rates
common_times <- dimcodes(xrates_STO)$TIME              # Get time periods from stock rates

# For flow exchange rates
common_countries_F <- dimcodes(xrates_FLO)$REF_AREA$code  # Get countries from flow rates
common_times_F <- dimcodes(xrates_FLO)$TIME              # Get time periods from flow rates

# Create subsets of supplementary exchange rate data matching the dimensions of original data
# This ensures dimensional compatibility for the subsequent merging operations
fxppXRE_subset <- fxppXRE[common_countries, common_times]        # Subset for stock rates
fxppXRA_subset <- fxppXRA[common_countries_F, common_times_F]    # Subset for flow rates

# Fill NA values in the original exchange rate arrays with values from supplementary data
# Using zerofiller function to replace any remaining NAs with zeros
xrates_STO[., usenames=TRUE, onlyna=TRUE] = fxppXRE_subset[.]  # Fill stock rates
xrates_FLO[., usenames=TRUE, onlyna=TRUE] = fxppXRA_subset[.]  # Fill flow rates

# Verification checks
xrates_STO[BG.]  # Check Bulgaria's stock rates
xrates_FLO[BG.]  # Check Bulgaria's flow rates

# Add 'STO' dimension to distinguish between stock and flow rates
# 'LE' code for stock rates (Level/End-of-period)
xrates_STO_new <- add.dim(xrates_STO, 
                          .dimname = "STO", 
                          .dimcodes = "LE")
# Verify structure
dimnames(xrates_STO_new)

# Add 'STO' dimension for flow rates
# 'F' code for flow rates
xrates_FLO_new <- add.dim(xrates_FLO, 
                          .dimname = "STO", 
                          .dimcodes = "F")
# Verify structure
dimnames(xrates_FLO_new)

# Create template array for exchange rates based on aall structure
# Taking first observation and collapsing all dimensions except REF_AREA and TIME
xr=copy(aall[1,,1,1,1,1,])  # Template for first set
xr[]=NA  # Initialize with NAs

# Create second template array
xr2=copy(aall[1,,1,1,1,1,])  # Template for second set
xr2[]=NA  # Initialize with NAs

# Verification checks for specific country (Bulgaria)
xrates_STO_new[.BG.]
xrates_FLO_new[.BG.]

# Merge stock and flow exchange rates along the STO dimension
# overwrite=FALSE ensures no data is accidentally overwritten
xrates <- merge(xrates_FLO_new, 
                xrates_STO_new, 
                along = "STO",
                overwrite = FALSE)
# Clear memory
gc()

# Check specific value before conversion
aall[F2M..S1.S0.LE._T.2008q4]

# Apply exchange rates to all values
aall1=aall*xrates

# Verify conversion
aall1[F2M..S1.S0.LE._T.2008q4]

# Clear memory and save converted data
gc()
saveRDS(aall1, file.path(data_dir, 'aall3.rds'))
gc()

################## 
# ROUNDING SECTION
# Due to memory constraints, rounding needs to be done in chunks
# Instead of: aall_rounded[......] = round(aall1[......])

# Define function to process a chunk of sectors
# Rounds values for specified sectors while maintaining all other dimensions
process_sector_chunk <- function(aall1, sectors) {
  # Process chunk: round values for specified sectors across all other dimensions
  # Dimensions order: INSTR, REF_AREA, REF_SECTOR, COUNTERPART_SECTOR, STO, CUST_BREAKDOWN, TIME
  aall1[TRUE, TRUE, sectors, TRUE, TRUE, TRUE, TRUE] = round(aall1[TRUE, TRUE, sectors, TRUE, TRUE, TRUE, TRUE])
  gc()  # Clean memory after processing chunk
  return(aall1)
}

# Get list of all unique reference sectors
ref_sectors <- dimcodes(aall1)$REF_SECTOR$code

# Set chunk processing parameters
chunk_size <- 2  # Process 2 sectors at a time
n_chunks <- ceiling(length(ref_sectors) / chunk_size)

# Process data in chunks
for(i in 1:n_chunks) {
  # Calculate sector indices for current chunk
  start_idx <- (i-1)*chunk_size + 1
  end_idx <- min(i*chunk_size, length(ref_sectors))
  
  # Get sectors for current chunk
  sector_chunk <- ref_sectors[start_idx:end_idx]
  
  # Process the chunk
  gc()  # Clear memory before processing new chunk
  aall1 <- process_sector_chunk(aall1, sector_chunk)
  
  # Log progress
  cat("Processed sectors:", paste(sector_chunk, collapse=", "), "\n")
}

# Final memory cleanup
gc()

# Verify results
aall1[F2M..S1.S0.LE._T.2008q4]

# Save final rounded data
saveRDS(aall1, file.path(data_dir, 'aall4.rds'))

