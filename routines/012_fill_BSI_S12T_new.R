library(MDecfin)

# Load assets data
asbsi= readRDS("data/bsi_ass.rds")
# Load liabilities data
libsi = readRDS("data/bsi_lia.rds")

#temp load current aall version
aall=readRDS('data/aall6.rds')
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


#function to fill nas
zerofiller=function(x, fillscalar=0){
  temp=copy(x)
  temp[onlyna=TRUE]=fillscalar
  temp
}
#check
aall[F5.AT.S12T..LE._T.2022q4]
#ASSETS FILLING
aall[..S12T..._T., usenames=TRUE, onlyna=TRUE] = zerofiller(asbsi["....1998q4:"])
#check
aall[F5.AT.S12T..LE._T.2022q4]

aall[F51.AT.S12T..LE._T.2022q4]
aall[F5.AT.S12T..F._T.2022q4]


#LIABILITIES FILLING
aall[F5..S1.S12T.._T., usenames=TRUE, onlyna=TRUE] = zerofiller(libsi["..1998q4:"])

##### FILL F51M NAS AS RESIDUAL BETWEEN THESE NEW F51 AND POSSIBLY PREEXISTING F511
gc()
aall[F51M..S12T..._T., usenames=TRUE, onlyna=TRUE] = zerofiller(aall["F51..S12T..._T."])-zerofiller(aall["F511..S12T..._T."])
