# Load required packages
library(MDstats)
library(MD3)

# Define paste0 operator
`%&%` = function (..., collapse = NULL, recycle0 = FALSE)  .Internal(paste0(list(...), collapse, recycle0))

# Set data directory
if (!exists("data_dir")) data_dir = getwd()

# Load main data matrix and processed NASQ data
aall = readRDS(file.path(data_dir, 'intermediate_domestic_data_files/aall_rounded.rds'))
setkey(aall, NULL)

# Load processed NASQ data
lq = readRDS(file.path(data_dir, 'intermediate_domestic_data_files/nasq_processed_assets_stocks.rds'))
lqt = readRDS(file.path(data_dir, 'intermediate_domestic_data_files/nasq_processed_assets_flows.rds'))
lq_l = readRDS(file.path(data_dir, 'intermediate_domestic_data_files/nasq_processed_liab_stocks.rds'))
lqt_l = readRDS(file.path(data_dir, 'intermediate_domestic_data_files/nasq_processed_liab_flows.rds'))

# Fill S0 (total economy) data with NASQ data
aall[...S0.LE._T., onlyna=TRUE] <- lq["...1999q4:"]
aall[...S0.F._T., onlyna=TRUE] <- lqt["...1999q4:"]
aall[..S0..LE._T., onlyna=TRUE] <- lq_l["...1999q4:"]
aall[..S0..F._T., onlyna=TRUE] <- lqt_l["...1999q4:"]

saveRDS(aall, file.path(data_dir, 'intermediate_domestic_data_files/aall_NASQ.rds'))