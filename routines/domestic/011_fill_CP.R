# Load required packages
library(MDstats)
library(MD3)

# Set data directory
if (!exists("data_dir")) data_dir = getwd()

# Load data
cpa= readRDS(file.path(data_dir, "cpa_new.rds"))
cpq= readRDS(file.path(data_dir, "cpq_new.rds"))
cpq_fdi= readRDS(file.path(data_dir, "cpq_fdi_new.rds"))
aall= readRDS(file.path(data_dir, "intermediate_domestic_data_files/aall_shss.rds"))
gc()
### WORK ON DIMNAMES

names(dimnames(cpa))[1]=names(dimnames(cpq))[5]=names(dimnames(cpq_fdi))[4]='STO'
names(dimnames(cpa))[6]=names(dimnames(cpq))[3]=names(dimnames(cpq_fdi))[3]='REF_AREA'
names(dimnames(cpa))[2]=names(dimnames(cpq))[4]='COUNTERPART_SECTOR'
names(dimnames(cpa))[3]=names(dimnames(cpq))[6]='REF_SECTOR'
names(dimnames(cpa))[4]='INSTR'

### RENAMING STOCKS AND FLOWS
dimnames(cpa)$STO[dimnames(cpa)$STO=='STK'] = 'LE'
dimnames(cpa)$STO[dimnames(cpa)$STO=='TRN'] = 'F'
dimnames(cpq)$STO[dimnames(cpq)$STO=='STK'] = 'LE'
dimnames(cpq)$STO[dimnames(cpq)$STO=='TRN'] = 'F'
dimnames(cpq_fdi)$STO[dimnames(cpq_fdi)$STO=='STK'] = 'LE'
dimnames(cpq_fdi)$STO[dimnames(cpq_fdi)$STO=='TRN'] = 'F'

### RENAMING SECTORS
dimnames(cpa)$REF_SECTOR[dimnames(cpa)$REF_SECTOR=='S14_S15'] = 'S1M'
dimnames(cpa)$COUNTERPART_SECTOR[dimnames(cpa)$COUNTERPART_SECTOR=='S14_S15'] = 'S1M'

dimnames(cpa)$INSTR[dimnames(cpa)$INSTR=='F31'] = 'F3S'
dimnames(cpa)$INSTR[dimnames(cpa)$INSTR=='F32'] = 'F3L'
dimnames(cpa)$INSTR[dimnames(cpa)$INSTR=='F41'] = 'F4S'
dimnames(cpa)$INSTR[dimnames(cpa)$INSTR=='F42'] = 'F4L'

dimnames(cpq)$REF_SECTOR[dimnames(cpq)$REF_SECTOR=='S121_S122_S123'] = 'S12K'
dimnames(cpq)$COUNTERPART_SECTOR[dimnames(cpq)$COUNTERPART_SECTOR=='S121_S122_S123'] = 'S12K'
dimnames(cpq)$REF_SECTOR[dimnames(cpq)$REF_SECTOR=='S125_S126_S127'] = 'S12O'
dimnames(cpq)$COUNTERPART_SECTOR[dimnames(cpq)$COUNTERPART_SECTOR=='S125_S126_S127'] = 'S12O'
dimnames(cpq)$REF_SECTOR[dimnames(cpq)$REF_SECTOR=='S128_S129'] = 'S12Q'
dimnames(cpq)$COUNTERPART_SECTOR[dimnames(cpq)$COUNTERPART_SECTOR=='S128_S129'] = 'S12Q'
dimnames(cpq)$REF_SECTOR[dimnames(cpq)$REF_SECTOR=='S14_S15'] = 'S1M'
dimnames(cpq)$COUNTERPART_SECTOR[dimnames(cpq)$COUNTERPART_SECTOR=='S14_S15'] = 'S1M'

cpa[...F6N...]<-cpa[...F62...]+cpa[...F63_F64_F65...]
cpa[...F2M...]<-cpa[...F22...]+cpa[...F29...]
cpa[...F51M...]<-cpa[...F512...]+cpa[...F519...]
cpa[...F6O...]<-cpa[...F61...]+cpa[...F66...]

cpa=cpa[...F+F21+F2M+F3+F3L+F3S+F4+F4L+F4S+F5+F51+F511+F51M+F52+F6+F6N+F6O+F7+F81+F89+F22+F29+F512+F519...]

cpq[...S12R...]<-cpq[...S12O...]+cpq[...S12Q...]+cpq[...S124...]
cpq[.....S12R.]<-cpq[.....S12O.]+cpq[.....S12Q.]+cpq[.....S124.]

### SPLIT ASSETS AND LIABILITIES
cpq_a=cpq[.ASS.....]
cpq_l=cpq[.LIAB.....]

cpa_a=cpa[....ASS..]
cpa_l=cpa[....LIAB..]

cpq_fdi_a=cpq_fdi[.ASS...]
cpq_fdi_l=cpq_fdi[.LIAB...]

### RENAME REF AND CP SECTORS FOR LIABILITIES 
names(dimnames(cpa_l))[2]=names(dimnames(cpq_l))[3]='temp'
names(dimnames(cpa_l))[3]=names(dimnames(cpq_l))[5]='COUNTERPART_SECTOR'
names(dimnames(cpa_l))[2]=names(dimnames(cpq_l))[3]='REF_SECTOR'

### ANNUAL IN QUARTERLY (END-OF-THE-YEAR)
cpa_aq=copy(cpa_a); frequency(cpa_aq)='Q'
cpa_lq=copy(cpa_l); frequency(cpa_lq)='Q'

### FILLING. ASSETS FIRST. THEN LIABILITIES
aall[....._T.,onlyna=TRUE]<-cpa_aq[.....]
aall[....._T.,onlyna=TRUE]<-cpq_a[.....]
aall[..S1.S2..FND.,onlyna=TRUE]<-cpq_fdi_a['...']

aall[....._T.,onlyna=TRUE]<-cpa_lq[.....]
aall[....._T.,onlyna=TRUE]<-cpq_l[.....]
aall[..S2.S1..FND.,onlyna=TRUE]<-cpq_fdi_l['...']

saveRDS(aall, file.path(data_dir, 'intermediate_domestic_data_files/aall_cp.rds'))
