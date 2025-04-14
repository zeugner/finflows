library(MDstats); library(MD3)

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

#### bilateral exposure stocks #### 
countries=c("BE","BG","CZ","DK","DE","EE","IE","EL","ES","FR","HR","IT","CY","LV","LT","LU","HU","MT","NL","AT","PL","PT","RO","SI","SK","FI","SE")
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

