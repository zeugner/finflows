library(MDstats); library(MD3)
`%&%` = function (..., collapse = NULL, recycle0 = FALSE)  .Internal(paste0(list(...), collapse, recycle0))

# Set data directory
if (!exists("data_dir")) data_dir = getwd()

##############################################################
########      loading prepared domestic data    ##############
##############################################################
# aa has dimensions: INSTR, REF_AREA, REF_SECTOR, COUNTERPART_SECTOR, STO, FUNCTIONAL_CAT, TIME, COUNTERPART_AREA
# ll has same positional structure, names swapped:
#     INSTR, COUNTERPART_AREA, COUNTERPART_SECTOR, REF_SECTOR, STO, FUNCTIONAL_CAT, TIME, REF_AREA
# Same query on both objects returns the same economic fact:
#   aa[F.AT.S11.S1.LE._T.2022q4.WRL_REST] = S11 cross-border assets
#   ll[F.AT.S11.S1.LE._T.2022q4.WRL_REST] = foreign liabilities to S11

aa=readRDS(file.path(data_dir,'aa_prep.rds')); gc()
ll=readRDS(file.path(data_dir,'ll_prep.rds')); gc()

#str(aa)
#str(ll)

##############################################################
########filling of EA aggregate based on ECB QSA##############
##############################################################

eatemp=readRDS(file.path(data_dir,'eaaggregate_ecbqsa.rds'))
dimnames(eatemp)

dimnames(eatemp)[['REF_AREA']] = ccode(dimnames(eatemp)[['REF_AREA']],2,'iso2m'); gc()

str(eatemp)

lookup=c(F2M='F2M.T.',F21='F21.T.', F3='F3.T.',F3S='F3.S.',F3L='F3.L.',F4='F4.T.', F4S='F4.S.',F4L='F4.L.',F511='F511._Z.',
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
  ll[i,'W0',,,,'_T',,'EA18', usenames=TRUE, onlyna=TRUE] = ea4liab['EA18..W0...' %&% lookup[i] ]
}
gc()
ll[.EA20..S1.LE._T.2022q4.WRL_REST]

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
                                             "OFFSHO", "PL", "RO", "RU", "SE", "GB", "US","CN_X_HK"),
                       sss=c("S1", "S121", "S122", "S123", "S12K", "S12M", "S12T", "S13", "S1P", "S11", "S1V", "S124", "S12Q", "S1M")) {
  aaF = bopeu[dimnames(aa)$REF_AREA,,sss,,time(aa)]; gc()
  for (cp in cparea) {
    message(cp)
    aa['F',,sss,'S1',le,'_T',,cp,   usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA",          ]); gc()
    aa['F',,sss,'S1',le,'_P',,cp,   usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F",    ]); gc()
    aa['F',,sss,'S1',le,'_O',,cp,   usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F",    ]); gc()
    aa['F',,sss,'S1',le,'_D',,cp,   usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F",    ]); gc()
    aa['F',,sss,'S1',le,'_R',,cp,   usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__R__F",    ]); gc()
    aa['F2',,sss,'S1',le,'_R',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__R__F2",   ]); gc()
    aa['F3',,sss,'S1',le,'_R',,cp,  usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__R__F3",   ]); gc()
    aa['F',,sss,'S1',le,'_F',,cp,   usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__F__F7",   ]); gc()
    aa['F2',,sss,'S1',le,'_O',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F2",   ]); gc()
    aa['F3',,sss,'S1',le,'_D',,cp,  usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F3",   ]); gc()
    aa['F3',,sss,'S1',le,'_P',,cp,  usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F3",   ]); gc()
    aa['F4',,sss,'S1',le,'_D',,cp,  usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F4",   ]); gc()
    aa['F4',,sss,'S1',le,'_O',,cp,  usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F4",   ]); gc()
    aa['F5',,sss,'S1',le,'_P',,cp,  usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F5",   ]); gc()
    aa['F51',,sss,'S1',le,'_P',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F51",  ]); gc()
    aa['F52',,sss,'S1',le,'_P',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F52",  ]); gc()
    aa['F511',,sss,'S1',le,'_D',,cp,usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F511", ]); gc()
    aa['F511',,sss,'S1',le,'_P',,cp,usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F511", ]); gc()
    aa['F51M',,sss,'S1',le,'_D',,cp,usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F51M", ]); gc()
    aa['F51M',,sss,'S1',le,'_P',,cp,usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F512", ]); gc()
    aa['F51M',,sss,'S1',le,'_O',,cp,usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F519", ]); gc()
    aa['F6',,sss,'S1',le,'_O',,cp,  usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F6",   ]); gc()
    aa['F81',,sss,'S1',le,'_D',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F81",  ]); gc()
    aa['F81',,sss,'S1',le,'_O',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F81",  ]); gc()
    aa['F89',,sss,'S1',le,'_O',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F89",  ]); gc()
  }
}


# #sz start 
# astfiller2 = function(bopeu,le='F',cparea=c("EXT_EA19", "EXT_EA20", "WRL_REST", "EU27", "EXT_EU27", "EU28",
#                                              "EXT_EU28",  "BG", "BR", "CA", "CH", "NA",
#                                              "CZ", "DK", "EUI", "HK", "HR", "HU", "IN", "JP",
#                                              "OFFSHO", "PL", "RO", "RU", "SE", "GB", "US","CN_X_HK"),
#                        sss=c("S1", "S121", "S122", "S123", "S12K", "S12M", "S12T", "S13", "S1P", "S11", "S1V", "S124", "S12Q", "S1M")) {
#   aaF = bopeu[dimnames(aa)$REF_AREA,,sss,,time(aa)]; gc()
#   
#   
#   aa['F',,sss,'S1',le,'_T',,cparea,   usenames=TRUE, onlyna=TRUE] <<- aaF[,cparea,,"FA",          ]
#   aa['F',,sss,'S1',le,'_P',,cparea,   usenames=TRUE, onlyna=TRUE] <<- aaF[,cparea,,"FA__P__F",    ]
#   aa['F',,sss,'S1',le,'_O',,cparea,   usenames=TRUE, onlyna=TRUE] <<- aaF[,cparea,,"FA__O__F",    ]
#   aa['F',,sss,'S1',le,'_D',,cparea,   usenames=TRUE, onlyna=TRUE] <<- aaF[,cparea,,"FA__D__F",    ]
#   aa['F',,sss,'S1',le,'_R',,cparea,   usenames=TRUE, onlyna=TRUE] <<- aaF[,cparea,,"FA__R__F",    ]
#   aa['F2',,sss,'S1',le,'_R',,cparea, usenames=TRUE, onlyna=TRUE] <<- aaF[,cparea,,"FA__R__F2",   ]
#   aa['F3',,sss,'S1',le,'_R',,cparea,  usenames=TRUE, onlyna=TRUE] <<- aaF[,cparea,,"FA__R__F3",   ]
#   aa['F',,sss,'S1',le,'_F',,cparea,   usenames=TRUE, onlyna=TRUE] <<- aaF[,cparea,,"FA__F__F7",   ]
#   aa['F2',,sss,'S1',le,'_O',,cparea, usenames=TRUE, onlyna=TRUE] <<- aaF[,cparea,,"FA__O__F2",   ]
#   aa['F3',,sss,'S1',le,'_D',,cparea,  usenames=TRUE, onlyna=TRUE] <<- aaF[,cparea,,"FA__D__F3",   ]
#   aa['F3',,sss,'S1',le,'_P',,cparea,  usenames=TRUE, onlyna=TRUE] <<- aaF[,cparea,,"FA__P__F3",   ]
#   aa['F4',,sss,'S1',le,'_D',,cparea,  usenames=TRUE, onlyna=TRUE] <<- aaF[,cparea,,"FA__D__F4",   ]
#   aa['F4',,sss,'S1',le,'_O',,cparea,  usenames=TRUE, onlyna=TRUE] <<- aaF[,cparea,,"FA__O__F4",   ]
#   aa['F5',,sss,'S1',le,'_P',,cparea,  usenames=TRUE, onlyna=TRUE] <<- aaF[,cparea,,"FA__P__F5",   ]
#   aa['F51',,sss,'S1',le,'_P',,cparea, usenames=TRUE, onlyna=TRUE] <<- aaF[,cparea,,"FA__P__F51",  ]
#   aa['F52',,sss,'S1',le,'_P',,cparea, usenames=TRUE, onlyna=TRUE] <<- aaF[,cparea,,"FA__P__F52",  ]
#   aa['F511',,sss,'S1',le,'_D',,cparea,usenames=TRUE, onlyna=TRUE] <<- aaF[,cparea,,"FA__D__F511", ]
#   aa['F511',,sss,'S1',le,'_P',,cparea,usenames=TRUE, onlyna=TRUE] <<- aaF[,cparea,,"FA__P__F511", ]
#   aa['F51M',,sss,'S1',le,'_D',,cparea,usenames=TRUE, onlyna=TRUE] <<- aaF[,cparea,,"FA__D__F51M", ]
#   aa['F51M',,sss,'S1',le,'_P',,cparea,usenames=TRUE, onlyna=TRUE] <<- aaF[,cparea,,"FA__P__F512", ]
#   aa['F51M',,sss,'S1',le,'_O',,cparea,usenames=TRUE, onlyna=TRUE] <<- aaF[,cparea,,"FA__O__F519", ]
#   aa['F6',,sss,'S1',le,'_O',,cparea,  usenames=TRUE, onlyna=TRUE] <<- aaF[,cparea,,"FA__O__F6",   ]
#   aa['F81',,sss,'S1',le,'_D',,cparea, usenames=TRUE, onlyna=TRUE] <<- aaF[,cparea,,"FA__D__F81",  ]
#   aa['F81',,sss,'S1',le,'_O',,cparea, usenames=TRUE, onlyna=TRUE] <<- aaF[,cparea,,"FA__O__F81",  ]
#   aa['F89',,sss,'S1',le,'_O',,cparea, usenames=TRUE, onlyna=TRUE] <<- aaF[,cparea,,"FA__O__F89",  ]
#   
#  return(invisible(TRUE))  
# }
# 
# aa0=copy(aa)
# 
# astfiller2(bopeu["...ASS.."],'F',c("EXT_EA19", "EXT_EA20", "WRL_REST", "EU27", "EXT_EU27", "EU28",
#                                     "EXT_EU28",  "BG", "BR", "CA", "CH", "NA",
#                                     "CZ", "DK", "EUI", "HK", "HR", "HU", "IN", "JP",
#                                     "OFFSHO", "PL", "RO", "RU", "SE", "GB", "US","CN_X_HK"))
# aa2 = copy(aa)
# aa=copy(aa0)
# #sz end

assetfiller(bopeu["...ASS.."],'F',c("EXT_EA19", "EXT_EA20", "WRL_REST", "EU27", "EXT_EU27", "EU28",
                                    "EXT_EU28",  "BG", "BR", "CA", "CH", "NA",
                                    "CZ", "DK", "EUI", "HK", "HR", "HU", "IN", "JP",
                                    "OFFSHO", "PL", "RO", "RU", "SE", "GB", "US","CN_X_HK"))
#sz: now compare aa to aa2
#aa2[.EA20.S1.S1.F..2022q4.EXT_EA20] 'should be teh same as 
aa[.EA20.S1.S1.F..2022q4.EXT_EA20]

saveRDS(aa, file.path(data_dir, 'aa_bop_cps_eu_temp.rds'))

#########################

liabfiller = function(bopeu,le='F',cparea=c("EXT_EA19", "EXT_EA20", "WRL_REST", "EU27", "EXT_EU27", "EU28",
                                            "EXT_EU28",  "BG", "BR", "CA", "CH", "NA",
                                            "CZ", "DK", "EUI", "HK", "HR", "HU", "IN", "JP",
                                            "OFFSHO", "PL", "RO", "RU", "SE", "GB", "US","CN_X_HK"),
                      sss=c("S1", "S121", "S122", "S123", "S12K", "S12M", "S12T", "S13", "S1P", "S11", "S1V", "S124", "S12Q", "S1M")) {
  llF = bopeu[dimnames(ll)$COUNTERPART_AREA,,sss,,time(ll)]; gc()
  for (cp in cparea) {
    message(cp)
    ll['F',  cp,'S1',sss,le,'_T',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA",          ]); gc()
    ll['F',  cp,'S1',sss,le,'_O',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F",    ]); gc()
    ll['F',  cp,'S1',sss,le,'_P',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F",    ]); gc()
    ll['F',  cp,'S1',sss,le,'_D',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F",    ]); gc()
    ll['F',  cp,'S1',sss,le,'_R',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__R__F",    ]); gc()
    ll['F',  cp,'S1',sss,le,'_F',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__F__F7",   ]); gc()
    ll['F2',cp,'S1',sss,le,'_O',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F2",   ]); gc()
    ll['F3', cp,'S1',sss,le,'_D',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F3",   ]); gc()
    ll['F3', cp,'S1',sss,le,'_P',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F3",   ]); gc()
    ll['F4', cp,'S1',sss,le,'_D',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F4",   ]); gc()
    ll['F4', cp,'S1',sss,le,'_O',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F4",   ]); gc()
    ll['F52',cp,'S1',sss,le,'_P',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F52",  ]); gc()
    ll['F5', cp,'S1',sss,le,'_D',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F5",   ]); gc()
    ll['F51',cp,'S1',sss,le,'_D',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F51",  ]); gc()
    ll['F511',cp,'S1',sss,le,'_D',,,usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F511", ]); gc()
    ll['F5', cp,'S1',sss,le,'_P',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F5",   ]); gc()
    ll['F51',cp,'S1',sss,le,'_P',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F51",  ]); gc()
    ll['F511',cp,'S1',sss,le,'_P',,,usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F511", ]); gc()
    ll['F51M',cp,'S1',sss,le,'_D',,,usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F51M", ]); gc()
    ll['F51M',cp,'S1',sss,le,'_P',,,usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F512", ]); gc()
    ll['F51M',cp,'S1',sss,le,'_O',,,usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F519", ]); gc()
    ll['F6', cp,'S1',sss,le,'_O',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F6",   ]); gc()
    ll['F81',cp,'S1',sss,le,'_D',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F81",  ]); gc()
    ll['F81',cp,'S1',sss,le,'_O',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F81",  ]); gc()
    ll['F89',cp,'S1',sss,le,'_O',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F89",  ]); gc()
  }
}
liabfiller(bopeu["...LIAB.."],'F',c("EXT_EA19", "EXT_EA20", "WRL_REST", "EU27", "EXT_EU27", "EU28",
                                   "EXT_EU28",  "BG", "BR", "CA", "CH", "NA",
                                   "CZ", "DK", "EUI", "HK", "HR", "HU", "IN", "JP",
                                   "OFFSHO", "PL", "RO", "RU", "SE", "GB", "US","CN_X_HK"))
gc()

ll[.EXT_EA20.S1.S1.F..2024q4.EA20]

saveRDS(ll, file.path(data_dir, 'll_bop_cps_eu_temp.rds'))

##############################################################
########filling of quarterly and annual iip data###############
##############################################################

iipq=readRDS(file.path(data_dir,'iip_cps.rds'))
iipa=readRDS(file.path(data_dir,'iip_cps_annual.rds'))
frequency(iipa)='Q'
iip=merge(iipq,iipa,along='STO')
dimnames(iip)
names(dimnames(iip))[2:4] = c('REF_AREA','COUNTERPART_AREA','REF_SECTOR')
dimnames(iip)[['REF_AREA']] = ccode(dimnames(iip)[['REF_AREA']],2,'iso2m'); gc()
dimnames(iip)[['COUNTERPART_AREA']] = ccode(dimnames(iip)[['COUNTERPART_AREA']],2,'iso2m',leaveifNA=TRUE); gc()
dimnames(iip)$REF_SECTOR[dimnames(iip)$REF_SECTOR=='S12M'] = 'S12R'



assetfiller = function(iip,le='LE',cparea=c("EXT_EA19", "WRL_REST", "BG", "BR", "CA", "CH",
                                          "CN_X_HK", "CZ", "DK", "EUI", "EXT_EU27", "HK",
                                          "HR", "HU", "IN", "JP", "OFFSHO", "PL",
                                          "RO", "RU", "SE", "GB", "US", "EXT_EA20",
                                          "IMF", "AT", "BE", "CY", "DE", "EE",
                                          "GR", "ES", "FI", "FR", "IE", "IT",
                                          "LT", "LU", "LV", "MT", "NL", "PT",
                                          "SI", "SK", "EXT_EU28", "EA19", "EA20", "EU27",
                                          "EU28", "G20_X_EU27_2020", "AR", "AU", "ID", "KR",
                                          "MX", "NO", "SA", "TR", "ZA"),
                       sss=c('S121','S12T','S12K','S13','S11','S1M','S124','S12O','S12Q','S1')) {
  
  aaF = iip[dimnames(aa)$REF_AREA,,sss,,time(aa)]; gc()
  for (cp in cparea) {
    message(cp)
    aa['F',  ,sss,'S1',le,'_T',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA",          ]); gc()
    aa['F',  ,sss,'S1',le,'_P',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F",    ]); gc()
    aa['F',  ,sss,'S1',le,'_O',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F",    ]); gc()
    aa['F',  ,sss,'S1',le,'_D',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F",    ]); gc()
    aa['F',  ,sss,'S1',le,'_R',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__R__F",    ]); gc()
    aa['F',  ,sss,'S1',le,'_F',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__F__F7",   ]); gc()
    aa['F2',,sss,'S1',le,'_O',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F2",   ]); gc()
    aa['F2',,sss,'S1',le,'_R',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__R__F2",   ]); gc()
    aa['F3', ,sss,'S1',le,'_D',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F3",   ]); gc()
    aa['F3', ,sss,'S1',le,'_P',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F3",   ]); gc()
    aa['F3', ,sss,'S1',le,'_R',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__R__F3",   ]); gc()
    aa['F4', ,sss,'S1',le,'_D',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F4",   ]); gc()
    aa['F4', ,sss,'S1',le,'_O',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F4",   ]); gc()
    aa['F52',,sss,'S1',le,'_P',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F52",  ]); gc()
    aa['F5', ,sss,'S1',le,'_D',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F5",   ]); gc()
    aa['F51',,sss,'S1',le,'_D',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F51",  ]); gc()
    aa['F511',,sss,'S1',le,'_D',,cp,usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F511", ]); gc()
    aa['F5', ,sss,'S1',le,'_P',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F5",   ]); gc()
    aa['F51',,sss,'S1',le,'_P',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F51",  ]); gc()
    aa['F511',,sss,'S1',le,'_P',,cp,usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F511", ]); gc()
    aa['F51M',,sss,'S1',le,'_D',,cp,usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F51M", ]); gc()
    aa['F51M',,sss,'S1',le,'_P',,cp,usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__P__F512", ]); gc()  # fixed: removed leading dot
    aa['F51M',,sss,'S1',le,'_O',,cp,usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F519", ]); gc()
    aa['F6', ,sss,'S1',le,'_O',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F6",   ]); gc()
    aa['F81',,sss,'S1',le,'_D',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__D__F81",  ]); gc()
    aa['F81',,sss,'S1',le,'_O',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F81",  ]); gc()
    aa['F89',,sss,'S1',le,'_O',,cp, usenames=TRUE, onlyna=TRUE] <<- as.array(aaF[,cp,,"FA__O__F89",  ]); gc()
  }
}

assetfiller(iip["A_LE....."],'LE',c("EXT_EA19", "WRL_REST", "BG", "BR", "CA", "CH",
                                    "CN_X_HK", "CZ", "DK", "EUI", "EXT_EU27", "HK",
                                    "HR", "HU", "IN", "JP", "OFFSHO", "PL",
                                    "RO", "RU", "SE", "GB", "US", "EXT_EA20",
                                    "IMF", "AT", "BE", "CY", "DE", "EE",
                                    "GR", "ES", "FI", "FR", "IE", "IT",
                                    "LT", "LU", "LV", "MT", "NL", "PT",
                                    "SI", "SK", "EXT_EU28", "EA19", "EA20", "EU27",
                                    "EU28", "G20_X_EU27_2020", "AR", "AU", "ID", "KR",
                                    "MX", "NO", "SA", "TR", "ZA"))
aa[.AT.S1.S1.LE..2022q4.WRL_REST]
gc()


aa[.EA20......WRL_REST] <- aa[.EA20......EXT_EA20]
aa[.EA19......WRL_REST] <- aa[.EA19......EXT_EA19]
aa[.EU27......WRL_REST] <- aa[.EU27......EXT_EU27]
aa[.EU28......WRL_REST] <- aa[.EU28......EXT_EU28]

saveRDS(aa, file='data/aa_iip_cps_temp.rds')

liabfiller = function(iip,le='LE',cparea=c("EXT_EA19", "WRL_REST", "BG", "BR", "CA", "CH",
                                           "CN_X_HK", "CZ", "DK", "EUI", "EXT_EU27", "HK",
                                           "HR", "HU", "IN", "JP", "OFFSHO", "PL",
                                           "RO", "RU", "SE", "GB", "US", "EXT_EA20",
                                           "IMF", "AT", "BE", "CY", "DE", "EE",
                                           "GR", "ES", "FI", "FR", "IE", "IT",
                                           "LT", "LU", "LV", "MT", "NL", "PT",
                                           "SI", "SK", "EXT_EU28", "EA19", "EA20", "EU27",
                                           "EU28", "G20_X_EU27_2020", "AR", "AU", "ID", "KR",
                                           "MX", "NO", "SA", "TR", "ZA"),
                      sss=c('S121','S12T','S13','S11','S1M','S124','S12O','S12Q','S1')) {
  llF = iip[dimnames(ll)$REF_AREA,,sss,,time(ll)]; gc()
  for (cp in cparea) {
    message(cp)
    ll['F',  cp,'S1',sss,le,'_T',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA",          ]); gc()
    ll['F',  cp,'S1',sss,le,'_P',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F",    ]); gc()
    ll['F',  cp,'S1',sss,le,'_O',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F",    ]); gc()
    ll['F',  cp,'S1',sss,le,'_D',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F",    ]); gc()
    ll['F',  cp,'S1',sss,le,'_R',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__R__F",    ]); gc()
    ll['F',  cp,'S1',sss,le,'_F',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__F__F7",   ]); gc()
    ll['F2',cp,'S1',sss,le,'_O',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F2",   ]); gc()
    ll['F3', cp,'S1',sss,le,'_D',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F3",   ]); gc()
    ll['F3', cp,'S1',sss,le,'_P',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F3",   ]); gc()
    ll['F4', cp,'S1',sss,le,'_D',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F4",   ]); gc()
    ll['F4', cp,'S1',sss,le,'_O',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F4",   ]); gc()
    ll['F52',cp,'S1',sss,le,'_P',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F52",  ]); gc()
    ll['F5', cp,'S1',sss,le,'_D',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F5",   ]); gc()  # added
    ll['F51',cp,'S1',sss,le,'_D',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F51",  ]); gc()  # added
    ll['F511',cp,'S1',sss,le,'_D',,,usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F511", ]); gc()
    ll['F5', cp,'S1',sss,le,'_P',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F5",   ]); gc()  # added
    ll['F51',cp,'S1',sss,le,'_P',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F51",  ]); gc()
    ll['F511',cp,'S1',sss,le,'_P',,,usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F511", ]); gc()
    ll['F51M',cp,'S1',sss,le,'_D',,,usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F51M", ]); gc()
    ll['F51M',cp,'S1',sss,le,'_P',,,usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__P__F512", ]); gc()  # fixed: removed leading dot
    ll['F51M',cp,'S1',sss,le,'_O',,,usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F519", ]); gc()
    ll['F6', cp,'S1',sss,le,'_O',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F6",   ]); gc()
    ll['F81',cp,'S1',sss,le,'_D',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__D__F81",  ]); gc()
    ll['F81',cp,'S1',sss,le,'_O',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F81",  ]); gc()
    ll['F89',cp,'S1',sss,le,'_O',,, usenames=TRUE, onlyna=TRUE] <<- as.array(llF[,cp,,"FA__O__F89",  ]); gc()
  }
}

liabfiller(iip["L_LE....."],'LE',c("EXT_EA19", "WRL_REST", "BG", "BR", "CA", "CH",
                                   "CN_X_HK", "CZ", "DK", "EUI", "EXT_EU27", "HK",
                                   "HR", "HU", "IN", "JP", "OFFSHO", "PL",
                                   "RO", "RU", "SE", "GB", "US", "EXT_EA20",
                                   "IMF", "AT", "BE", "CY", "DE", "EE",
                                   "GR", "ES", "FI", "FR", "IE", "IT",
                                   "LT", "LU", "LV", "MT", "NL", "PT",
                                   "SI", "SK", "EXT_EU28", "EA19", "EA20", "EU27",
                                   "EU28", "G20_X_EU27_2020", "AR", "AU", "ID", "KR",
                                   "MX", "NO", "SA", "TR", "ZA"))
ll[.WRL_REST.S1.S1.LE..2022q4.AT]

ll[.WRL_REST......EA20] <- ll[.EXT_EA20......EA20]
ll[.WRL_REST......EA19] <- ll[.EXT_EA19......EA19]
ll[.WRL_REST......EU27] <- ll[.EXT_EU27......EU27]
ll[.WRL_REST......EU28] <- ll[.EXT_EU28......EU28]

gc()
saveRDS(aa, file.path(data_dir, 'aa_iip_cps_temp.rds'))
saveRDS(ll, file.path(data_dir, 'll_iip_cps_temp.rds'))

##############################################################
########filling of individual country BOP flows    ##########
#### Source: bop_cps.rds (Eurostat bop_c6_q)              ####
#### Fills bilateral flow data (STO='F') for individual   ####
#### EU countries. Previously missing because bop_cps.rds ####
#### was empty due to a bug in combineloadedbits.          ####
#### Uses the IIP assetfiller and liabfiller defined above ####
#### since bop_cps has the same dimension structure as iip ####
#### after renaming: STO, REF_AREA, COUNTERPART_AREA,     ####
#### REF_SECTOR, BOP_ITEM, TIME                           ####
##############################################################

bop_ind = readRDS(file.path(data_dir, 'bop_cps.rds'))

# Rename to match iip dimension structure
# bop_cps raw dims: STO, geo, partner, sector10, bop_item, TIME
names(dimnames(bop_ind)) = c('STO', 'REF_AREA', 'COUNTERPART_AREA', 'REF_SECTOR', 'BOP_ITEM', 'TIME')
dimnames(bop_ind)[['REF_AREA']]         = ccode(dimnames(bop_ind)[['REF_AREA']],         2, 'iso2m')
dimnames(bop_ind)[['COUNTERPART_AREA']] = ccode(dimnames(bop_ind)[['COUNTERPART_AREA']], 2, 'iso2m', leaveifNA=TRUE)

# Use sectors and counterpart areas available in bop_cps
sss_ind    = intersect(c("S1","S121","S122","S123","S12T","S13","S1P","S1V"),
                       dimnames(bop_ind)[['REF_SECTOR']])
cparea_ind = dimnames(bop_ind)[['COUNTERPART_AREA']]

# assetfiller subsets dim1 (REF_AREA) by dimnames(aa)$REF_AREA —
# correct for bop_cps where geo = reporting country = REF_AREA in aa
assetfiller(bop_ind["ASS....."], 'F', cparea_ind, sss_ind)
gc()
saveRDS(aa, file.path(data_dir, 'aa_bop_cps_ind_temp.rds'))

# liabfiller subsets dim1 (REF_AREA) by dimnames(ll)$REF_AREA —
# correct for bop_cps where geo = reporting country = REF_AREA in ll (dim8)
liabfiller(bop_ind["LIAB....."], 'F', cparea_ind, sss_ind)
gc()
saveRDS(ll, file.path(data_dir, 'll_bop_cps_ind_temp.rds'))

rm(bop_ind); gc()

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
  aa['F2',i , ,'S1' ,'F' ,'_O',, , usenames=TRUE, onlyna=TRUE] =eui['F','FA__O__F2',,,'ASS',,i,];
  aa['F2',i , ,'S1' ,'LE' ,'_O',, , usenames=TRUE, onlyna=TRUE] =eui['LE','FA__O__F2',,,'A_LE',,i,];
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
  ll['F', ,,'S1','F' ,'_T',,i , usenames=TRUE, onlyna=TRUE] =eui['F','FA',,,'LIAB',,i,];
  ll['F', ,,'S1','LE' ,'_T',,i , usenames=TRUE, onlyna=TRUE] =eui['LE','FA',,,'L_LE',,i,];
  ll['F', ,,'S1','F' ,'_D',,i , usenames=TRUE, onlyna=TRUE] =eui['F','FA__D__F',,,'LIAB',,i,];
  ll['F', ,,'S1','LE' ,'_D',,i , usenames=TRUE, onlyna=TRUE] =eui['LE','FA__D__F',,,'L_LE',,i,];
  ll['F', ,,'S1','F' ,'_O',,i , usenames=TRUE, onlyna=TRUE] =eui['F','FA__O__F',,,'LIAB',,i,];
  ll['F', ,,'S1','LE' ,'_O',,i , usenames=TRUE, onlyna=TRUE] =eui['LE','FA__O__F',,,'L_LE',,i,];
  ll['F2', ,,'S1','F' ,'_O',,i , usenames=TRUE, onlyna=TRUE] =eui['F','FA__O__F2',,,'LIAB',,i,];
  ll['F2', ,,'S1','LE' ,'_O',,i , usenames=TRUE, onlyna=TRUE] =eui['LE','FA__O__F2',,,'L_LE',,i,];
  ll['F4', ,,'S1','F' ,'_O',,i , usenames=TRUE, onlyna=TRUE] =eui['F','FA__O__F4',,,'LIAB',,i,];
  ll['F4', ,,'S1','LE' ,'_O',,i , usenames=TRUE, onlyna=TRUE] =eui['LE','FA__O__F4',,,'L_LE',,i,];
  ll['F51M', ,,'S1','F' ,'_O',,i , usenames=TRUE, onlyna=TRUE] =eui['F','FA__O__F519',,,'LIAB',,i,];
  ll['F51M', ,,'S1','LE' ,'_O',,i , usenames=TRUE, onlyna=TRUE] =eui['LE','FA__O__F519',,,'L_LE',,i,];
  ll['F89', ,,'S1','F' ,'_O',,i , usenames=TRUE, onlyna=TRUE] =eui['F','FA__O__F89',,,'LIAB',,i,];
  ll['F89', ,,'S1','LE' ,'_O',,i , usenames=TRUE, onlyna=TRUE] =eui['LE','FA__O__F89',,,'L_LE',,i,];
  ll['F', ,,'S1','F' ,'_P',,i , usenames=TRUE, onlyna=TRUE] =eui['F','FA__P__F',,,'LIAB',,i,];
  ll['F', ,,'S1','LE' ,'_P',,i , usenames=TRUE, onlyna=TRUE] =eui['LE','FA__P__F',,,'L_LE',,i,];
  ll['F3', ,,'S1','F' ,'_P',,i , usenames=TRUE, onlyna=TRUE] =eui['F','FA__P__F3',,,'LIAB',,i,];
  ll['F3', ,,'S1','LE' ,'_P',,i , usenames=TRUE, onlyna=TRUE] =eui['LE','FA__P__F3',,,'L_LE',,i,];
  ll['F3S', ,,'S1','F' ,'_P',,i , usenames=TRUE, onlyna=TRUE] =eui['F','FA__P__F3__S',,,'LIAB',,i,];
  ll['F3S', ,,'S1','LE' ,'_P',,i , usenames=TRUE, onlyna=TRUE] =eui['LE','FA__P__F3__S',,,'L_LE',,i,];
  ll['F3L', ,,'S1','F' ,'_P',,i , usenames=TRUE, onlyna=TRUE] =eui['F','FA__P__F3__L',,,'LIAB',,i,];
  ll['F3L', ,,'S1','LE' ,'_P',,i , usenames=TRUE, onlyna=TRUE] =eui['LE','FA__P__F3__L',,,'L_LE',,i,];
  ll['F51', ,,'S1','F' ,'_P',,i , usenames=TRUE, onlyna=TRUE] =eui['F','FA__P__F51',,,'LIAB',,i,];
  ll['F51', ,,'S1','LE' ,'_P',,i , usenames=TRUE, onlyna=TRUE] =eui['LE','FA__P__F51',,,'L_LE',,i,]
}

ll[F.COMM.S1.S1.LE._T.2023Q4.] 

gc()

saveRDS(aa,file.path(data_dir,'aa_iip_cps.rds'))
saveRDS(ll,file.path(data_dir,'ll_iip_cps.rds'))

saveRDS(aa,file.path(data_dir,'vintages/aa_iip_cps_' %&% format(Sys.time(),'%F') %&% '_.rds'))
saveRDS(ll,file.path(data_dir,'vintages/ll_iip_cps_' %&% format(Sys.time(),'%F') %&% '_.rds'))


##############################################################
####                 CALCULATE TOTAL F2                   ####
####                   BASED ON F21+F2M                   ####
####                                                      ####
##############################################################
<<<<<<< HEAD
# zerofiller=function(x, fillscalar=0){
#   temp=copy(x)
#   temp[onlyna=TRUE]=fillscalar
#   temp
# }
# 
# #zerofiller only used for F21 
# aa[F2.......WRL_REST, usenames=TRUE, onlyna=TRUE] = zerofiller(aa[F21.......WRL_REST])+aa[F2M.......WRL_REST]
# ll[F2.WRL_REST......, usenames=TRUE, onlyna=TRUE] = zerofiller(ll[F21.WRL_REST......])+ll[F2M.WRL_REST......]
=======
#zerofiller=function(x, fillscalar=0){
 # temp=copy(x)
  #temp[onlyna=TRUE]=fillscalar
  #temp
#}

#zerofiller only used for F21
#aa[F2.......WRL_REST, usenames=TRUE, onlyna=TRUE] = zerofiller(aa[F21.......WRL_REST])+aa[F2M.......WRL_REST]
#ll[F2.WRL_REST......, usenames=TRUE, onlyna=TRUE] = zerofiller(ll[F21.WRL_REST......])+ll[F2M.WRL_REST......]
>>>>>>> f55887bf1cfac16c1298286e6e92e55225f65c0d

#gc()
##############################################################
##############################################################


saveRDS(aa,file.path(data_dir,'aa_iip_cps.rds'))
saveRDS(ll,file.path(data_dir,'ll_iip_cps.rds'))

saveRDS(aa,file.path(data_dir,'vintages/aa_iip_cps_' %&% format(Sys.time(),'%F') %&% '_.rds'))
saveRDS(ll,file.path(data_dir,'vintages/ll_iip_cps_' %&% format(Sys.time(),'%F') %&% '_.rds'))

