# ==============================================================================
# 014_F81.R
# Filling of F81 (trade credits) into aall
# Requires: 012_loading_F81_F89_F6.R to have been run first
# ==============================================================================

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

# --- Load previously saved data ---
aall <- readRDS(file.path(data_dir, "intermediate_domestic_data_files/aall_f51m.rds"))

tradecredits <- readRDS(file.path(data_dir, "tradecredits.rds"))
bopf81q <- readRDS(file.path(data_dir, "bopf81q.rds"))
bopf81a <- readRDS(file.path(data_dir, "bopf81a.rds"))

# --- Prepare working object ---
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

# Fill aall with af81 
aall[F81....LE.., onlyna=TRUE] <- af81[....]

# Compute S1 residuals 
# Assets 
aall['F81..S1....', onlyna=TRUE] <- aall['F81..S0....'] - aall['F81..S2....']

# Liabilities 
aall['F81...S1...', onlyna=TRUE] <- aall['F81...S0...'] - aall['F81...S2...']

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

saveRDS(aall, file.path(data_dir, 'intermediate_domestic_data_files/aall_f81.rds'))
