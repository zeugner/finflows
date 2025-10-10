# Load required packages
library(MDstats)
library(MD3)

# Define paste0 operator
`%&%` = function (..., collapse = NULL, recycle0 = FALSE)  .Internal(paste0(list(...), collapse, recycle0))

# Set data directory
if (!exists("data_dir")) data_dir = getwd()

#### LOADING CPQ TOTALS
cpq_F2M=mds('Estat/nasq_10_f_cp/Q.MIO_EUR...STK+TRN..F22_F29.')
cpq_F3=mds('Estat/nasq_10_f_cp/Q.MIO_EUR...STK+TRN..F3.')
cpq_F4=mds('Estat/nasq_10_f_cp/Q.MIO_EUR...STK+TRN..F4.')
cpq_F511=mds('Estat/nasq_10_f_cp/Q.MIO_EUR...STK+TRN..F511.')
cpq_F52=mds('Estat/nasq_10_f_cp/Q.MIO_EUR...STK+TRN..F52.')

### create cpq raw 
cpq=add.dim(cpq_F2M, .dimname = 'INSTR', .dimcodes = c('F2M', 'F3', 'F4', 'F511', 'F52'), .fillall = FALSE)
gc()

cpq['F3......']<-cpq_F3['.....']
cpq['F4......']<-cpq_F4['.....']
cpq['F511......']<-cpq_F511['.....']
cpq['F52......']<-cpq_F52['.....']

saveRDS(cpq, file=file.path(data_dir, 'cpq_new.rds'))

#### LOADING CPQ FDI
cpq_F3_FDI=mds('Estat/nasq_10_f_cp/Q.MIO_EUR...STK+TRN..F3_FDI.')
cpq_F4_FDI=mds('Estat/nasq_10_f_cp/Q.MIO_EUR...STK+TRN..F4_FDI.')
cpq_F511_FDI=mds('Estat/nasq_10_f_cp/Q.MIO_EUR...STK+TRN..F511_FDI.')

cpq_fdi=add.dim(cpq_F3_FDI, .dimname = 'INSTR', .dimcodes = c('F3', 'F4', 'F511'), .fillall = FALSE)
gc()

cpq_fdi['F4....']<-cpq_F4_FDI['...']
cpq_fdi['F511....']<-cpq_F511_FDI['...']

### create cpq_fdi raw 
saveRDS(cpq_fdi, file=file.path(data_dir, 'cpq_fdi_new.rds'))

##### plug this in at the end of the nasa_10_f_cp loader....
cpa=cpa_raw=mds('EStat/nasa_10_f_cp') 

## note for domestic linkages, A and L are the same across QSA and NASA_10_F_CP
# cpinfo[S1.S11.ASS..2022]
# qsinfo[.W2.S11.A.2022q4]

## but not for links with external (S2):
# cpinfo[S2.S1.ASS..2022]
# qsinfo[.W1.S1.A.2022q4]
# qsinfo[.W1.S1.L.2022q4]
# 
# 
#so do the following
ccc=intersect(dimnames(cpinfo)$GEO,dimnames(qsinfo)$REF_AREA)
cmp1=range((cpinfo[S2.S1.ASS..2022][ccc])/(qsinfo[.W1.S1.L.2022q4][ccc]),na.rm = TRUE)
cmp2=range((cpinfo[S2.S1.ASS..2022][ccc])/(qsinfo[.W1.S1.A.2022q4][ccc]),na.rm = TRUE)

if (diff(cmp1)<.1 & diff(cmp2)>.2) {
  #switch S2 around for nasa_10_f_bs, but only for S2 relationships
  
  #xcp=copy(cpinfo)#this is just for demonstration, use the real array loaded from nasa_10_f_bs instead
  cpa=copy(cpa[.....MIO_EUR..])
  temp2=copy(cpa[.S2...ASS..])
  cpa[.S2...ASS..]=cpa[.S2...LIAB..]
  cpa[.S2...LIAB..] = temp2
  
}
saveRDS(cpa, file=file.path(data_dir, 'cpa_new.rds'))