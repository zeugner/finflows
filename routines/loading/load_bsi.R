
#### BSI LOADING OF BILATERAL LOANS AND DEPOSITS . S12T IS THE REFERENCE SECTOR

bbsirawq=mds('ECB/BSI/Q..N.A.A20+L20.A.1+4...Z01.E',labels=TRUE, ccode = NULL) #separating Q and M because of widely different elements that are filled
bbsirawm=mds('ECB/BSI/M..N.A.A20+L20.A.1+4...Z01.E',labels=FALSE, ccode = NULL)

gc()
gc()
bbsiraw=aggregate(bbsirawm,'Q',FUN = end)
gc()


#dimcodes(absirawq)[2:4]
#U5=S2I, U6=S1
dictbsisec= c('2260'='S124','0000'='S1','1000'='S12K','2220'='S12Q','2270'='S12O','2100'='S13','2240'='S11', '1100'='S121', '1210'='S122', '2221'='S128', '2222'='S129', '2250'='S1M')

# 0000=Swhat? ## CHECK WITH STEFAN AND ERZA????

bbsiraw=copy(bbsiraw)

suppressWarnings(bbsiraw[usenames=TRUE] <- bbsirawq)
for (i in setdiff(names(dimnames(bbsiraw)),'TIME')) {
  dimcodes(bbsiraw)[[i]][,'label:en'] = helpmds('ECB/BSI',dim=i,verbose = FALSE)[dimnames(bbsiraw)[[i]],'label:en']
}
dimcodes(bbsiraw)[['BS_COUNT_SECTOR']]['2270','label:en'] = 'OFIs (sum of S.125, S.126, S.127)'

# saveRDS(absiraw,file='absiraw.rds')
# absiraw=readRDS('absiraw.rds')
dimnames(bbsiraw)

#dimcodes(absiraw)[2:4]
#absiraw[AT.A41.IT..y2022q4]
#absiraw[AT..U2..y2022q4]
bbsiraw[AT.A20.1...2023q4]
bbsi=copy(bbsiraw)

dimnames(bbsi)
bbsi[AT.A20.1...2023q4]
names(dimnames(bbsi))[[2]] = 'INSTR'
names(dimnames(bbsi))[[3]] = 'STO'
names(dimnames(bbsi))[[4]] = 'COUNTERPART_AREA'
names(dimnames(bbsi))[[5]] = 'COUNTERPART_SECTOR'
bbsi[AT.A20.1...2023q4]


dimnames(bbsi)

bbsi=bbsi[,,,,names(dictbsisec),]
dimnames(bbsi)[[5]] = dictbsisec[dimnames(bbsi)[[5]]]
dimnames(bbsi)

bbsi[AT.A20.1...2023q4]
saveRDS(bbsi,file='bbsi.rds')

# Update STO values

sto_values <- dimnames(bbsi)[["STO"]]
new_values <- sto_values
names(new_values) <- sto_values
if ("1" %in% sto_values) new_values["1"] <- "LE"
if ("4" %in% sto_values) new_values["4"] <- "F"
dimnames(bbsi)[["STO"]] <- new_values

dimnames(bbsi)

bbsi[AT.A20..U2.S1.2023q4]


saveRDS(bbsi,file='bsi_loans_deposits.rds')


basbsi=bbsi[.A20....]
blibsi=bbsi[.L20....]
dimnames(blibsi)

names(dimnames(blibsi))[[4]] = 'REF_SECTOR'

dimnames(blibsi)
blibsi[AT.LE...2023q4]
saveRDS(basbsi,file='data/bsi_loans.rds')
saveRDS(blibsi,file='data/bsi_deposits.rds')

