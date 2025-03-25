
# Load assets data
asbsi= readRDS("data/bsi_ass.rds")
# Load liabilities data
libsi = readRDS("data/bsi_lia.rds")

#temp load current aall version
aall=readRDS('data/aall8.rds')
setkey(aall, NULL)


### data structure
gc()
gc()
names(dimnames(asbsi))[[2]] = 'INSTR'
names(dimnames(libsi))[[1]] = 'STO'
names(dimnames(libsi))[[2]] = 'REF_AREA'

dimnames(libsi)[['STO']] = c("1"='LE',"4"='F')

#check
dimnames(asbsi)
dimnames(libsi)



#check
aall[F5.AT.S12T..LE._T.2022q4]
#ASSETS FILLING
aall[..S12T..._T., usenames=TRUE, onlyna=TRUE] = asbsi["....1998q4:"]
#check
aall[F5.AT.S12T..LE._T.2022q4]

aall[F51.AT.S12T..LE._T.2022q4]
aall[F5.AT.S12T..F._T.2022q4]


#LIABILITIES FILLING
aall[F5..S1.S12T.._T., usenames=TRUE, onlyna=TRUE] = libsi["..1998q4:"]

##### FILL F51M NAS AS RESIDUAL BETWEEN THESE NEW F51 AND POSSIBLY PREEXISTING F511
gc()
temp=aall["F51..S12T..._T."])-aall["F511..S12T..._T."]
aall[F51M..S12T..._T., usenames=TRUE, onlyna=TRUE] = temp

saveRDS(aall, file.path(data_dir, 'aall9.rds'))
