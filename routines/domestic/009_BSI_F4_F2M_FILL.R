# Load required packages
library(MDstats)
library(MD3)

# Define paste0 operator
`%&%` = function (..., collapse = NULL, recycle0 = FALSE)  .Internal(paste0(list(...), collapse, recycle0))

# Set data directory
if (!exists("data_dir")) data_dir = getwd()

aall=readRDS(file.path(data_dir, "intermediate_domestic_data_files/aall_bsi_f5.rds"))
gc()
setkey(aall, NULL)
gc()
bsi_loans_dep= readRDS(file.path(data_dir, "bsi_loans_dep.rds"))

bsi_loans=bsi_loans_dep[".A20....1999q1:"]
bsi_dep=bsi_loans_dep[".L20....1999q1:"]
gc()

### fill loans
names(dimnames(bsi_loans))[4] = 'COUNTERPART_SECTOR'
aall[F4..S12T..._T.,onlyna=TRUE]<-bsi_loans[.A...]
aall[F4S..S12T..._T.,onlyna=TRUE]<-bsi_loans[.F...]

### fill deposits
names(dimnames(bsi_dep))[4] = 'REF_SECTOR'
aall[F2M...S12T.._T.,onlyna=TRUE]<-bsi_dep[.A...]

aall[F2M.AT..S12T.LE._T.2022q4]
bsi_dep[AT.A.LE..2022q4]

# Check
saveRDS(aall, file.path(data_dir, 'intermediate_domestic_data_files/aall_bsi_loans_deposits.rds'))
