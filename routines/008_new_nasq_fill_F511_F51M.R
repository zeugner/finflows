library(MDecfin)

names(dimnames(aa511))[[2]] = 'REF_AREA'
names(dimnames(aa511))[[3]] = 'REF_SECTOR'

names(dimnames(aa51M))[[2]] = 'REF_AREA'
names(dimnames(aa51M))[[3]] = 'REF_SECTOR'

names(dimnames(aa511t))[[2]] = 'REF_AREA'
names(dimnames(aa511t))[[3]] = 'REF_SECTOR'

names(dimnames(aa51Mt))[[2]] = 'REF_AREA'
names(dimnames(aa51Mt))[[3]] = 'REF_SECTOR'

#function to fill nas
zerofiller=function(x, fillscalar=0){
  temp=copy(x)
  temp[onlyna=TRUE]=fillscalar
  temp
}

#check
aall[F511.AT...LE._T.2022q4]
aall[F511.AT...F._T.2022q4]


#ASSETS FILLING FOR F511 STOCKS
aall[F511..S1.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S1."])
aall[F511..S11.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S11."])
aall[F511..S1.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S1."])
aall[F511..S12.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S12."])
aall[F511..S12K.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S121_S122_S123."])
aall[F511..S124.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S124."])
aall[F511..S125.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S125."])
aall[F511..S12O.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S125_S126_S127."])
aall[F511..S126.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S126."])
aall[F511..S127.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S127."])
aall[F511..S128.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S128."])
aall[F511..S129.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S129."])
aall[F511..S13.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S13."])
aall[F511..S14.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S14."])
aall[F511..S15.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S15."])
aall[F511..S1M.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S14_S15."])
aall[F511..S2.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S2."])
aall[F511..S12Q.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S128."]) + zerofiller(aa511["ASS..S129."])
aall[F511..S12R.S0.LE._T.]= aall[F511..S124.S0.LE._T.] + aall[F511..S12O.S0.LE._T.] + aall[F511..S12Q.S0.LE._T.]

#LIABILITIES FILLING FOR F511 STOCKS
aall[F511..S0.S1.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S1."])
aall[F511..S0.S11.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S11."])
aall[F511..S0.S1.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S1."])
aall[F511..S0.S12.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S12."])
aall[F511..S0.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S121_S122_S123."])
aall[F511..S0.S124.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S124."])
aall[F511..S0.S125.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S125."])
aall[F511..S0.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S125_S126_S127."])
aall[F511..S0.S126.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S126."])
aall[F511..S0.S127.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S127."])
aall[F511..S0.S128.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S128."])
aall[F511..S0.S129.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S129."])
aall[F511..S0.S13.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S13."])
aall[F511..S0.S14.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S14."])
aall[F511..S0.S15.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S15."])
aall[F511..S0.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S14_S15."])
aall[F511..S0.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S2."])
aall[F511..S0.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S128."]) + zerofiller(aa511["LIAB..S129."])
aall[F511..S0.S12R.LE._T.]= aall[F511..S0.S124.LE._T.] + aall[F511..S0.S12O.LE._T.] + aall[F511..S0.S12Q.LE._T.]

#ASSETS FILLING FOR F511 FLOWS
aall[F511..S1.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S1."])
aall[F511..S11.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S11."])
aall[F511..S1.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S1."])
aall[F511..S12.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S12."])
aall[F511..S12K.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S121_S122_S123."])
aall[F511..S124.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S124."])
aall[F511..S125.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S125."])
aall[F511..S12O.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S125_S126_S127."])
aall[F511..S126.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S126."])
aall[F511..S127.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S127."])
aall[F511..S128.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S128."])
aall[F511..S129.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S129."])
aall[F511..S13.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S13."])
aall[F511..S14.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S14."])
aall[F511..S15.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S15."])
aall[F511..S1M.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S14_S15."])
aall[F511..S2.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S2."])
aall[F511..S12Q.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S128."]) + zerofiller(aa511t["ASS..S129."])
aall[F511..S12R.S0.F._T.]= aall[F511..S124.S0.F._T.] + aall[F511..S12O.S0.F._T.] + aall[F511..S12Q.S0.F._T.]

#LIABILITIES FILLING FOR F511 FLOWS
aall[F511..S0.S1.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S1."])
aall[F511..S0.S11.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S11."])
aall[F511..S0.S1.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S1."])
aall[F511..S0.S12.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S12."])
aall[F511..S0.S12K.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S121_S122_S123."])
aall[F511..S0.S124.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S124."])
aall[F511..S0.S125.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S125."])
aall[F511..S0.S12O.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S125_S126_S127."])
aall[F511..S0.S126.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S126."])
aall[F511..S0.S127.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S127."])
aall[F511..S0.S128.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S128."])
aall[F511..S0.S129.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S129."])
aall[F511..S0.S13.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S13."])
aall[F511..S0.S14.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S14."])
aall[F511..S0.S15.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S15."])
aall[F511..S0.S1M.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S14_S15."])
aall[F511..S0.S2.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S2."])
aall[F511..S0.S12Q.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S128."]) + zerofiller(aa511t["LIAB..S129."])
aall[F511..S0.S12R.F._T.]= aall[F511..S0.S124.F._T.] + aall[F511..S0.S12O.F._T.] + aall[F511..S0.S12Q.F._T.]


#ASSETS FILLING FOR F51M STOCKS
aall[F51M..S1.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S1."])
aall[F51M..S11.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S11."])
aall[F51M..S1.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S1."])
aall[F51M..S12.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S12."])
aall[F51M..S12K.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S121_S122_S123."])
aall[F51M..S124.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S124."])
aall[F51M..S125.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S125."])
aall[F51M..S12O.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S125_S126_S127."])
aall[F51M..S126.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S126."])
aall[F51M..S127.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S127."])
aall[F51M..S128.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S128."])
aall[F51M..S129.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S129."])
aall[F51M..S13.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S13."])
aall[F51M..S14.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S14."])
aall[F51M..S15.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S15."])
aall[F51M..S1M.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S14_S15."])
aall[F51M..S2.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S2."])
aall[F51M..S12Q.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S128."]) + zerofiller(aa511["ASS..S129."])
aall[F51M..S12R.S0.LE._T.]= aall[F51M..S124.S0.LE._T.] + aall[F51M..S12O.S0.LE._T.] + aall[F51M..S12Q.S0.LE._T.]

#LIABILITIES FILLING FOR F51M STOCKS
aall[F51M..S0.S1.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S1."])
aall[F51M..S0.S11.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S11."])
aall[F51M..S0.S1.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S1."])
aall[F51M..S0.S12.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S12."])
aall[F51M..S0.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S121_S122_S123."])
aall[F51M..S0.S124.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S124."])
aall[F51M..S0.S125.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S125."])
aall[F51M..S0.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S125_S126_S127."])
aall[F51M..S0.S126.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S126."])
aall[F51M..S0.S127.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S127."])
aall[F51M..S0.S128.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S128."])
aall[F51M..S0.S129.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S129."])
aall[F51M..S0.S13.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S13."])
aall[F51M..S0.S14.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S14."])
aall[F51M..S0.S15.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S15."])
aall[F51M..S0.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S14_S15."])
aall[F51M..S0.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S2."])
aall[F51M..S0.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["LIAB..S128."]) + zerofiller(aa511["LIAB..S129."])
aall[F51M..S0.S12R.LE._T.]= aall[F51M..S0.S124.LE._T.] + aall[F51M..S0.S12O.LE._T.] + aall[F51M..S0.S12Q.LE._T.]

#ASSETS FILLING FOR F51M FLOWS
aall[F51M..S1.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S1."])
aall[F51M..S11.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S11."])
aall[F51M..S1.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S1."])
aall[F51M..S12.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S12."])
aall[F51M..S12K.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S121_S122_S123."])
aall[F51M..S124.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S124."])
aall[F51M..S125.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S125."])
aall[F51M..S12O.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S125_S126_S127."])
aall[F51M..S126.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S126."])
aall[F51M..S127.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S127."])
aall[F51M..S128.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S128."])
aall[F51M..S129.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S129."])
aall[F51M..S13.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S13."])
aall[F51M..S14.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S14."])
aall[F51M..S15.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S15."])
aall[F51M..S1M.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S14_S15."])
aall[F51M..S2.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S2."])
aall[F51M..S12Q.S0.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["ASS..S128."]) + zerofiller(aa511t["ASS..S129."])
aall[F51M..S12R.S0.F._T.]= aall[F51M..S124.S0.F._T.] + aall[F51M..S12O.S0.F._T.] + aall[F51M..S12Q.S0.F._T.]

#LIABILITIES FILLING FOR F51M FLOWS
aall[F51M..S0.S1.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S1."])
aall[F51M..S0.S11.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S11."])
aall[F51M..S0.S1.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S1."])
aall[F51M..S0.S12.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S12."])
aall[F51M..S0.S12K.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S121_S122_S123."])
aall[F51M..S0.S124.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S124."])
aall[F51M..S0.S125.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S125."])
aall[F51M..S0.S12O.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S125_S126_S127."])
aall[F51M..S0.S126.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S126."])
aall[F51M..S0.S127.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S127."])
aall[F51M..S0.S128.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S128."])
aall[F51M..S0.S129.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S129."])
aall[F51M..S0.S13.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S13."])
aall[F51M..S0.S14.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S14."])
aall[F51M..S0.S15.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S15."])
aall[F51M..S0.S1M.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S14_S15."])
aall[F51M..S0.S2.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S2."])
aall[F51M..S0.S12Q.F._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511t["LIAB..S128."]) + zerofiller(aa511t["LIAB..S129."])
aall[F51M..S0.S12R.F._T.]= aall[F51M..S0.S124.F._T.] + aall[F51M..S0.S12O.F._T.] + aall[F51M..S0.S12Q.F._T.]

aall[F51M..S1.S0.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aa511["ASS..S1."])




#check
aall[F511.AT..S0.LE._T.2022q4]
aall[F51.AT..S0.LE._T.2022q4]
aall[F51M.AT..S0.LE._T.2022q4]

aall[F51....._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aall["F51M....._T."])+zerofiller(aall["F511....._T."])


gc()
