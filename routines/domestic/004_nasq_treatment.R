<<<<<<< HEAD
# Load required packages
library(MDstats)
library(MD3)

# Define paste0 operator
`%&%` = function (..., collapse = NULL, recycle0 = FALSE)  .Internal(paste0(list(...), collapse, recycle0))

# Set data directory
if (!exists("data_dir")) data_dir = getwd()

# Load NASQ data that was already processed in 008_load_NASQ.R
nasq_S = readRDS(file.path(data_dir, "domestic_loading_data_files/nasq_S.rds"))
nasq_F = readRDS(file.path(data_dir, "domestic_loading_data_files/nasq_F.rds"))

# Extract quarterly data from 1999Q4 onwards
lq=nasq_S["ASS....1999q4:"]
lq_l=nasq_S["LIAB....1999q4:"]
lqt=nasq_F["ASS....1999q4:"]
lqt_l=nasq_F["LIAB....1999q4:"]

# Standardize dimension names
names(dimnames(lq))[[1]] = names(dimnames(lqt))[[1]] = names(dimnames(lq_l))[[1]] = names(dimnames(lqt_l))[[1]] = 'REF_AREA'
names(dimnames(lq))[[2]] = names(dimnames(lqt))[[2]] = names(dimnames(lq_l))[[2]] = names(dimnames(lqt_l))[[2]] = 'INSTR'
names(dimnames(lq))[[3]] = names(dimnames(lqt))[[3]] = 'REF_SECTOR'
names(dimnames(lq_l))[[3]] = names(dimnames(lqt_l))[[3]] = 'COUNTERPART_SECTOR'

####### RENAME SECTORS AND INSTRUMENTS!

# Sector mappings
dimnames(lq)$REF_SECTOR[dimnames(lq)$REF_SECTOR=='S14_S15'] = dimnames(lq_l)$COUNTERPART_SECTOR[dimnames(lq_l)$COUNTERPART_SECTOR=='S14_S15'] = dimnames(lqt_l)$COUNTERPART_SECTOR[dimnames(lqt_l)$COUNTERPART_SECTOR=='S14_S15'] = dimnames(lqt)$REF_SECTOR[dimnames(lqt)$REF_SECTOR=='S14_S15'] = 'S1M'
dimnames(lq)$REF_SECTOR[dimnames(lq)$REF_SECTOR=='S121_S122_S123'] = dimnames(lq_l)$COUNTERPART_SECTOR[dimnames(lq_l)$COUNTERPART_SECTOR=='S121_S122_S123'] = dimnames(lqt_l)$COUNTERPART_SECTOR[dimnames(lqt_l)$COUNTERPART_SECTOR=='S121_S122_S123'] = dimnames(lqt)$REF_SECTOR[dimnames(lqt)$REF_SECTOR=='S121_S122_S123'] = 'S12K'
dimnames(lq)$REF_SECTOR[dimnames(lq)$REF_SECTOR=='S125_S126_S127'] = dimnames(lq_l)$COUNTERPART_SECTOR[dimnames(lq_l)$COUNTERPART_SECTOR=='S125_S126_S127'] = dimnames(lqt_l)$COUNTERPART_SECTOR[dimnames(lqt_l)$COUNTERPART_SECTOR=='S125_S126_S127'] = dimnames(lqt)$REF_SECTOR[dimnames(lqt)$REF_SECTOR=='S125_S126_S127'] = 'S12O'

# Financial instrument mappings
dimnames(lq)$INSTR[dimnames(lq)$INSTR=='F63_F64_F65'] = dimnames(lq_l)$INSTR[dimnames(lq_l)$INSTR=='F63_F64_F65'] = dimnames(lqt_l)$INSTR[dimnames(lqt_l)$INSTR=='F63_F64_F65'] = dimnames(lqt)$INSTR[dimnames(lqt)$INSTR=='F63_F64_F65'] = 'F6M'
dimnames(lq)$INSTR[dimnames(lq)$INSTR=='F31'] = dimnames(lq_l)$INSTR[dimnames(lq_l)$INSTR=='F31'] = dimnames(lqt_l)$INSTR[dimnames(lqt_l)$INSTR=='F31'] = dimnames(lqt)$INSTR[dimnames(lqt)$INSTR=='F31'] = 'F3S'
dimnames(lq)$INSTR[dimnames(lq)$INSTR=='F32'] = dimnames(lq_l)$INSTR[dimnames(lq_l)$INSTR=='F32'] = dimnames(lqt_l)$INSTR[dimnames(lqt_l)$INSTR=='F32'] = dimnames(lqt)$INSTR[dimnames(lqt)$INSTR=='F32'] = 'F3L'
dimnames(lq)$INSTR[dimnames(lq)$INSTR=='F41'] = dimnames(lq_l)$INSTR[dimnames(lq_l)$INSTR=='F41'] = dimnames(lqt_l)$INSTR[dimnames(lqt_l)$INSTR=='F41'] = dimnames(lqt)$INSTR[dimnames(lqt)$INSTR=='F41'] = 'F4S'
dimnames(lq)$INSTR[dimnames(lq)$INSTR=='F42'] = dimnames(lq_l)$INSTR[dimnames(lq_l)$INSTR=='F42'] = dimnames(lqt_l)$INSTR[dimnames(lqt_l)$INSTR=='F42'] = dimnames(lqt)$INSTR[dimnames(lqt)$INSTR=='F42'] = 'F4L'
dimnames(lq)$INSTR[dimnames(lq)$INSTR=='F22_F29'] = dimnames(lq_l)$INSTR[dimnames(lq_l)$INSTR=='F22_F29'] = dimnames(lqt_l)$INSTR[dimnames(lqt_l)$INSTR=='F22_F29'] = dimnames(lqt)$INSTR[dimnames(lqt)$INSTR=='F22_F29'] = 'F2M'
dimnames(lq)$INSTR[dimnames(lq)$INSTR=='F512_F519'] = dimnames(lq_l)$INSTR[dimnames(lq_l)$INSTR=='F512_F519'] = dimnames(lqt_l)$INSTR[dimnames(lqt_l)$INSTR=='F512_F519'] = dimnames(lqt)$INSTR[dimnames(lqt)$INSTR=='F512_F519'] = 'F51M'
dimnames(lq)$INSTR[dimnames(lq)$INSTR=='F61_F66'] = dimnames(lq_l)$INSTR[dimnames(lq_l)$INSTR=='F61_F66'] = dimnames(lqt_l)$INSTR[dimnames(lqt_l)$INSTR=='F61_F66'] = dimnames(lqt)$INSTR[dimnames(lqt)$INSTR=='F61_F66'] = 'F6O'
dimnames(lq)$INSTR[dimnames(lq)$INSTR=='F64_F65'] = dimnames(lq_l)$INSTR[dimnames(lq_l)$INSTR=='F64_F65'] = dimnames(lqt_l)$INSTR[dimnames(lqt_l)$INSTR=='F64_F65'] = dimnames(lqt)$INSTR[dimnames(lqt)$INSTR=='F64_F65'] = 'F6P'

#### Create sums
lq[.F6N..]<-lq[.F62..]+lq[.F6M..]
lqt[.F6N..]<-lqt[.F62..]+lqt[.F6M..]
lq_l[.F6N..]<-lq_l[.F62..]+lq_l[.F6M..]
lqt_l[.F6N..]<-lqt_l[.F62..]+lqt_l[.F6M..]

####EA18=EA19=EA20
lq["EA18..."]=lq["EA19..."]<-lq["EA20..."]
lqt["EA18..."]=lqt["EA19..."]<-lqt["EA20..."]
lq_l["EA18..."]=lq_l["EA19..."]<-lq_l["EA20..."]
lqt_l["EA18..."]=lqt_l["EA19..."]<-lqt_l["EA20..."]

# Save processed NASQ data
saveRDS(lq, file.path(data_dir, 'intermediate_domestic_data_files/nasq_processed_assets_stocks.rds'))
saveRDS(lqt, file.path(data_dir, 'intermediate_domestic_data_files/nasq_processed_assets_flows.rds'))
saveRDS(lq_l, file.path(data_dir, 'intermediate_domestic_data_files/nasq_processed_liab_stocks.rds'))
=======
# Load required packages
library(MDstats)
library(MD3)

# Define paste0 operator
`%&%` = function (..., collapse = NULL, recycle0 = FALSE)  .Internal(paste0(list(...), collapse, recycle0))

# Set data directory
if (!exists("data_dir")) data_dir = getwd()

# Load NASQ data that was already processed in 008_load_NASQ.R
nasq_S = readRDS(file.path(data_dir, "domestic_loading_data_files/nasq_S.rds"))
nasq_F = readRDS(file.path(data_dir, "domestic_loading_data_files/nasq_F.rds"))

# Extract quarterly data from 1999Q4 onwards
lq=nasq_S["ASS....1999q4:"]
lq_l=nasq_S["LIAB....1999q4:"]
lqt=nasq_F["ASS....1999q4:"]
lqt_l=nasq_F["LIAB....1999q4:"]

# Standardize dimension names
names(dimnames(lq))[[1]] = names(dimnames(lqt))[[1]] = names(dimnames(lq_l))[[1]] = names(dimnames(lqt_l))[[1]] = 'REF_AREA'
names(dimnames(lq))[[2]] = names(dimnames(lqt))[[2]] = names(dimnames(lq_l))[[2]] = names(dimnames(lqt_l))[[2]] = 'INSTR'
names(dimnames(lq))[[3]] = names(dimnames(lqt))[[3]] = 'REF_SECTOR'
names(dimnames(lq_l))[[3]] = names(dimnames(lqt_l))[[3]] = 'COUNTERPART_SECTOR'

####### RENAME SECTORS AND INSTRUMENTS!

# Sector mappings
dimnames(lq)$REF_SECTOR[dimnames(lq)$REF_SECTOR=='S14_S15'] = dimnames(lq_l)$COUNTERPART_SECTOR[dimnames(lq_l)$COUNTERPART_SECTOR=='S14_S15'] = dimnames(lqt_l)$COUNTERPART_SECTOR[dimnames(lqt_l)$COUNTERPART_SECTOR=='S14_S15'] = dimnames(lqt)$REF_SECTOR[dimnames(lqt)$REF_SECTOR=='S14_S15'] = 'S1M'
dimnames(lq)$REF_SECTOR[dimnames(lq)$REF_SECTOR=='S121_S122_S123'] = dimnames(lq_l)$COUNTERPART_SECTOR[dimnames(lq_l)$COUNTERPART_SECTOR=='S121_S122_S123'] = dimnames(lqt_l)$COUNTERPART_SECTOR[dimnames(lqt_l)$COUNTERPART_SECTOR=='S121_S122_S123'] = dimnames(lqt)$REF_SECTOR[dimnames(lqt)$REF_SECTOR=='S121_S122_S123'] = 'S12K'
dimnames(lq)$REF_SECTOR[dimnames(lq)$REF_SECTOR=='S125_S126_S127'] = dimnames(lq_l)$COUNTERPART_SECTOR[dimnames(lq_l)$COUNTERPART_SECTOR=='S125_S126_S127'] = dimnames(lqt_l)$COUNTERPART_SECTOR[dimnames(lqt_l)$COUNTERPART_SECTOR=='S125_S126_S127'] = dimnames(lqt)$REF_SECTOR[dimnames(lqt)$REF_SECTOR=='S125_S126_S127'] = 'S12O'

# Financial instrument mappings
dimnames(lq)$INSTR[dimnames(lq)$INSTR=='F63_F64_F65'] = dimnames(lq_l)$INSTR[dimnames(lq_l)$INSTR=='F63_F64_F65'] = dimnames(lqt_l)$INSTR[dimnames(lqt_l)$INSTR=='F63_F64_F65'] = dimnames(lqt)$INSTR[dimnames(lqt)$INSTR=='F63_F64_F65'] = 'F6M'
dimnames(lq)$INSTR[dimnames(lq)$INSTR=='F31'] = dimnames(lq_l)$INSTR[dimnames(lq_l)$INSTR=='F31'] = dimnames(lqt_l)$INSTR[dimnames(lqt_l)$INSTR=='F31'] = dimnames(lqt)$INSTR[dimnames(lqt)$INSTR=='F31'] = 'F3S'
dimnames(lq)$INSTR[dimnames(lq)$INSTR=='F32'] = dimnames(lq_l)$INSTR[dimnames(lq_l)$INSTR=='F32'] = dimnames(lqt_l)$INSTR[dimnames(lqt_l)$INSTR=='F32'] = dimnames(lqt)$INSTR[dimnames(lqt)$INSTR=='F32'] = 'F3L'
dimnames(lq)$INSTR[dimnames(lq)$INSTR=='F41'] = dimnames(lq_l)$INSTR[dimnames(lq_l)$INSTR=='F41'] = dimnames(lqt_l)$INSTR[dimnames(lqt_l)$INSTR=='F41'] = dimnames(lqt)$INSTR[dimnames(lqt)$INSTR=='F41'] = 'F4S'
dimnames(lq)$INSTR[dimnames(lq)$INSTR=='F42'] = dimnames(lq_l)$INSTR[dimnames(lq_l)$INSTR=='F42'] = dimnames(lqt_l)$INSTR[dimnames(lqt_l)$INSTR=='F42'] = dimnames(lqt)$INSTR[dimnames(lqt)$INSTR=='F42'] = 'F4L'
dimnames(lq)$INSTR[dimnames(lq)$INSTR=='F22_F29'] = dimnames(lq_l)$INSTR[dimnames(lq_l)$INSTR=='F22_F29'] = dimnames(lqt_l)$INSTR[dimnames(lqt_l)$INSTR=='F22_F29'] = dimnames(lqt)$INSTR[dimnames(lqt)$INSTR=='F22_F29'] = 'F2M'
dimnames(lq)$INSTR[dimnames(lq)$INSTR=='F512_F519'] = dimnames(lq_l)$INSTR[dimnames(lq_l)$INSTR=='F512_F519'] = dimnames(lqt_l)$INSTR[dimnames(lqt_l)$INSTR=='F512_F519'] = dimnames(lqt)$INSTR[dimnames(lqt)$INSTR=='F512_F519'] = 'F51M'
dimnames(lq)$INSTR[dimnames(lq)$INSTR=='F61_F66'] = dimnames(lq_l)$INSTR[dimnames(lq_l)$INSTR=='F61_F66'] = dimnames(lqt_l)$INSTR[dimnames(lqt_l)$INSTR=='F61_F66'] = dimnames(lqt)$INSTR[dimnames(lqt)$INSTR=='F61_F66'] = 'F6O'
dimnames(lq)$INSTR[dimnames(lq)$INSTR=='F64_F65'] = dimnames(lq_l)$INSTR[dimnames(lq_l)$INSTR=='F64_F65'] = dimnames(lqt_l)$INSTR[dimnames(lqt_l)$INSTR=='F64_F65'] = dimnames(lqt)$INSTR[dimnames(lqt)$INSTR=='F64_F65'] = 'F6P'

#### Create sums
lq[.F6N..]<-lq[.F62..]+lq[.F6M..]
lqt[.F6N..]<-lqt[.F62..]+lqt[.F6M..]
lq_l[.F6N..]<-lq_l[.F62..]+lq_l[.F6M..]
lqt_l[.F6N..]<-lqt_l[.F62..]+lqt_l[.F6M..]

####EA18=EA19=EA20
lq["EA18..."]=lq["EA19..."]<-lq["EA20..."]
lqt["EA18..."]=lqt["EA19..."]<-lqt["EA20..."]
lq_l["EA18..."]=lq_l["EA19..."]<-lq_l["EA20..."]
lqt_l["EA18..."]=lqt_l["EA19..."]<-lqt_l["EA20..."]

# Save processed NASQ data
saveRDS(lq, file.path(data_dir, 'intermediate_domestic_data_files/nasq_processed_assets_stocks.rds'))
saveRDS(lqt, file.path(data_dir, 'intermediate_domestic_data_files/nasq_processed_assets_flows.rds'))
saveRDS(lq_l, file.path(data_dir, 'intermediate_domestic_data_files/nasq_processed_liab_stocks.rds'))
>>>>>>> 55a5a789115f3c6e93936ceaded19180b9724739
saveRDS(lqt_l, file.path(data_dir, 'intermediate_domestic_data_files/nasq_processed_liab_flows.rds'))