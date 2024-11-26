#source('https://s-ecfin-web.net1.cec.eu.int/directorates/db/u1/R/routines/installMDecfin.txt')


library(MDecfin)
#setwd('U:/Topics/Spillovers_and_EA/flowoffunds/finflows2024/gitcodedata')


aall=readRDS('data/aall.rds')

#dimcodes(aall)


######### plausibility checks of data to assure consistency ######### 

#!todo: if not S12K or S13 sectors are filled when FI = F21+F2M (should be not filled)

aall[!(is.na(aall[F2M+F21...S1M+S11+S12O+S12Q+S124.LE._T.]))]>0

result_nok <- aall[F2M+F21...S1M+S11+S12O+S12Q+S124.LE._T.]>0



#!todo: include a check if S0 is zero also  check if S1 is zero or NA (should be not filled)
fifelse(aall[..S0.S1.LE._T.2023q4]>0,yes='ok',no='nok',na=NA)
aall[.AT.S1..LE._T.2023q4]
#!todo: if not S12K or S13 sectors are filled when FI = F21+F2M (should be not filled)
#!todo: check if they are NA or not filled or zero before filling with 0 (rule 3+2) (should be not filled)