######################### F51M TREATMENT  #########################
# This script fills F51M (unlisted shares and other equity) data in the aall matrix
# using various data sources and economic assumptions to complete missing values

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
if (!exists("script_dir")) script_dir = getwd()
# Load the main aall matrix containing financial accounts data
aall=readRDS(file.path(data_dir, 'intermediate_domestic_data_files/aall_equity_bilateral_imf_gov.rds'))
gc()

aall[F5....LE._D.,onlyna=TRUE]=aall[F51....LE._D.]+zerofiller(aall[F52....LE._D.])
aall[F5+F51+F51M+F511+F512+F519..S1.S2.LE._D.,onlyna=TRUE]<-aall[F5+F51+F51M+F511+F512+F519..S1.S0.LE._D.]

### STRAIGHTFORWARD FILLINGS
aall["F512..S2.S2.._T."]=0
aall["F512..S0.S2.._T."]<-aall["F512..S1.S2.._T."]

aall["F519..S2.S2.._T."]=0
aall["F519..S0.S2.._T."]<-aall["F519..S1.S2.._T."]

aall["F51M..S2.S2.._D."]=0
aall["F51M..S2.S0.._D."]<-aall["F51M..S2.S1.._D."]
aall["F51M..S0.S2.._D."]<-aall["F51M..S1.S2.._D."]

aall["..S1.S1.._D."]<-0

### CENTRAL BANK HOLDINGS (source https://www.ecb.europa.eu/ecb/orga/capital/html/index.en.html )
ecb_capital_md3=readRDS(file.path(data_dir, 'ecb_capital_md3.rds'))
gc()

aall[F519..S121.S2.LE._O.,onlyna=TRUE]<-ecb_capital_md3

aall[F519.DE.S121.S2.LE._O.2024q4]

gc()

### unflagging necessary to get the "obs_status" away
aall=unflag(aall)
aall_S=as.data.table(aall,.simple=TRUE)
gc()
aallcast=dcast(aall_S, ... ~ FUNCTIONAL_CAT, id.vars=1:8, value.var = 'obs_value')
gc()

# Use _T when available, otherwise calculate sum
aallcast[['_S']] <- ifelse(
  !is.na(aallcast[['_T']]), 
  aallcast[['_T']],  # Use existing _T when available
  rowSums(aallcast[,c('_D','_P','_O')], na.rm=TRUE)  # Calculate from components when _T is missing
)
gc()

aallcast2=copy(aallcast[,intersect(c(colnames(aall_S),'_S'),colnames(aallcast)),with=FALSE])
gc()
colnames(aallcast2)[NCOL(aallcast2)]='obs_value'
gc()
aallcast2[,FUNCTIONAL_CAT:='_S']
gc()
aall_S=rbind(aall_S,aallcast2,fill=TRUE)
gc()     
aall_M=as.md3(aall_S)
gc()
aall=copy(aall_M)

gc()

aall[F51M....LE..,onlyna=TRUE]=aall[F512....LE..]+aall[F519....LE..]
aall[F51....LE..,onlyna=TRUE]=aall[F511....LE..]+aall[F51M....LE..]

interpol_assets <- aall["F51M..S121+S12Q+S124.S1+S2+S0.LE._T."]
interpol_liab <- aall["F51M..S1+S2+S0.S121+S12Q+S124+S1M.LE._T."]

source(file.path(script_dir, "domestic/013_bis_interpolate_F51m.R"))

aall["F51M..S121+S12Q+S124.S1+S2+S0.LE._T.", onlyna=TRUE]<-interpol_assets
aall["F51M..S1+S2+S0.S121+S12Q+S124+S1M.LE._T.", onlyna=TRUE]<-interpol_liab


### FILL COUNTERPART S1 (DOMESTIC ECONOMY) AS RESIDUAL FOR ALL OTHER SECTORS
aall["F51M...S1...",  onlyna=TRUE]<-aall["F51M...S0..."]-aall["F51M...S2..."]
aall["F51M..S1....",  onlyna=TRUE]<-aall["F51M..S0...."]-aall["F51M..S2...."]

gc()

### HOUSEHOLD (S1M) LIABILITIES ASSUMPTION
# Economic assumption: Households do not issue unlisted shares/equity
# Therefore, set all F51M stocks where S1M is the issuing sector to zero
aall["F51M..S0+S1+S11+S12T+S2+S1M.S1M.LE._S.2023q4"]  # CHECK: View before
aall["F51M...S1M...",  onlyna=TRUE] <- 0

################## FIRST STEP: MFI (S12T) HOLDINGS #################
# Check current data availability for MFIs vis-à-vis various sectors
aall[F51M..S12T.S1+S12O+S12T.LE._T.2023q4]  # CHECK: View S12T holdings
aall[F51M..S12T.S1+S12O+S12T.LE._S.2023q4]  # CHECK: View S12T holdings

### ASSUMPTION: Domestic MFI holdings of OFI listed shares
# We assume that listed shares of OFIs held by MFIs are only held by banks (S12K)
# and not by the central bank (S121)
# Therefore: F511..S12T.S12O = F511..S12K.S12O
# This assumes central banks don't hold OFI listed shares
# Therefore: S12T holdings = S12K holdings for F511 in OFI liabilities
aall[F511..S12T.S12O..., onlyna=TRUE] <- aall[F511..S12K.S12O...]

aall[F511..S12T+S12K.S12O.LE._S.2023q4]  # CHECK: Verify after filling

### COMPUTE F51M HOLDINGS BY S12T IN S12O
# Now calculate F51M as residual: F51 (total equity) - F511 (listed shares)
aall[F51+F511+F51M..S12T.S12O.LE._S.2022q4]  # CHECK: View components before
aall[F51M..S12T.S12O..., onlyna=TRUE] <- aall[F51..S12T.S12O...] - zerofiller(aall[F511..S12T.S12O...])
aall[F51+F511+F51M..S12T.S12O.LE._S.2023q4]  # CHECK: Verify calculation

###########################  ATTENTION MAYBE SHIFT LATER ############# QUITE STRONG ASSUMPTION...
### COMPUTE S12T HOLDINGS OF F51M IN S11 (NFC) LIABILITIES
# Now we can finally compute the residual and obtain S12T holdings of F51M in S11 (NFC) liabilities!
aall[F51M..S12T.S11+S1+S12T+S12O+S121+S13+S1M.LE._S.2023q4]  # CHECK: View before
aall[F51M..S12T.S11..., onlyna=TRUE] <- aall[F51M..S12T.S1...] - aall[F51M..S12T.S12T...] - zerofiller(aall[F51M..S12T.S12O...])
aall[F51M..S12T.S11+S1+S12T+S12O.LE._S.2023q4]  # CHECK: Verify after

#aall["F51M..S12T.S11..."][which(aall["F51M..S12T.S11..."] < 0)] <- 0

### CB Holdings of Government
# Economic assumption: Central banks do not hold equity in government sector
# CBs typically hold government debt, not equity
aall[F51M..S121.S13..., onlyna=TRUE] <- 0

###  CB Assets in S11
# Assumes all CB domestic assets (except self and government) are in NFC
# HERE WE ARE ASSUMING THAT CB ONLY HOLD UNLISTED EQUITY ISSUED BY NFCs and government, and not by MFIs. 
aall[F51M..S121.S11+S1+S121+S13+S12T+S12O.LE._S.2023q4]
aall[F51M..S121.S11..., onlyna=TRUE] = aall[F51M..S121.S1...] - zerofiller(aall[F51M..S121.S121...]) - zerofiller(aall[F51M..S121.S13...])
aall[F51M..S121.S11+S1+S121+S13.LE._S.2023q4]
### COMPUTE OFI HOLDINGS OF F51M IN S11 (NFC) LIABILITIES
# Once S12T is computed, calculate OFI as: S12 total - S12T (MFIs)
# Using this assumption, we can use S12.S11 instead of the sum of S12T+S12O.S11 (we lack both)
aall[F51M..S12O.S11..., onlyna=TRUE] = aall[F51M..S12.S11...] - zerofiller(aall[F51M..S12T.S11...]) - zerofiller(aall[F51M..S121.S11...])
aall[F51M..S12+S12T+S12O+S121.S11.LE._S.2023q4]  # CHECK: Verify all financial sector holdings

aall[F51M..S12O.S12T+S1+S11+S12O.LE._S.2023q4]
aall[F51M..S12O.S12T..., onlyna=TRUE] = aall[F51M..S12O.S1...] - zerofiller(aall[F51M..S12O.S11...]) - aall[F51M..S12O.S12O...]

### ATTENTION. BECAUSE OF ABOVE ASSUMPTIONS ON MFI holdings of NFC unlisted equity as residual AND/OR central bank holdings of NFC unlisted equity as residual,
### THE STEP BELOW IS NECESSARY BECAUSE
### for some countries (FI, HU, LT, RO), F51M.S12O.S11 is larger than F51M.S12O.S1 . 
### For France, the sum of F51M.S12O.S11 and F51M.S12O intrasector is greater than F51M.S12O.S1 (again impossible).
aall["F51M..S12O.S12T..."][which(aall["F51M..S12O.S12T..."] < 0)] <- 0
aall[F51M..S12O.S12T+S1+S11+S12O.LE._S.2023q4]

#### BEFORE PROCEEDING TO THIRD STEP: INTEGRATE COUNTRY-SPECIFIC DATA
# Load Italy-specific F51M data adjustments
source(file.path(script_dir, "domestic/F51M_IT.R"))

aall[F51M.DE.S12O.S12T.LE._S., onlyna=TRUE]= aall[F51M.DE.S12O.S12T.LE._T., onlyna=TRUE]=0

################## THIRD STEP: HOUSEHOLD HOLDINGS ##################
# Calculate household holdings in financial sector liabilities

### ASSUMPTION: HH F51M holdings in financial sector are only in OFI liabilities
# Households are assumed to hold unlisted equity only in OFIs, not in banks or CB
aall[F51M..S1M.S12O..., onlyna=TRUE] <- aall[F51M..S1M.S12...]

### Set banks and central banks holdings by households TO ZERO
aall[F51M..S1M.S121..., onlyna=TRUE] = aall[F51M..S1M.S12...] - aall[F51M..S1M.S12O...]
aall[F51M..S1M.S12T..., onlyna=TRUE] = aall[F51M..S1M.S12...] - aall[F51M..S1M.S12O...]
aall[F51M..S1M.S12K..., onlyna=TRUE] = aall[F51M..S1M.S12...] - aall[F51M..S1M.S12O...]

aall[F51M..S1M.S12+S12O+S121+S12T+S12K.LE._S.2023q4]  # CHECK: Verify all HH holdings

### 1. CENTRAL BANK EQUITY ASSUMPTION
# Any F51 equity of CB MUST be F51M (unlisted) and not F511 (listed)
# Central banks do not issue listed shares

aall["F51..S0.S121.LE.."][which(aall["F51..S0.S121.LE.."] <0)] <- 0
aall[F511..S0.S121.LE._S.2022q4]

aall[F51M..S0.S121.LE._S.2022q4]
### cbs do not have listed equities in their liabilities, only F51M
aall[F51M..S0.S121..., onlyna=TRUE] <-aall[F51..S0.S121...]
aall["F51M..S0.S121.LE.."][which(aall["F51M..S0.S121.LE.."] <0)] <- 0

### 2. COMPUTE F51M.S0.S12T AS RESIDUAL
# S12K (all MFIs) = S12T (banks) + S121 (central bank)
# Therefore: S12T = S12K - S121
aall[F51M..S0.S12T.LE._S.2023q4]
aall[F51M..S0.S12T..., onlyna=TRUE] <-aall[F51M..S0.S12K...]-aall[F51M..S0.S121...]
aall["F51M..S0.S12T.LE.."][which(aall["F51M..S0.S12T.LE.."] <0)] <- 0
aall[F51M..S1.S12T.LE._S.2023q4]
### 3. COMPUTE F51M.S1.S12T AS RESIDUAL
# S0 = S1 + S2, therefore: S1 = S0 - S2
aall[F51M..S1.S12T..., onlyna=TRUE] <-aall[F51M..S0.S12T...]-aall[F51M..S2.S12T...]
aall["F51M..S1.S12T.LE.."][which(aall["F51M..S1.S12T.LE.."] <0)] <- 0

# Check the calculation
aall[F51M..S11+S1+S12T+S12O.S12T.LE._S.2023q4]  # CHECK: Verify S12T liabilities

### COMPLETE THE MATRIX F51M.S0+S1+S2.S12K+S12T+S121
aall[F51M.AT.S0+S1+S2.S12K+S12T+S121.LE._S.2022q4]  # CHECK: View matrix for Austria

# Since S2.S121 = 0 (no foreign holdings of CB equity), then S2.S12K = S2.S12T
aall[F51M..S2.S12K..., onlyna=TRUE] <-aall[F51M..S2.S12T...]

# Calculate S1.S12K as residual: S0 - S2
aall[F51M..S1.S12K..., onlyna=TRUE] <-aall[F51M..S0.S12K...]-aall[F51M..S2.S12K...]

### Calculate S1.S121 as residual: S12K-S12T
aall[F51M..S1.S121..., onlyna=TRUE] <-aall[F51M..S1.S12K...]-aall[F51M..S1.S12T...]

aall[F51M..S2.S121..., onlyna=TRUE] <-aall[F51M..S2.S12K...]-aall[F51M..S2.S12T...]

### CALCULATE S11 (NFC) HOLDINGS OF S12T (MFI) LIABILITIES
# Residual: S1 total - S12T self - S12O other financials
aall[F51M..S11.S12T..., onlyna=TRUE] <- aall[F51M..S1.S12T...] - zerofiller(aall[F51M..S12T.S12T...]) - zerofiller(aall[F51M..S12O.S12T...])
aall[F51M..S11+S1+S12T+S12O.S12T.LE._S.2023q4]  # CHECK: Verify calculation

#####HERE WE HAVE A PROBLEM!!!!!! S120.S12T IS TOO BIG AS ABOVE!!!!!
#### SO A LOT OF NEGATIVE S11!!!

aall["F51M..S11.S12T..."][which(aall["F51M..S11.S12T..."] < 0)] <-0

### NFC HOLDINGS IN OFI LIABILITIES
# Residual: NFC total assets - NFC self - NFC holdings in MFI
aall[F51M..S11.S12O..., usenames=TRUE, onlyna=TRUE] = aall[F51M..S11.S1...] - zerofiller(aall[F51M..S11.S11...]) - zerofiller(aall[F51M..S11.S12T...])

aall[F51M..S11.S12O+S1+S11+S12T.LE._S.2022q4]  # CHECK: Verify NFC holdings of OFI
aall["F51M..S11.S12O..."][which(aall["F51M..S11.S12O..."]< 0)] <-0

############## HOUSEHOLD RESIDUAL CALCULATIONS

### HH IN NFC: Calculate as residual
# Liabilities of NFC - self NFC - OFI in NFC - MFI in NFC
aall[F51M..S1M+S1+S12O+S12T.S11.LE._S.2022q4]  # CHECK: View before
aall[F51M..S1M.S11..., usenames=TRUE, onlyna=TRUE]=aall[F51M..S1.S11...]-zerofiller(aall[F51M..S11.S11...])-zerofiller(aall[F51M..S12O.S11...])-zerofiller(aall[F51M..S12T.S11...])

### S12T.S12Q (Insurance) Calculation
# Calculate MFI holdings of insurance sector as residual
aall[F51M..S12T.S12Q+S12T+S1+S12O+S11.LE._S.2022q4]  # CHECK: View before calculation
aall[F51M..S12T.S12Q..., onlyna=TRUE] <- aall[F51M..S12T.S1...] - 
  zerofiller(aall[F51M..S12T.S12T...]) - zerofiller(aall[F51M..S12T.S11...]) - zerofiller(aall[F51M..S12T.S12O...])
aall[F51M..S12T.S12Q.LE..][which(aall[F51M..S12T.S12Q.LE..]<0)]<-0

###  S12T.S13 (Government) Calculation
# Any remainder after accounting for all financial and non-financial sectors
# goes to government sector holdings
aall[F51M..S12T.S13..., onlyna=TRUE] <- aall[F51M..S12T.S1...] - 
  zerofiller(aall[F51M..S12T.S12T...]) - zerofiller(aall[F51M..S12T.S11...]) - 
  zerofiller(aall[F51M..S12T.S12O...]) - zerofiller(aall[F51M..S12T.S12Q...])

aall[F51M..S12O+S1+S1M+S11+S12T+S124+S12Q+S13.S13.LE._S.2023q4]
aall[F51M..S12T.S13.LE..][which(aall[F51M..S12T.S13.LE..]<0)] <- 0

###  OFI Holdings of Government
# Calculate as residual: Total domestic - all other sectors
aall[F51M..S12O.S13..., onlyna=TRUE] = aall[F51M..S1.S13...] - zerofiller(aall[F51M..S1M.S13...])- zerofiller(aall[F51M..S11.S13...])- zerofiller(aall[F51M..S12T.S13...])- zerofiller(aall[F51M..S124.S13...])- zerofiller(aall[F51M..S12Q.S13...])- zerofiller(aall[F51M..S13.S13...])
aall[F51M..S12O.S13.LE._S.2022q4]

###  NFC Holdings of CB
# Economic assumption: NFCs do not hold equity in central banks
aall[F51M..S11.S121..., onlyna=TRUE] = 0

###  Banks Holdings of CB
# Economic assumption: Commercial banks do not hold equity in central banks
aall[F51M..S12T.S121..., onlyna=TRUE] = 0

### Government Holdings of CB
# Calculate government holdings of CB equity as residual
aall[F51M..S13.S121..., onlyna=TRUE] = aall[F51M..S1.S121...] - zerofiller(aall[F51M..S1M.S121...]) - zerofiller(aall[F51M..S11.S121...])- zerofiller(aall[F51M..S121.S121...])- zerofiller(aall[F51M..S12T.S121...])- zerofiller(aall[F51M..S124.S121...])-- zerofiller(aall[F51M..S12Q.S121...])- zerofiller(aall[F51M..S12O.S121...])
aall[F51M..S13.S121.LE._S.2022q4]

aall["F51M..S13.S121..."][which(aall["F51M..S13.S121..."]<0)]<-0

### Set remaining sectors' holdings of CB to zero
aall[F51M..S1M+S11+S121+S12T+S124+S12Q+S12O.S121..., onlyna=TRUE] = 0

# First set all the zero assumptions for S124
# MFI holdings of S124 - Banks don't typically hold non-MMF fund equity
aall[F51M..S12T.S124..., onlyna=TRUE] = 0

# NFC holdings of S124 - NFCs don't typically hold investment fund equity
aall[F51M..S11.S124..., onlyna=TRUE] = 0

# HH holdings of S124 and S12Q
aall[F51M..S1M.S124+S12Q..., onlyna=TRUE] = 0

# Insurance and government holdings of S124
aall[F51M..S12Q+S13.S124..., onlyna=TRUE] = 0

# NOW calculate OFI holdings of S124 as residual (after setting the zeros)
aall[F51M..S12O.S124..., onlyna=TRUE] = aall[F51M..S1.S124...] - zerofiller(aall[F51M..S1.S12T...])- zerofiller(aall[F51M..S12Q.S12T...])- zerofiller(aall[F51M..S13.S12T...])-- zerofiller(aall[F51M..S1M.S12T...])- zerofiller(aall[F51M..S11.S12T...])
aall[F51M..S12O.S124.LE._S.2022q4]

aall["F51M..S12O.S124.LE.."][which(aall["F51M..S12O.S124.LE.."]<0)] <- 0

### S12Q (Insurance) Interconnections
# Insurance doesn't hold MFI unlisted equity directly
aall[F51M..S12Q.S12T..., onlyna=TRUE] <- 0

# NFC and S124 don't hold insurance unlisted equity
aall[F51M..S11+S124.S12Q..., onlyna=TRUE] <- 0

### OFI Holdings of Insurance
# Calculate OFI holdings in insurance as residual
aall[F51M..S12O.S12Q..., onlyna=TRUE] = aall[F51M..S12O.S1...] - zerofiller(aall[F51M..S12O.S11...])-zerofiller(aall[F51M..S12O.S121...])-zerofiller(aall[F51M..S12O.S12T...])-zerofiller(aall[F51M..S12O.S124...])-zerofiller(aall[F51M..S12O.S12O...])-zerofiller(aall[F51M..S12O.S13...])
aall[F51M..S12O.S12Q+S11+S121+S12T+S124+S12O+S13.LE._S.2022q4]
aall[F51M..S12O.S12Q...][which(aall[F51M..S12O.S12Q...]<0)]<-0  

saveRDS(aall, file.path(data_dir, 'intermediate_domestic_data_files/aall_f51m.rds'))

aall[F51M.AT.S0+S1+S11+S12+S121+S124+S12K+S12Q+S12R+S12T+S13+S1M+S2.S1+S11+S121+S124+S12K+S12T+S13+S1M+S0+S12+S2.LE._S.2022q4]

aall[F51M.IT.S0+S1+S11+S12+S121+S124+S12K+S12Q+S12R+S12T+S13+S1M+S2.S1+S11+S121+S124+S12K+S12T+S13+S1M+S0+S12+S2.LE._S.2022q4]

aall[F51M.DE.S0+S1+S11+S12+S121+S124+S12K+S12Q+S12R+S12T+S13+S1M+S2.S1+S11+S121+S124+S12K+S12T+S13+S1M+S0+S12+S2.LE._S.2022q4]

aall[F51M.AT.S0+S1+S11+S12+S121+S124+S12K+S12Q+S12R+S12T+S13+S1M+S2.S1+S0+S2.LE._S.2022q4]

aall["F51M.AT.S12T.S1+S0+S2.LE._S+_T.2022q4"]
