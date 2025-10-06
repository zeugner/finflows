#source('https://s-ecfin-web.net1.cec.eu.int/directorates/db/u1/R/routines/installMDecfin.txt')


library(MDecfin)
#setwd('U:/Topics/Spillovers_and_EA/flowoffunds/finflows2024/gitcodedata')


aall=readRDS('data/aall.rds')

#dimcodes(aall)

#####example AUSTRIA#####

#whom to whom with F
aall[.AT..S1M.LE._T.y2022q4]
aall[F.AT...LE.FND.y2022q4]


#####fill blanks assets#####
#!todo: include a check if S0 is zero also  check if S1 is zero or NA (should be not filled)
#!todo: if not S12K or S13 sectors are filled when FI = F21+F2M (should be not filled)
#!todo: check if they are NA or not filled or zero before filling with 0 (rule 3+2) (should be not filled)
### rule 1: if S0 assets = 0, then all counterpart sectors =0
aall[....LE._T. ][aall[...S0.LE._T.]==0, onlyna=TRUE] = 0
aall[.AT.S12K..LE._T.2023q4 ]

### rule 2: deposits if counterpart is not S12K or S13, then 0 (non-bank/non-govt sectors cannot have F2M+F21 as liabilities)
aall[F2M+F21...S1M+S11+S12O+S12Q+S124.LE._T.] = 0
aall[F2M.DE.S12K..LE._T.2023q1]

### rule 3: S1M liabilities (logic: S1m does not have F511+F52 equity and no F60 liabilities)
aall[F511+F52+F6O...S1M.LE._T.] = 0
aall[.AT+DE+IT.S0.S1M.LE._T.2023q4]

### rule 4: F52 (logic: F52 liabilities only for S124 and RoW)
aall[F52.AT...LE._T.2023q4 ]
aall[F52..S0.S1.LE._T.y2022q4]-rowSums(aall[F52..S0.S124+S12K.LE._T.y2022q4])
aall[F52...S11+S12O+S12Q+S13+S1M.LE._T.] = 0

test=aall[F52.AT...LE._T.2023q4 ]
aall[F52.AT...LE._T.2023q4 ]

aall[F52...S12T.._T.] = aall[F52...S12K.._T.]
tempix= aall[F52..S1.S1.LE._T.]==apply(aall[F52..S1.S124+S12K.LE._T.],c(1,3),sum)


aall[.AT.S12K..LE._T.2023q4 ]
aall[.AT..S12K.LE._T.2023q4 ]

### Assets S121+s122 vis-a-vis counterpart_sectors per FI
aall[.AT.S12K..LE._T.y2022q4]


### Liabilities S121+s122 vis-a-vis counterpart_sectors per FI
aall[.AT..S12K.LE._T.y2022q4]



