
aa5 = readRDS("data/aa5.rds")
aa511 = aa5$aa511[....]
aa51M = aa5$aa51M[....]
aa511t = aa5$aa511t[....]
aa51Mt = aa5$aa51Mt[....]

names(dimnames(aa511))[[2]] = 'REF_AREA'
names(dimnames(aa511))[[3]] = 'REF_SECTOR'

names(dimnames(aa51M))[[2]] = 'REF_AREA'
names(dimnames(aa51M))[[3]] = 'REF_SECTOR'

names(dimnames(aa511t))[[2]] = 'REF_AREA'
names(dimnames(aa511t))[[3]] = 'REF_SECTOR'

names(dimnames(aa51Mt))[[2]] = 'REF_AREA'
names(dimnames(aa51Mt))[[3]] = 'REF_SECTOR'



aall=readRDS(file.path(data_dir,'aall3.rds'))
setkey(aall, NULL)


#check
aall[F511.AT...LE._T.2022q4]
aall[F511.AT...F._T.2022q4]



#ASSETS FILLING FOR F511 STOCKS
aall[F511..S1.S0.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["ASS..S1.1999q4:"]
aall[F511..S11.S0.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["ASS..S11.1999q4:"]
aall[F511..S1.S0.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["ASS..S1.1999q4:"]
aall[F511..S12.S0.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["ASS..S12.1999q4:"]
aall[F511..S12K.S0.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["ASS..S121_S122_S123.1999q4:"]
aall[F511..S124.S0.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["ASS..S124.1999q4:"]
aall[F511..S125.S0.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["ASS..S125.1999q4:"]
aall[F511..S12O.S0.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["ASS..S125_S126_S127.1999q4:"]
aall[F511..S126.S0.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["ASS..S126.1999q4:"]
aall[F511..S127.S0.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["ASS..S127.1999q4:"]
aall[F511..S128.S0.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["ASS..S128.1999q4:"]
aall[F511..S129.S0.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["ASS..S129.1999q4:"]
aall[F511..S13.S0.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["ASS..S13.1999q4:"]
aall[F511..S14.S0.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["ASS..S14.1999q4:"]
aall[F511..S15.S0.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["ASS..S15.1999q4:"]
aall[F511..S1M.S0.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["ASS..S14_S15.1999q4:"]
aall[F511..S2.S0.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["ASS..S2.1999q4:"]
aall[F511..S12Q.S0.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["ASS..S128.1999q4:"] + aa511["ASS..S129.1999q4:"]
aall[F511..S12R.S0.LE._T.]= aall[F511..S124.S0.LE._T.] + aall[F511..S12O.S0.LE._T.] + aall[F511..S12Q.S0.LE._T.]

#LIABILITIES FILLING FOR F511 STOCKS
aall[F511..S0.S1.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["LIAB..S1.1999q4:"]
aall[F511..S0.S11.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["LIAB..S11.1999q4:"]
aall[F511..S0.S1.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["LIAB..S1.1999q4:"]
aall[F511..S0.S12.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["LIAB..S12.1999q4:"]
aall[F511..S0.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["LIAB..S121_S122_S123.1999q4:"]
aall[F511..S0.S124.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["LIAB..S124.1999q4:"]
aall[F511..S0.S125.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["LIAB..S125.1999q4:"]
aall[F511..S0.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["LIAB..S125_S126_S127.1999q4:"]
aall[F511..S0.S126.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["LIAB..S126.1999q4:"]
aall[F511..S0.S127.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["LIAB..S127.1999q4:"]
aall[F511..S0.S128.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["LIAB..S128.1999q4:"]
aall[F511..S0.S129.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["LIAB..S129.1999q4:"]
aall[F511..S0.S13.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["LIAB..S13.1999q4:"]
aall[F511..S0.S14.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["LIAB..S14.1999q4:"]
aall[F511..S0.S15.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["LIAB..S15.1999q4:"]
aall[F511..S0.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["LIAB..S14_S15.1999q4:"]
aall[F511..S0.S2.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["LIAB..S2.1999q4:"]
aall[F511..S0.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = aa511["LIAB..S128.1999q4:"] + aa511["LIAB..S129.1999q4:"]
aall[F511..S0.S12R.LE._T.]= aall[F511..S0.S124.LE._T.] + aall[F511..S0.S12O.LE._T.] + aall[F511..S0.S12Q.LE._T.]

#ASSETS FILLING FOR F511 FLOWS
aall[F511..S1.S0.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["ASS..S1.1999q4:"]
aall[F511..S11.S0.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["ASS..S11.1999q4:"]
aall[F511..S1.S0.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["ASS..S1.1999q4:"]
aall[F511..S12.S0.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["ASS..S12.1999q4:"]
aall[F511..S12K.S0.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["ASS..S121_S122_S123.1999q4:"]
aall[F511..S124.S0.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["ASS..S124.1999q4:"]
aall[F511..S125.S0.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["ASS..S125.1999q4:"]
aall[F511..S12O.S0.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["ASS..S125_S126_S127.1999q4:"]
aall[F511..S126.S0.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["ASS..S126.1999q4:"]
aall[F511..S127.S0.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["ASS..S127.1999q4:"]
aall[F511..S128.S0.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["ASS..S128.1999q4:"]
aall[F511..S129.S0.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["ASS..S129.1999q4:"]
aall[F511..S13.S0.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["ASS..S13.1999q4:"]
aall[F511..S14.S0.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["ASS..S14.1999q4:"]
aall[F511..S15.S0.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["ASS..S15.1999q4:"]
aall[F511..S1M.S0.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["ASS..S14_S15.1999q4:"]
aall[F511..S2.S0.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["ASS..S2.1999q4:"]
aall[F511..S12Q.S0.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["ASS..S128.1999q4:"] + aa511t["ASS..S129.1999q4:"]
aall[F511..S12R.S0.F._T.]= aall[F511..S124.S0.F._T.] + aall[F511..S12O.S0.F._T.] + aall[F511..S12Q.S0.F._T.]

#LIABILITIES FILLING FOR F511 FLOWS
aall[F511..S0.S1.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["LIAB..S1.1999q4:"]
aall[F511..S0.S11.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["LIAB..S11.1999q4:"]
aall[F511..S0.S1.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["LIAB..S1.1999q4:"]
aall[F511..S0.S12.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["LIAB..S12.1999q4:"]
aall[F511..S0.S12K.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["LIAB..S121_S122_S123.1999q4:"]
aall[F511..S0.S124.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["LIAB..S124.1999q4:"]
aall[F511..S0.S125.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["LIAB..S125.1999q4:"]
aall[F511..S0.S12O.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["LIAB..S125_S126_S127.1999q4:"]
aall[F511..S0.S126.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["LIAB..S126.1999q4:"]
aall[F511..S0.S127.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["LIAB..S127.1999q4:"]
aall[F511..S0.S128.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["LIAB..S128.1999q4:"]
aall[F511..S0.S129.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["LIAB..S129.1999q4:"]
aall[F511..S0.S13.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["LIAB..S13.1999q4:"]
aall[F511..S0.S14.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["LIAB..S14.1999q4:"]
aall[F511..S0.S15.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["LIAB..S15.1999q4:"]
aall[F511..S0.S1M.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["LIAB..S14_S15.1999q4:"]
aall[F511..S0.S2.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["LIAB..S2.1999q4:"]
aall[F511..S0.S12Q.F._T., usenames=TRUE, onlyna=TRUE] = aa511t["LIAB..S128.1999q4:"] + aa511t["LIAB..S129.1999q4:"]
aall[F511..S0.S12R.F._T.]= aall[F511..S0.S124.F._T.] + aall[F511..S0.S12O.F._T.] + aall[F511..S0.S12Q.F._T.]



#ASSETS FILLING FOR F51M STOCKS
aall[F51M..S1.S0.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["ASS..S1.1999q4:"]
aall[F51M..S11.S0.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["ASS..S11.1999q4:"]
aall[F51M..S1.S0.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["ASS..S1.1999q4:"]
aall[F51M..S12.S0.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["ASS..S12.1999q4:"]
aall[F51M..S12K.S0.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["ASS..S121_S122_S123.1999q4:"]
aall[F51M..S124.S0.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["ASS..S124.1999q4:"]
aall[F51M..S125.S0.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["ASS..S125.1999q4:"]
aall[F51M..S12O.S0.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["ASS..S125_S126_S127.1999q4:"]
aall[F51M..S126.S0.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["ASS..S126.1999q4:"]
aall[F51M..S127.S0.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["ASS..S127.1999q4:"]
aall[F51M..S128.S0.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["ASS..S128.1999q4:"]
aall[F51M..S129.S0.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["ASS..S129.1999q4:"]
aall[F51M..S13.S0.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["ASS..S13.1999q4:"]
aall[F51M..S14.S0.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["ASS..S14.1999q4:"]
aall[F51M..S15.S0.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["ASS..S15.1999q4:"]
aall[F51M..S1M.S0.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["ASS..S14_S15.1999q4:"]
aall[F51M..S2.S0.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["ASS..S2.1999q4:"]
aall[F51M..S12Q.S0.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["ASS..S128.1999q4:"] + AA51M["ASS..S129.1999q4:"]
aall[F51M..S12R.S0.LE._T.]= aall[F51M..S124.S0.LE._T.] + aall[F51M..S12O.S0.LE._T.] + aall[F51M..S12Q.S0.LE._T.]

#LIABILITIES FILLING FOR F51M STOCKS
aall[F51M..S0.S1.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["LIAB..S1.1999q4:"]
aall[F51M..S0.S11.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["LIAB..S11.1999q4:"]
aall[F51M..S0.S1.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["LIAB..S1.1999q4:"]
aall[F51M..S0.S12.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["LIAB..S12.1999q4:"]
aall[F51M..S0.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["LIAB..S121_S122_S123.1999q4:"]
aall[F51M..S0.S124.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["LIAB..S124.1999q4:"]
aall[F51M..S0.S125.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["LIAB..S125.1999q4:"]
aall[F51M..S0.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["LIAB..S125_S126_S127.1999q4:"]
aall[F51M..S0.S126.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["LIAB..S126.1999q4:"]
aall[F51M..S0.S127.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["LIAB..S127.1999q4:"]
aall[F51M..S0.S128.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["LIAB..S128.1999q4:"]
aall[F51M..S0.S129.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["LIAB..S129.1999q4:"]
aall[F51M..S0.S13.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["LIAB..S13.1999q4:"]
aall[F51M..S0.S14.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["LIAB..S14.1999q4:"]
aall[F51M..S0.S15.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["LIAB..S15.1999q4:"]
aall[F51M..S0.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["LIAB..S14_S15.1999q4:"]
aall[F51M..S0.S2.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["LIAB..S2.1999q4:"]
aall[F51M..S0.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = AA51M["LIAB..S128.1999q4:"] + AA51M["LIAB..S129.1999q4:"]
aall[F51M..S0.S12R.LE._T.]= aall[F51M..S0.S124.LE._T.] + aall[F51M..S0.S12O.LE._T.] + aall[F51M..S0.S12Q.LE._T.]

#ASSETS FILLING FOR F51M FLOWS
aall[F51M..S1.S0.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["ASS..S1.1999q4:"]
aall[F51M..S11.S0.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["ASS..S11.1999q4:"]
aall[F51M..S1.S0.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["ASS..S1.1999q4:"]
aall[F51M..S12.S0.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["ASS..S12.1999q4:"]
aall[F51M..S12K.S0.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["ASS..S121_S122_S123.1999q4:"]
aall[F51M..S124.S0.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["ASS..S124.1999q4:"]
aall[F51M..S125.S0.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["ASS..S125.1999q4:"]
aall[F51M..S12O.S0.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["ASS..S125_S126_S127.1999q4:"]
aall[F51M..S126.S0.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["ASS..S126.1999q4:"]
aall[F51M..S127.S0.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["ASS..S127.1999q4:"]
aall[F51M..S128.S0.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["ASS..S128.1999q4:"]
aall[F51M..S129.S0.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["ASS..S129.1999q4:"]
aall[F51M..S13.S0.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["ASS..S13.1999q4:"]
aall[F51M..S14.S0.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["ASS..S14.1999q4:"]
aall[F51M..S15.S0.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["ASS..S15.1999q4:"]
aall[F51M..S1M.S0.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["ASS..S14_S15.1999q4:"]
aall[F51M..S2.S0.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["ASS..S2.1999q4:"]
aall[F51M..S12Q.S0.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["ASS..S128.1999q4:"] + AA51Mt["ASS..S129.1999q4:"]
aall[F51M..S12R.S0.F._T.]= aall[F51M..S124.S0.F._T.] + aall[F51M..S12O.S0.F._T.] + aall[F51M..S12Q.S0.F._T.]

#LIABILITIES FILLING FOR F51M FLOWS
aall[F51M..S0.S1.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["LIAB..S1.1999q4:"]
aall[F51M..S0.S11.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["LIAB..S11.1999q4:"]
aall[F51M..S0.S1.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["LIAB..S1.1999q4:"]
aall[F51M..S0.S12.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["LIAB..S12.1999q4:"]
aall[F51M..S0.S12K.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["LIAB..S121_S122_S123.1999q4:"]
aall[F51M..S0.S124.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["LIAB..S124.1999q4:"]
aall[F51M..S0.S125.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["LIAB..S125.1999q4:"]
aall[F51M..S0.S12O.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["LIAB..S125_S126_S127.1999q4:"]
aall[F51M..S0.S126.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["LIAB..S126.1999q4:"]
aall[F51M..S0.S127.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["LIAB..S127.1999q4:"]
aall[F51M..S0.S128.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["LIAB..S128.1999q4:"]
aall[F51M..S0.S129.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["LIAB..S129.1999q4:"]
aall[F51M..S0.S13.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["LIAB..S13.1999q4:"]
aall[F51M..S0.S14.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["LIAB..S14.1999q4:"]
aall[F51M..S0.S15.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["LIAB..S15.1999q4:"]
aall[F51M..S0.S1M.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["LIAB..S14_S15.1999q4:"]
aall[F51M..S0.S2.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["LIAB..S2.1999q4:"]
aall[F51M..S0.S12Q.F._T., usenames=TRUE, onlyna=TRUE] = AA51Mt["LIAB..S128.1999q4:"] + AA51Mt["LIAB..S129.1999q4:"]
aall[F51M..S0.S12R.F._T.]= aall[F51M..S0.S124.F._T.] + aall[F51M..S0.S12O.F._T.] + aall[F51M..S0.S12Q.F._T.]



temp=aall["F51M....._T."]+aall["F511....._T."]

aall[F51....._T., usenames=TRUE, onlyna=TRUE] = temp

#check
temp[.S1.S0.LE.2022q4]
aall[F51..S1.S0.LE._T.2022q4]
aall[F511.AT..S0.LE._T.2022q4]
aall[F51.AT..S0.LE._T.2022q4]
aall[F51M.AT..S0.LE._T.2022q4]

gc()

saveRDS(aall, file.path('data/aall4.rds'))
