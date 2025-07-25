library(MDstats); library(MD3)
`%&%` = function (..., collapse = NULL, recycle0 = FALSE)  .Internal(paste0(list(...), collapse, recycle0))

# Set data directory
setwd("V:/FinFlows/githubrepo/trialarea")
data_dir= file.path(getwd(),'data')
if (!exists("data_dir")) data_dir = '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/data/'

# #### EU and EA balance of payments exposure  #### 
# 
# countries=c("EA19","EA20","EU27_2020","EU28")
# sectors=c("S1","S121","s122", "S123", "S12k","S12M","S12T","S13","S1P","S1V","S1N")
# 
# allsecload=function(cc,cpsto='S1.NSA.ASS.',dataflow='bop_eu6_q') {
#   ll=paste0("Estat/",dataflow,"/Q.MIO_EUR..",sectors,".",cpsto,".",cc)
#   message(Sys.timo() , ': loading ',cc,'...')
#   lapply(as.list(ll), \(x) try(mds(x,drop=FALSE),silent=TRUE))
# }
# 
# 
# combineloadedbits = function(loadedbitslist) {
#   resmd3=loadedbitslist[[1]][[1]]
#   for (i in seq_along(loadedbitslist)) {
#     for (j in seq_along(loadedbitslist[[i]])) {
#       message(i,'  ',j)
#       if (!is(loadedbitslist[[i]][[j]],'try-error')) { resmd3=merge(resmd3,loadedbitslist[[i]][[j]])}
#     }
#   }
#   return(resmd3)
# }
# 
# 
# euaout = lapply(as.list(countries),allsecload,cpsto='S1.NSA.ASS.')
# euaba=combineloadedbits(euaout)
# euaba2=drop(euaba)
# 
# save.image('C:/USers/Public/finflowsbuffer/boploadedstuffagg.rda')
# 
# eulout = lapply(as.list(countries), function(x) allsecload(x,cpsto='S1.NSA.LIAB.'))
# eulba=combineloadedbits(eulout)
# eulba2=drop(eulba)
# save.image('C:/USers/Public/finflowsbuffer/boploadedstuffagg.rda')
# 
# iamd3eu=merge(euaba2,eulba2,along='STO',newcodes=c('ASS','LIAB'))
# 
# saveRDS(iamd3eu,file='data/bop_cps_euea.rds')
# 
# gc()

#### bilateral exposure transactions #### 

countries=c("BE","BG","CZ","DK","DE","EE","IE","EL","ES","FR","HR","IT","CY","LV","LT","LU","HU","MT","NL","AT","PL","PT","RO","SI","SK","FI","SE")
sectors=c("S1","S121","S123","S12M","S12R","S12T","S13","S1P","S1V","S1Z")

allsecload=function(cc,cpsto='S1.ASS.',dataflow='bop_c6_q') {
  ll=paste0("Estat/",dataflow,"/Q.MIO_EUR..",sectors,".",cpsto,".",cc)
  message(Sys.timo() , ': loading ',cc,'...')
  lapply(as.list(ll), \(x) try(mds(x,drop=FALSE),silent=TRUE))
}


combineloadedbits = function(loadedbitslist) {
  resmd3=loadedbitslist[[1]][[1]]
  for (i in seq_along(loadedbitslist)) {
    for (j in seq_along(loadedbitslist[[i]])) {
      message(i,'  ',j)
      if (!is(loadedbitslist[[i]][[j]],'try-error')) { resmd3=merge(resmd3,loadedbitslist[[i]][[j]])}
    }
  }
  return(resmd3)
}


aout = lapply(as.list(countries),allsecload,cpsto='S1.ASS.')
aba=combineloadedbits(aout)
aba2=drop(aba)

save.image('C:/USers/Public/finflowsbuffer/boploadedstuff.rda')

lout = lapply(as.list(countries), function(x) allsecload(x,cpsto='S1.LIAB.'))
lba=combineloadedbits(lout)
lba2=drop(lba)
save.image('C:/USers/Public/finflowsbuffer/boploadedstuff.rda')

iamd3=merge(aba2,lba2,along='STO',newcodes=c('ASS','LIAB'))

saveRDS(iamd3,file='data/bop_cps.rds')

gc()

#### annual bilateral exposure stocks #### 
countries=c("EA19","EA20","EU27_2020","EU28","BE","BG","CZ","DK","DE","EE","IE","EL","ES","FR","HR","IT","CY","LV","LT","LU","HU","MT","NL","AT","PL","PT","RO","SI","SK","FI","SE")
sectors=c("S1","S11","S121","S12T","S12K", "S13", "S124", "S12O", "S12Q", "S12M", "S1M")

allsecload=function(cc,cpsto='S1.A_LE',dataflow='bop_iip6_q') {
  ll=paste0("Estat/",dataflow,"/A.MIO_EUR..",sectors,".",cpsto,"..",cc)
  message(Sys.timo() , ': loading ',cc,'...')
  lapply(as.list(ll), \(x) try(mds(x,drop=FALSE),silent=TRUE))
}


combineloadedbits = function(loadedbitslist) {
  resmd3=loadedbitslist[[1]][[1]]
  for (i in seq_along(loadedbitslist)) {
    for (j in seq_along(loadedbitslist[[i]])) {
      message(i,'  ',j)
      if (!is(loadedbitslist[[i]][[j]],'try-error')) { resmd3=merge(resmd3,loadedbitslist[[i]][[j]])}
    }
  }
  return(resmd3)
}


aout = lapply(as.list(countries),allsecload,cpsto='S1.A_LE')
aaia=combineloadedbits(aout)
aaia2=drop(aaia)

save.image('C:/USers/Public/finflowsbuffer/bopiiploadedstuff.rda')

lout = lapply(as.list(countries), function(x) allsecload(x,cpsto='S1.L_LE'))
llia=combineloadedbits(lout)
llia2=drop(llia)
save.image('C:/USers/Public/finflowsbuffer/bopiiploadedstuff.rda')

iamd3=merge(aaia2,llia2,along='STO',newcodes=c('A_LE','L_LE'))

saveRDS(iamd3,file='data/iip_cps_annual.rds')


#### quarterly bilateral exposure stocks #### 
countries=c("EA19","EA20","EU27_2020","EU28","BE","BG","CZ","DK","DE","EE","IE","EL","ES","FR","HR","IT","CY","LV","LT","LU","HU","MT","NL","AT","PL","PT","RO","SI","SK","FI","SE")
sectors=c("S1","S11","S121","S12T","S12K", "S13", "S124", "S12O", "S12Q", "S12M", "S1M")

allsecload=function(cc,cpsto='S1.A_LE',dataflow='bop_iip6_q') {
  ll=paste0("Estat/",dataflow,"/Q.MIO_EUR..",sectors,".",cpsto,"..",cc)
  message(Sys.timo() , ': loading ',cc,'...')
  lapply(as.list(ll), \(x) try(mds(x,drop=FALSE),silent=TRUE))
}


combineloadedbits = function(loadedbitslist) {
  resmd3=loadedbitslist[[1]][[1]]
  for (i in seq_along(loadedbitslist)) {
    for (j in seq_along(loadedbitslist[[i]])) {
      message(i,'  ',j)
      if (!is(loadedbitslist[[i]][[j]],'try-error')) { resmd3=merge(resmd3,loadedbitslist[[i]][[j]])}
    }
  }
  return(resmd3)
}


aout = lapply(as.list(countries),allsecload,cpsto='S1.A_LE')
aia=combineloadedbits(aout)
aia2=drop(aia)

save.image('C:/USers/Public/finflowsbuffer/bopiiploadedstuff.rda')

lout = lapply(as.list(countries), function(x) allsecload(x,cpsto='S1.L_LE'))
lia=combineloadedbits(lout)
lia2=drop(lia)
save.image('C:/USers/Public/finflowsbuffer/bopiiploadedstuff.rda')

iamd3=merge(aia2,lia2,along='STO',newcodes=c('A_LE','L_LE'))

saveRDS(iamd3,file='data/iip_cps.rds')




#### Balance of payments of the EU institutions - quarterly data #### 

euibopraw=mds('ESTAT/bop_euins6_q/Q.EUR....ASS..COMM', ccode = NULL)


countries=c("COMM","EDF","EIB","EUI_X_EAI")
sectors=c("S1", "S13","S12M")

allsecload=function(cc,cpsto='ASS',dataflow='bop_euins6_q') {
  ll=paste0("Estat/",dataflow,"/Q.EUR..",sectors,"..",cpsto,"..",cc)
  message(Sys.timo() , ': loading ',cc,'...')
  lapply(as.list(ll), \(x) try(mds(x,drop=FALSE),silent=TRUE))
}


combineloadedbits = function(loadedbitslist) {
  resmd3=loadedbitslist[[1]][[1]]
  for (i in seq_along(loadedbitslist)) {
    for (j in seq_along(loadedbitslist[[i]])) {
      message(i,'  ',j)
      if (!is(loadedbitslist[[i]][[j]],'try-error')) { resmd3=merge(resmd3,loadedbitslist[[i]][[j]])}
    }
  }
  return(resmd3)
}


euiaout = lapply(as.list(countries),allsecload,cpsto='ASS')
euiaaia=combineloadedbits(euiaout)
euiaaia2=drop(euiaaia)

save.image('C:/USers/Public/finflowsbuffer/euibopiiploadedstuff.rda')

euilout = lapply(as.list(countries), function(x) allsecload(x,cpsto='LIAB'))
euillia=combineloadedbits(euilout)
euillia2=drop(euillia)
save.image('C:/USers/Public/finflowsbuffer/uibopiiploadedstuff.rda')

euiiamd3=merge(euiaaia2,euillia2,along='STO',newcodes=c('ASS','LIAB'))

saveRDS(euiiamd3,file='data/bop_eui.rds')
eui=readRDS(file.path(data_dir,'bop_eui.rds'))
