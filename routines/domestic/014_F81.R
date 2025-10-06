<<<<<<< HEAD
# Load required packages
library(MDstats)
library(MD3)

# Define zerofiller function
zerofiller=function(x, fillscalar=0){
  temp=copy(x)
  temp[onlyna=TRUE]=fillscalar
  temp
}

# Set data directory
if (!exists("data_dir")) data_dir = getwd()

aall <- readRDS(file.path(data_dir, "intermediate_domestic_data_files/aall_f51m.rds"))

tradecredits_al=mds('ECB/QSA/Q.N..W0+W1...N.A+L.LE.F81.T._Z.XDC._T.S.V.N._T')
saveRDS(tradecredits_al, file.path(data_dir, 'tradecredits_al.rds'))
bopf81q=mds('Estat/bop_iip6_q/Q.MIO_EUR.FA__D__F81+FA__O__F81+..S1.A_LE+L_LE.WRL_REST.')
bopf81_a=mds('Estat/bop_iip6_q/A.MIO_EUR.FA__D__F81+FA__O__F81+..S1.A_LE+L_LE.WRL_REST.')
saveRDS(bopf81q, file.path(data_dir, 'bopf81q.rds'))
bopf81a=copy(bopf81_a); frequency(bopf81a)='Q'
saveRDS(bopf81a, file.path(data_dir, 'bopf81a.rds'))

names(dimnames(tradecredits_al)) =gsub("^COUNTER.*$","COUNTERPART_SECTOR",names(dimnames(tradecredits_al)))
tradecredits_al=aperm(tradecredits_al,c("REF_AREA","REF_SECTOR","COUNTERPART_SECTOR","ACCOUNTING_ENTRY","TIME"))

tradecredits=tradecredits_al[...A.]

dimnames(tradecredits)$COUNTERPART_SECTOR = c(W0='S0' , W1='S2')[dimnames(tradecredits)$COUNTERPART_SECTOR]

tradecredits[.S2.S0.] =tradecredits_al[.S1.W1.L.]
tradecredits[.S2.S1.] =tradecredits_al[.S1.W1.L.]
tradecredits[.S1.S1.] = tradecredits[.S1.S0.] -tradecredits[.S1.S2.] 
tradecredits[.S0.S1.] = tradecredits[.S1.S1.] +tradecredits[.S2.S1.] 
saveRDS(tradecredits, file.path(data_dir, 'tradecredits.rds'))
gc()

tradecredits=add.dim(tradecredits,.dimname = 'FUNCTIONAL_CAT',.dimcodes = '_T')
dimnames(tradecredits)[[1]]='_T'

af81_=aall['F81....LE._T+_S+_D+_O.1999q1:']
af81=merge(tradecredits, af81_,along = 'FUNCTIONAL_CAT')

##check the following
af81['_D...S2.']<-af81['_D...S0.']

names(dimnames(bopf81a))[1]=names(dimnames(bopf81q))[1]='REF_AREA'  
names(dimnames(bopf81q))[2]=names(dimnames(bopf81a))[2]='REF_SECTOR'

af81['_F+_O+_P+_R....'] <- NA

################ASSETS
af81['_D...S2.',onlyna=TRUE]<-bopf81q["..A_LE.FA__D__F81.1998q4:"]
af81['_O...S2.',onlyna=TRUE]<-bopf81q["..A_LE.FA__O__F81.1998q4:"]

af81['_D...S2.',onlyna=TRUE]<-bopf81a["..A_LE.FA__D__F81.1998q4:"]
af81['_O...S2.',onlyna=TRUE]<-bopf81a["..A_LE.FA__O__F81.1998q4:"]

af81['_T...S2.',onlyna=TRUE]<-af81['_D...S2.']+af81['_O...S2.']
af81['_S...S2.',onlyna=TRUE]<-af81['_D...S2.']+af81['_O...S2.']

############LIABILITIES
bopf81q_liab=copy(bopf81q)
names(dimnames(bopf81q_liab))[2]='COUNTERPART_SECTOR'

bopf81a_liab=copy(bopf81a)
names(dimnames(bopf81a_liab))[2]='COUNTERPART_SECTOR'

af81['_D..S2..',onlyna=TRUE]<-bopf81q_liab["..L_LE.FA__D__F81.1998q4:"]
af81['_O..S2..',onlyna=TRUE]<-bopf81q_liab["..L_LE.FA__O__F81.1998q4:"]

af81['_D..S2..',onlyna=TRUE]<-bopf81a_liab["..L_LE.FA__D__F81.1998q4:"]
af81['_O..S2..',onlyna=TRUE]<-bopf81a_liab["..L_LE.FA__O__F81.1998q4:"]

af81['_T..S2..',onlyna=TRUE]<-af81['_D..S2..']+af81['_O..S2..']
af81['_S..S2..',onlyna=TRUE]<-af81['_D..S2..']+af81['_O..S2..']

af81['..S1..',onlyna=TRUE]<-af81['..S0..']-af81['..S2..']

af81['...S1.',onlyna=TRUE]<-af81['...S0.']-af81['...S2.']

######FILLING
aall[F81....LE..,onlyna=TRUE]<-af81[....]

aall[....._S.,onlyna=TRUE]<-aall[....._T.]

# Set all F81 sectors to 0 where S0 counterpart is 0
temp=aall["F81....LE.."]
temp[temp[,"S0",,,]==0]=0
temp[temp[,,"S0",,]==0]=0

aall["F81....LE..", onlyna=TRUE]<-temp

#### countries with nothing filled, everything goes to S11
aall["F81...S11.LE..", onlyna=TRUE]<-aall["F81...S1.LE.."]

#### all residual goes to S12O
aall["F81...S12O.LE..", onlyna=TRUE]<-aall["F81...S1.LE.."]-aall["F81...S11.LE.."]-zerofiller(aall["F81...S13.LE.."])-zerofiller(aall["F81...S1M.LE.."])

=======
# Load required packages
library(MDstats)
library(MD3)

# Define zerofiller function
zerofiller=function(x, fillscalar=0){
  temp=copy(x)
  temp[onlyna=TRUE]=fillscalar
  temp
}

# Set data directory
if (!exists("data_dir")) data_dir = getwd()

aall <- readRDS(file.path(data_dir, "intermediate_domestic_data_files/aall_f51m.rds"))

tradecredits_al=mds('ECB/QSA/Q.N..W0+W1...N.A+L.LE.F81.T._Z.XDC._T.S.V.N._T')
saveRDS(tradecredits_al, file.path(data_dir, 'tradecredits_al.rds'))
bopf81q=mds('Estat/bop_iip6_q/Q.MIO_EUR.FA__D__F81+FA__O__F81+..S1.A_LE+L_LE.WRL_REST.')
bopf81_a=mds('Estat/bop_iip6_q/A.MIO_EUR.FA__D__F81+FA__O__F81+..S1.A_LE+L_LE.WRL_REST.')
saveRDS(bopf81q, file.path(data_dir, 'bopf81q.rds'))
bopf81a=copy(bopf81_a); frequency(bopf81a)='Q'
saveRDS(bopf81a, file.path(data_dir, 'bopf81a.rds'))

names(dimnames(tradecredits_al)) =gsub("^COUNTER.*$","COUNTERPART_SECTOR",names(dimnames(tradecredits_al)))
tradecredits_al=aperm(tradecredits_al,c("REF_AREA","REF_SECTOR","COUNTERPART_SECTOR","ACCOUNTING_ENTRY","TIME"))

tradecredits=tradecredits_al[...A.]

dimnames(tradecredits)$COUNTERPART_SECTOR = c(W0='S0' , W1='S2')[dimnames(tradecredits)$COUNTERPART_SECTOR]

tradecredits[.S2.S0.] =tradecredits_al[.S1.W1.L.]
tradecredits[.S2.S1.] =tradecredits_al[.S1.W1.L.]
tradecredits[.S1.S1.] = tradecredits[.S1.S0.] -tradecredits[.S1.S2.] 
tradecredits[.S0.S1.] = tradecredits[.S1.S1.] +tradecredits[.S2.S1.] 
saveRDS(tradecredits, file.path(data_dir, 'tradecredits.rds'))
gc()

tradecredits=add.dim(tradecredits,.dimname = 'FUNCTIONAL_CAT',.dimcodes = '_T')
dimnames(tradecredits)[[1]]='_T'

af81_=aall['F81....LE._T+_S+_D+_O.1999q1:']
af81=merge(tradecredits, af81_,along = 'FUNCTIONAL_CAT')

##check the following
af81['_D...S2.']<-af81['_D...S0.']

names(dimnames(bopf81a))[1]=names(dimnames(bopf81q))[1]='REF_AREA'  
names(dimnames(bopf81q))[2]=names(dimnames(bopf81a))[2]='REF_SECTOR'

af81['_F+_O+_P+_R....'] <- NA

################ASSETS
af81['_D...S2.',onlyna=TRUE]<-bopf81q["..A_LE.FA__D__F81.1998q4:"]
af81['_O...S2.',onlyna=TRUE]<-bopf81q["..A_LE.FA__O__F81.1998q4:"]

af81['_D...S2.',onlyna=TRUE]<-bopf81a["..A_LE.FA__D__F81.1998q4:"]
af81['_O...S2.',onlyna=TRUE]<-bopf81a["..A_LE.FA__O__F81.1998q4:"]

af81['_T...S2.',onlyna=TRUE]<-af81['_D...S2.']+af81['_O...S2.']
af81['_S...S2.',onlyna=TRUE]<-af81['_D...S2.']+af81['_O...S2.']

############LIABILITIES
bopf81q_liab=copy(bopf81q)
names(dimnames(bopf81q_liab))[2]='COUNTERPART_SECTOR'

bopf81a_liab=copy(bopf81a)
names(dimnames(bopf81a_liab))[2]='COUNTERPART_SECTOR'

af81['_D..S2..',onlyna=TRUE]<-bopf81q_liab["..L_LE.FA__D__F81.1998q4:"]
af81['_O..S2..',onlyna=TRUE]<-bopf81q_liab["..L_LE.FA__O__F81.1998q4:"]

af81['_D..S2..',onlyna=TRUE]<-bopf81a_liab["..L_LE.FA__D__F81.1998q4:"]
af81['_O..S2..',onlyna=TRUE]<-bopf81a_liab["..L_LE.FA__O__F81.1998q4:"]

af81['_T..S2..',onlyna=TRUE]<-af81['_D..S2..']+af81['_O..S2..']
af81['_S..S2..',onlyna=TRUE]<-af81['_D..S2..']+af81['_O..S2..']

af81['..S1..',onlyna=TRUE]<-af81['..S0..']-af81['..S2..']

af81['...S1.',onlyna=TRUE]<-af81['...S0.']-af81['...S2.']

######FILLING
aall[F81....LE..,onlyna=TRUE]<-af81[....]

aall[....._S.,onlyna=TRUE]<-aall[....._T.]

# Set all F81 sectors to 0 where S0 counterpart is 0
temp=aall["F81....LE.."]
temp[temp[,"S0",,,]==0]=0
temp[temp[,,"S0",,]==0]=0

aall["F81....LE..", onlyna=TRUE]<-temp

#### countries with nothing filled, everything goes to S11
aall["F81...S11.LE..", onlyna=TRUE]<-aall["F81...S1.LE.."]

#### all residual goes to S12O
aall["F81...S12O.LE..", onlyna=TRUE]<-aall["F81...S1.LE.."]-aall["F81...S11.LE.."]-zerofiller(aall["F81...S13.LE.."])-zerofiller(aall["F81...S1M.LE.."])

>>>>>>> 55a5a789115f3c6e93936ceaded19180b9724739
saveRDS(aall, file.path(data_dir, 'aall_f81.rds'))