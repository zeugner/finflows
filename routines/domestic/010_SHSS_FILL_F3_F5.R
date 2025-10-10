# Load required packages
library(MDstats)
library(MD3)

# Define paste0 operator
`%&%` = function (..., collapse = NULL, recycle0 = FALSE)  .Internal(paste0(list(...), collapse, recycle0))

# Set data directory
if (!exists("data_dir")) data_dir = getwd()

aall=readRDS(file.path(data_dir, 'intermediate_domestic_data_files/aall_bsi_loans_deposits.rds'))
setkey(aall, NULL)

ash=readRDS(file.path(data_dir, 'ash.rds'))
gc()

shss<-ash["shss..W2....."]

names(dimnames(shss))[[5]] = 'INSTR'
aall[....._T., usenames=TRUE, onlyna=TRUE] <- shss

saveRDS(aall, file.path(data_dir, 'intermediate_domestic_data_files/aall_shss.rds'))