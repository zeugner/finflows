#source('https://s-ecfin-web.net1.cec.eu.int/directorates/db/u1/R/routines/installMDecfin.txt')


library(MDecfin)
#setwd('U:/Topics/Spillovers_and_EA/flowoffunds/finflows2024/gitcodedata')


aall=readRDS('data/aall.rds')

#dimcodes(aall)


######### plausibility checks of data to assure consistency ######### 

####secotral checks
## @ Erza: implement for the abs check a level - currently hard coded at 0.01 

#### ASSETS S1 = S11+S1M+S12K+S13+S12O+S12Q+S124+S13
#!todo: how to handle time (quarter/years) +   
check1=aall[F..S1.S0.LE._T.2023q4]-rowSums(aall[F..S11+S1M+S12K+S12O+S12Q+S124+S13.S0.LE._T.2023q4])
see_check1 <- check1[abs(check1) > 0.01]

##instead of having array with fifelse(abs(check1)>0.01,yes='nok',no='ok',na=NA)

#### LIAB S1 = S11+S1M+S12K+S13+S12O+S12Q+S124+S13
#!todo: how to handle time (quarter/years) +   
check2=aall[F..S0.S1.LE._T.2023q4]-rowSums(aall[F..S0.S11+S1M+S12K+S12O+S12Q+S124+S13.LE._T.2023q4])
#!todo: implement to check only if abs value is >0.00
fifelse(abs(check2)>0.01,yes='nok',no='ok',na=NA)

#if not S12K or S13 sectors are filled when FI = F21+F2M (should be not filled)
#!todo: how to handle time (quarter/years) + 
check3a=aall[F21..S0.S1.LE._T.2023q4]-rowSums(aall[F21..S0.S13+S12K.LE._T.2023q4])
#!todo: implement to check only if abs value is >0.00
fifelse(abs(check3a)>0.01,yes='nok',no='ok',na=NA)
#!todo: how to handle time (quarter/years) + 
check3b=aall[F2M..S0.S1.LE._T.2023q4]-rowSums(aall[F2M..S0.S13+S12K.LE._T.2023q4])
#!todo: implement to check only if abs value is >0.00
fifelse(abs(check3b)>0.01,yes='nok',no='ok',na=NA)

#!todo open: include a check if S0 is zero also  check if S1 is zero or NA (should be not filled)
#!todo: how to handle time (quarter/years) + 
check4=aall[.AT.S1..LE._T.2023q4]-rowSums(aall[F21..S0.S13+S12K.LE._T.2023q4])
fifelse(check4>0,yes='ok',no='nok',na=NA) 



####financial instruments checks
#!todo: @ Stefano check for assets and liabilities if F=F21+F2M+F3+F4+F51+F52+F6+F7+F81+F89
#!todo: @ Stefano check for assets and liabilities if F3=F3S+F3L
#!todo: @ Stefano check for assets and liabilities if F4=F4S+F4L
#!todo: @ Stefano check for assets and liabilities if F51=F511+F51M
#!todo: @ Stefano check for assets and liabilities if F6=F6N+F6O


#!todo: check if they are NA or not filled or zero before filling with 0 (rule 3+2) (should be not filled)