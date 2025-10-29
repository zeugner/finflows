library(MDstats) 
library(MD3)

# Set data directory
#data_dir= file.path(getwd(),'data')
if (!exists("data_dir")) data_dir = '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/data'
source('\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/routines/utilities.R')



############################################################################################################################
############################################################################################################################
#####                                   temp load current aall version                                                 ##### 
##        aall_domestic is the final output of the domestic economy (incl. for example F51M counterpart allocation)       ##
############################################################################################################################
############################################################################################################################

aall=readRDS(file.path(data_dir,'aall_domestic.rds')); gc()
aall[F.AT.S1.S2+S0.LE._T.2022q4]
aall[F.AT.S2+S0.S1.LE._T.2022q4]


#########################################
#check functional_cat - only use _T 
#########################################

if (!('FUNCTIONAL_CAT' %in% names(dimnames(aall)))) stop('hey, i need FUNCTIONAL_CAT')
dimnames(aall)[[6]]

aall=aall['....._T.'] 
aallsmall=aall
aall=add.dim(aallsmall, .dimname = 'FUNCTIONAL_CAT', .dimcodes = c('_T'), .fillall = FALSE)
aall <- aperm(aall, c(2:6,1,7))
gc()
dimnames(aall)[[6]]
dimnames(aall)$FUNCTIONAL_CAT[dimnames(aall)$FUNCTIONAL_CAT=='X_T'] = '_T'

#########################################
#clean data 
#########################################

dall=as.data.table(aall,.simple=TRUE,na.rm=TRUE)
if (anyNA(dall$obs_value)) {dall=dall[!is.na(obs_value), ]}
dall=dall[!(REF_SECTOR %in% c('S2I','S22', 'S21')),]
dall=dall[!(COUNTERPART_SECTOR %in% c('S2I','S22', 'S21')),]
dall=dall[!(REF_AREA %in% c('GR','GB','I7','I8','I9')),]

#dall=dall[!(COUNTERPART_AREA %in% c('GR','GB','I7','I8','I9')),]

mydn=dimnames(aall)
mydn[["REF_SECTOR"]]=setdiff(mydn[["REF_SECTOR"]],c('S2I','S22', 'S21'))
mydn[["COUNTERPART_SECTOR"]]=setdiff(mydn[["COUNTERPART_SECTOR"]],c('S2I','S22', 'S21'))
mydn[["REF_AREA"]]=setdiff(mydn[["REF_AREA"]],c('GR','GB','I7','I8','I9'))
#mydn[["COUNTERPART_AREA"]]=setdiff(mydn[["COUNTERPART_AREA"]],c('GR','GB','I7','I8','I9'))
attr(dall, 'dcstruct') = MD3:::.dimcodesrescue(mydn,dimcodes(aall))
attr(dall, 'dcsimp') = mydn
aall=as.md3(dall)
gc()

#########################################
#adjust iso code
#########################################

dimnames(aall)[['REF_AREA']] = ccode(dimnames(aall)[['REF_AREA']],2,'iso2m'); gc()

aall[F.AT.S1.S2+S0.LE._T.2022q4]
aall[F.AT.S2+S0.S1.LE._T.2022q4]

#what is saveRDSvl?
saveRDSvl(aall,file=file.path(data_dir,'aall_temp.rds'))
saveRDSvl(aall,file=file.path(data_dir,'vintages/aall_temp' %&% format(Sys.time(),'%F') %&% '_.rds'))

##############################################################
### load FDI Information from ECB QSA
##############################################################
fnd=readRDS('\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/trialarea/data/fndqsa.rds')
names(dimnames(fnd))[5] = 'INSTR'
fnd=aperm(copy(fnd),c(5,2,3,1,4,6))


##############################################################
### fill FDI Information from ECB QSA
##############################################################
#setting FDI information from QSA as NA if 0, in order to fill if values are available in ESTAT
##############################################################
dall=as.data.table(unflag(aall),na.rm = TRUE)
dall[COUNTERPART_SECTOR =='S0' & FUNCTIONAL_CAT   =='_D' & obs_value ==0, obs_value:=NA]
dall[REF_SECTOR =='S0' & FUNCTIONAL_CAT   =='_D' & obs_value ==0, obs_value:=NA]
aall=as.md3(dall); rm(dall)
###direct investment assets from ECB QSA
aall[...S2.LE._D., usenames=TRUE, onlyna=TRUE] = fnd[...S0.LE.]
aall[..S12R.S2.LE._D., usenames=TRUE, onlyna=TRUE] = fnd[..S124.S0.LE.]+fnd[..S12O.S0.LE.]+fnd[..S12Q.S0.LE.]
aall[...S2.F._D., usenames=TRUE, onlyna=TRUE] = fnd[...S0.F.]
aall[..S12R.S2.F._D., usenames=TRUE, onlyna=TRUE] = fnd[..S124.S0.F.]+fnd[..S12O.S0.F.]+fnd[..S12Q.S0.F.]
###direct investment liabilities from ECB QSA
aall[..S2..LE._D., usenames=TRUE, onlyna=TRUE] = fnd[..S0..LE.]
aall[..S2.S12R.LE._D., usenames=TRUE, onlyna=TRUE] = fnd[..S0.S124.LE.]+fnd[..S0.S12O.LE.]+fnd[..S0.S12Q.LE.]
aall[..S2..F._D., usenames=TRUE, onlyna=TRUE] = fnd[..S0..F.]
aall[..S2.S12R.F._D., usenames=TRUE, onlyna=TRUE] = fnd[..S0.S124.F.]+fnd[..S0.S12O.F.]+fnd[..S0.S12Q.F.]

gc()
str(aall)

saveRDSvl(aall,file=file.path(data_dir,'aall_intermediate.rds'))
saveRDSvl(aall,file=file.path(data_dir,'vintages/aall_intermediate' %&% format(Sys.time(),'%F') %&% '_.rds'))

###############################################################
# Add the new dimension COUNTERPART_AREA with W0, W1, W2 codes
###############################################################


aallsmall = copy(aall)
gc()
aall=add.dim(aallsmall, .dimname = 'COUNTERPART_AREA', .dimcodes = c('W2', 'W0', 'WRL_REST'), .fillall = FALSE)
aall <- aperm(aall, c(2:length(dim(aall)),1))
gc()

#check before
#S0 is total economy!!
aall[F.AT.S1..LE._T.2022q4.]
aall[F.AT..S1.LE._T.2022q4.]

aall['....._F+_O+_P+_R..'] <- NA

###############################################################
###############################################################
##because otherwise the combination of S1.S1. and W0 or WRL_REST is already filled, use S0 and S2 temporarily
##this will make the asset liability split easier without losing information
##S0 and S2 will be deleted later
###############################################################
###############################################################

aall[...S0....W0,usenames=TRUE, onlyna=TRUE]<-aall[...S0....W2]
aall[...S2....WRL_REST,usenames=TRUE, onlyna=TRUE]<-aall[...S2....W2]
aall[..S0.....W0,usenames=TRUE, onlyna=TRUE]<-aall[..S0.....W2]
aall[..S2.....WRL_REST,usenames=TRUE, onlyna=TRUE]<-aall[..S2.....W2]
gc()

#check after
aall[F.AT.S1..LE._T.2022q4.]
aall[F.AT..S1.LE._T.2022q4.]

saveRDSvl(aall,file=file.path(data_dir,'aall_intermediate.rds'))
saveRDSvl(aall,file=file.path(data_dir,'vintages/aall_intermediate' %&% format(Sys.time(),'%F') %&% '_.rds'))


##############################################################
#####splitting aall into assets (aa) and liabilities (ll)#####
###to fill cross-border assets and liabilities seperately ####
##############################################################

#example: AT households (S1M) has deposits (F2M) at IT bank (S12T)

############ assets are shown in aa, grouped by:	
# INSTR	REF_AREA	REF_SECTOR	COUNTERPART_SECTOR	STO	FUNCTIONAL_CAT	TIME	  COUNTERPART_AREA
# F2M   AT        S1M         S1 (S12T)           LE  _O              2024Q4  IT

############ liabilities are shown in ll, grouped by:
# ll	INSTR	 COUNTERPART_AREA	COUNTERPART_SECTOR	REF_SECTOR	STO	  FUNCTIONAL_CAT	TIME	  REF_AREA
# F2M   AT    AT              S1 (S1M)            S12T         LE     _O            2024Q4  IT

####ASSETS
## we want to keep aall for all domestic sectors, hence we exclude S2+S0
gc()

tempix=dimnames(aall)[[3]]
aa=copy(aall[,,setdiff(tempix,c('S0','S2')),,,,,])
gc()

#should exist:
aa[F511.AT.S2+S1+S0.S2+S1+S0.LE._T.2022q4.]
#should _not_ exist:
aa[F511.AT.S2+S0.S1.LE..2022q4.WRL_REST]

#S2 and S0 are no longer needed
aa[...S1....WRL_REST, usenames =FALSE, onlyna=TRUE]=aa[...S2....WRL_REST];gc()
aa[...S1....W0, usenames =FALSE, onlyna=TRUE]=aa[...S0....W0];gc()

#should not exist for S2+S0:
aa[F511.AT.S1.S2+S1+S0.LE._T.2022q4.]
#should exist:
aa[F511.AT.S1.S1.LE._T.2022q4.]


###replace with this erza

# tempix=dimnames(aa)[[4]]
# aa=copy(aa[,,,setdiff(tempix,c('S0','S2')),,,,])


####LIABILITIES
## we want to keep aall for all domestic sectors, hence we exclude S2+S0

gc()

tempix=dimnames(aall)[[4]]
ll=copy(aall[,,,setdiff(tempix,c('S0','S2')),,,,])

#should _not_  exist:
ll[F511.AT.S1.S2.LE..2022q4.]
#should exist:
ll[F511.AT.S2.S1.LE..2022q4.WRL_REST]

#S2 and S0 are no longer needed
ll[..S1.....WRL_REST, usenames =FALSE, onlyna=TRUE]=ll[..S2.....WRL_REST];gc()
ll[..S1.....W0, usenames =FALSE, onlyna=TRUE]=ll[..S0.....W0];gc()

#should not exist for S2+S0:
ll[F511.AT.S1.S2+S1+S0.LE._T.2022q4.]
#should exist:
ll[F511.AT.S1.S1.LE._T.2022q4.]

#switching structure of CP AREA and CP Sector for liabilities 
ll=aperm(copy(ll), c(1,8,4,3,5,6,7,2))
dim(ll)


#should not exist:
ll[F511.WRL_REST.S1.S2.LE..2022q4.AT]
#should  exist:
ll[F511..S1.S1.LE..2022q4.AT]
gc()

saveRDSvl(aa,file.path(data_dir,'aa_prep.rds'))
saveRDSvl(ll,file.path(data_dir,'ll_prep.rds'))

saveRDSvl(aa,file.path(data_dir,'vintages/aa_prep' %&% format(Sys.time(),'%F') %&% '_.rds'))
saveRDSvl(ll,file.path(data_dir,'vintages/ll_prep' %&% format(Sys.time(),'%F') %&% '_.rds'))
          
          