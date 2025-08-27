library(MDstats); library(MD3)

# Set data directory
#data_dir= file.path(getwd(),'data')
if (!exists("data_dir")) data_dir = '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/data/'

#### EU and EA balance of payments exposure  ####

countries=c("EA19","EA20","EU27_2020","EU28")
sectors=c("S1","S121","S122", "S123", "S12K","S12M","S12T","S13","S1P","S1V","S1N","S11","S124","S12Q","S1M")

allsecload=function(countries,cpsto='S1.NSA.ASS.',dataflow='bop_eu6_q') {
  ll=paste0("Estat/",dataflow,"/Q.MIO_EUR..",sectors,".",cpsto,".",countries)
  message(Sys.timo() , ': loading ',countries,'...')
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


euaout = lapply(as.list(countries),allsecload,cpsto='S1.NSA.ASS.')
euaba=combineloadedbits(euaout)
euaba2=drop(euaba)

save.image('C:/USers/Public/finflowsbuffer/boploadedstuffagg.rda')

eulout = lapply(as.list(countries), function(x) allsecload(x,cpsto='S1.NSA.LIAB.'))
eulba=combineloadedbits(eulout)
eulba2=drop(eulba)
save.image('C:/USers/Public/finflowsbuffer/boploadedstuffagg.rda')

iamd3eu=merge(euaba2,eulba2,along='STO',newcodes=c('ASS','LIAB'))

saveRDS(iamd3eu,file='data/bop_cps_euea.rds')

gc()

#### Balance of payments + IIP of the EU institutions - quarterly data #### 

#euibopraw=MDstats:::.mdEstat('Estat/bop_euins6_q'); gc()
euibopraw=mds('Estat/bop_euins6_q'); gc()
dim(euibopraw)
saveRDS(euibopraw,file='data/bop_eui.rds')

euiiipraw=MDstats:::.mdEstat('Estat/bop_euins6_iip'); gc()
dim(euiiipraw)
saveRDS(euiiipraw,file='data/iip_eui.rds')

#### bilateral exposure transactions #### 

countries=c("BE","BG","CZ","DK","DE","EE","IE","EL","ES","FR","HR","IT","CY","LV","LT","LU","HU","MT","NL","AT","PL","PT","RO","SI","SK","FI","SE")
sectors=c("S1","S121","S122","S123","S12T","S13","S1P","S1V")

allsecload=function(countries,cpsto='S1.ASS',dataflow='bop_c6_q') {
  ll=paste0("Estat/",dataflow,"/Q.MIO_EUR..",sectors,".",cpsto,"..",countries)
  message(Sys.timo() , ': loading ',countries,'...')
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


aout = lapply(as.list(countries),allsecload,cpsto='S1.ASS')
aia=combineloadedbits(aout)
aia2=drop(aia)

save.image('C:/USers/Public/finflowsbuffer/bopiiploadedstuff.rda')

lout = lapply(as.list(countries), function(x) allsecload(x,cpsto='S1.LIAB'))
lia=combineloadedbits(lout)
lia2=drop(lia)
save.image('C:/USers/Public/finflowsbuffer/bopiiploadedstuff.rda')

iamd3=merge(aia2,lia2,along='STO',newcodes=c('ASS','LIAB'))

saveRDS(iamd3,file='data/bop_cps.rds')


gc()

#### annual bilateral exposure stocks #### 
countries=c("EA19","EA20","EU27_2020","EU28","BE","BG","CZ","DK","DE","EE","IE","EL","ES","FR","HR","IT","CY","LV","LT","LU","HU","MT","NL","AT","PL","PT","RO","SI","SK","FI","SE")
sectors=c("S1","S11","S121","S12T","S12K", "S13", "S124", "S12O", "S12Q", "S12M", "S1M")

allsecload=function(countries,cpsto='S1.A_LE',dataflow='bop_iip6_q') {
  ll=paste0("Estat/",dataflow,"/A.MIO_EUR..",sectors,".",cpsto,"..",countries)
  message(Sys.timo() , ': loading ',countries,'...')
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

allsecload=function(countries,cpsto='S1.A_LE',dataflow='bop_iip6_q') {
  ll=paste0("Estat/",dataflow,"/Q.MIO_EUR..",sectors,".",cpsto,"..",countries)
  message(Sys.timo() , ': loading ',countries,'...')
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


