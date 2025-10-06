library(MDstats); library(MD3)
`%&%` = function (..., collapse = NULL, recycle0 = FALSE)  .Internal(paste0(list(...), collapse, recycle0))

# Set data directory
setwd("Z:/FinFlows/githubrepo/trialarea")
data_dir= file.path(getwd(),'data')
if (!exists("data_dir")) data_dir = '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/data/'


aall=readRDS("Z:/FinFlows/githubrepo/finflows/data/intermediate_domestic_data_files/aall_bsi_f5.rds"); gc()
setkey(aall, NULL)
gc()
bsi_loans_dep= readRDS("data/bsi_loans_dep.rds")

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
#check
saveRDS(aall, file='data/intermediate_domestic_data_files/aall_bsi_loans_deposits.rds')
