<<<<<<<< HEAD:routines/archive_codes/012_load_BSI_MFI_new.R

#### all of this is for sector S12T

absirawq=mds('ECB/BSI/Q..N.A.A41+A5A+A50.A.1+4...Z01.E',labels=TRUE, ccode = NULL) #separating Q and M because of widely different elements that are filled
absirawm=mds('ECB/BSI/M..N.A.A41+A5A+A50.A.1+4...Z01.E',labels=FALSE, ccode = NULL)

gc()
gc()
absiraw=aggregate(absirawm,'Q',FUN = end)


#dimcodes(absirawq)[2:4]
#U5=S2I, U6=S1
dictbsisec= c('2260'='S124','0000'='S1','1000'='S12K','2220'='S12Q','2270'='S12O','2100'='S13','2240'='S11')

absiraw=copy(absiraw)

suppressWarnings(absiraw[usenames=TRUE] <- absirawq)
for (i in setdiff(names(dimnames(absiraw)),'TIME')) {
  dimcodes(absiraw)[[i]][,'label:en'] = helpmds('ECB/BSI',dim=i,verbose = FALSE)[dimnames(absiraw)[[i]],'label:en']
}
dimcodes(absiraw)[['BS_COUNT_SECTOR']]['2270','label:en'] = 'OFIs (sum of S.125, S.126, S.127)'

# saveRDS(absiraw,file='absiraw.rds')
# absiraw=readRDS('absiraw.rds')


#dimcodes(absiraw)[2:4]
#absiraw[AT.A41.IT..y2022q4]
#absiraw[AT..U2..y2022q4]

absi=copy(absiraw)
dimnames(absi)
names(dimnames(absi))[2:5] =c('INSTRUMENT','STO','COUNTERPART_AREA','COUNTERPART_SECTOR')
dimnames(absi)[['INSTRUMENT']] = c(A41='F52',A50='F5',A5A='F51')
dimnames(absi)[['STO']] = c("1"='LE',"4"='F')


#temp=absi[,'F52','U2','0000',] - absi[,'F52','U2','2260',] 
#any(rowSums(temp,na.rm = T)>1); rm(temp)
##so, all of F52 goes to S124

#any(-absiraw['.A41.U2.2260.']-absiraw['.A5A.U2.2270.']+ absiraw['.A50.U2.2210.'] > 1 ,na.rm=TRUE)
##so all of equity in S124 is F52


absi[,,,,'2100',]=NA
absi[,,,,'2100',] = absi[,,,,'0000',] - absi[,,,,'1000',] - absi[,,,,'2200',]


absi['.F52..U6+U2.2270+2220+2221+2222+2240.',onlyna=TRUE] = 0
absi[.F52..U6+U2..,onlyna=TRUE] = absi[.F5..U6+U2..]-absi[.F51..U6+U2..]
absi[.F51..U6+U2..,onlyna=TRUE] = absi[.F5..U6+U2..]-absi[.F52..U6+U2..]
absi['...U6+U2.2210.',onlyna=TRUE] = absi['...U6+U2.2260.'] + absi['...U6+U2.2270.']
absi['.F51..U6+U2..',onlyna=TRUE] = absi['.F5..U6+U2..'] - absi['.F52..U6+U2..']
absi['...U6+U2.2260.',onlyna=TRUE] = absi['...U6+U2.2210.'] - absi['...U6+U2.2270.']
absi[AT...U6..y2022q4]; absi[AT...U2..y2022q4]

absi[...U5.., onlyna=TRUE] = absi[...U2..] - absi[...U6..]



#round(absi['.F51.U2.2240+2270.y2022q4']/absi['.F51.U2.2200.y2022q4'],2)
#round(absi['.F51.U2.2240+2270.y2016q4']/absi['.F51.U2.2200.y2016q4'],2)
#===> the safest is the assume that RoEA equity holdings all go to the OFI=2270 sector

###### assumption here already! ############
absi['...U5.2210.'] = absi['...U5.2270.'] = absi['...U5.2200.']
absi['...U5.2220.', onlyna=TRUE] = 0; absi['...U5.2240.', onlyna=TRUE] = 0;

absi[...U6.., onlyna=TRUE] = absi[...U2..] - absi[...U5..]

absi=absi[,,,,names(dictbsisec),]
dimnames(absi)[[5]] = dictbsisec[dimnames(absi)[[5]]]
saveRDS(absi,file='absi_wRoEAsectors.rds')

absi[....S2.]=NA; absi[....S2I.]=NA; absi[....S0.]=NA

asbsi = absi[...U6..]
asbsi[...S2.] = absi[...U4.S1.]+absi[...U2.S1.]
asbsi[...S2I.] = absi[...U5.S1.]
asbsi[...S0.] = asbsi[...S1.] + asbsi[...S2.] 
dimcodes(absiraw)

libsi=absiraw['U5.A50...0000.']
saveRDS(asbsi,file='data/bsi_assets.rds')
saveRDS(libsi,file='data/bsi_liab.rds')


asbsi[AT....y2022q4]
========
# Load required packages
library(MDstats)
library(MD3)

# Set data directory
if (!exists("data_dir")) data_dir = getwd()

#### all of this is for sector S12T

# Load quarterly and monthly BSI data (separating Q and M because of widely different elements that are filled)
absirawq=mds('ECB/BSI/Q..N.A.A41+A5A+A50.A.1+4...Z01.E',labels=TRUE, ccode = NULL)
absirawm=mds('ECB/BSI/M..N.A.A41+A5A+A50.A.1+4...Z01.E',labels=FALSE, ccode = NULL)

gc()

# Aggregate monthly to quarterly
absiraw=aggregate(absirawm,'Q',FUN = end)

# Dictionary for BSI sectors
dictbsisec= c('2260'='S124','0000'='S1','1000'='S12K','2220'='S12Q','2270'='S12O','2100'='S13','2240'='S11')

absiraw=copy(absiraw)

suppressWarnings(absiraw[usenames=TRUE] <- absirawq)
for (i in setdiff(names(dimnames(absiraw)),'TIME')) {
  dimcodes(absiraw)[[i]][,'label:en'] = helpmds('ECB/BSI',dim=i,verbose = FALSE)[dimnames(absiraw)[[i]],'label:en']
}
dimcodes(absiraw)[['BS_COUNT_SECTOR']]['2270','label:en'] = 'OFIs (sum of S.125, S.126, S.127)'

absi=copy(absiraw)
dimnames(absi)
names(dimnames(absi))[2:5] =c('INSTRUMENT','STO','COUNTERPART_AREA','COUNTERPART_SECTOR')
dimnames(absi)[['INSTRUMENT']] = c(A41='F52',A50='F5',A5A='F51')
dimnames(absi)[['STO']] = c("1"='LE',"4"='F')

absi[,,,,'2100',]=NA
absi[,,,,'2100',] = absi[,,,,'0000',] - absi[,,,,'1000',] - absi[,,,,'2200',]

absi['.F52..U6+U2.2270+2220+2221+2222+2240.',onlyna=TRUE] = 0
absi[.F52..U6+U2..,onlyna=TRUE] = absi[.F5..U6+U2..]-absi[.F51..U6+U2..]
absi[.F51..U6+U2..,onlyna=TRUE] = absi[.F5..U6+U2..]-absi[.F52..U6+U2..]
absi['...U6+U2.2210.',onlyna=TRUE] = absi['...U6+U2.2260.'] + absi['...U6+U2.2270.']
absi['.F51..U6+U2..',onlyna=TRUE] = absi['.F5..U6+U2..'] - absi['.F52..U6+U2..']
absi['...U6+U2.2260.',onlyna=TRUE] = absi['...U6+U2.2210.'] - absi['...U6+U2.2270.']

absi[...U5.., onlyna=TRUE] = absi[...U2..] - absi[...U6..]

###### assumption here already! ############
absi['...U5.2210.'] = absi['...U5.2270.'] = absi['...U5.2200.']
absi['...U5.2220.', onlyna=TRUE] = 0; absi['...U5.2240.', onlyna=TRUE] = 0;

absi[...U6.., onlyna=TRUE] = absi[...U2..] - absi[...U5..]

absi=absi[,,,,names(dictbsisec),]
dimnames(absi)[[5]] = dictbsisec[dimnames(absi)[[5]]]
saveRDS(absi, file=file.path(data_dir, 'absi_wRoEAsectors.rds'))

absi[....S2.]=NA; absi[....S2I.]=NA; absi[....S0.]=NA

asbsi = absi[...U6..]
asbsi[...S2.] = absi[...U4.S1.]+absi[...U2.S1.]
asbsi[...S2I.] = absi[...U5.S1.]
asbsi[...S0.] = asbsi[...S1.] + asbsi[...S2.] 

libsi=absiraw['U5.A50...0000.']
saveRDS(asbsi, file=file.path(data_dir, 'bsi_assets.rds'))
saveRDS(libsi, file=file.path(data_dir, 'bsi_liab.rds'))
>>>>>>>> 55a5a789115f3c6e93936ceaded19180b9724739:routines/loading/005_load_BSI_MFI.R
