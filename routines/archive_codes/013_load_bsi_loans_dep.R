#### BSI LOADING OF BILATERAL LOANS AND DEPOSITS . S12T IS THE REFERENCE SECTOR

bbsirawq=mds('ECB/BSI/Q..N.A.A20+L20.A+F.1+4.U6..Z01.E',labels=TRUE, ccode = NULL) #separating Q and M because of widely different elements that are filled
bbsirawm=mds('ECB/BSI/M..N.A.A20+L20.A+F.1+4.U6..Z01.E',labels=FALSE, ccode = NULL)

gc()
gc()
bbsiraw=aggregate(bbsirawm,'Q',FUN = end)
gc()

dimnames(bbsiraw)

dimnames(bbsiraw)$BS_COUNT_SECTOR[dimnames(bbsiraw)$BS_COUNT_SECTOR=='1000'] = 'S12K'
dimnames(bbsiraw)$BS_COUNT_SECTOR[dimnames(bbsiraw)$BS_COUNT_SECTOR=='1100'] = 'S121'
dimnames(bbsiraw)$BS_COUNT_SECTOR[dimnames(bbsiraw)$BS_COUNT_SECTOR=='2271'] = 'S125A'
dimnames(bbsiraw)$BS_COUNT_SECTOR[dimnames(bbsiraw)$BS_COUNT_SECTOR=='1210'] = 'S122'
dimnames(bbsiraw)$BS_COUNT_SECTOR[dimnames(bbsiraw)$BS_COUNT_SECTOR=='2100'] = 'S13'
dimnames(bbsiraw)$BS_COUNT_SECTOR[dimnames(bbsiraw)$BS_COUNT_SECTOR=='2220'] = 'S12Q'
dimnames(bbsiraw)$BS_COUNT_SECTOR[dimnames(bbsiraw)$BS_COUNT_SECTOR=='2240'] = 'S11'
dimnames(bbsiraw)$BS_COUNT_SECTOR[dimnames(bbsiraw)$BS_COUNT_SECTOR=='2250'] = 'S1M'

dimnames(bbsiraw)$REF_AREA[dimnames(bbsiraw)$REF_AREA=='GB'] = 'UK'
dimnames(bbsiraw)$REF_AREA[dimnames(bbsiraw)$REF_AREA=='GR'] = 'EL'
dimnames(bbsiraw)$REF_AREA[dimnames(bbsiraw)$REF_AREA=='U2'] = 'EA20'

bbsiraw['EA19..... ']<- bbsiraw['EA20..... ']
bbsiraw['EA18..... ']<- bbsiraw['EA20..... ']

names(dimnames(bbsiraw))[4] = 'STO'
dimnames(bbsiraw)$STO[dimnames(bbsiraw)$STO=='1'] = 'LE'
dimnames(bbsiraw)$STO[dimnames(bbsiraw)$STO=='4'] = 'F'


bbsiraw = bbsiraw[....S12K+S121+S125A+S122+S13+S12Q+S11+S1M.]
dimnames(bbsiraw)

bsi_loans_dep=bbsiraw
saveRDS(bsi_loans_dep,file='data/bsi_loans_dep.rds')
