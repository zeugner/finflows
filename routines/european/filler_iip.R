library(MDstats); library(MD3)

# Set data directory
#data_dir= file.path(getwd(),'data')
if (!exists("data_dir")) data_dir = '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/data/'
source('\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/routines/utilities.R')

##############################################################
########      loading prepared domestic data    ##############
##############################################################

aa=readRDS(file.path(data_dir,'aa_prep.rds')); gc()
lll=readRDS(file.path(data_dir,'ll_prep.rds')); gc()



#temp load current aall version
aall=readRDS(file.path(data_dir,'aall_domestic.rds')); gc()
aall=unflag(aall)["....._T+FND."]
gc()
names(dimnames(aall))[6] = 'FUNCTIONAL_CAT'
dimnames(aall)$FUNCTIONAL_CAT[dimnames(aall)$FUNCTIONAL_CAT=='FND'] = '_D'
gc()
str(aall)
aall['....._F+_O+_P+_R.'] <- NA


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



###############################################################
# Add the new dimension COUNTERPART_AREA with W0, W1, W2 codes
saveRDS(aall,file=file.path(data_dir,'aall_iipfiller_intermediate,rds'))
aallsmall = copy(aall)
#aallsmall = copy(aall[F3+F4+F52.AT+IT+BE.....y2021q1:y]); rm(aall)
gc()
aall=add.dim(aallsmall, .dimname = 'COUNTERPART_AREA', .dimcodes = c('W2', 'W0', 'WRL_REST'), .fillall = FALSE)
aall <- aperm(aall, c(2:length(dim(aall)),1))
gc()

#check before
#S0 is total economy!!
aall[F511.AT.S1..LE._T.2022q4.]
aall[F511.AT..S1.LE._T.2022q4.]

##because otherwise the combination of S1.S1. and W0 or WRL_REST is already filled, use S0 and S2 temporarily
##this will make the asset liability split easier without losing information
##S0 and S2 will be deleted later

aall[...S0....W0,usenames=FALSE, onlyna=TRUE]<-aall[...S0....W2]
aall[...S2....WRL_REST,usenames=FALSE, onlyna=TRUE]<-aall[...S2....W2]
aall[..S0.....W0,usenames=FALSE, onlyna=TRUE]<-aall[..S0.....W2]
aall[..S2.....WRL_REST,usenames=FALSE, onlyna=TRUE]<-aall[..S2.....W2]
gc()

#check after
aall[F511.AT.S1..LE._T.2022q4.]
aall[F511.AT..S1.LE._T.2022q4.]


##############################################################
##### filling domestic sources needs a cleaning Stefano ######
### use ccode=NULL to load and in addition iso2m to fill  ####
##############################################################

dall=as.data.table(aall,.simple=TRUE,na.rm=TRUE)
dall=dall[!(REF_SECTOR %in% c('S2I','S22', 'S21')),]
dall=dall[!(COUNTERPART_SECTOR %in% c('S2I','S22', 'S21')),]
dall=dall[!(REF_AREA %in% c('GR','GB')),]
dall=dall[!(COUNTERPART_AREA %in% c('GR','GB')),]

mydn=dimnames(aall)
mydn[["REF_SECTOR"]]=setdiff(mydn[["REF_SECTOR"]],c('S2I','S22', 'S21'))
mydn[["COUNTERPART_SECTOR"]]=setdiff(mydn[["COUNTERPART_SECTOR"]],c('S2I','S22', 'S21'))
mydn[["REF_AREA"]]=setdiff(mydn[["REF_AREA"]],c('GR','GB'))
mydn[["COUNTERPART_AREA"]]=setdiff(mydn[["COUNTERPART_AREA"]],c('GR','GB'))
attr(dall, 'dcstruct') = MD3:::.dimcodesrescue(mydn,dimcodes(aall))
attr(dall, 'dcsimp') = mydn
aall=as.md3(dall)
gc()

dimnames(aall)[['REF_AREA']] = ccode(dimnames(aall)[['REF_AREA']],2,'iso2m'); gc()

aall[F511.AT.S1.S1+S2+S0.LE._T.2022q4.]
aall[F511.AT.S1+S2+S0.S1.LE._T.2022q4.]


saveRDS(aall,file=file.path(data_dir,'aall_temp.rds'))
rm(list=ls());gc()
data_dir= file.path(getwd(),'data')
aall=readRDS(file.path(data_dir,'aall_temp.rds')); 


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


##############################################################
########filling of EA aggregate based on ECB QSA##############
##############################################################

eatemp=readRDS(file.path(data_dir,'eaaggregate_ecbqsa.rds'))
dimnames(eatemp)

dimnames(eatemp)[['REF_AREA']] = ccode(dimnames(eatemp)[['REF_AREA']],2,'iso2m'); gc()

str(eatemp)
str(aa)

lookup=c(F2M='F2M.T.',F21='F21.T.', F3='F3.T.',F3S='F3.S.',F3L='F3.L.',F4='F4.T.', F4S='F34.S.',F4='F4.L.',F511='F511._Z.',
         F51M='F51M._Z.',F52='F52._Z.', F6='F6._Z.',F6N='F6N._Z.',F6O='F6O._Z.', F81='F81.T.', F89='F89.T.', F='F._Z.')

for (i in names(lookup)) {
  aa[i,'EA20',,,,'_T',,'WRL_REST', usenames=TRUE, onlyna=TRUE] = eatemp['EA20..W1...A.' %&% lookup[i] ];
  aa[i,'EA20',,,,'_T',,'EXT_EA20', usenames=TRUE, onlyna=TRUE] = eatemp['EA20..W1...A.' %&% lookup[i] ];
  aa[i,'EA20',,,,'_T',,'W0', usenames=TRUE, onlyna=TRUE] = eatemp['EA20..W0...A.' %&% lookup[i] ];
  aa[i,'EA19',,,,'_T',,'WRL_REST', usenames=TRUE, onlyna=TRUE] = eatemp['EA19..W1...A.' %&% lookup[i] ];
  aa[i,'EA19',,,,'_T',,'EXT_EA19', usenames=TRUE, onlyna=TRUE] = eatemp['EA19..W1...A.' %&% lookup[i] ];
  aa[i,'EA19',,,,'_T',,'W0', usenames=TRUE, onlyna=TRUE] = eatemp['EA19..W0...A.' %&% lookup[i] ];
  aa[i,'EA18',,,,'_T',,'WRL_REST', usenames=TRUE, onlyna=TRUE] = eatemp['EA18..W1...A.' %&% lookup[i] ];
  aa[i,'EA18',,,,'_T',,'EXT_EA18', usenames=TRUE, onlyna=TRUE] = eatemp['EA18..W1...A.' %&% lookup[i] ];
  aa[i,'EA20',,,,'_T',,'W0', usenames=TRUE, onlyna=TRUE] = eatemp['EA20..W0...A.' %&% lookup[i] ];
  aa[i,'EA19',,,,'_T',,'WRL_REST', usenames=TRUE, onlyna=TRUE] = eatemp['EA19..W1...A.' %&% lookup[i] ];
  aa[i,'EA19',,,,'_T',,'W0', usenames=TRUE, onlyna=TRUE] = eatemp['EA19..W0...A.' %&% lookup[i] ];
  aa[i,'EA18',,,,'_T',,'WRL_REST', usenames=TRUE, onlyna=TRUE] = eatemp['EA18..W1...A.' %&% lookup[i] ];
  aa[i,'EA18',,,,'_T',,'W0', usenames=TRUE, onlyna=TRUE] = eatemp['EA18..W0...A.' %&% lookup[i] ]
}
aa[.EA20..S1.LE._T.2022q4.WRL_REST]
gc()

str(ll)

ea4liab=eatemp['EA20+EA19+EA18..W1+W0...L...'  ]
str(ea4liab)

lookup=c(F2M='F2M.T.',F21='F21.T.', F3='F3.T.',F3S='F3.S.',F3L='F3.L.',F4='F4.T.', F4S='F4.S.',F4='F4.L.',F511='F511._Z.',
         F51M='F51M._Z.',F52='F52._Z.', F6='F6._Z.',F6N='F6N._Z.',F6O='F6O._Z.', F81='F81.T.', F89='F89.T.', F='F._Z.')


for (i in names(lookup)) {
  ll[i,'WRL_REST',,,,'_T',,'EA20', usenames=TRUE, onlyna=TRUE] = ea4liab['EA20..W1...' %&% lookup[i] ];
  ll[i,'EXT_EA20',,,,'_T',,'EA20', usenames=TRUE, onlyna=TRUE] = ea4liab['EA20..W1...' %&% lookup[i] ];
  ll[i,'W0',,,,'_T',,'EA20', usenames=TRUE, onlyna=TRUE] = ea4liab['EA20..W0...' %&% lookup[i] ];
  ll[i,'WRL_REST',,,,'_T',,'EA19', usenames=TRUE, onlyna=TRUE] = ea4liab['EA19..W1...' %&% lookup[i] ];
  ll[i,'EXT_EA19',,,,'_T',,'EA19', usenames=TRUE, onlyna=TRUE] = ea4liab['EA19..W1...' %&% lookup[i] ];
  ll[i,'W0',,,,'_T',,'EA19', usenames=TRUE, onlyna=TRUE] = ea4liab['EA19..W0...' %&% lookup[i] ];
  ll[i,'WRL_REST',,,,'_T',,'EA18', usenames=TRUE, onlyna=TRUE] = ea4liab['EA18..W1...' %&% lookup[i] ];
  ll[i,'EXT_EA18',,,,'_T',,'EA18', usenames=TRUE, onlyna=TRUE] = ea4liab['EA18..W1...' %&% lookup[i] ];
  ll[i,'W0',,,,'_T',,'EA20', usenames=TRUE, onlyna=TRUE] = ea4liab['EA20..W0...' %&% lookup[i] ];
  ll[i,'WRL_REST',,,,'_T',,'EA19', usenames=TRUE, onlyna=TRUE] = ea4liab['EA19..W1...' %&% lookup[i] ];
  ll[i,'W0',,,,'_T',,'EA19', usenames=TRUE, onlyna=TRUE] = ea4liab['EA19..W0...' %&% lookup[i] ];
  ll[i,'WRL_REST',,,,'_T',,'EA18', usenames=TRUE, onlyna=TRUE] = ea4liab['EA18..W1...' %&% lookup[i] ];
  ll[i,'W0',,,,'_T',,'EA18', usenames=TRUE, onlyna=TRUE] = ea4liab['EA18..W0...' %&% lookup[i] ]
}

gc()
ll[.WRL_REST.S1..LE._T.2022q4.EA20]

saveRDSvl(aa,file='aa_iip_cps_temp.rds')
saveRDSvl(ll,file='ll_iip_cps_temp.rds')

saveRDS(aa,file='data/aa_iip_cps_temp.rds')
saveRDS(ll,file='data/ll_iip_cps_temp.rds')



#aa=readRDS(file.path(data_dir,'aa_iip_cps_temp.rds')); gc()
#ll=readRDS(file.path(data_dir,'ll_iip_cps_temp.rds')); gc()
##############################################################
########filling of quarterly financial bop data###############
##############################################################

bopeu=readRDS(file.path(data_dir,'bop_cps_euea.rds'))
dimnames(bopeu)
names(dimnames(bopeu))[2:4] = c( 'REF_AREA' ,'COUNTERPART_AREA','REF_SECTOR')
dimnames(bopeu)[['REF_AREA']] = ccode(dimnames(bopeu)[['REF_AREA']],2,'iso2m'); gc()
dimnames(bopeu)[['COUNTERPART_AREA']] = ccode(dimnames(bopeu)[['COUNTERPART_AREA']],2,'iso2m'); gc()
#dimnames(bopeu)$REF_SECTOR[dimnames(bopeu)$REF_SECTOR=='S1V'] ='S11'

assetfiller = function(bopeu,le='F',cparea=c("EXT_EA19", "EXT_EA20", "WRL_REST", "EU27", "EXT_EU27", "EU28",
                                           "EXT_EU28",  "BG", "BR", "CA", "CH", "NA", 
                                           "CZ", "DK", "EUI", "HK", "HR", "HU", "IN", "JP",
                                           "OFFSHO", "PL", "RO", "RU", "SE", "GB", "US"),
                       sss=c("S1", "S121", "S122", "S123", "S12K", "S12M", "S12T", "S13", "S1P", "S11", "S1V", "S124", "S12Q", "S1M")) {
  aaF = bopeu[dimnames(aa)$REF_AREA,,sss,,time(aa)]; gc()
  for (cp in cparea) {
    message(cp)

    aa['F',,sss,'S1',le,'_T',,cp,  usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA", ]); gc()  #stefan to check
    aa['F',,sss,'S1',le,'_P',,cp,  usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F", ]); gc()
    aa['F',,sss,'S1',le,'_O',,cp,  usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F", ]); gc()
    aa['F',,sss,'S1',le,'_D',,cp,  usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F", ]); gc()
    aa['F',,sss,'S1',le,'_R',,cp,  usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__R__F", ]); gc()
    aa['F2M',,sss,'S1',le,'_R',,cp,  usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__R__F2", ]); gc()
    aa['F3',,sss,'S1',le,'_R',,cp,  usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__R__F3", ]); gc()
    aa['F',,sss,'S1',le,'_F',,cp,  usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__F__F7", ]); gc()
    aa['F2M',,sss,'S1',le,'_O',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F2", ]); gc()
    aa['F3',,sss,'S1',le,'_D',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F3", ]); gc()
    aa['F3',,sss,'S1',le,'_P',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F3", ]); gc()
    aa['F4',,sss,'S1',le,'_D',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F4", ]); gc()
    aa['F4',,sss,'S1',le,'_O',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F4", ]); gc()
    aa['F52',,sss,'S1',le,'_P',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F52", ]); gc()
    aa['F511',,sss,'S1',le,'_D',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F511", ]); gc()
    aa['F511',,sss,'S1',le,'_P',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F511", ]); gc()
    #aa['F51',,sss,'S1',le,'_P',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F51", ]); gc()
    aa['F51M',,sss,'S1',le,'_D',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F51M", ]); gc()
    aa['F51M',,sss,'S1',le,'_P',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F512", ]); gc()
    aa['F51M',,sss,'S1',le,'_O',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F519", ]); gc()
    aa['F6',,sss,'S1',le,'_O',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F6", ]); gc()
    aa['F81',,sss,'S1',le,'_D',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F81", ]); gc()
    aa['F81',,sss,'S1',le,'_O',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F81", ]); gc()
    aa['F89',,sss,'S1',le,'_O',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F89", ]); gc()
    aa['F',,sss,'S1',le,'_T',,cp,  usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA", ]); gc()  #stefan to check
    aa['F',,sss,'S1',le,'_P',,cp,  usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F", ]); gc()
    aa['F',,sss,'S1',le,'_O',,cp,  usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F", ]); gc()
    aa['F',,sss,'S1',le,'_D',,cp,  usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F", ]); gc()
    aa['F',,sss,'S1',le,'_R',,cp,  usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__R__F", ]); gc()
    aa['F2M',,sss,'S1',le,'_R',,cp,  usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__R__F2", ]); gc()
    aa['F3',,sss,'S1',le,'_R',,cp,  usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__R__F3", ]); gc()
    aa['F',,sss,'S1',le,'_F',,cp,  usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__F__F7", ]); gc()
    aa['F2M',,sss,'S1',le,'_O',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F2", ]); gc()
    aa['F3',,sss,'S1',le,'_D',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F3", ]); gc()
    aa['F3',,sss,'S1',le,'_P',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F3", ]); gc()
    aa['F4',,sss,'S1',le,'_D',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F4", ]); gc()
    aa['F4',,sss,'S1',le,'_O',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F4", ]); gc()
    aa['F52',,sss,'S1',le,'_P',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F52", ]); gc()
    aa['F511',,sss,'S1',le,'_D',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F511", ]); gc()
    aa['F511',,sss,'S1',le,'_P',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F511", ]); gc()
    #aa['F51',,sss,'S1',le,'_P',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F51", ]); gc()
    aa['F51M',,sss,'S1',le,'_D',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F51M", ]); gc()
    aa['F51M',,sss,'S1',le,'_P',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F512", ]); gc()
    aa['F51M',,sss,'S1',le,'_O',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F519", ]); gc()
    aa['F6',,sss,'S1',le,'_O',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F6", ]); gc()
    aa['F81',,sss,'S1',le,'_D',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F81", ]); gc()
    aa['F81',,sss,'S1',le,'_O',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F81", ]); gc()
    aa['F89',,sss,'S1',le,'_O',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F89", ]); gc()

  }
}


assetfiller(bopeu["ASS....."],'F',c("EXT_EA19", "EXT_EA20", "WRL_REST", "EU27", "EXT_EU27", "EU28",
                                    "EXT_EU28",  "BG", "BR", "CA", "CH", "NA", 
                                    "CZ", "DK", "EUI", "HK", "HR", "HU", "IN", "JP",
                                    "OFFSHO", "PL", "RO", "RU", "SE", "GB", "US"))
aa[.EA20.S1.S1.F..2022q4.EXT_EA20]


saveRDSvl(aa,file='aa_bop_cps_eu_temp.rds')

saveRDS(aa,file='data/aa_bop_cps_eu_temp.rds')

#aa=readRDS(file.path(data_dir,'aa_bop_cps_temp.rds')); gc()

#########################

liabfiller = function(bopeu,le='F',cparea=c("EXT_EA19", "EXT_EA20", "WRL_REST", "EU27", "EXT_EU27", "EU28",
                                          "EXT_EU28",  "BG", "BR", "CA", "CH", "NA", 
                                          "CZ", "DK", "EUI", "HK", "HR", "HU", "IN", "JP",
                                          "OFFSHO", "PL", "RO", "RU", "SE", "GB", "US"),
                      sss=c("S1", "S121", "S122", "S123", "S12K", "S12M", "S12T", "S13", "S1P", "S11", "S1V", "S124", "S12Q", "S1M")) {
  llF = bopeu[dimnames(ll)$REF_AREA,,sss,,time(ll)]; gc()
  # names(dimnames(llF))[names(dimnames(llF))=="REF_SECTOR"] <- 'COUNTERPART_SECTOR'
  # names(dimnames(llF))[names(dimnames(llF))=="REF_AREA"] <- 'COUNTERPART_AREA'
  # names(dimnames(llF))[names(dimnames(llF))=="COUNTERPART_SECTOR"] <- 'REF_SECTOR'
  # names(dimnames(llF))[names(dimnames(llF))=="COUNTERPART_AREA"] <- 'REF_AREA'
  for (cp in cparea) {
    message(cp)
    ll['F',cp,'S1',sss,le,'_T',,,  usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA", ]); gc()
    ll['F',cp,'S1',sss,le,'_O',,,  usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,sss,"FA__O__F", ]); gc()
    ll['F',cp,'S1',sss,le,'_P',,,  usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F", ]); gc()
    ll['F',cp,'S1',sss,le,'_D',,,  usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F", ]); gc()
    ll['F',cp,'S1',sss,le,'_R',,,  usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__R__F", ]); gc()
    ll['F',cp,'S1',sss,le,'_F',,,  usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__F__F7", ]); gc()
    ll['F2M',cp,'S1',sss,le,'_O',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F2", ]); gc()
    ll['F3',cp,'S1',sss,le,'_D',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F3", ]); gc()
    ll['F3',cp,'S1',sss,le,'_P',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F3", ]); gc()
    ll['F4',cp,'S1',sss,le,'_D',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F4", ]); gc()
    ll['F4',cp,'S1',sss,le,'_O',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F4", ]); gc()
    ll['F52',cp,'S1',sss,le,'_P',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F52", ]); gc()
    ll['F511',cp,'S1',sss,le,'_D',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F511", ]); gc()
    ll['F511',cp,'S1',sss,le,'_P',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F511", ]); gc()
    #aall['F51',cp,'S1',sss,le,'_P',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F51", ]); gc()
    ll['F51M',cp,'S1',sss,le,'_D',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F51M", ]); gc()
    ll['F51M',cp,'S1',sss,le,'_P',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,".FA__P__F512", ]); gc()
    ll['F51M',cp,'S1',sss,le,'_O',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F519", ]); gc()
    ll['F6',cp,'S1',sss,le,'_O',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F6", ]); gc()
    ll['F81',cp,'S1',sss,le,'_D',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F81", ]); gc()
    ll['F81',cp,'S1',sss,le,'_O',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F81", ]); gc()
    ll['F89',cp,'S1',sss,le,'_O',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F89", ]); gc()
  }
}


liabfiller(bopeu["LIAB....."],'F',c("EXT_EA19", "EXT_EA20", "WRL_REST", "EU27", "EXT_EU27", "EU28",
                                  "EXT_EU28",  "BG", "BR", "CA", "CH", "NA", 
                                  "CZ", "DK", "EUI", "HK", "HR", "HU", "IN", "JP",
                                  "OFFSHO", "PL", "RO", "RU", "SE", "GB", "US"))

gc()


ll[.EXT_EA20.S1.S1.F..2022q4.EA20]



saveRDSvl(ll,file='ll_bop_cps_eu_temp.rds')

saveRDS(ll,file='data/ll_bop_cps_eu_temp.rds')

##############################################################
########filling of quarterly financial bop data###############
##############################################################

bop=readRDS(file.path(data_dir,'bop_cps.rds'))
dimnames(bop)
names(dimnames(bop))[2:4] = c( 'REF_AREA' ,'COUNTERPART_AREA','REF_SECTOR')
dimnames(bop)[['REF_AREA']] = ccode(dimnames(bop)[['REF_AREA']],2,'iso2m'); gc()
dimnames(bop)[['COUNTERPART_AREA']] = ccode(dimnames(bop)[['COUNTERPART_AREA']],2,'iso2m'); gc()
#dimnames(bop)$REF_SECTOR[dimnames(bop)$REF_SECTOR=='S1V'] ='S11'
#!?!? to be reviewed later
assetfiller = function(bop,le='F',cparea=c("EA19", "EA20", "EXT_EA19", "EXT_EA20", "WRL_REST", "EU27", "EXT_EU27", "EU28",
                                           "EXT_EU28", "AT", "BG", "BR", "CA", "CH", "CN", "CY",
                                           "CZ", "DE", "DK", "EE", "GR", "ES", "EUI", "FI",
                                           "FR", "HK", "HR", "HU", "IE", "IN", "IT", "JP",
                                           "LT", "LU", "LV", "MT", "NL", "OFFSHO", "PL", "PT",
                                           "RO", "RU", "SE", "SI", "SK", "GB", "US", "BE"),
                       sss=c("S1", "S121", "S123", "S12T", "S13", "S1P", "S1V")) {
  #aaF = bop["A_F....FA__D__F+FA__P__F+FA__O__F+FA__R__F+FA__F__F7."]; gc()
  aaF = bop[dimnames(aa)$REF_AREA,,sss,,time(aa)]; gc()
  for (cp in cparea) {
    message(cp)

    aa['F',,sss,'S1',le,'_T',,cp,  usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA", ]); gc()  #stefan to check
    aa['F',,sss,'S1',le,'_P',,cp,  usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F", ]); gc()
    aa['F',,sss,'S1',le,'_O',,cp,  usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F", ]); gc()
    aa['F',,sss,'S1',le,'_D',,cp,  usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F", ]); gc()
    aa['F',,sss,'S1',le,'_R',,cp,  usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__R__F", ]); gc()
    aa['F2M',,sss,'S1',le,'_R',,cp,  usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__R__F2", ]); gc()
    aa['F3',,sss,'S1',le,'_R',,cp,  usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__R__F3", ]); gc()
    aa['F',,sss,'S1',le,'_F',,cp,  usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__F__F7", ]); gc()
    aa['F2M',,sss,'S1',le,'_O',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F2", ]); gc()
    aa['F3',,sss,'S1',le,'_D',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F3", ]); gc()
    aa['F3',,sss,'S1',le,'_P',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F3", ]); gc()
    aa['F4',,sss,'S1',le,'_D',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F4", ]); gc()
    aa['F4',,sss,'S1',le,'_O',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F4", ]); gc()
    aa['F52',,sss,'S1',le,'_P',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F52", ]); gc()
    aa['F511',,sss,'S1',le,'_D',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F511", ]); gc()
    aa['F511',,sss,'S1',le,'_P',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F511", ]); gc()
    #aa['F51',,sss,'S1',le,'_P',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F51", ]); gc()
    aa['F51M',,sss,'S1',le,'_D',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F512", ]+aaF[,cp,,"FA__D__F519", ]); gc()
    aa['F51M',,sss,'S1',le,'_P',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F512", ]); gc()
    aa['F51M',,sss,'S1',le,'_O',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F519", ]); gc()
    aa['F6',,sss,'S1',le,'_O',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F6", ]); gc()
    aa['F81',,sss,'S1',le,'_D',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F81", ]); gc()
    aa['F81',,sss,'S1',le,'_O',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F81", ]); gc()
    aa['F89',,sss,'S1',le,'_O',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F89", ]); gc()
    aa['F',,sss,'S1',le,'_T',,cp,  usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA", ]); gc()  #stefan to check
    aa['F',,sss,'S1',le,'_P',,cp,  usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F", ]); gc()
    aa['F',,sss,'S1',le,'_O',,cp,  usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F", ]); gc()
    aa['F',,sss,'S1',le,'_D',,cp,  usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F", ]); gc()
    aa['F',,sss,'S1',le,'_R',,cp,  usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__R__F", ]); gc()
    aa['F2M',,sss,'S1',le,'_R',,cp,  usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__R__F2", ]); gc()
    aa['F3',,sss,'S1',le,'_R',,cp,  usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__R__F3", ]); gc()
    aa['F',,sss,'S1',le,'_F',,cp,  usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__F__F7", ]); gc()
    aa['F2M',,sss,'S1',le,'_O',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F2", ]); gc()
    aa['F3',,sss,'S1',le,'_D',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F3", ]); gc()
    aa['F3',,sss,'S1',le,'_P',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F3", ]); gc()
    aa['F4',,sss,'S1',le,'_D',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F4", ]); gc()
    aa['F4',,sss,'S1',le,'_O',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F4", ]); gc()
    aa['F52',,sss,'S1',le,'_P',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F52", ]); gc()
    aa['F511',,sss,'S1',le,'_D',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F511", ]); gc()
    aa['F511',,sss,'S1',le,'_P',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F511", ]); gc()
    #aa['F51',,sss,'S1',le,'_P',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F51", ]); gc()
    aa['F51M',,sss,'S1',le,'_D',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F512", ]+aaF[,cp,,"FA__D__F519", ]); gc()
    aa['F51M',,sss,'S1',le,'_P',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F512", ]); gc()
    aa['F51M',,sss,'S1',le,'_O',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F519", ]); gc()
    aa['F6',,sss,'S1',le,'_O',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F6", ]); gc()
    aa['F81',,sss,'S1',le,'_D',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F81", ]); gc()
    aa['F81',,sss,'S1',le,'_O',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F81", ]); gc()
    aa['F89',,sss,'S1',le,'_O',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F89", ]); gc()

  }
}


assetfiller(bop["ASS....."],'F',c("EA19", "EA20", "EXT_EA19", "EXT_EA20", "WRL_REST", "EU27", "EXT_EU27", "EU28",
                                  "EXT_EU28", "AT", "BG", "BR", "CA", "CH", "CN", "CY",
                                  "CZ", "DE", "DK", "EE", "GR", "ES", "EUI", "FI",
                                  "FR", "HK", "HR", "HU", "IE", "IN", "IT", "JP",
                                  "LT", "LU", "LV", "MT", "NL", "OFFSHO", "PL", "PT",
                                  "RO", "RU", "SE", "SI", "SK", "GB", "US", "BE"))
aa[.AT.S1.S1.F..2022q4.WRL_REST]


saveRDSvl(aa,file='aa_bop_cps_temp.rds')

saveRDS(aa,file='data/aa_bop_cps_temp.rds')

#aa=readRDS(file.path(data_dir,'aa_bop_cps_temp.rds')); gc()

#########################

liabfiller = function(bop,le='F',cparea=c("EA19", "EA20", "EXT_EA19", "EXT_EA20", "WRL_REST", "EU27", "EXT_EU27", "EU28",
                                          "EXT_EU28", "AT", "BG", "BR", "CA", "CH", "CN", "CY",
                                          "CZ", "DE", "DK", "EE", "GR", "ES", "EUI", "FI",
                                          "FR", "HK", "HR", "HU", "IE", "IN", "IT", "JP",
                                          "LT", "LU", "LV", "MT", "NL", "OFFSHO", "PL", "PT",
                                          "RO", "RU", "SE", "SI", "SK", "GB", "US", "BE"),
                      sss=c("S1", "S121", "S123", "S12M", "S12T", "S13", "S1P", "S11", "S12R")) {
  llF = bop[dimnames(ll)$REF_AREA,,sss,,time(ll)]; gc()
 
  for (cp in cparea) {
    message(cp)
    ll['F',cp,'S1',sss,le,'_T',,,  usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA", ]); gc()
    ll['F',cp,'S1',sss,le,'_O',,,  usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,sss,"FA__O__F", ]); gc()
    ll['F',cp,'S1',sss,le,'_P',,,  usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F", ]); gc()
    ll['F',cp,'S1',sss,le,'_D',,,  usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F", ]); gc()
    ll['F',cp,'S1',sss,le,'_R',,,  usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__R__F", ]); gc()
    ll['F',cp,'S1',sss,le,'_F',,,  usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__F__F7", ]); gc()
     ll['F2M',cp,'S1',sss,le,'_O',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F2", ]); gc()
    ll['F3',cp,'S1',sss,le,'_D',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F3", ]); gc()
    ll['F3',cp,'S1',sss,le,'_P',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F3", ]); gc()
    ll['F4',cp,'S1',sss,le,'_D',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F4", ]); gc()
    ll['F4',cp,'S1',sss,le,'_O',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F4", ]); gc()
    ll['F52',cp,'S1',sss,le,'_P',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F52", ]); gc()
    ll['F511',cp,'S1',sss,le,'_D',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F511", ]); gc()
    ll['F511',cp,'S1',sss,le,'_P',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F511", ]); gc()
    #aall['F51',cp,'S1',sss,le,'_P',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F51", ]); gc()
    ll['F51M',cp,'S1',sss,le,'_D',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F512", ]+llF[,cp,,"FA__D__F519", ]); gc()
    ll['F51M',cp,'S1',sss,le,'_P',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,".FA__P__F512", ]); gc()
    ll['F51M',cp,'S1',sss,le,'_O',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F519", ]); gc()
    ll['F6',cp,'S1',sss,le,'_O',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F6", ]); gc()
    ll['F81',cp,'S1',sss,le,'_D',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F81", ]); gc()
     ll['F81',cp,'S1',sss,le,'_O',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F81", ]); gc()
     ll['F89',cp,'S1',sss,le,'_O',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F89", ]); gc()
  }
}


liabfiller(bop["LIAB....."],'F',c("EA19", "EA20", "EXT_EA19", "EXT_EA20", "WRL_REST", "EU27", "EXT_EU27", "EU28",
                                  "EXT_EU28", "AT", "BG", "BR", "CA", "CH", "CN", "CY",
                                  "CZ", "DE", "DK", "EE", "GR", "ES", "EUI", "FI",
                                  "FR", "HK", "HR", "HU", "IE", "IN", "IT", "JP",
                                  "LT", "LU", "LV", "MT", "NL", "OFFSHO", "PL", "PT",
                                  "RO", "RU", "SE", "SI", "SK", "GB", "US", "BE"))

gc()


ll[.WRL_REST.S1.S1.F..2022q4.AT]



saveRDSvl(ll,file='ll_bop_cps_temp.rds')

saveRDS(ll,file='data/ll_bop_cps_temp.rds')


##############################################################
########filling of quaterly and annual iip data###############
##############################################################
iipq=readRDS(file.path(data_dir,'iip_cps.rds'))
iipa=readRDS(file.path(data_dir,'iip_cps_annual.rds'))
frequency(iipa)='Q'
iip=merge(iipq,iipa,along='STO')
dimnames(iip)
names(dimnames(iip))[2:4] = c( 'REF_AREA' ,'COUNTERPART_AREA','REF_SECTOR')
dimnames(iip)[['REF_AREA']] = ccode(dimnames(iip)[['REF_AREA']],2,'iso2m'); gc()
dimnames(iip)[['COUNTERPART_AREA']] = ccode(dimnames(iip)[['COUNTERPART_AREA']],2,'iso2m',leaveifNA=TRUE); gc()
dimnames(iip)$REF_SECTOR[dimnames(iip)$REF_SECTOR=='S12M'] ='S12R'

assetfiller = function(iip,le='LE',cparea=c("EA19", "EA20", "EXT_EA19", "EXT_EA20", "WRL_REST", "AT", "BG", "BR", "CA", "CH", "CN", "CY", "CZ",
                                            "DE", "DK", "EE", "GR", "ES", "EU27", "EU28", "EUI", "EXT_EU27", "EXT_EU28", "FI", "FR",
                                            "G20_X_EU27", "HK", "HR", "HU", "IE", "IMF", "IN", "IT", "JP", "LT", "LU", "LV", "MT", "NL",
                                            "OFFSHO", "PL", "PT", "RO", "RU", "SE", "SI", "SK", "GB", "US", "AR", "AU", "ID", "KR", "MX", "NO",
                                            "SA", "TR", "ZA", "BE"),
                       sss=c('S121','S12T','S12K','S13','S11','S1M','S124','S12O','S12Q','S1')) {

  aaF = iip[dimnames(aa)$REF_AREA,,sss,,time(aa)]; gc()
  for (cp in cparea) {
    message(cp)
    aa['F',,sss,'S1',le,'_T',,cp,  usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA", ]); gc()
    aa['F',,sss,'S1',le,'_P',,cp,  usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F", ]); gc()
    aa['F',,sss,'S1',le,'_O',,cp,  usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F", ]); gc()
    aa['F',,sss,'S1',le,'_D',,cp,  usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F", ]); gc()
    aa['F',,sss,'S1',le,'_R',,cp,  usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__R__F", ]); gc()
    aa['F',,sss,'S1',le,'_F',,cp,  usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__F__F7", ]); gc()
    aa['F2M',,sss,'S1',le,'_O',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F2", ]); gc()
    aa['F2M',,sss,'S1',le,'_R',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__R__F2", ]); gc()
    aa['F3',,sss,'S1',le,'_D',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F3", ]); gc()
    aa['F3',,sss,'S1',le,'_P',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F3", ]); gc()
    aa['F3',,sss,'S1',le,'_R',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__R__F3", ]); gc()
    aa['F4',,sss,'S1',le,'_D',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F4", ]); gc()
    aa['F4',,sss,'S1',le,'_O',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F4", ]); gc()
    aa['F52',,sss,'S1',le,'_P',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F52", ]); gc()
    aa['F511',,sss,'S1',le,'_D',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F511", ]); gc()
    aa['F511',,sss,'S1',le,'_P',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F511", ]); gc()
    aa['F51',,sss,'S1',le,'_P',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F51", ]); gc()
    aa['F51M',,sss,'S1',le,'_D',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F51M", ]); gc()
    aa['F51M',,sss,'S1',le,'_P',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,".FA__P__F512", ]); gc()
    aa['F51M',,sss,'S1',le,'_O',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F519", ]); gc()
    aa['F6',,sss,'S1',le,'_O',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F6", ]); gc()
    aa['F81',,sss,'S1',le,'_D',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F81", ]); gc()
    aa['F81',,sss,'S1',le,'_O',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F81", ]); gc()
    aa['F89',,sss,'S1',le,'_O',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F89", ]); gc()
    aa['F',,sss,'S1',le,'_T',,cp,  usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA", ]); gc()
    aa['F',,sss,'S1',le,'_P',,cp,  usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F", ]); gc()
    aa['F',,sss,'S1',le,'_O',,cp,  usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F", ]); gc()
    aa['F',,sss,'S1',le,'_D',,cp,  usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F", ]); gc()
    aa['F',,sss,'S1',le,'_R',,cp,  usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__R__F", ]); gc()
    aa['F',,sss,'S1',le,'_F',,cp,  usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__F__F7", ]); gc()
    aa['F2M',,sss,'S1',le,'_O',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F2", ]); gc()
    aa['F2M',,sss,'S1',le,'_R',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__R__F2", ]); gc()
    aa['F3',,sss,'S1',le,'_D',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F3", ]); gc()
    aa['F3',,sss,'S1',le,'_P',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F3", ]); gc()
    aa['F3',,sss,'S1',le,'_R',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__R__F3", ]); gc()
    aa['F4',,sss,'S1',le,'_D',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F4", ]); gc()
    aa['F4',,sss,'S1',le,'_O',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F4", ]); gc()
    aa['F52',,sss,'S1',le,'_P',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F52", ]); gc()
    aa['F511',,sss,'S1',le,'_D',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F511", ]); gc()
    aa['F511',,sss,'S1',le,'_P',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F511", ]); gc()
    aa['F51',,sss,'S1',le,'_P',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F51", ]); gc()
    aa['F51M',,sss,'S1',le,'_D',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F51M", ]); gc()
    aa['F51M',,sss,'S1',le,'_P',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,".FA__P__F512", ]); gc()
    aa['F51M',,sss,'S1',le,'_O',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F519", ]); gc()
    aa['F6',,sss,'S1',le,'_O',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F6", ]); gc()
    aa['F81',,sss,'S1',le,'_D',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F81", ]); gc()
    aa['F81',,sss,'S1',le,'_O',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F81", ]); gc()
    aa['F89',,sss,'S1',le,'_O',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F89", ]); gc()
  }
}


assetfiller(iip["A_LE....."],'LE',c("IT", "EA19", "EA20", "EXT_EA19", "EXT_EA20", "WRL_REST", "AT", "BG", "BR", "CA", "CH", "CN", "CY", "CZ",
                                    "DE", "DK", "EE", "GR", "ES", "EU27", "EU28", "EUI", "EXT_EU27", "EXT_EU28", "FI", "FR",
                                    "G20_X_EU27", "HK", "HR", "HU", "IE", "IMF", "IN", "IT", "JP", "LT", "LU", "LV", "MT", "NL",
                                    "OFFSHO", "PL", "PT", "RO", "RU", "SE", "SI", "SK", "GB", "US", "AR", "AU", "ID", "KR", "MX", "NO",
                                    "SA", "TR", "ZA", "BE"))
aa[.AT.S1.S1.LE..2022q4.WRL_REST]
 gc()


saveRDSvl(aa,file='aa_iip_cps_temp.rds')

saveRDS(aa,file='data/aa_iip_cps_temp.rds')


liabfiller = function(iip,le='LE',cparea=c("EA19", "EA20", "EXT_EA19", "EXT_EA20", "WRL_REST", "AT", "BG", "BR", "CA", "CH", "CN", "CY", "CZ",
                                           "DE", "DK", "EE", "GR", "ES", "EU27", "EU28", "EUI", "EXT_EU27", "EXT_EU28", "FI", "FR",
                                           "G20_X_EU27", "HK", "HR", "HU", "IE", "IMF", "IN", "IT", "JP", "LT", "LU", "LV", "MT", "NL",
                                           "OFFSHO", "PL", "PT", "RO", "RU", "SE", "SI", "SK", "GB", "US", "AR", "AU", "ID", "KR", "MX", "NO",
                                           "SA", "TR", "ZA", "BE"),sss=c('S121','S12T','S13','S11','S1M','S124','S12O','S12Q','S1')) {
  #aaF = iip["A_LE....FA__D__F+FA__P__F+FA__O__F+FA__R__F+FA__F__F7."]; gc()
  llF = iip[dimnames(ll)$REF_AREA,,sss,,time(ll)]; gc()
  for (cp in cparea) {
    message(cp)
    ll['F',cp,'S1',sss,le,'_T',,,  usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA", ]); gc()
    ll['F',cp,'S1',sss,le,'_P',,,  usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F", ]); gc()
    ll['F',cp,'S1',sss,le,'_O',,,  usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F", ]); gc()
    ll['F',cp,'S1',sss,le,'_D',,,  usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F", ]); gc()
    ll['F',cp,'S1',sss,le,'_R',,,  usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__R__F", ]); gc()
    ll['F',cp,'S1',sss,le,'_F',,,  usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__F__F7", ]); gc()
    ll['F2M',cp,'S1',sss,le,'_O',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F2", ]); gc()
    ll['F3',cp,'S1',sss,le,'_D',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F3", ]); gc()
    ll['F3',cp,'S1',sss,le,'_P',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F3", ]); gc()
    ll['F4',cp,'S1',sss,le,'_D',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F4", ]); gc()
    ll['F4',cp,'S1',sss,le,'_O',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F4", ]); gc()
    ll['F52',cp,'S1',sss,le,'_P',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F52", ]); gc()
    ll['F511',cp,'S1',sss,le,'_D',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F511", ]); gc()
    ll['F511',cp,'S1',sss,le,'_P',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F511", ]); gc()
    ll['F51',cp,'S1',sss,le,'_P',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F51", ]); gc()
    ll['F51M',cp,'S1',sss,le,'_D',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F51M", ]); gc()
    ll['F51M',cp,'S1',sss,le,'_P',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,".FA__P__F512", ]); gc()
    ll['F51M',cp,'S1',sss,le,'_O',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F519", ]); gc()
    ll['F6',cp,'S1',sss,le,'_O',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F6", ]); gc()
    ll['F81',cp,'S1',sss,le,'_D',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F81", ]); gc()
    ll['F81',cp,'S1',sss,le,'_O',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F81", ]); gc()
    ll['F89',cp,'S1',sss,le,'_O',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F89", ]); gc()
  }
}


liabfiller(iip["L_LE....."],'LE',c("IT", "EA19", "EA20", "EXT_EA19", "EXT_EA20", "WRL_REST", "AT", "BG", "BR", "CA", "CH", "CN", "CY", "CZ",
                                   "DE", "DK", "EE", "GR", "ES", "EU27", "EU28", "EUI", "EXT_EU27", "EXT_EU28", "FI", "FR",
                                   "G20_X_EU27", "HK", "HR", "HU", "IE", "IMF", "IN", "IT", "JP", "LT", "LU", "LV", "MT", "NL",
                                   "OFFSHO", "PL", "PT", "RO", "RU", "SE", "SI", "SK", "GB", "US", "AR", "AU", "ID", "KR", "MX", "NO",
                                   "SA", "TR", "ZA", "BE"))
ll[.WRL_REST.S1.S1.LE..2022q4.AT]

gc()

saveRDSvl(ll,file='ll_iip_cps_temp.rds')

saveRDS(ll,file='data/ll_iip_cps_temp.rds')


# aa=readRDS(file.path(data_dir,'aa_iip_cps_temp.rds')); gc()
# ll=readRDS(file.path(data_dir,'ll_iip_cps_temp.rds')); gc()

##############################################################
########      filling EUI bop and iip data     ###############
##############################################################
bopeui=readRDS(file.path(data_dir,'bop_eui.rds'))
iipeui=readRDS(file.path(data_dir,'iip_eui.rds'))
dim(bopeui); dim(iipeui)
str(bopeui); str(iipeui)
frequency(iipeui)='Q'; gc()
eui=merge(bopeui,iipeui,along='STO',newcodes=c('F','LE')); gc()
dimnames(eui)
names(dimnames(eui))[3:5] = c( 'INSTR' ,'REF_SECTOR','COUNTERPART_SECTOR')
names(dimnames(eui))[7:8] = c( 'COUNTERPART_AREA', 'REF_AREA')
dimnames(eui)[['REF_AREA']] = ccode(dimnames(eui)[['REF_AREA']],2,'iso2m'); gc()
dimnames(eui)[['COUNTERPART_AREA']] = ccode(dimnames(eui)[['COUNTERPART_AREA']],2,'iso2m',leaveifNA=TRUE); gc()
dimnames(eui)$COUNTERPART_AREA[dimnames(eui)$COUNTERPART_AREA=='WORLD'] ='WRL_REST'
dimnames(eui)$REF_SECTOR[dimnames(eui)$REF_SECTOR=='S12M'] ='S12R'
eui=eui[".EUR......."];gc()

#transform from EUR to MEUR 
eui=unflag(eui)
deui=as.data.table(eui,.simple=TRUE,na.rm=TRUE)
deui[, obs_value := obs_value / 1e6]
eui=as.md3(deui); rm(deui)

gc()

refa=dimnames(eui)[['REF_AREA']]
for (i in refa) {
aa['F',i , ,'S1' ,'F' ,'_T',, , usenames=TRUE, onlyna=TRUE] =eui['F','FA',,,'ASS',,i,];
aa['F',i , ,'S1' ,'LE' ,'_T',, , usenames=TRUE, onlyna=TRUE] =eui['LE','FA',,,'A_LE',,i,];
aa['F',i , ,'S1' ,'F' ,'_D',, , usenames=TRUE, onlyna=TRUE] =eui['F','FA__D__F',,,'ASS',,i,];
aa['F',i , ,'S1' ,'LE' ,'_D',, , usenames=TRUE, onlyna=TRUE] =eui['LE','FA__D__F',,,'A_LE',,i,];
aa['F',i , ,'S1' ,'F' ,'_O',, , usenames=TRUE, onlyna=TRUE] =eui['F','FA__O__F',,,'ASS',,i,];
aa['F',i , ,'S1' ,'LE' ,'_O',, , usenames=TRUE, onlyna=TRUE] =eui['LE','FA__O__F',,,'A_LE',,i,];
aa['F2M',i , ,'S1' ,'F' ,'_O',, , usenames=TRUE, onlyna=TRUE] =eui['F','FA__O__F2',,,'ASS',,i,];
aa['F2M',i , ,'S1' ,'LE' ,'_O',, , usenames=TRUE, onlyna=TRUE] =eui['LE','FA__O__F2',,,'A_LE',,i,];
aa['F4',i , ,'S1' ,'F' ,'_O',, , usenames=TRUE, onlyna=TRUE] =eui['F','FA__O__F2',,,'ASS',,i,];
aa['F4',i , ,'S1' ,'LE' ,'_O',, , usenames=TRUE, onlyna=TRUE] =eui['LE','FA__O__F4',,,'A_LE',,i,];
aa['F51M',i , ,'S1' ,'F' ,'_O',, , usenames=TRUE, onlyna=TRUE] =eui['F','FA__O__F519',,,'ASS',,i,];
aa['F51M',i , ,'S1' ,'LE' ,'_O',, , usenames=TRUE, onlyna=TRUE] =eui['LE','FA__O__F519',,,'A_LE',,i,];
aa['F89',i , ,'S1' ,'F' ,'_O',, , usenames=TRUE, onlyna=TRUE] =eui['F','FA__O__F89',,,'ASS',,i,];
aa['F89',i , ,'S1' ,'LE' ,'_O',, , usenames=TRUE, onlyna=TRUE] =eui['LE','FA__O__F89',,,'A_LE',,i,];
aa['F',i , ,'S1' ,'F' ,'_P',, , usenames=TRUE, onlyna=TRUE] =eui['F','FA__P__F',,,'ASS',,i,];
aa['F',i , ,'S1' ,'LE' ,'_P',, , usenames=TRUE, onlyna=TRUE] =eui['LE','FA__P__F',,,'A_LE',,i,];
aa['F3',i , ,'S1' ,'F' ,'_P',, , usenames=TRUE, onlyna=TRUE] =eui['F','FA__P__F3',,,'ASS',,i,];
aa['F3',i , ,'S1' ,'LE' ,'_P',, , usenames=TRUE, onlyna=TRUE] =eui['LE','FA__P__F3',,,'A_LE',,i,];
aa['F3S',i , ,'S1' ,'F' ,'_P',, , usenames=TRUE, onlyna=TRUE] =eui['F','FA__P__F3__S',,,'ASS',,i,];
aa['F3S',i , ,'S1' ,'LE' ,'_P',, , usenames=TRUE, onlyna=TRUE] =eui['LE','FA__P__F3__S',,,'A_LE',,i,];
aa['F3L',i , ,'S1' ,'F' ,'_P',, , usenames=TRUE, onlyna=TRUE] =eui['F','FA__P__F3__L',,,'ASS',,i,];
aa['F3L',i , ,'S1' ,'LE' ,'_P',, , usenames=TRUE, onlyna=TRUE] =eui['LE','FA__P__F3__L',,,'A_LE',,i,];
aa['F51',i , ,'S1' ,'F' ,'_P',, , usenames=TRUE, onlyna=TRUE] =eui['F','FA__P__F51',,,'ASS',,i,];
aa['F51',i , ,'S1' ,'LE' ,'_P',, , usenames=TRUE, onlyna=TRUE] =eui['LE','FA__P__F51',,,'A_LE',,i,]
  }

aa[F.COMM.S1.S1.LE._T.2023Q4.] 

refa=dimnames(eui)[['REF_AREA']]
for (i in refa) {
  ll['F', ,'S1', ,'F' ,'_T',,i , usenames=TRUE, onlyna=TRUE] =eui['F','FA',,,'LIAB',,i,];
  ll['F', ,'S1', ,'LE' ,'_T',,i , usenames=TRUE, onlyna=TRUE] =eui['LE','FA',,,'L_LE',,i,];
  ll['F', ,'S1', ,'F' ,'_D',,i , usenames=TRUE, onlyna=TRUE] =eui['F','FA__D__F',,,'LIAB',,i,];
  ll['F', ,'S1', ,'LE' ,'_D',,i , usenames=TRUE, onlyna=TRUE] =eui['LE','FA__D__F',,,'L_LE',,i,];
  ll['F', ,'S1', ,'F' ,'_O',,i , usenames=TRUE, onlyna=TRUE] =eui['F','FA__O__F',,,'LIAB',,i,];
  ll['F', ,'S1', ,'LE' ,'_O',,i , usenames=TRUE, onlyna=TRUE] =eui['LE','FA__O__F',,,'L_LE',,i,];
  ll['F2M', ,'S1', ,'F' ,'_O',,i , usenames=TRUE, onlyna=TRUE] =eui['F','FA__O__F2',,,'LIAB',,i,];
  ll['F2M', ,'S1', ,'LE' ,'_O',,i , usenames=TRUE, onlyna=TRUE] =eui['LE','FA__O__F2',,,'L_LE',,i,];
  ll['F4', ,'S1', ,'F' ,'_O',,i , usenames=TRUE, onlyna=TRUE] =eui['F','FA__O__F4',,,'LIAB',,i,];
  ll['F4', ,'S1', ,'LE' ,'_O',,i , usenames=TRUE, onlyna=TRUE] =eui['LE','FA__O__F4',,,'L_LE',,i,];
  ll['F51M', ,'S1', ,'F' ,'_O',,i , usenames=TRUE, onlyna=TRUE] =eui['F','FA__O__F519',,,'LIAB',,i,];
  ll['F51M', ,'S1', ,'LE' ,'_O',,i , usenames=TRUE, onlyna=TRUE] =eui['LE','FA__O__F519',,,'L_LE',,i,];
  ll['F89', ,'S1', ,'F' ,'_O',,i , usenames=TRUE, onlyna=TRUE] =eui['F','FA__O__F89',,,'LIAB',,i,];
  ll['F89', ,'S1', ,'LE' ,'_O',,i , usenames=TRUE, onlyna=TRUE] =eui['LE','FA__O__F89',,,'L_LE',,i,];
  ll['F', ,'S1', ,'F' ,'_P',,i , usenames=TRUE, onlyna=TRUE] =eui['F','FA__P__F',,,'LIAB',,i,];
  ll['F', ,'S1', ,'LE' ,'_P',,i , usenames=TRUE, onlyna=TRUE] =eui['LE','FA__P__F',,,'L_LE',,i,];
  ll['F3', ,'S1', ,'F' ,'_P',,i , usenames=TRUE, onlyna=TRUE] =eui['F','FA__P__F3',,,'LIAB',,i,];
  ll['F3', ,'S1', ,'LE' ,'_P',,i , usenames=TRUE, onlyna=TRUE] =eui['LE','FA__P__F3',,,'L_LE',,i,];
  ll['F3S', ,'S1', ,'F' ,'_P',,i , usenames=TRUE, onlyna=TRUE] =eui['F','FA__P__F3__S',,,'LIAB',,i,];
  ll['F3S', ,'S1', ,'LE' ,'_P',,i , usenames=TRUE, onlyna=TRUE] =eui['LE','FA__P__F3__S',,,'L_LE',,i,];
  ll['F3L', ,'S1', ,'F' ,'_P',,i , usenames=TRUE, onlyna=TRUE] =eui['F','FA__P__F3__L',,,'LIAB',,i,];
  ll['F3L', ,'S1', ,'LE' ,'_P',,i , usenames=TRUE, onlyna=TRUE] =eui['LE','FA__P__F3__L',,,'L_LE',,i,];
  ll['F51', ,'S1', ,'F' ,'_P',,i , usenames=TRUE, onlyna=TRUE] =eui['F','FA__P__F51',,,'LIAB',,i,];
  ll['F51', ,'S1', ,'LE' ,'_P',,i , usenames=TRUE, onlyna=TRUE] =eui['LE','FA__P__F51',,,'L_LE',,i,]
}

ll[F..S1.S1.LE._T.2023Q4.COMM] 

gc()

saveRDSvl(aa,file.path(data_dir,'aa_iip_cps.rds'))
saveRDSvl(ll,file.path(data_dir,'ll_iip_cps.rds'))

saveRDSvl(aa,file.path(data_dir,'vintages/aa_iip_cps_' %&% format(Sys.time(),'%F') %&% '_.rds'))
saveRDSvl(ll,file.path(data_dir,'vintages/ll_iip_cps_' %&% format(Sys.time(),'%F') %&% '_.rds'))


saveRDS(aa,file='data/aa_iip_cps_temp.rds')

saveRDS(ll,file='data/ll_iip_cps_temp.rds')
# 
# aa=readRDS(file.path(data_dir,'aa_iip_cps_temp.rds')); gc()
# ll=readRDS(file.path(data_dir,'ll_iip_cps_temp.rds')); gc()


#####################################################
#####################################################
### calculating temporary sum in functional ASSETS###
### category _X = sum of functional categories    ###
#####################################################
#####################################################

#if the transformation into as.md3 does not work, open command prompt as admin and run: ipconfig /flushdns

aa[....._X..]=NA;gc()
daa=as.data.table(aa,.simple=TRUE); gc()
dacast=dcast(daa, ... ~ FUNCTIONAL_CAT, id.vars=1:8, value.var = 'obs_value'); gc()
dacast[['_X']]=apply(dacast[,c('_D','_P','_O','_R')],1,sum,na.rm=TRUE);gc()
dacast2=copy(dacast[,intersect(c(colnames(daa),'_X'),colnames(dacast)),with=FALSE]);gc()
colnames(dacast2)[NCOL(dacast2)]='obs_value';gc()
dacast2[,FUNCTIONAL_CAT:='_X'];gc()

daa=rbind(daa,dacast2,fill=TRUE);gc()     
aa2=as.md3(daa);gc()
#aa2=MD3:::.md3_class(daa)

aa2=aperm(copy(aa2), c(1:6,8,7))
dim(aa2)
gc()

saveRDS(aa2,file='data/aa_iip_cps.rds')

ll[....._X..]=NA;gc()
dll=as.data.table(ll,.simple=TRUE);gc()
dlcast=dcast(dll, ... ~ FUNCTIONAL_CAT, id.vars=1:8, value.var = 'obs_value');gc()
dlcast[['_X']]=apply(dlcast[,c('_D','_P','_O')],1,sum,na.rm=TRUE);gc()
dlcast2=copy(dlcast[,intersect(c(colnames(dll),'_X'),colnames(dlcast)),with=FALSE]);gc()
colnames(dlcast2)[NCOL(dlcast2)]='obs_value';gc()
dlcast2[,FUNCTIONAL_CAT:='_X'];gc()

dll=rbind(dll,dlcast2,fill=TRUE);gc()     
ll2=as.md3(dll);gc()
#ll2=MD3:::.md3_class(dll)

ll2=aperm(copy(ll2), c(1:6,8,7))
dim(ll2)
gc()

saveRDS(ll2,file='data/ll_iip_cps.rds')

aa=aa2
ll=ll2

