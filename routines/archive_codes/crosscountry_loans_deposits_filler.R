library(MDstats); library(MD3); library(MDecfin)

aall <- readRDS("Z:/FinFlows/githubrepo/finflows/data/aall_iip_cps.rds")

# Load loans data
loans_bsi= readRDS("data/bsi_loans.rds")
# Load deposits data
deposits_bsi = readRDS("data/bsi_deposits.rds")

setkey(aall, NULL)


### data structure
gc()
gc()

#check
#Loans
aall[F4.AT.S12T..LE._T.2022q4.]
#Deposits
aall[F2M.AT..S12T.LE._T.2022q4.]

#LOANS FILLING
aall[F4..S12T..._T.., usenames=TRUE, onlyna=TRUE] = loans_bsi["....1998q4:"]

#check
#Loans
aall[F4.AT.S12T..LE._T.2022q4.]


#DEPOSITS FILLING
aall[F2M...S12T.._T.., usenames=TRUE, onlyna=TRUE] = deposits_bsi["....1998q4:"]

aall[F2M.AT..S12T.LE._T.2022q4.]


saveRDS(aall, file='data/aall_RENAME.rds')