library(MDecfin)
# Set data directory
data_dir <- if (exists("data_dir")) data_dir else "data"

# directory in Brussels
#setwd('U:/Topics/Spillovers_and_EA/flowoffunds/finflows2024/gitcodedata')


# Purpose: Calculate exchange rates between national currencies and euro using debt securities data,
# then use these rates to convert all financial instruments from national currency to euro

# EXCHANGE RATES FOR STOCKS (X rates at the end of the quarter)
# Load quarterly financial data in different denominations
# Using debt securities (F3) held by total economy (S1) as benchmark for exchange rate calculation
# Load data 
aaF3_STO=mds("Estat/nasq_10_f_bs/Q.MIO_NAC+MIO_EUR.S1.ASS.F3.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
# Calculate exchange rates by dividing EUR values by NAC values
# This gives us EUR per unit of national currency
xrates_STO=aaF3_STO[".MIO_EUR."]/aaF3_STO[".MIO_NAC."]
# Verification checks for exchange rates
xrates_STO['DK.2020']  # Check Denmark's rate in 2020
xrates_STO['RO.']      # Check Romania's complete time series
# Save exchange rates for future use
saveRDS(xrates_STO, file.path(data_dir, 'xrates_sto.rds'))


# EXCHANGE RATES FOR FLOWS (exchange rates are averaged over the quarter)
#load data
aaF3_FLO=mds("Estat/nasq_10_f_tr/Q.MIO_NAC+MIO_EUR.S1.ASS.F3.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
xrates_FLO=aaF3_FLO[".MIO_EUR."]/aaF3_FLO[".MIO_NAC."]
# Verification checks for exchange rates
xrates_FLO['DK.2020']  # Check Denmark's rate in 2020
xrates_FLO['RO.']      # Check Romania's complete time series
# Save exchange rates for future use
saveRDS(xrates_FLO, file.path(data_dir, 'xrates_flo.rds'))

### try to multiply directly but it does not work

aall["F511.AT+IT...F.FND.2022q4"]*xrates_STO[".2022q4"]
#Error in Ops.md3(aall["F511.AT+IT...F.FND.2022q4"], xrates_STO[".2022q4"]) : 
# Indexing  error.

#####
#### FOR STEFAN ZEUGNER: What follows works but consumes a lot of memory
#### (and at the end it crashes)
#### in order to directly multiply the exchange rate with the aall array as tried above
#### we must solve the indexing error (see above)



# Prepare exchange rates for merging with main dataset (aall)
# Standardize dimension names for consistency
dimcodes(aall)     # Check current dimension structure
dimnames(xrates_STO)   # Check exchange rates dimensions
# Rename first dimension to match aall structure
names(dimnames(xrates_STO))[[1]] ='REF_AREA'
dimnames(xrates_STO)   # Verify rename

# Convert exchange rates to data table for manipulation
exchangerates=as.data.table(xrates_STO,na.rm = TRUE)
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
