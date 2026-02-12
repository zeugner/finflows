library(MDstats); library(MD3)

# Set data directory
data_dir= file.path(getwd(),'data')
#if (!exists("data_dir")) data_dir = '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/data/'

#source('\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/routines/utilities.R')
gc()

## load filled iip bop
aa=readRDS(file.path(data_dir,'aa_iip_bsi.rds')); gc()
ll=readRDS(file.path(data_dir,'ll_iip_bsi.rds')); gc()

## load shs-s data
ash=readRDS(file.path(data_dir,'ash.rds')); gc()
gc()

############################################################
##### imputation is done for:
#####  >> reference area = EA19 
#####  >> STO= LE (stocks) 
############################################################

#overview
ash['.EA+EA19.W0.S11..LE.F3.2021q4']
#example, filled only for shss:
ash['.EA+EA19.W0.S11.S122.LE.F3.2021q4']
#example, filled only for shs:
ash['.EA+EA19.W0.S11.S13.LE.F3.2019q4']

###impute NAs from shss to shs and vice versa

###loop through reference sector and financial instrument

ref_sector = dimnames(ash)[['REF_SECTOR']]
instr = dimnames(ash)[['INSTR_ASSET']]

for (rs in ref_sector) {
  for (fi in instr) {
    pat_shss <- paste0("shss.EA..", rs, "..LE.", fi, ".")
    pat_shs  <- paste0("shs.EA19..", rs, "..LE.", fi, ".")
    
    tempshss <- ash[pat_shss]  
    tempshss <- imputena(tempshss, ash[pat_shs])
    ash[pat_shss, onlyna=TRUE] <- tempshss
  }
}

ash['.EA+EA19.W0.S11.S11.LE.F511.2019q4']

### use SHS information for EA19 
tempshsea=ash['shs.EA19....LE..']; gc()
ash['shss.EA19....LE..',usenames=TRUE, onlyna=TRUE]=tempshsea
ash['.EA+EA19.W0.S11.S13.LE.F3.2019q4']


saveRDS(ash, file.path(data_dir, '.ash.rds'))


ashs=ash
dim(ashs)

dimnames(ashs)$REF_AREA[dimnames(ashs)$REF_AREA=='EA'] ='EA20'
dimnames(ashs)$COUNTERPART_AREA[dimnames(ashs)$COUNTERPART_AREA=='EA'] ='EA20'
names(dimnames(ashs))[names(dimnames(ashs))=="INSTR_ASSET"] <- 'INSTR'
gc()

dim(ashs)

##prep
#drop source since data was imputed + EA19 information is was filled for NAs in shss
shs=ashs["shss",,,,,,,]; gc()
shs=aperm(copy(shs), c(6,1,3:5,7,2)); gc()
dim(shs)
dim(aa)

#check
#before
aa[F3.AT.S1..LE._T.2022q4.EA20+W2+WRL_REST]
shs[F3.AT...LE.2022q4.EA20]

#FILLING assets
common_instr <- intersect(dimnames(aa)$INSTR, dimnames(shs)$INSTR)
common_time <- intersect(dimnames(aa)$TIME, dimnames(shs)$TIME)

for (i in common_instr) {
  aa[i, , , , , "_T", common_time, , usenames=TRUE, onlyna=TRUE] =shs[i,,,,,common_time,]
  }

#check
#after
aa[F3.AT.S1..LE._T.2022q4.EA20+W2+WRL_REST]



#ll was not adjusted but for naming consistency it is saved too
saveRDS(aa,file.path(data_dir,'aa_iip_shss.rds'))
saveRDS(ll,file.path(data_dir,'ll_iip_shss.rds'))

saveRDS(aa,file.path(data_dir,'vintages/aa_iip_shss_' %&% format(Sys.time(),'%F') %&% '_.rds'))
saveRDS(ll,file.path(data_dir,'vintages/ll_iip_shss_' %&% format(Sys.time(),'%F') %&% '_.rds'))
