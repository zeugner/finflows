<<<<<<< HEAD
# Load required packages
library(MDstats)
library(MD3)

# Set data directory
if (!exists("data_dir")) data_dir = getwd()

#### BSI LOADING OF BILATERAL LOANS AND DEPOSITS . S12T IS THE REFERENCE SECTOR

# Load quarterly and monthly data (separating Q and M because of widely different elements that are filled)
bbsirawq=mds('ECB/BSI/Q..N.A.A20+L20.A+F.1+4.U6..Z01.E',labels=TRUE, ccode = NULL)
bbsirawm=mds('ECB/BSI/M..N.A.A20+L20.A+F.1+4.U6..Z01.E',labels=FALSE, ccode = NULL)

gc()

# Aggregate monthly to quarterly
bbsiraw=aggregate(bbsirawm,'Q',FUN = end)

gc()

# Rename sectors
dimnames(bbsiraw)$BS_COUNT_SECTOR[dimnames(bbsiraw)$BS_COUNT_SECTOR=='1000'] = 'S12K'
dimnames(bbsiraw)$BS_COUNT_SECTOR[dimnames(bbsiraw)$BS_COUNT_SECTOR=='1100'] = 'S121'
dimnames(bbsiraw)$BS_COUNT_SECTOR[dimnames(bbsiraw)$BS_COUNT_SECTOR=='2271'] = 'S125A'
dimnames(bbsiraw)$BS_COUNT_SECTOR[dimnames(bbsiraw)$BS_COUNT_SECTOR=='1210'] = 'S122'
dimnames(bbsiraw)$BS_COUNT_SECTOR[dimnames(bbsiraw)$BS_COUNT_SECTOR=='2100'] = 'S13'
dimnames(bbsiraw)$BS_COUNT_SECTOR[dimnames(bbsiraw)$BS_COUNT_SECTOR=='2220'] = 'S12Q'
dimnames(bbsiraw)$BS_COUNT_SECTOR[dimnames(bbsiraw)$BS_COUNT_SECTOR=='2240'] = 'S11'
dimnames(bbsiraw)$BS_COUNT_SECTOR[dimnames(bbsiraw)$BS_COUNT_SECTOR=='2250'] = 'S1M'

# Rename countries
dimnames(bbsiraw)$REF_AREA[dimnames(bbsiraw)$REF_AREA=='GB'] = 'UK'
dimnames(bbsiraw)$REF_AREA[dimnames(bbsiraw)$REF_AREA=='GR'] = 'EL'
dimnames(bbsiraw)$REF_AREA[dimnames(bbsiraw)$REF_AREA=='U2'] = 'EA20'

# Fill EA data
bbsiraw['EA19..... ']<- bbsiraw['EA20..... ']
bbsiraw['EA18..... ']<- bbsiraw['EA20..... ']

# Rename dimensions
names(dimnames(bbsiraw))[4] = 'STO'
dimnames(bbsiraw)$STO[dimnames(bbsiraw)$STO=='1'] = 'LE'
dimnames(bbsiraw)$STO[dimnames(bbsiraw)$STO=='4'] = 'F'

# Filter to relevant sectors
bbsiraw = bbsiraw[....S12K+S121+S125A+S122+S13+S12Q+S11+S1M.]

bsi_loans_dep=bbsiraw
=======
# Load required packages
library(MDstats)
library(MD3)

# Set data directory
if (!exists("data_dir")) data_dir = getwd()

#### BSI LOADING OF BILATERAL LOANS AND DEPOSITS . S12T IS THE REFERENCE SECTOR

# Load quarterly and monthly data (separating Q and M because of widely different elements that are filled)
bbsirawq=mds('ECB/BSI/Q..N.A.A20+L20.A+F.1+4.U6..Z01.E',labels=TRUE, ccode = NULL)
bbsirawm=mds('ECB/BSI/M..N.A.A20+L20.A+F.1+4.U6..Z01.E',labels=FALSE, ccode = NULL)

gc()

# Aggregate monthly to quarterly
bbsiraw=aggregate(bbsirawm,'Q',FUN = end)

gc()

# Rename sectors
dimnames(bbsiraw)$BS_COUNT_SECTOR[dimnames(bbsiraw)$BS_COUNT_SECTOR=='1000'] = 'S12K'
dimnames(bbsiraw)$BS_COUNT_SECTOR[dimnames(bbsiraw)$BS_COUNT_SECTOR=='1100'] = 'S121'
dimnames(bbsiraw)$BS_COUNT_SECTOR[dimnames(bbsiraw)$BS_COUNT_SECTOR=='2271'] = 'S125A'
dimnames(bbsiraw)$BS_COUNT_SECTOR[dimnames(bbsiraw)$BS_COUNT_SECTOR=='1210'] = 'S122'
dimnames(bbsiraw)$BS_COUNT_SECTOR[dimnames(bbsiraw)$BS_COUNT_SECTOR=='2100'] = 'S13'
dimnames(bbsiraw)$BS_COUNT_SECTOR[dimnames(bbsiraw)$BS_COUNT_SECTOR=='2220'] = 'S12Q'
dimnames(bbsiraw)$BS_COUNT_SECTOR[dimnames(bbsiraw)$BS_COUNT_SECTOR=='2240'] = 'S11'
dimnames(bbsiraw)$BS_COUNT_SECTOR[dimnames(bbsiraw)$BS_COUNT_SECTOR=='2250'] = 'S1M'

# Rename countries
dimnames(bbsiraw)$REF_AREA[dimnames(bbsiraw)$REF_AREA=='GB'] = 'UK'
dimnames(bbsiraw)$REF_AREA[dimnames(bbsiraw)$REF_AREA=='GR'] = 'EL'
dimnames(bbsiraw)$REF_AREA[dimnames(bbsiraw)$REF_AREA=='U2'] = 'EA20'

# Fill EA data
bbsiraw['EA19..... ']<- bbsiraw['EA20..... ']
bbsiraw['EA18..... ']<- bbsiraw['EA20..... ']

# Rename dimensions
names(dimnames(bbsiraw))[4] = 'STO'
dimnames(bbsiraw)$STO[dimnames(bbsiraw)$STO=='1'] = 'LE'
dimnames(bbsiraw)$STO[dimnames(bbsiraw)$STO=='4'] = 'F'

# Filter to relevant sectors
bbsiraw = bbsiraw[....S12K+S121+S125A+S122+S13+S12Q+S11+S1M.]

bsi_loans_dep=bbsiraw
>>>>>>> 55a5a789115f3c6e93936ceaded19180b9724739
saveRDS(bsi_loans_dep, file=file.path(data_dir, 'bsi_loans_dep.rds'))