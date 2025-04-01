#setwd("V:/FinFlows/githubrepo/trialarea")

library(MDstats); library(MD3)
`%&%` = function (..., collapse = NULL, recycle0 = FALSE)  .Internal(paste0(list(...), collapse, recycle0))

# Set data directory
#data_dir= file.path(getwd(),'data')
if (!exists("data_dir")) data_dir = '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/data/'


#temp load current aall version
#aall=readRDS(file.path(data_dir,'aall6.rds')); gc()
aall=readRDS(file.path(data_dir,'aall6.rds')); gc()
aall=unflag(aall)["....._T+FND."]
gc()
names(dimnames(aall))[6] = 'FUNCTIONAL_CAT'
dimnames(aall)$FUNCTIONAL_CAT[dimnames(aall)$FUNCTIONAL_CAT=='FND'] = '_D'
gc()
str(aall)
aall[....._F.] <- NA
aall[....._O.] <- NA
aall[....._P.] <- NA
aall[....._R.] <- NA
gc()
##############################################################
### FDI Information from ECB QSA
#setting FDI information from QSA as NA if 0, in order to fill if values are available in ESTAT
dall=as.data.table(unflag(aall),na.rm = TRUE)
dall[COUNTERPART_SECTOR =='S0' & FUNCTIONAL_CAT   =='_D' & obs_value ==0, obs_value:=NA]
dall[REF_SECTOR =='S0' & FUNCTIONAL_CAT   =='_D' & obs_value ==0, obs_value:=NA]
aall=as.md3(dall); rm(dall)
###direct investment assets from ECB QSA
aall[...S2.LE._D., usenames=FALSE, onlyna=TRUE] = aall[...S0.LE._D.]
aall[..S12R.S2.LE._D., usenames=FALSE, onlyna=TRUE] = aall[..S124.S0.LE._D.]+aall[..S12O.S0.LE._D.]+aall[..S12Q.S0.LE._D.]
aall[...S2.F._D., usenames=FALSE, onlyna=TRUE] = aall[...S0.F._D.]
aall[..S12R.S2.F._D., usenames=FALSE, onlyna=TRUE] = aall[..S124.S0.F._D.]+aall[..S12O.S0.F._D.]+aall[..S12Q.S0.F._D.]
###direct investment liabilities from ECB QSA
aall[..S2..LE._D., usenames=FALSE, onlyna=TRUE] = aall[..S0..LE._D.]
aall[..S2.S12R.LE._D., usenames=FALSE, onlyna=TRUE] = aall[..S0.S124.LE._D.]+aall[..S0.S12O.LE._D.]+aall[..S0.S12Q.LE._D.]
aall[..S2..F._D., usenames=FALSE, onlyna=TRUE] = aall[..S0..F._D.]
aall[..S2.S12R.F._D., usenames=FALSE, onlyna=TRUE] = aall[..S0.S124.F._D.]+aall[..S0.S12O.F._D.]+aall[..S0.S12Q.F._D.]
##############################################################
# Add the new dimension COUNTERPART_AREA with W0, W1, W2 codes
#fillall false only fills the first dimension while the others are filled with NAs
aall_8=add.dim(aall, .dimname = 'COUNTERPART_AREA', .dimcodes = c('W0', 'W1', 'W2'), .fillall = FALSE,)
gc()
aall_8[.F.AT.S0.S1.LE._T.2022q4]
## Use aperm to put the dimension at the end
# Create permutation vector: 2,3,4,5,6,7,8,1
# This means: take the 2nd through 8th dimensions in order, then put the 1st dimension last
aall <- aperm(aall_8, c(2:8, 1))
# Verify the new dimension order
dimnames(aall)
aall[F.AT.S0.S1.LE._T.2022q4.]
gc()
##############################################################
iip=readRDS(file.path(data_dir,'iip_cps.rds'))
dimnames(iip)
names(dimnames(iip))[2:4] = c( 'REF_AREA' ,'COUNTERPART_AREA','REF_SECTOR')
dimnames(iip)$REF_SECTOR[dimnames(iip)$REF_SECTOR=='S12M'] ='S12R'
#!?!? to be reviewed later
assetfiller = function(iip,le='LE',cparea=c("EA19", "EA20", "EXT_EA19", "EXT_EA20", "WRL_REST", "AT", "BG", "BR", "CA", "CH", "CN", "CY", "CZ",
                                  "DE", "DK", "EE", "EL", "ES", "EU27_2020", "EU28", "EUI", "EXT_EU27_2020", "EXT_EU28", "FI", "FR",
                                  "G20_X_EU27_2020", "HK", "HR", "HU", "IE", "IMF", "IN", "IT", "JP", "LT", "LU", "LV", "MT", "NL",
                                  "OFFSHO", "PL", "PT", "RO", "RU", "SE", "SI", "SK", "UK", "US", "AR", "AU", "ID", "KR", "MX", "NO",
                                  "SA", "TR", "ZA", "BE"),sss=c('S121','S12T','S13','S11','S1M','S124','S12O','S12Q','S1')) {
  #aaF = iip["A_LE....FA__D__F+FA__P__F+FA__O__F+FA__R__F+FA__F__F7."]; gc()
  aaF = iip[dimnames(aall)$REF_AREA,,sss,,time(aall)]; gc()
  for (cp in cparea) {
    message(cp)
    aall['F',,sss,'S2',le,'_P',,cp,  usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F", ]); gc()
    aall['F',,sss,'S2',le,'_O',,cp,  usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F", ]); gc()
    aall['F',,sss,'S2',le,'_D',,cp,  usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F", ]); gc()
    aall['F',,sss,'S2',le,'_R',,cp,  usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__R__F", ]); gc()
    aall['F',,sss,'S2',le,'_F',,cp,  usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__F__F7", ]); gc()
    aall['F2M',,sss,'S2',le,'_O',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F2", ]); gc()
    aall['F3',,sss,'S2',le,'_D',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F3", ]); gc()
    aall['F3',,sss,'S2',le,'_P',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F3", ]); gc()
    aall['F4',,sss,'S2',le,'_D',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F4", ]); gc()
    aall['F4',,sss,'S2',le,'_O',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F4", ]); gc()
    aall['F52',,sss,'S2',le,'_P',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F52", ]); gc()
    aall['F511',,sss,'S2',le,'_D',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F511", ]); gc()
    aall['F511',,sss,'S2',le,'_P',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F511", ]); gc()
    aall['F51',,sss,'S2',le,'_P',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F51", ]); gc()
    aall['F51M',,sss,'S2',le,'_D',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F51M", ]); gc()
    aall['F51M',,sss,'S2',le,'_P',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,".FA__P__F512", ]); gc()
    aall['F51M',,sss,'S2',le,'_O',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F519", ]); gc()
    aall['F6',,sss,'S2',le,'_O',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F6", ]); gc()
    aall['F81',,sss,'S2',le,'_D',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F81", ]); gc()
    aall['F81',,sss,'S2',le,'_O',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F81", ]); gc()
    aall['F89',,sss,'S2',le,'_O',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F89", ]); gc()
  }
}


assetfiller(iip["A_LE....."],'LE',c("IT", "EA19", "EA20", "EXT_EA19", "EXT_EA20", "WRL_REST", "AT", "BG", "BR", "CA", "CH", "CN", "CY", "CZ",
                "DE", "DK", "EE", "EL", "ES", "EU27_2020", "EU28", "EUI", "EXT_EU27_2020", "EXT_EU28", "FI", "FR",
                "G20_X_EU27_2020", "HK", "HR", "HU", "IE", "IMF", "IN", "IT", "JP", "LT", "LU", "LV", "MT", "NL",
                "OFFSHO", "PL", "PT", "RO", "RU", "SE", "SI", "SK", "UK", "US", "AR", "AU", "ID", "KR", "MX", "NO",
                "SA", "TR", "ZA", "BE"))
aall[F..S1.S2.LE..2024q1.EXT_EU27_2020]

liabfiller = function(iip,le='LE',cparea=c("EA19", "EA20", "EXT_EA19", "EXT_EA20", "WRL_REST", "AT", "BG", "BR", "CA", "CH", "CN", "CY", "CZ",
                                            "DE", "DK", "EE", "EL", "ES", "EU27_2020", "EU28", "EUI", "EXT_EU27_2020", "EXT_EU28", "FI", "FR",
                                            "G20_X_EU27_2020", "HK", "HR", "HU", "IE", "IMF", "IN", "IT", "JP", "LT", "LU", "LV", "MT", "NL",
                                            "OFFSHO", "PL", "PT", "RO", "RU", "SE", "SI", "SK", "UK", "US", "AR", "AU", "ID", "KR", "MX", "NO",
                                            "SA", "TR", "ZA", "BE"),sss=c('S121','S12T','S13','S11','S1M','S124','S12O','S12Q','S1')) {
  #aaF = iip["A_LE....FA__D__F+FA__P__F+FA__O__F+FA__R__F+FA__F__F7."]; gc()
  llF = iip[dimnames(aall)$REF_AREA,,sss,,time(aall)]; gc()
  names(dimnames(llF))[names(dimnames(llF))=="REF_SECTOR"] <- 'COUNTERPART_SECTOR'
  for (cp in cparea) {
    message(cp)
    aall['F',,'S2',sss,le,'_P',,cp,  usenames=FALSE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F", ]); gc()
    aall['F',,'S2',sss,le,'_O',,cp,  usenames=FALSE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F", ]); gc()
    aall['F',,'S2',sss,le,'_D',,cp,  usenames=FALSE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F", ]); gc()
    aall['F',,'S2',sss,le,'_R',,cp,  usenames=FALSE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__R__F", ]); gc()
    aall['F',,'S2',sss,le,'_F',,cp,  usenames=FALSE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__F__F7", ]); gc()
    aall['F2M',,'S2',sss,le,'_O',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F2", ]); gc()
    aall['F3',,'S2',sss,le,'_D',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F3", ]); gc()
    aall['F3',,'S2',sss,le,'_P',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F3", ]); gc()
    aall['F4',,'S2',sss,le,'_D',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F4", ]); gc()
    aall['F4',,'S2',sss,le,'_O',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F4", ]); gc()
    aall['F52',,'S2',sss,le,'_P',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F52", ]); gc()
    aall['F511',,'S2',sss,le,'_D',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F511", ]); gc()
    aall['F511',,'S2',sss,le,'_P',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F511", ]); gc()
    aall['F51',,'S2',sss,le,'_P',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F51", ]); gc()
    aall['F51M',,'S2',sss,le,'_D',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F51M", ]); gc()
    aall['F51M',,'S2',sss,le,'_P',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(llF[,cp,,".FA__P__F512", ]); gc()
    aall['F51M',,'S2',sss,le,'_O',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F519", ]); gc()
    aall['F6',,'S2',sss,le,'_O',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F6", ]); gc()
    aall['F81',,'S2',sss,le,'_D',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F81", ]); gc()
    aall['F81',,'S2',sss,le,'_O',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F81", ]); gc()
    aall['F89',,'S2',sss,le,'_O',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F89", ]); gc()
  }
}


liabfiller(iip["L_LE....."],'LE',c("IT", "EA19", "EA20", "EXT_EA19", "EXT_EA20", "WRL_REST", "AT", "BG", "BR", "CA", "CH", "CN", "CY", "CZ",
                                    "DE", "DK", "EE", "EL", "ES", "EU27_2020", "EU28", "EUI", "EXT_EU27_2020", "EXT_EU28", "FI", "FR",
                                    "G20_X_EU27_2020", "HK", "HR", "HU", "IE", "IMF", "IN", "IT", "JP", "LT", "LU", "LV", "MT", "NL",
                                    "OFFSHO", "PL", "PT", "RO", "RU", "SE", "SI", "SK", "UK", "US", "AR", "AU", "ID", "KR", "MX", "NO",
                                    "SA", "TR", "ZA", "BE"))
aall[F..S2.S1.LE..2024q1.EXT_EU27_2020]

#####################################################
### calculating S2 based on functional categories

zerofiller=function(x, fillscalar=0){
  temp=copy(x)
  temp[onlyna=TRUE]=fillscalar
  temp
}

tempA=as.md3(apply((aall["...S2.LE._D+_P+_O+_R+_F.." ]),c('INSTR','REF_AREA','REF_SECTOR','TIME','COUNTERPART_AREA'),
                   function(x) if (all(is.na(x))) {
                     return(NA_real_)
                   } else {
                     return(sum(x,na.rm=TRUE))
                   }))

aall["...S2.LE._T.." ,onlyna=TRUE] = tempA


tempL=as.md3(apply((aall["..S2..LE._D+_P+_O+_R+_F.." ]),c('INSTR','REF_AREA','COUNTERPART_SECTOR','TIME','COUNTERPART_AREA'),
                   function(x) if (all(is.na(x))) {
                     return(NA_real_)
                   } else {
                     return(sum(x,na.rm=TRUE))
                   }))

aall["..S2..LE._T.." ,onlyna=TRUE] = tempL


saveRDS(aall,file='data/aall_iip_cps.rds')
