library(MDstats); library(MD3)
`%&%` = function (..., collapse = NULL, recycle0 = FALSE)  .Internal(paste0(list(...), collapse, recycle0))

# Set data directory
setwd("V:/FinFlows/githubrepo/trialarea")
data_dir= file.path(getwd(),'data')
if (!exists("data_dir")) data_dir = '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/data/'

aall=readRDS(file.path(data_dir,'intermediate_domestic_data_files/aall_bsi_loans_deposits.rds'))
setkey(aall, NULL)


ash=readRDS('data/ash.rds'); gc()

shss<-ash["shss..W2....."]
str(shss)

  names(dimnames(shss))[[5]] = 'INSTR'
dimnames(shss)
aall[....._T., usenames=TRUE, onlyna=TRUE] <- shss

saveRDS(aall, file.path('data/intermediate_domestic_data_files/aall_shss.rds'))
