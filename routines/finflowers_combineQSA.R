#source('https://s-ecfin-web.net1.cec.eu.int/directorates/db/u1/R/routines/installMDecfin.txt')


library(MDecfin)
setwd('U:/Topics/Spillovers_and_EA/flowoffunds/finflows2024/codealpha')

lll=readRDS('data/fflist.rds')


#dim(lll$A$F511)
#lapply(lll$L, \(x) {names(dim(x)) })
sss=unique(unlist(lapply(lll$A, \(x) {dimnames(x)$REF_SECTOR })))

lll$Ladj = lll$L
lll$Ladj$F2M= lll$Ladj$F2M[.W0...]
lll$Ladj = lapply(lll$Ladj, \(x) {names(dimnames(x))[2L]='COUNTERPART_SECTOR'; x})

#dim(lll$L$F511)

aall=copy(add.dim(lll$A$F511[.W2.....],.dimname = 'INSTR', .dimcodes = 'F511'))
aall['F511',,,'S0',,,] = lll$A$F511[.W0..S1...]
aall['F511',,'S0',,,,] = lll$Ladj$F511
aall[,,setdiff(sss,dimnames(aall)$REF_SECTOR),,,,]=NA

aaraw=copy(aall); #aall=aaraw
aall['F52',,,,,'_T',]  =NA
#aall['F52',,'S124',,,'_T',]  = lll$A$F52[.W2.S124...]
aall['F52',,,,,'_T',]  = lll$A$F52[.W2....]
aall['F52',,,'S0',,'_T',] = lll$A$F52[.W0..S1..]
aall['F52',,'S0',,,'_T',] = lll$Ladj$F52


aaraw=copy(aall); #aall=aaraw
aall['F2M',,,,,,]  =NA
aall['F2M',,,,,,]  = lll$A$F2M[.W2.....]
aall['F2M',,,'S12K',,,]  = lll$L$F2M[.W2...]
aall['F2M',,,'S0',,,] = lll$A$F2M[.W0..S1...]
aall['F2M',,'S0',,'F','_T',] = lll$Ladj$F2M[..F.]
aall['F2M',,'S0',,'LE','_T',] = lll$Ladj$F2M[..LE.]


aaraw=copy(aall); #aall=aaraw
aall['F4',,,,,,]  =NA
aall['F4',,,,,,]  = lll$A$F4[.W2....T..]
aall['F4',,,'S0',,,] = lll$A$F4[.W0..S1..T..]
aall['F4',,'S0',,,,] = lll$Ladj$F4[...T..]

aall['F4S',,,,,,]  = lll$A$F4[.W2....S..]
aall['F4S',,,'S0',,,] = lll$A$F4[.W0..S1..S..]
aall['F4S',,'S0',,,,] = lll$Ladj$F4[...S..]

aall['F4L',,,,,,]  = lll$A$F4[.W2....L..]
aall['F4L',,,'S0',,,] = lll$A$F4[.W0..S1..L..]
aall['F4L',,'S0',,,,] = lll$Ladj$F4[...L..]

aall['F3+F3S+F3L',,,,,,] = NA

aall['F3',,,,,,]  = lll$A$F3[.W2....T..]
aall['F3',,,'S0',,,]  = lll$A$F3[.W0..S1..T..]
aall['F3',,'S0',   ,,,]  = lll$Ladj$F3[...T..]



aall['F3S',,,,,,]  = lll$A$F3[.W2....S..]
aall['F3S',,,'S0',,,]  = lll$A$F3[.W0..S1..S..]
aall['F3S',,'S0',   ,,,]  = lll$Ladj$F3[...S..]
aall['F3L',,,,,,]  = lll$A$F3[.W2....L..]
aall['F3L',,,'S0',,,]  = lll$A$F3[.W0..S1..L..]
aall['F3L',,'S0',   ,,,]  = lll$Ladj$F3[...L..]


aall['F21',,,,,,]=NA
aall['F21',,,'S0',,'_T',] = lll$A$F21
aall['F21',,'S0',,,'_T',] = lll$Ladj$F21

irest=setdiff(names(lll$A), dimnames(aall)[[1]])


for (i in irest) {
  message(' doing ',i, '  ...')
  aall[i,,,,,,]=NA  
  aall[i,,,'S0',,,]=lll$A[[i]][]
  if ('CUST_BREAKDOWN' %in% names(dim(lll$Ladj[[i]]))) {
    aall[i,,'S0',,,,]=lll$Ladj[[i]]
  } else {
    aall[i,,'S0',,,'_T',]=lll$Ladj[[i]]
  }
}



xx=lll$F2MLW2
names(dimnames(xx))[2:3] = c('a','b')
names(dimnames(xx))[2:3] = names(dimnames(aall))[4:3]

aall['F2M',,,,,'_T',,usenames=TRUE, justval=TRUE] = xx




#aall[.AT.S11..LE._T.y2022q4]
#aall[F511...S12K.LE._T.y2022q4]
#aall[F2M.AT...LE._T.y2022q4]




saveRDS(aall,'data/aallraw.rds')
saveRDS(aall,'data/aall.rds')







