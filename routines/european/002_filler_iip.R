library(MDstats); library(MD3)
`%&%` = function (..., collapse = NULL, recycle0 = FALSE)  .Internal(paste0(list(...), collapse, recycle0))

# Set data directory
if (!exists("data_dir")) data_dir = getwd()

##############################################################
########      loading prepared domestic data    ##############
##############################################################
# aa has dimensions: INSTR, REF_AREA, REF_SECTOR, COUNTERPART_SECTOR, STO, FUNCTIONAL_CAT, TIME, COUNTERPART_AREA
# ll has dimensions: INSTR, COUNTERPART_AREA, COUNTERPART_SECTOR, REF_SECTOR, STO, FUNCTIONAL_CAT, TIME, REF_AREA

aa=readRDS(file.path(data_dir,'aa_prep.rds')); gc()
ll=readRDS(file.path(data_dir,'ll_prep.rds')); gc()

str(aa)
str(ll)

##############################################################
########filling of EA aggregate based on ECB QSA##############
##############################################################

eatemp=readRDS(file.path(data_dir,'eaaggregate_ecbqsa.rds'))
dimnames(eatemp)

dimnames(eatemp)[['REF_AREA']] = ccode(dimnames(eatemp)[['REF_AREA']],2,'iso2m'); gc()

str(eatemp)

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

saveRDS(aa,file.path(data_dir, 'aa_iip_cps_temp.rds'))
saveRDS(ll,file.path(data_dir, 'll_iip_cps_temp.rds'))


##############################################################
########filling of quarterly financial bop data###############
##############################################################

bopeu=readRDS(file.path(data_dir,'bop_cps_euea.rds'))
dimnames(bopeu)

names(dimnames(bopeu)) = c('REF_AREA', 'COUNTERPART_AREA', 'REF_SECTOR', 'STO', 'BOP_ITEM', 'TIME')

# Now convert country codes
dimnames(bopeu)[['REF_AREA']] = ccode(dimnames(bopeu)[['REF_AREA']], 2, 'iso2m')
dimnames(bopeu)[['COUNTERPART_AREA']] = ccode(dimnames(bopeu)[['COUNTERPART_AREA']], 2, 'iso2m', leaveifNA=TRUE)

assetfiller = function(bopeu,le='F',cparea=c("EXT_EA19", "EXT_EA20", "WRL_REST", "EU27", "EXT_EU27", "EU28",
                                             "EXT_EU28",  "BG", "BR", "CA", "CH", "NA", 
                                             "CZ", "DK", "EUI", "HK", "HR", "HU", "IN", "JP",
                                             "OFFSHO", "PL", "RO", "RU", "SE", "GB", "US"),
                       sss=c("S1", "S121", "S122", "S123", "S12K", "S12M", "S12T", "S13", "S1P", "S11", "S1V", "S124", "S12Q", "S1M")) {
  aaF = bopeu[dimnames(aa)$REF_AREA,,sss,,time(aa)]; gc()
  for (cp in cparea) {
    message(cp)
    
    aa['F',,sss,'S1',le,'_T',,cp,  usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA", ]); gc()
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
    aa['F51M',,sss,'S1',le,'_D',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F51M", ]); gc()
    aa['F51M',,sss,'S1',le,'_P',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F512", ]); gc()
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
    aa['F51M',,sss,'S1',le,'_D',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F51M", ]); gc()
    aa['F51M',,sss,'S1',le,'_P',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F512", ]); gc()
    aa['F51M',,sss,'S1',le,'_O',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F519", ]); gc()
    aa['F6',,sss,'S1',le,'_O',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F6", ]); gc()
    aa['F81',,sss,'S1',le,'_D',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F81", ]); gc()
    aa['F81',,sss,'S1',le,'_O',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F81", ]); gc()
    aa['F89',,sss,'S1',le,'_O',,cp, usenames=FALSE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F89", ]); gc()
    
  }
}


assetfiller(bopeu["...ASS.."],'F',c("EXT_EA19", "EXT_EA20", "WRL_REST", "EU27", "EXT_EU27", "EU28",
                                    "EXT_EU28",  "BG", "BR", "CA", "CH", "NA", 
                                    "CZ", "DK", "EUI", "HK", "HR", "HU", "IN", "JP",
                                    "OFFSHO", "PL", "RO", "RU", "SE", "GB", "US"))
aa[.EA20.S1.S1.F..2022q4.EXT_EA20]


saveRDS(aa, file.path(data_dir, 'aa_bop_cps_eu_temp.rds'))

#########################

liabfiller = function(bopeu,le='F',cparea=c("EXT_EA19", "EXT_EA20", "WRL_REST", "EU27", "EXT_EU27", "EU28",
                                            "EXT_EU28",  "BG", "BR", "CA", "CH", "NA", 
                                            "CZ", "DK", "EUI", "HK", "HR", "HU", "IN", "JP",
                                            "OFFSHO", "PL", "RO", "RU", "SE", "GB", "US"),
                      sss=c("S1", "S121", "S122", "S123", "S12K", "S12M", "S12T", "S13", "S1P", "S11", "S1V", "S124", "S12Q", "S1M")) {
  llF = bopeu[dimnames(ll)$REF_AREA,,sss,,time(ll)]; gc()
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
    ll['F51M',cp,'S1',sss,le,'_D',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F51M", ]); gc()
    ll['F51M',cp,'S1',sss,le,'_P',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F512", ]); gc()
    ll['F51M',cp,'S1',sss,le,'_O',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F519", ]); gc()
    ll['F6',cp,'S1',sss,le,'_O',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F6", ]); gc()
    ll['F81',cp,'S1',sss,le,'_D',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F81", ]); gc()
    ll['F81',cp,'S1',sss,le,'_O',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F81", ]); gc()
    ll['F89',cp,'S1',sss,le,'_O',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F89", ]); gc()
  }
}


liabfiller(bopeu["...LIAB.."],'F',c("EXT_EA19", "EXT_EA20", "WRL_REST", "EU27", "EXT_EU27", "EU28",
                                    "EXT_EU28",  "BG", "BR", "CA", "CH", "NA", 
                                    "CZ", "DK", "EUI", "HK", "HR", "HU", "IN", "JP",
                                    "OFFSHO", "PL", "RO", "RU", "SE", "GB", "US"))

gc()


ll[.EXT_EA20.S1.S1.F..2022q4.EA20]


saveRDS(ll, file.path(data_dir, 'll_bop_cps_eu_temp.rds'))

##############################################################
########filling of quarterly financial iip data###############
##############################################################

iip=readRDS(file.path(data_dir,'iip_cps.rds'))
dimnames(iip)
names(dimnames(iip))[2:4] = c( 'REF_AREA' ,'COUNTERPART_AREA','REF_SECTOR')
dimnames(iip)[['REF_AREA']] = ccode(dimnames(iip)[['REF_AREA']],2,'iso2m'); gc()
dimnames(iip)[['COUNTERPART_AREA']] = ccode(dimnames(iip)[['COUNTERPART_AREA']],2,'iso2m',leaveifNA=TRUE); gc()


assetfiller(iip["A_LE....."],'LE',c("IT", "EA19", "EA20", "EXT_EA19", "EXT_EA20", "WRL_REST", "AT", "BG", "BR", "CA", "CH", "CN", "CY", "CZ",
                                    "DE", "DK", "EE", "GR", "ES", "EU27", "EU28", "EUI", "EXT_EU27", "EXT_EU28", "FI", "FR",
                                    "G20_X_EU27", "HK", "HR", "HU", "IE", "IMF", "IN", "IT", "JP", "LT", "LU", "LV", "MT", "NL",
                                    "OFFSHO", "PL", "PT", "RO", "RU", "SE", "SI", "SK", "GB", "US", "AR", "AU", "ID", "KR", "MX", "NO",
                                    "SA", "TR", "ZA", "BE"))

aa[.IT.S1.S1.LE..2022q4.WRL_REST]


saveRDS(aa, file.path(data_dir, 'aa_iip_cps_temp.rds'))


liabfiller(iip["L_LE....."],'LE',c("IT", "EA19", "EA20", "EXT_EA19", "EXT_EA20", "WRL_REST", "AT", "BG", "BR", "CA", "CH", "CN", "CY", "CZ",
                                   "DE", "DK", "EE", "GR", "ES", "EU27", "EU28", "EUI", "EXT_EU27", "EXT_EU28", "FI", "FR",
                                   "G20_X_EU27", "HK", "HR", "HU", "IE", "IMF", "IN", "IT", "JP", "LT", "LU", "LV", "MT", "NL",
                                   "OFFSHO", "PL", "PT", "RO", "RU", "SE", "SI", "SK", "GB", "US", "AR", "AU", "ID", "KR", "MX", "NO",
                                   "SA", "TR", "ZA", "BE"))
ll[.WRL_REST.S1.S1.LE..2022q4.AT]

gc()

saveRDS(ll, file.path(data_dir, 'll_iip_cps_temp.rds'))


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

saveRDS(aa,file.path(data_dir,'aa_iip_cps.rds'))
saveRDS(ll,file.path(data_dir,'ll_iip_cps.rds'))

saveRDS(aa,file.path(data_dir,'vintages/aa_iip_cps_' %&% format(Sys.time(),'%F') %&% '_.rds'))
saveRDS(ll,file.path(data_dir,'vintages/ll_iip_cps_' %&% format(Sys.time(),'%F') %&% '_.rds'))


#####################################################
#####################################################
### calculating temporary sum in functional ASSETS###
### category _X = sum of functional categories    ###
#####################################################
#####################################################

aa[....._X..]=NA;gc()
daa=as.data.table(aa,.simple=TRUE); gc()
dacast=dcast(daa, ... ~ FUNCTIONAL_CAT, id.vars=1:8, value.var = 'obs_value'); gc()
dacast[['_X']]=apply(dacast[,c('_D','_P','_O','_R')],1,sum,na.rm=TRUE);gc()
dacast2=copy(dacast[,intersect(c(colnames(daa),'_X'),colnames(dacast)),with=FALSE]);gc()
colnames(dacast2)[NCOL(dacast2)]='obs_value';gc()
dacast2[,FUNCTIONAL_CAT:='_X'];gc()

daa=rbind(daa,dacast2,fill=TRUE);gc()     
aa2=as.md3(daa);gc()

aa2=aperm(copy(aa2), c(1:6,8,7))
dim(aa2)
gc()

saveRDS(aa2, file.path(data_dir, 'aa_iip_cps_final.rds'))

ll[....._X..]=NA;gc()
dll=as.data.table(ll,.simple=TRUE);gc()
dlcast=dcast(dll, ... ~ FUNCTIONAL_CAT, id.vars=1:8, value.var = 'obs_value');gc()
dlcast[['_X']]=apply(dlcast[,c('_D','_P','_O')],1,sum,na.rm=TRUE);gc()
dlcast2=copy(dlcast[,intersect(c(colnames(dll),'_X'),colnames(dlcast)),with=FALSE]);gc()
colnames(dlcast2)[NCOL(dlcast2)]='obs_value';gc()
dlcast2[,FUNCTIONAL_CAT:='_X'];gc()

dll=rbind(dll,dlcast2,fill=TRUE);gc()     
ll2=as.md3(dll);gc()

ll2=aperm(copy(ll2), c(1:6,8,7))
dim(ll2)
gc()

saveRDS(ll2, file.path(data_dir, 'll_iip_cps_final.rds'))

aa=aa2
ll=ll2
