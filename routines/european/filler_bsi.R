library(MDstats); library(MD3)

# Set data directory
#data_dir= file.path(getwd(),'data')
if (!exists("data_dir")) data_dir = '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/data/'

## load filled iip bop
## split of assets and liabilities of banks
aa=readRDS(file.path(data_dir,'aa_iip_cps.rds')); gc()
ll=readRDS(file.path(data_dir,'ll_iip_cps.rds')); gc()

# Load loans data
loans_bsi= readRDS("data/bsi_loans.rds")
dim(loans_bsi)
dimnames(loans_bsi)[['REF_AREA']] = ccode(dimnames(loans_bsi)[['REF_AREA']],2,'iso2m',leaveifNA=TRUE); gc()
dimnames(loans_bsi)[['COUNTERPART_AREA']] = ccode(dimnames(loans_bsi)[['COUNTERPART_AREA']],2,'iso2m',leaveifNA=TRUE); gc()

### ?!?! to review = manual allocation of EA to EA20 
dimnames(loans_bsi)$REF_AREA[dimnames(loans_bsi)$REF_AREA=='EA'] ='EA20'
dimnames(loans_bsi)$COUNTERPART_AREA[dimnames(loans_bsi)$COUNTERPART_AREA=='EA'] ='EA20'


#check
#Loans
aa[F4.AT.S12T..LE._T.2022q4.]

#LOANS FILLING
# maturity A is = total, F= up to 1 year (short term), K = more than 1 year (long term)
aa[F4..S12T..._T.., usenames=TRUE, onlyna=TRUE] = loans_bsi[".A....1998q4:"]
aa[F4..S12T..._O.., usenames=TRUE, onlyna=TRUE] = loans_bsi[".A....1998q4:"]
aa[F4S..S12T..._T.., usenames=TRUE, onlyna=TRUE] = loans_bsi[".F....1998q4:"]
aa[F4S..S12T..._O.., usenames=TRUE, onlyna=TRUE] = loans_bsi[".F....1998q4:"]
aa[F4L..S12T..._T.., usenames=TRUE, onlyna=TRUE] = loans_bsi[".K....1998q4:"]
aa[F4L..S12T..._O.., usenames=TRUE, onlyna=TRUE] = loans_bsi[".K....1998q4:"]
#check
#Loans
aa[F4.AT.S12T..LE._T.2022q4.]

# Load deposits data
deposits_bsi = readRDS("data/bsi_deposits.rds")
dim(deposits_bsi)
dimnames(deposits_bsi)[['REF_AREA']] = ccode(dimnames(deposits_bsi)[['REF_AREA']],2,'iso2m',leaveifNA=TRUE); gc()
dimnames(deposits_bsi)[['COUNTERPART_AREA']] = ccode(dimnames(deposits_bsi)[['COUNTERPART_AREA']],2,'iso2m',leaveifNA=TRUE); gc()

### ?!?! to review = manual allocation of EA to EA20 
dimnames(deposits_bsi)$REF_AREA[dimnames(deposits_bsi)$REF_AREA=='EA'] ='EA20'
dimnames(deposits_bsi)$COUNTERPART_AREA[dimnames(deposits_bsi)$COUNTERPART_AREA=='EA'] ='EA20'


names(dimnames(deposits_bsi))[names(dimnames(deposits_bsi))=="REF_SECTOR"] <- 'COUNTERPART_SECTOR'
names(dimnames(deposits_bsi))[names(dimnames(deposits_bsi))=="REF_AREA"] <- 'COUNTERPART_AREA2'
names(dimnames(deposits_bsi))[names(dimnames(deposits_bsi))=="COUNTERPART_AREA"] <- 'REF_AREA'
names(dimnames(deposits_bsi))[names(dimnames(deposits_bsi))=="COUNTERPART_AREA2"] <- 'COUNTERPART_AREA'

dim(deposits_bsi)

#check
#Deposits
ll[F2M...S12T.LE._T.2022q4.AT]

#DEPOSITS FILLING
ll[F2M...S12T.._T.., usenames=TRUE, onlyna=TRUE] = deposits_bsi[".A....1998q4:"]
ll[F2M...S12T.._O.., usenames=TRUE, onlyna=TRUE] = deposits_bsi[".A....1998q4:"]
ll[F2M...S12T.LE._T.2022q4.AT]

saveRDS(aa,file='data/aa_iip_bsi.rds')
saveRDS(ll,file='data/ll_iip_bsi.rds')
