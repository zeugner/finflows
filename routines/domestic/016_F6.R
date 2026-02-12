# ==============================================================================
# 016_F6.R
# Filling of F6 (insurance & pensions) into aall
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

if (!exists("data_dir")) data_dir = getwd()

# --- Load previously saved data ---
aall <- readRDS(file.path(data_dir, "intermediate_domestic_data_files/aall_f89.rds"));gc()

insurancepensions <- readRDS(file.path(data_dir, "insurancepensions.rds"))
bopf6a <- readRDS(file.path(data_dir, "bopf6a.rds"))
bopf6q <- readRDS(file.path(data_dir, "bopf6q.rds"))

# --- Prepare working object ---
af6_=aall['F6....LE._T+_S+_O.1999q1:']
insurancepensions=add.dim(insurancepensions,.dimname = 'FUNCTIONAL_CAT',.dimcodes = '_T')
dimnames(insurancepensions)[[1]]='_T'
af6=merge(insurancepensions, af6_,along = 'FUNCTIONAL_CAT')

names(dimnames(bopf6a))[1]=names(dimnames(bopf6q))[1]='REF_AREA'  
names(dimnames(bopf6q))[2]=names(dimnames(bopf6a))[2]='REF_SECTOR'

af6['_O....'] <- NA

################ASSETS
af6['_O...S2.',onlyna=TRUE]<-bopf6q["..A_LE.1998q4:"]
af6['_O...S2.',onlyna=TRUE]<-bopf6a["..A_LE.1998q4:"]

af6['_T...S2.',onlyna=TRUE]<-af6['_O...S2.']
af6['_S...S2.',onlyna=TRUE]<-af6['_O...S2.']

############LIABILITIES
bopf6q_liab=copy(bopf6q)
names(dimnames(bopf6q_liab))[2]='COUNTERPART_SECTOR'

bopf6a_liab=copy(bopf6a)
names(dimnames(bopf6a_liab))[2]='COUNTERPART_SECTOR'

af6['_O..S2..',onlyna=TRUE]<-bopf6q_liab["..L_LE.1998q4:"]

af6['_O..S2..',onlyna=TRUE]<-bopf6a_liab["..L_LE.1998q4:"]

af6['_T..S2..',onlyna=TRUE]<-af6['_O..S2..']
af6['_S..S2..',onlyna=TRUE]<-af6['_O..S2..']

######FILLING
aall[F6....LE..,onlyna=TRUE]<-af6[....]

# Compute S1 residuals directly on aall (7 dimensions)
# Assets (REF_SECTOR position 3)
aall['F6..S1....', onlyna=TRUE] <- aall['F6..S0....'] - aall['F6..S2....']
# Liabilities (COUNTERPART_SECTOR position 4)
aall['F6...S1...', onlyna=TRUE] <- aall['F6...S0...'] - aall['F6...S2...']

# Set all F6 sectors to 0 where S0 counterpart is 0
temp=aall["F6....LE.."]
temp[temp[,"S0",,,]==0]=0
temp[temp[,,"S0",,]==0]=0
aall["F6....LE..", onlyna=TRUE]<-temp

#### create object where we store ref sector S0 or S1
F6_total<-aall[F6..S0..LE..]
F6_total["...",onlyna=TRUE]<-aall[F6..S1..LE..]

#now we want to attribute to ref sector S1M the value of S0 or S1 for all CP sectors except S12Q 
#so we take the S1M.S12Q value
F6_S1M_S12Q<-aall[F6..S1M.S12Q.LE..]
aall[F6..S1M..LE..,onlyna=TRUE]<-F6_total
aall[F6..S1M.S12Q.LE..]<-F6_S1M_S12Q
aall[F6..S1M.S12Q.LE..,onlyna=TRUE]<-aall[F6..S1M.S1.LE..]-zerofiller(aall[F6..S1M.S121.LE..])-zerofiller(aall[F6..S1M.S12T.LE..])-zerofiller(aall[F6..S1M.S124.LE..])-zerofiller(aall[F6..S1M.S12O.LE..])-zerofiller(aall[F6..S1M.S12Q.LE..])-zerofiller(aall[F6..S1M.S13.LE..])-zerofiller(aall[F6..S1M.S11.LE..])-zerofiller(aall[F6..S1M.S1M.LE..])

saveRDS(aall, file.path(data_dir, 'intermediate_domestic_data_files/aall_F6.rds'))

aall[....._T.,onlyna=TRUE]<-aall[....._S.]

saveRDS(aall, file.path(data_dir, 'intermediate_domestic_data_files/aall_domestic.rds'))
