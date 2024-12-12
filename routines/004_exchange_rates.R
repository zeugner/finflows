library(MDecfin)
# Set data directory
data_dir <- if (exists("data_dir")) data_dir else "data"
# Purpose: Calculate exchange rates between national currencies and euro using debt securities data,
# then use these rates to convert all financial instruments from national currency to euro

# Load quarterly financial data in different denominations
# Using debt securities (F3) held by total economy (S1) as benchmark for exchange rate calculation
# Load data in national currency (NAC)
aaF3NAC=mds("Estat/nasq_10_f_bs/Q.MIO_NAC.S1.ASS.F3.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
# Load same data in euro (EUR)
aaF3EUR=mds("Estat/nasq_10_f_bs/Q.MIO_EUR.S1.ASS.F3.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Calculate exchange rates by dividing EUR values by NAC values
# This gives us EUR per unit of national currency
xrates = aaF3EUR / aaF3NAC

# Verification checks for exchange rates
xrates['DK.2020']  # Check Denmark's rate in 2020
xrates['RO.']      # Check Romania's complete time series

# Save exchange rates for future use

saveRDS(xrates, file.path(data_dir, 'xrates.rds'))
# Prepare exchange rates for merging with main dataset (aall)
# Standardize dimension names for consistency
dimcodes(aall)     # Check current dimension structure
dimnames(xrates)   # Check exchange rates dimensions
# Rename first dimension to match aall structure
names(dimnames(xrates))[[1]] ='REF_AREA'
dimnames(xrates)   # Verify rename

# Convert exchange rates to data table for manipulation
exchangerates=as.data.table(xrates,na.rm = TRUE)
# Remove unnecessary attributes
attr(exchangerates,"dcsimp") = NULL
attr(exchangerates,"dcstruct") = NULL
# Convert time column to character for consistency
exchangerates$TIME = as.character(exchangerates$TIME)
# Convert back to MD3 object
xrat=as.md3(copy(exchangerates),id.vars=1:2) 

# Verify main array structure
dimnames(aall)
# Add exchange rates as new "instrument" in first dimension
aall['xrate',,,,,,]=xrat[.]


# Add dimension DENOMINATION - this will put existing data in NAC by default
aall_bis = add.dim(aall, "DENOMINATION", c("NAC", "EUR"))

# Fill NAC dimension with existing data
aall_bis[.NAC.......] = aall[......]

# Fill EUR = NAC * exchange rate:
instruments = setdiff(dimnames(aall)$INSTR, "xrate")
##########################STEFANO BLOCKED HERE
# The following line seems to work but it takes very long and on my Net1 PC
# I have the following error:
# Error: cannot allocate vector of size 5.8 Gb
# Erza can you try that? Thanks!!!
aall_bis[.EUR.......] = aall_bis[.NAC.......] * aall['xrate',,,,,,]
#test
dimcodes(aall_bis)
#test for one country one year
aall_bis[F3..RO......]#to be completed with all dimensions except denomination

# Save the expanded array
saveRDS(aall_bis, file.path(data_dir, 'aall_bis.rds'))
