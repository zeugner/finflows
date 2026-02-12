# ==============================================================================
# 015_F89.R
# Filling of F89 (other accounts) into aall
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
aall <- readRDS(file.path(data_dir, "intermediate_domestic_data_files/aall_f81.rds"))

otheraccounts <- readRDS(file.path(data_dir, "otheraccounts.rds"))
bopf89q <- readRDS(file.path(data_dir, "bopf89q.rds"))
bopf89a <- readRDS(file.path(data_dir, "bopf89a.rds"))

# --- Prepare working object ---
af89_=aall['F89....LE._T+_S+_O.1999q1:']
otheraccounts=add.dim(otheraccounts,.dimname = 'FUNCTIONAL_CAT',.dimcodes = '_T')
dimnames(otheraccounts)[[1]]='_T'
af89=merge(otheraccounts, af89_,along = 'FUNCTIONAL_CAT')

names(dimnames(bopf89a))[1]=names(dimnames(bopf89q))[1]='REF_AREA'  
names(dimnames(bopf89q))[2]=names(dimnames(bopf89a))[2]='REF_SECTOR'

af89['_O....'] <- NA

################ASSETS
af89['_O...S2.',onlyna=TRUE]<-bopf89q["..A_LE.1998q4:"]
af89['_O...S2.',onlyna=TRUE]<-bopf89a["..A_LE.1998q4:"]

af89['_T...S2.',onlyna=TRUE]<-af89['_O...S2.']
af89['_S...S2.',onlyna=TRUE]<-af89['_O...S2.']

############LIABILITIES
bopf89q_liab=copy(bopf89q)
names(dimnames(bopf89q_liab))[2]='COUNTERPART_SECTOR'

bopf89a_liab=copy(bopf89a)
names(dimnames(bopf89a_liab))[2]='COUNTERPART_SECTOR'

af89['_O..S2..',onlyna=TRUE]<-bopf89q_liab["..L_LE.1998q4:"]

af89['_O..S2..',onlyna=TRUE]<-bopf89a_liab["..L_LE.1998q4:"]

af89['_T..S2..',onlyna=TRUE]<-af89['_O..S2..']
af89['_S..S2..',onlyna=TRUE]<-af89['_O..S2..']

######FILLING
aall[F89....LE..,onlyna=TRUE]<-af89[....]

# Compute S1 residuals directly on aall (7 dimensions)
# Assets (REF_SECTOR position 3)
aall['F89..S1....', onlyna=TRUE] <- aall['F89..S0....'] - aall['F89..S2....']
# Liabilities (COUNTERPART_SECTOR position 4)
aall['F89...S1...', onlyna=TRUE] <- aall['F89...S0...'] - aall['F89...S2...']

aall[....._S.,onlyna=TRUE]<-aall[....._T.]

# Set all F89 sectors to 0 where S0 counterpart is 0
temp=aall["F89....LE.."]
temp[temp[,"S0",,,]==0]=0
temp[temp[,,"S0",,]==0]=0

aall["F89....LE..", onlyna=TRUE]<-temp

#### countries with nothing filled, everything goes to S13
aall["F89...S13.LE..", onlyna=TRUE]<-aall["F89...S1.LE.."]

#### all residual goes to S12O
aall["F89...S12O.LE..", onlyna=TRUE]<-aall["F89...S1.LE.."]-aall["F89...S11.LE.."]-zerofiller(aall["F89...S13.LE.."])-zerofiller(aall["F89...S1M.LE.."])-zerofiller(aall["F89...S12O.LE.."])-zerofiller(aall["F89...S12Q.LE.."])

saveRDS(aall, file.path(data_dir, 'intermediate_domestic_data_files/aall_f89.rds'))
