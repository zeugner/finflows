######################### F51M TREATMENT  #########################
# This script fills F51M (unlisted shares and other equity) data in the aall matrix
# using various data sources and economic assumptions to complete missing values

# Load required packages
library(MDstats)
library(MD3)
library(data.table)

# Define zerofiller function
zerofiller=function(x, fillscalar=0){
  temp=copy(x)
  temp[onlyna=TRUE]=fillscalar
  temp
}

# Toggle: set to TRUE to apply LP balancing, FALSE to skip
APPLY_F51M_BALANCING <- TRUE

# Set data directory
if (!exists("data_dir")) data_dir = getwd()
if (!exists("script_dir")) script_dir = getwd()
# Load the main aall matrix containing financial accounts data
aall=readRDS(file.path(data_dir, 'intermediate_domestic_data_files/aall_equity_bilateral_imf_gov.rds'))
aall["F51M+F512+F519....LE.."][which(aall["F51M+F512+F519....LE.."]<0)] <- 0
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

aall["F519.CZ.S121.S2+S0.LE._O+_T.2024q4"]

gc()
dimnames(aall)

aall[F51M.CZ+EA20.S1+S1M+S13+S11+S121+S12T+S124+S12Q+S12O+S12K.S2.LE._S.2023q4]
aall[F51M.CZ+EA20.S1+S1M+S13+S11+S121+S12T+S124+S12Q+S12O+S12K.S2.LE._T.2023q4]

### unflagging necessary to get the "obs_status" away
aall=unflag(aall)
aall_S=as.data.table(aall,.simple=TRUE)
gc()
aallcast=dcast(aall_S, ... ~ FUNCTIONAL_CAT, id.vars=1:8, value.var = 'obs_value')
gc()

# Use _T when available, otherwise calculate sum
components <- aallcast[, c('_D','_P','_O')]
all_na <- rowSums(is.na(components)) == ncol(components)
sum_components <- rowSums(components, na.rm=TRUE)
sum_components[all_na] <- NA_real_

aallcast[['_S']] <- ifelse(
  !is.na(aallcast[['_T']]),
  aallcast[['_T']],
  sum_components
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

aall[F51M.CZ+EA20.S1+S1M+S13+S11+S121+S12T+S124+S12Q+S12O+S12K.S2.LE._S.2023q4]
aall[F51M.CZ+EA20.S1+S1M+S13+S11+S121+S12T+S124+S12Q+S12O+S12K.S2.LE._T.2023q4]


aall[F51M....LE..,onlyna=TRUE]=aall[F512....LE..]+aall[F519....LE..]
aall[F51....LE..,onlyna=TRUE]=aall[F511....LE..]+aall[F51M....LE..]

interpol_assets <- aall["F51M..S121+S12Q+S124.S1+S2+S0.LE._T."]
interpol_liab <- aall["F51M..S1+S2+S0.S121+S12Q+S124+S1M.LE._T."]

source(file.path(script_dir, "domestic/013_bis_interpolate_F51m.R"))

aall["F51M..S121+S12Q+S124.S1+S2+S0.LE._T.", onlyna=TRUE]<-interpol_assets
aall["F51M..S1+S2+S0.S121+S12Q+S124+S1M.LE._T.", onlyna=TRUE]<-interpol_liab

aall["F51M..S12T.S1...",  onlyna=TRUE]<-aall["F51M..S12T.S0..."]-aall["F51M..S12T.S2..."]
aall["F51M..S1.S2..."]<-aall["F51M..S1.S0..."]-aall["F51M..S1.S1..."]
aall["F51M..S2.S12K...",  onlyna=TRUE]<-aall["F51M..S2.S12T..."]+aall["F51M..S2.S121..."]

### FILL COUNTERPART S1 (DOMESTIC ECONOMY) AS RESIDUAL FOR ALL OTHER SECTORS
#aall["F51M...S1...",  onlyna=TRUE]<-aall["F51M...S0..."]-aall["F51M...S2..."] #later
aall["F51M..S1....",  onlyna=TRUE]<-aall["F51M..S0...."]-aall["F51M..S2...."]

gc()

### HOUSEHOLD (S1M) LIABILITIES ASSUMPTION
# Economic assumption: Households do not issue unlisted shares/equity
# Therefore, set all F51M stocks where S1M is the issuing sector to zero
aall["F51M..S0+S1+S11+S12T+S2+S1M.S1M.LE._S.2023q4"]  # CHECK: View before
aall["F51M...S1M...",  onlyna=TRUE] <- 0


### Maximise 


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
# MT has negative F51 so negative F51M as well
aall[F51M..S12T.S12O...][which(aall[F51M..S12T.S12O...]<0)] <- 0

### S12Q liabilities, assumptions: not held by S11, S124, S1M, note: S12T can exist for FR, NL, BE 

aall[F51M.EA20+CZ.S0+S1+S2.S12Q.LE._S.2023q4]
#f51m.s1.s12q only there for some countries (no germany, no ea20!)
#so we have to fill s2.s12q first - bop_iip, then residual

s12q_foreign_liab <-mds('Estat/bop_iip6_q/Q.MIO_EUR.FA__D__F51M+FA__O__F519+FA__P__F512.S12Q.S1.L_LE.EXT_EA20+WRL_REST.')
s12q_foreign_liab[..F51M.]<-s12q_foreign_liab[..FA__D__F51M.]+s12q_foreign_liab[..FA__O__F519.]+s12q_foreign_liab[..FA__O__F519.]

#s12q_foreign_liab[.WRL_REST..2012q4]

# s12q_foreign_liab[DE+EA20..2024q4]

names(dimnames(s12q_foreign_liab))[1] = 'REF_AREA'
names(dimnames(s12q_foreign_liab))[2] = 'COUNTERPART_AREA'
names(dimnames(s12q_foreign_liab))[3] = 'INSTR'
dimnames(s12q_foreign_liab)

aall[F51M.EA20.S2.S12Q.LE._S., onlyna=TRUE]<-s12q_foreign_liab[EA20.EXT_EA20.F51M.]
aall[F51M.EA20.S2.S12Q.LE._T., onlyna=TRUE]<-s12q_foreign_liab[EA20.EXT_EA20.F51M.]
aall[F51M.EA20.S2.S12Q.LE._D., onlyna=TRUE]<-s12q_foreign_liab[EA20.EXT_EA20.F51M.]

aall[F51M..S2.S12Q.LE._S., onlyna=TRUE]<-s12q_foreign_liab[.WRL_REST.F51M.]
aall[F51M..S2.S12Q.LE._T., onlyna=TRUE]<-s12q_foreign_liab[.WRL_REST.F51M.]
aall[F51M..S2.S12Q.LE._D., onlyna=TRUE]<-s12q_foreign_liab[.WRL_REST.F51M.]

aall[F51M..S1.S12Q.LE.., onlyna=TRUE] <- aall[F51M..S0.S12Q.LE..] - aall[F51M..S2.S12Q.LE..]
aall[F51M..S1.S12Q.LE..][which(aall[F51M..S1.S12Q.LE..]<0)] <- 0 


# also, solve occasionnal problem with S12O.S12Q: S1 too low (S2 too high?)
# Quick fix: lower bound of S1.S12Q is sum of sectors

# Primitive solution, improve later
x <- as.data.table(aall[F51M..S1.S12Q...])

test <- copy(x)

test[, obs_value := pmax(
  x$obs_value,
  as.data.table(aall[F51M..S12Q.S12Q...])$obs_value + as.data.table(zerofiller(aall[F51M..S121.S12Q...]))$obs_value
  + as.data.table(zerofiller(aall[F51M..S11.S12Q...]))$obs_value + as.data.table(zerofiller(aall[F51M..S13.S12Q...]))$obs_value + as.data.table(zerofiller(aall[F51M..S12T.S12Q...]))$obs_value
  + as.data.table(zerofiller(aall[F51M..S124.S12Q...]))$obs_value + as.data.table(zerofiller(aall[F51M..S1M.S12Q...]))$obs_value
  + as.data.table(zerofiller(aall[F51M..S12O.S12Q...]))$obs_value)]

test <- as.md3(test)

aall[F51M..S1.S12Q...] <- test["..."]


aall[F51M.EA20+CZ.S0+S1+S2.S12Q.LE._S.2023q4]
#liab of s12q
aall[F51M.CZ..S12Q.LE._S.2023q4]
aall[F51M.EA20..S12Q.LE._S.2023q4]
aall[F51M..S12O.S12Q..., onlyna=TRUE] <- aall[F51M..S1.S12Q...] - aall[F51M..S12Q.S12Q...] - zerofiller(aall[F51M..S13.S12Q...]) - 
  zerofiller(aall[F51M..S1M.S12Q...]) - zerofiller(aall[F51M..S11.S12Q...]) - zerofiller(aall[F51M..S121.S12Q...]) - 
  zerofiller(aall[F51M..S12T.S12Q...]) - zerofiller(aall[F51M..S124.S12Q...])


aall[F51M.CZ+EA20.S12O.S12Q.LE._S.2023q4]
### now we fill all liabilities of S2
aall[F51M.CZ+EA20.S1+S1M+S13+S11+S121+S12T+S124+S12Q+S12O+S12K.S2.LE._S.2023q4]
aall[F51M.CZ+EA20.S1+S1M+S13+S11+S121+S12T+S124+S12Q+S12O+S12K.S2.LE._T.2023q4]

###ISSUE HERE! UNFORTUNATELY FROM QSA, F51M.S1.S0.FND IS FULL OF ZEROS...
### THIS REFLECTS INTO F51M.S1.S2.FND AND THEREFORE INTO F51M.S1.S2._S AND F51M.S1.S2._T
### BUT THESE ZEROS ARE NOT REAL. SO WE HAVE TO REPLACE THEM WITH EUROSTAT IIP BOP!!!

# Load BoP-IIP country-level data (quarterly and annual)
bopf51ma = readRDS(file.path(data_dir, 'bopf51ma.rds'))
bopf51mq = readRDS(file.path(data_dir, 'bopf51mq.rds'))

# Rename source dimensions. 
names(dimnames(bopf51ma))[1] = names(dimnames(bopf51mq))[1] = 'REF_AREA'
names(dimnames(bopf51mq))[2] = 'REF_SECTOR'
names(dimnames(bopf51ma))[2] = 'REF_SECTOR'

# Load BoP-IIP euro area aggregates dataset
bop_iip_eu = mds('ESTAT/bop_eu6_q/........')

gc()
saveRDS(bop_iip_eu, file.path(data_dir, 'domestic_loading_data_files/bop_iip_eu.rds'))

# Filter EA aggregates: geo=EAxx, partner=EXT_EAxx, sector10 open, ASS, NSA,
# F51M direct + F519 other. F512 (portfolio listed shares) is not available
# in this dataset.
euroaggregates_y = bop_iip_eu["EA19+EA20+EA21.EXT_EA19+EXT_EA20+EXT_EA21.S1..ASS.NSA.FA__D__F51M+FA__O__F519.1999+2000+2001+2002+2003+2004+2005+2006+2007+2008+2009+2010+2011+2012+2013+2014+2015+2016+2017+2018+2019+2020+2021+2022+2023+2024+2025"]

euroaggregates_q = bop_iip_eu["EA19+EA20+EA21.EXT_EA19+EXT_EA20+EXT_EA21.S1..ASS.NSA.FA__D__F51M+FA__O__F519.1999q4+2000q1+2000q2+2000q3+2000q4+2001q1+2001q2+2001q3+2001q4+2002q1+2002q2+2002q3+2002q4+2003q1+2003q2+2003q3+2003q4+2004q1+2004q2+2004q3+2004q4+2005q1+2005q2+2005q3+2005q4+2006q1+2006q2+2006q3+2006q4+2007q1+2007q2+2007q3+2007q4+2008q1+2008q2+2008q3+2008q4+2009q1+2009q2+2009q3+2009q4+2010q1+2010q2+2010q3+2010q4+2011q1+2011q2+2011q3+2011q4+2012q1+2012q2+2012q3+2012q4+2013q1+2013q2+2013q3+2013q4+2014q1+2014q2+2014q3+2014q4+2015q1+2015q2+2015q3+2015q4+2016q1+2016q2+2016q3+2016q4+2017q1+2017q2+2017q3+2017q4+2018q1+2018q2+2018q3+2018q4+2019q1+2019q2+2019q3+2019q4+2020q1+2020q2+2020q3+2020q4+2021q1+2021q2+2021q3+2021q4+2022q1+2022q2+2022q3+2022q4+2023q1+2023q2+2023q3+2023q4+2024q1+2024q2+2024q3+2024q4+2025q1+2025q2+2025q3+2025q4"]
frequency(euroaggregates_y) = 'Q'
# Keep only the diagonal pairs (EA19+EXT_EA19, EA20+EXT_EA20, EA21+EXT_EA21),
# rename geo->REF_AREA and sector10->REF_SECTOR, drop partner.
to_aall_dims = function(x){
  dt = as.data.table(x, .simple=TRUE)
  dt = dt[(geo == "EA19" & partner == "EXT_EA19") |
            (geo == "EA20" & partner == "EXT_EA20") |
            (geo == "EA21" & partner == "EXT_EA21")]
  dt[, partner := NULL]
  setnames(dt, c("geo", "sector10"), c("REF_AREA", "REF_SECTOR"))
  as.md3(dt)
}
ea_q = to_aall_dims(euroaggregates_q)
ea_y = to_aall_dims(euroaggregates_y)

# STEP 1: Replace spurious zeros with NA in target slices.
# Spurious zeros originate from the QSA loader assigning F51M.S1.S0 entries
# to S2 as zero rather than as missing data, in the QSA loading step.
# Approach: wipe each slice to NA, then restore the non-zero values via onlyna fill.
for (fc in c("_T", "_S")) {
  slice_id = paste0("F51M...S2.LE.", fc, ".")
  
  dt_orig = as.data.table(aall[slice_id], .simple=TRUE)
  dt_keep = dt_orig[!is.na(obs_value) & obs_value != 0]
  
  aall[slice_id] = NA
  
  if (nrow(dt_keep) > 0) {
    md3_keep = as.md3(dt_keep)
    aall[slice_id, onlyna=TRUE] = md3_keep
  }
}

# Verification 1: count remaining zeros in target slices.
# Both numbers should be 0 after STEP 1.
cat("Zeros remaining in _T slice:",
    sum(as.data.table(aall["F51M...S2.LE._T."], .simple=TRUE)$obs_value == 0, na.rm=TRUE), "\n")
cat("Zeros remaining in _S slice:",
    sum(as.data.table(aall["F51M...S2.LE._S."], .simple=TRUE)$obs_value == 0, na.rm=TRUE), "\n")

# STEP 2: Fill NAs (original + ex-zeros) using BoP-IIP asset-side data.
# Priority order (each step only fills remaining NAs):
#   (a) country-level quarterly
#   (b) country-level annual
#   (c) EA aggregate quarterly
#   (d) EA aggregate annual
# Same value applied to _T and _S.
for (fc in c("_T", "_S")) {
  slice_id = paste0("F51M...S2.LE.", fc, ".")
  
  # (a) Country-level quarterly fill
  aall[slice_id, onlyna=TRUE] = 
    bopf51mq["..A_LE.FA__D__F51M.1998q4:"] +
    zerofiller(bopf51mq["..A_LE.FA__O__F519.1998q4:"]) +
    zerofiller(bopf51mq["..A_LE.FA__P__F512.1998q4:"])
  
  # (b) Country-level annual fill (fallback for missing quarterly)
  aall[slice_id, onlyna=TRUE] = 
    bopf51ma["..A_LE.FA__D__F51M.1998q4:"] +
    zerofiller(bopf51ma["..A_LE.FA__O__F519.1998q4:"]) +
    zerofiller(bopf51ma["..A_LE.FA__P__F512.1998q4:"])
  
  # (c) EA aggregate quarterly fill (F512 not available in this dataset)
  aall[slice_id, onlyna=TRUE] = 
    ea_q["..FA__D__F51M."] +
    zerofiller(ea_q["..FA__O__F519."])
  
  # (d) EA aggregate annual fill
  aall[slice_id, onlyna=TRUE] = 
    ea_y["..FA__D__F51M."] +
    zerofiller(ea_y["..FA__O__F519."])
}

# Verification 2: country-level inspection
cat("\n--- CZ and EA20, _T, 2023q4 ---\n")
print(aall["F51M.CZ+EA20.S1+S1M+S13+S11+S121+S12T+S124+S12Q+S12O+S12K.S2.LE._T.2023q4"])

cat("\n--- CZ and EA20, _S, 2023q4 ---\n")
print(aall["F51M.CZ+EA20.S1+S1M+S13+S11+S121+S12T+S124+S12Q+S12O+S12K.S2.LE._S.2023q4"])

# Verification 3: EA aggregates inspection
cat("\n--- EA19, EA20, EA21, _T, 2022q4 (filled by step c) ---\n")
print(aall["F51M.EA19+EA20+EA21.S1+S1M+S11+S124+S12O+S12Q.S2.LE._T.2022q4"])

cat("\n--- EA19, EA20, EA21, _T, 2022 annual (filled by step d) ---\n")
print(aall["F51M.EA19+EA20+EA21.S1+S1M+S11+S124+S12O+S12Q.S2.LE._T.2022"])


### now fill s1 as residuals
aall["F51M...S1...",  onlyna=TRUE]<-aall["F51M...S0..."]-aall["F51M...S2..."] 


## Cap S2 at S0 - This causes issues mostly for IE and SK only 
# aall["F51M..S2...."][which(aall["F51M..S1...."]<0)] <- aall["F51M..S0...."]
# aall["F51M...S2..."][which(aall["F51M...S1..."]<0)] <- aall["F51M...S0..."]

aall["F51M...S1.LE.."][which(aall["F51M...S1.LE.."]<0)] <- 0 
aall["F51M..S1..LE.."][which(aall["F51M..S1..LE.."]<0)] <- 0

aall["F51M..S12K.S1...",  onlyna=TRUE]<-aall["F51M..S12T.S1..."]+aall["F51M..S121.S1..."] 
aall["F51M..S12K.S2...",  onlyna=TRUE]<-aall["F51M..S12K.S0..."]+aall["F51M..S12K.S1..."]
aall["F51M.CZ.S1+S1M+S13+S11+S121+S12T+S124+S12Q+S12O+S12K.S0+S2+S1.LE._S.2023q4"]
aall["F51M.EA20.S1+S1M+S13+S11+S121+S12T+S124+S12Q+S12O+S12K.S0+S2+S1.LE._S.2023q4"]


### S12T assets, assumptions: only holds unlisted equity issued by S12O, S11, and S12T, maybe S13 for some bad banks
# For banks where S12T.S12O not present

aall[F51M..S12T.S12O..., onlyna=TRUE] = aall[F51M..S12T.S1...]  - aall[F51M..S12T.S12T...] - zerofiller(aall[F51M..S12T.S11...]) -
  zerofiller(aall[F51M..S12T.S13...]) - zerofiller(aall[F51M..S12T.S1M...]) - zerofiller(aall[F51M..S12T.S121...]) -
  zerofiller(aall[F51M..S12T.S124...]) - zerofiller(aall[F51M..S12T.S12Q...])

# s124 assets: mainly S11
aall[F51M..S124.S11..., onlyna=TRUE] = aall[F51M..S124.S1...]  - aall[F51M..S124.S124...] - zerofiller(aall[F51M..S124.S12T...]) -
  zerofiller(aall[F51M..S124.S13...]) - zerofiller(aall[F51M..S124.S1M...]) - zerofiller(aall[F51M..S124.S121...]) -
  zerofiller(aall[F51M..S124.S12O...]) - zerofiller(aall[F51M..S124.S12Q...])


# ok now the liabilities of s11
# let us start by calculating s1m.s11 by maximum enthropy

aall[F519+F512+F51M.CZ.S1M+S0.S11+S0+S12O.LE._T.2023q4]

aall[F519..S1M.S11...] = aall[F519..S1M.S0...] * (aall[F519..S0.S11...] / (aall[F519..S0.S11...] + aall[F519..S0.S12O...]))
aall[F519..S1M.S12O...] = aall[F519..S1M.S0...] * (aall[F519..S0.S12O...] / (aall[F519..S0.S11...] + aall[F519..S0.S12O...]))

aall[F519.CZ.S1M.S11.LE._T.2023q4]

aall[F512.CZ.S1M+S0+S2+S1.S1+S0+S2+S11+S12O.LE._T.2023q4]
## ATTENTION NO F512 PORTFOLIO FOR EURO AREA

aall[F512..S2.S11.LE._T.]<-bopf51mq[.S11.L_LE.FA__P__F512.]
aall[F512..S2.S12O.LE._T.]<-bopf51mq[.S12O.L_LE.FA__P__F512.]
aall[F512..S2.S11+S12O.LE._P.]<-aall[F512..S2.S11+S12O.LE._T.]
aall[F512..S2.S11+S12O.LE._S.]<-aall[F512..S2.S11+S12O.LE._T.]

aall[F512..S1M.S2.LE._T.]<-bopf51mq[.S1M.A_LE.FA__P__F512.]
aall[F512..S1M.S2.LE._P.]<-aall[F512..S1M.S2.LE._T.]
aall[F512..S1M.S2.LE._S.]<-aall[F512..S1M.S2.LE._T.]

aall[F512..S1.S11+S12O.LE..]<-aall[F512..S0.S11+S12O.LE..]-aall[F512..S0.S11+S12O.LE..]
aall[F512..S1M.S1.LE..]<-aall[F512..S1M.S0.LE..]-aall[F512..S1M.S2.LE..]

# aall[F512..S1M.S11...] = aall[F512..S1M.S1...] * (aall[F512..S1.S11...] / (aall[F512..S1.S11...] + aall[F512..S1.S12O...]))
#use S0 for those for which we do not have info on S2 (therefore S1)
#### Gabor: I drop this to ensure F51M.S1M.S11 + F51M.S1M.S12O <= F51M.S1M.S1 but can add back later 
aall[F512..S1M.S11...] <- aall[F512..S1M.S0...] * (aall[F512..S0.S11...] / (aall[F512..S0.S11...]  + aall[F512..S0.S12O...]))
aall[F512..S1M.S12O...] <- aall[F512..S1M.S0...] * (aall[F512..S0.S12O...] / (aall[F512..S0.S11...]  + aall[F512..S0.S12O...]))

# old version                                                                                                                                                                                  aall[F512..S0.S12O...]))
# aall[F51M..S1M.S11...]<- aall[F512..S1M.S11...]+ aall[F519..S1M.S11...]

# this adjustment ensures values are <= total  
aall[F51M..S1M.S11...]<- ((aall[F512..S1M.S11...] + aall[F519..S1M.S11...])/(aall[F512..S1M.S0...]+aall[F519..S1M.S0...]))*aall[F51M..S1M.S1...]
aall[F51M..S1M.S12O...]<- ((aall[F512..S1M.S12O...] + aall[F519..S1M.S12O...])/(aall[F512..S1M.S0...]+aall[F519..S1M.S0...]))*aall[F51M..S1M.S1...]


aall[F51M.CZ+EA20.S1M.S11.LE._T.2023q4]


### NOW ASSETS OF CENTRAL BANKS
### CB Holdings of Government
# Economic assumption: Central banks do not hold equity in government sector
# CBs typically hold government debt, not equity
aall[F51M..S121.S13..., onlyna=TRUE] <- 0

#S121 assets: residuals go to S11

aall[F51M.CZ+EA20.S121.S1+S0+S2+S121+S1M+S11+S124+S12Q+S12T+S12O+S13.LE._T.2023q4]

aall[F51M..S121.S11...,onlyna=TRUE] = aall[F51M..S121.S1...]- aall[F51M..S121.S121...] - zerofiller(aall[F51M..S121.S11...]) -
  zerofiller(aall[F51M..S121.S1M...]) - zerofiller(aall[F51M..S121.S13...]) - zerofiller(aall[F51M..S121.S12T...]) -
  zerofiller(aall[F51M..S121.S13...]) - zerofiller(aall[F51M..S121.S124...]) - zerofiller(aall[F51M..S121.S12Q...]) -
  zerofiller(aall[F51M..S121.S12O...]) 
  

# s11 liabilities: residuals go to S12O
# FIRST, FILL S2.S11
aall[F51M..S2.S11.LE._T.]<-bopf51mq[".S11.L_LE.FA__D__F51M."]+bopf51mq[".S11.L_LE.FA__O__F519."]+zerofiller(bopf51mq[".S11.L_LE.FA__P__F512."])
aall[F51M..S2.S11.LE._S.]<-aall[F51M..S2.S11.LE._T.]

aall[F51M..S1.S11.LE..]<-aall[F51M..S0.S11.LE..]-aall[F51M..S2.S11.LE..]

aall[F51M..S12T+S12Q.S11...,onlyna=TRUE]<-0

## Gabor ##
# also, solve problem with S13.S11: F5 calculated residually - S2 too low (iip as fallback), other sectors too low (e.g negative S12 for spain)
# Quick fix: cap S13.S11 at S13.S1 minues others

# Primitive solution, improve later
x <- as.data.table(aall[F51M..S13.S11...])

test <- copy(x)

test[, obs_value := pmin(
  x$obs_value,
  as.data.table(aall[F51M..S13.S1...])$obs_value - as.data.table(aall[F51M..S13.S13...])$obs_value - as.data.table(zerofiller(aall[F51M..S13.S121...]))$obs_value
  - as.data.table(zerofiller(aall[F51M..S13.S12T...]))$obs_value - as.data.table(zerofiller(aall[F51M..S13.S124...]))$obs_value - as.data.table(zerofiller(aall[F51M..S13.S12Q...]))$obs_value
  - as.data.table(zerofiller(aall[F51M..S13.S1M...]))$obs_value   - as.data.table(zerofiller(aall[F51M..S13.S12O...]))$obs_value
)]

test <- as.md3(test)

aall[F51M..S13.S11...] <- test["..."]

## Gabor ##


# ok now liabilities of s11 for real
aall[F51M.CZ+EA20.S1+S0+S2+S11+S1M+S121+S12T+S124+S12Q+S12O+S13.S11.LE._T.2023q4]
aall[F51M..S12O.S11...] <- aall[F51M..S1.S11...] - aall[F51M..S11.S11...] - aall[F51M..S1M.S11...] -aall[F51M..S121.S11...] -
  aall[F51M..S124.S11...] - aall[F51M..S13.S11...] - zerofiller(aall[F51M..S12T.S11...])-zerofiller(aall[F51M..S12Q.S11...])

### attention: s12O.S11 is negative - this is because S1 is negative - S2 higher than SO

## assets of s11: s12o is residual
aall[F51M..S11.S1M+S13+S12T+S124+S12Q+S121...,onlyna=TRUE]<-0
aall[F51M..S11.S12O...]<- aall[F51M..S11.S1...] - aall[F51M..S11.S11...] - zerofiller(aall[F51M..S11.S1M...]) -
  zerofiller(aall[F51M..S11.S13...]) - zerofiller(aall[F51M..S11.S12T...]) - zerofiller(aall[F51M..S11.S124...]) -
  zerofiller(aall[F51M..S11.S12Q...]) - zerofiller(aall[F51M..S11.S121...]) 

aall[F51M.CZ.S11.S12O.LE._T.2023q4]
### s12t liabilities: S12o residual

aall[F51M.CZ.S1+S0+S2.S12T.LE._T.2023q4]
## total s12t liabilities (s2 is absent)

bopf51mq[".S12T.L_LE.FA__D__F51M+FA__O__F519+FA__P__F512.2020q4"]
aall[F51M..S2.S12T.LE._T.]<-bopf51mq[".S12T.L_LE.FA__D__F51M."]+zerofiller(bopf51mq[".S12T.L_LE.FA__O__F519."])+
  zerofiller(bopf51mq[".S12T.L_LE.FA__P__F512."])
aall[F51M..S2.S12T.LE._S.]<-aall[F51M..S2.S12T.LE._T.]
# 



aall[F51M..S1.S12T.LE..]<-aall[F51M..S0.S12T.LE..]-aall[F51M..S2.S12T.LE..]
aall[F51M..S1.S12T.LE..][which(aall[F51M..S1.S12T.LE..]<0)] <- 0

# also, solve problem with S12O.S12T: S1 too low (S2 too high?)
# Quick fix: lower bound of S1.S12T is sum of sectors

# Primitive solution, improve later
x <- as.data.table(aall[F51M..S1.S12T...])

test <- copy(x)

test[, obs_value := pmax(
  x$obs_value,
  as.data.table(aall[F51M..S12T.S12T...])$obs_value + as.data.table(zerofiller(aall[F51M..S121.S12T...]))$obs_value
  + as.data.table(zerofiller(aall[F51M..S11.S12T...]))$obs_value + as.data.table(zerofiller(aall[F51M..S13.S12T...]))$obs_value + as.data.table(zerofiller(aall[F51M..S12Q.S12T...]))$obs_value
  + as.data.table(zerofiller(aall[F51M..S124.S12T...]))$obs_value + as.data.table(zerofiller(aall[F51M..S1M.S12T...]))$obs_value
)]

test <- as.md3(test)

aall[F51M..S1.S12T...] <- test["..."]


aall[F51M..S12O.S12T...]<- aall[F51M..S1.S12T...] - aall[F51M..S12T.S12T...] - zerofiller(aall[F51M..S11.S12T...]) -
  zerofiller(aall[F51M..S1M.S12T...]) - zerofiller(aall[F51M..S13.S12T...]) - zerofiller(aall[F51M..S12Q.S12T...]) - 
  zerofiller(aall[F51M..S124.S12T...]) 

## attention - some countries negative as S1 is negative (S2 larger than S0)
  
aall[F51M.CZ.S12O.S12T.LE._T.2023q4]

## s13 assets: RESIDUAL IS S12O


aall[F51M..S13.S12O...] <- aall[F51M..S13.S1...] - aall[F51M..S13.S13...] - zerofiller(aall[F51M..S13.S11...]) -
  zerofiller(aall[F51M..S13.S121...]) - zerofiller(aall[F51M..S13.S12Q...]) - zerofiller(aall[F51M..S13.S124...]) - 
  zerofiller(aall[F51M..S13.S12T...])  - zerofiller(aall[F51M..S13.S1M...])
aall["F51M.CZ.S13.S12O.LE._T+_S.2023q4"]

#### S12O LIABILITIES: residual is S13


#### Balancing algorithm, make sure toggle is ON at the beginning of code

if (APPLY_F51M_BALANCING) {
  
  source(file.path(script_dir, "utilities/F51M_balancing.R"))
  
  eu_countries <- c(
    "BE","BG","CZ","DK","DE","EE","IE","GR","ES","FR","HR",
    "IT","CY","LV","LT","LU","HU","MT","NL","AT","PL","PT",
    "RO","SI","SK","FI","SE"
  )
  
  # generate all quarterly periods from 1999q4 to latest available
  # adjust end period as needed
  start_year <- 1999; start_q <- 4
  end_year   <- 2024; end_q   <- 4
  
  all_periods <- c()
  for (yr in start_year:end_year) {
    for (q in 1:4) {
      if (yr == start_year && q < start_q) next
      if (yr == end_year   && q > end_q)   next
      all_periods <- c(all_periods, sprintf("%dq%d", yr, q))
    }
  }
  
  aall <- balance_f51m(
    aall       = aall,
    countries  = eu_countries,
    periods    = all_periods,
    w_disc     = 100,   # priority on row/col closure
    w_pen      = 1,     # regularisation toward observed values
    verbose    = FALSE  # set TRUE for per-country-period output
  )
  
}
  
#### FROM NOW ON: OLD SCRIPT


# #MFIs only holds unlisted equity issued by OFIs, NFCS, and other MFIs
# 
# ###########################  ATTENTION MAYBE SHIFT LATER ############# QUITE STRONG ASSUMPTION...
# ### COMPUTE S12T HOLDINGS OF F51M IN S11 (NFC) LIABILITIES
# # Now we can finally compute the residual and obtain S12T holdings of F51M in S11 (NFC) liabilities!
# aall[F51M..S12T.S11+S1+S12T+S12O+S121+S13+S1M.LE._S.2023q4]  # CHECK: View before
# aall[F51M..S12T.S11..., onlyna=TRUE] <- aall[F51M..S12T.S1...] - aall[F51M..S12T.S12T...] - zerofiller(aall[F51M..S12T.S12O...])
# aall[F51M..S12T.S11+S1+S12T+S12O.LE._S.2023q4]  # CHECK: Verify after
# 
# #aall["F51M..S12T.S11..."][which(aall["F51M..S12T.S11..."] < 0)] <- 0
# 
# ### CB Holdings of Government
# # Economic assumption: Central banks do not hold equity in government sector
# # CBs typically hold government debt, not equity
# aall[F51M..S121.S13..., onlyna=TRUE] <- 0
# 
# ###  CB Assets in S11
# # Assumes all CB domestic assets (except self and government) are in NFC
# # HERE WE ARE ASSUMING THAT CB ONLY HOLD UNLISTED EQUITY ISSUED BY NFCs and government, and not by MFIs. 
# aall[F51M..S121.S11+S1+S121+S13+S12T+S12O.LE._S.2023q4]
# aall[F51M..S121.S11..., onlyna=TRUE] = aall[F51M..S121.S1...] - zerofiller(aall[F51M..S121.S121...]) - zerofiller(aall[F51M..S121.S13...])
# aall[F51M..S121.S11+S1+S121+S13.LE._S.2023q4]
# ### COMPUTE OFI HOLDINGS OF F51M IN S11 (NFC) LIABILITIES
# # Once S12T is computed, calculate OFI as: S12 total - S12T (MFIs)
# # Using this assumption, we can use S12.S11 instead of the sum of S12T+S12O.S11 (we lack both)
# aall[F51M..S12O.S11..., onlyna=TRUE] = aall[F51M..S12.S11...] - zerofiller(aall[F51M..S12T.S11...]) - zerofiller(aall[F51M..S121.S11...])
# aall[F51M..S12+S12T+S12O+S121.S11.LE._S.2023q4]  # CHECK: Verify all financial sector holdings
# 
# aall[F51M..S12O.S12T+S1+S11+S12O.LE._S.2023q4]
# aall[F51M..S12O.S12T..., onlyna=TRUE] = aall[F51M..S12O.S1...] - zerofiller(aall[F51M..S12O.S11...]) - aall[F51M..S12O.S12O...]
# 
# ### ATTENTION. BECAUSE OF ABOVE ASSUMPTIONS ON MFI holdings of NFC unlisted equity as residual AND/OR central bank holdings of NFC unlisted equity as residual,
# ### THE STEP BELOW IS NECESSARY BECAUSE
# ### for some countries (FI, HU, LT, RO), F51M.S12O.S11 is larger than F51M.S12O.S1 . 
# ### For France, the sum of F51M.S12O.S11 and F51M.S12O intrasector is greater than F51M.S12O.S1 (again impossible).
# aall["F51M..S12O.S12T..."][which(aall["F51M..S12O.S12T..."] < 0)] <- 0
# aall[F51M..S12O.S12T+S1+S11+S12O.LE._S.2023q4]
# 
# #### BEFORE PROCEEDING TO THIRD STEP: INTEGRATE COUNTRY-SPECIFIC DATA
# # Load Italy-specific F51M data adjustments
# source(file.path(script_dir, "domestic/F51M_IT.R"))
# 
# aall[F51M.DE.S12O.S12T.LE._S., onlyna=TRUE]= aall[F51M.DE.S12O.S12T.LE._T., onlyna=TRUE]=0
# 
# ################## THIRD STEP: HOUSEHOLD HOLDINGS ##################
# # Calculate household holdings in financial sector liabilities
# 
# ### ASSUMPTION: HH F51M holdings in financial sector are only in OFI liabilities
# # Households are assumed to hold unlisted equity only in OFIs, not in banks or CB
# aall[F51M..S1M.S12O..., onlyna=TRUE] <- aall[F51M..S1M.S12...]
# 
# ### Set banks and central banks holdings by households TO ZERO
# aall[F51M..S1M.S121..., onlyna=TRUE] = aall[F51M..S1M.S12...] - aall[F51M..S1M.S12O...]
# aall[F51M..S1M.S12T..., onlyna=TRUE] = aall[F51M..S1M.S12...] - aall[F51M..S1M.S12O...]
# aall[F51M..S1M.S12K..., onlyna=TRUE] = aall[F51M..S1M.S12...] - aall[F51M..S1M.S12O...]
# 
# aall[F51M..S1M.S12+S12O+S121+S12T+S12K.LE._S.2023q4]  # CHECK: Verify all HH holdings
# 
# ### 1. CENTRAL BANK EQUITY ASSUMPTION
# # Any F51 equity of CB MUST be F51M (unlisted) and not F511 (listed)
# # Central banks do not issue listed shares
# 
# aall["F51..S0.S121.LE.."][which(aall["F51..S0.S121.LE.."] <0)] <- 0
# aall[F511..S0.S121.LE._S.2022q4]
# 
# aall[F51M..S0.S121.LE._S.2022q4]
# ### cbs do not have listed equities in their liabilities, only F51M
# aall[F51M..S0.S121..., onlyna=TRUE] <-aall[F51..S0.S121...]
# aall["F51M..S0.S121.LE.."][which(aall["F51M..S0.S121.LE.."] <0)] <- 0
# 
# ### 2. COMPUTE F51M.S0.S12T AS RESIDUAL
# # S12K (all MFIs) = S12T (banks) + S121 (central bank)
# # Therefore: S12T = S12K - S121
# aall[F51M..S0.S12T.LE._S.2023q4]
# aall[F51M..S0.S12T..., onlyna=TRUE] <-aall[F51M..S0.S12K...]-aall[F51M..S0.S121...]
# aall["F51M..S0.S12T.LE.."][which(aall["F51M..S0.S12T.LE.."] <0)] <- 0
# aall[F51M..S1.S12T.LE._S.2023q4]
# ### 3. COMPUTE F51M.S1.S12T AS RESIDUAL
# # S0 = S1 + S2, therefore: S1 = S0 - S2
# aall[F51M..S1.S12T..., onlyna=TRUE] <-aall[F51M..S0.S12T...]-aall[F51M..S2.S12T...]
# aall["F51M..S1.S12T.LE.."][which(aall["F51M..S1.S12T.LE.."] <0)] <- 0
# 
# # Check the calculation
# aall[F51M..S11+S1+S12T+S12O.S12T.LE._S.2023q4]  # CHECK: Verify S12T liabilities
# 
# ### COMPLETE THE MATRIX F51M.S0+S1+S2.S12K+S12T+S121
# aall[F51M.AT.S0+S1+S2.S12K+S12T+S121.LE._S.2022q4]  # CHECK: View matrix for Austria
# 
# # Since S2.S121 = 0 (no foreign holdings of CB equity), then S2.S12K = S2.S12T
# aall[F51M..S2.S12K..., onlyna=TRUE] <-aall[F51M..S2.S12T...]
# 
# # Calculate S1.S12K as residual: S0 - S2
# aall[F51M..S1.S12K..., onlyna=TRUE] <-aall[F51M..S0.S12K...]-aall[F51M..S2.S12K...]
# 
# ### Calculate S1.S121 as residual: S12K-S12T
# aall[F51M..S1.S121..., onlyna=TRUE] <-aall[F51M..S1.S12K...]-aall[F51M..S1.S12T...]
# 
# aall[F51M..S2.S121..., onlyna=TRUE] <-aall[F51M..S2.S12K...]-aall[F51M..S2.S12T...]
# 
# ### CALCULATE S11 (NFC) HOLDINGS OF S12T (MFI) LIABILITIES
# # Residual: S1 total - S12T self - S12O other financials
# aall[F51M..S11.S12T..., onlyna=TRUE] <- aall[F51M..S1.S12T...] - zerofiller(aall[F51M..S12T.S12T...]) - zerofiller(aall[F51M..S12O.S12T...])
# aall[F51M..S11+S1+S12T+S12O.S12T.LE._S.2023q4]  # CHECK: Verify calculation
# 
# #####HERE WE HAVE A PROBLEM!!!!!! S120.S12T IS TOO BIG AS ABOVE!!!!!
# #### SO A LOT OF NEGATIVE S11!!!
# 
# aall["F51M..S11.S12T..."][which(aall["F51M..S11.S12T..."] < 0)] <-0
# 
# ### NFC HOLDINGS IN OFI LIABILITIES
# # Residual: NFC total assets - NFC self - NFC holdings in MFI
# aall[F51M..S11.S12O..., usenames=TRUE, onlyna=TRUE] = aall[F51M..S11.S1...] - zerofiller(aall[F51M..S11.S11...]) - zerofiller(aall[F51M..S11.S12T...])
# 
# aall[F51M..S11.S12O+S1+S11+S12T.LE._S.2022q4]  # CHECK: Verify NFC holdings of OFI
# aall["F51M..S11.S12O..."][which(aall["F51M..S11.S12O..."]< 0)] <-0
# 
# ############## HOUSEHOLD RESIDUAL CALCULATIONS
# 
# ### HH IN NFC: Calculate as residual
# # Liabilities of NFC - self NFC - OFI in NFC - MFI in NFC
# aall[F51M..S1M+S1+S12O+S12T.S11.LE._S.2022q4]  # CHECK: View before
# aall[F51M..S1M.S11..., usenames=TRUE, onlyna=TRUE]=aall[F51M..S1.S11...]-zerofiller(aall[F51M..S11.S11...])-zerofiller(aall[F51M..S12O.S11...])-zerofiller(aall[F51M..S12T.S11...])
# 
# ### S12T.S12Q (Insurance) Calculation
# # Calculate MFI holdings of insurance sector as residual
# aall[F51M..S12T.S12Q+S12T+S1+S12O+S11.LE._S.2022q4]  # CHECK: View before calculation
# aall[F51M..S12T.S12Q..., onlyna=TRUE] <- aall[F51M..S12T.S1...] - 
#   zerofiller(aall[F51M..S12T.S12T...]) - zerofiller(aall[F51M..S12T.S11...]) - zerofiller(aall[F51M..S12T.S12O...])
# aall[F51M..S12T.S12Q.LE..][which(aall[F51M..S12T.S12Q.LE..]<0)]<-0
# ###  S12T.S13 (Government) Calculation
# # Any remainder after accounting for all financial and non-financial sectors
# # goes to government sector holdings
# aall[F51M..S12T.S13..., onlyna=TRUE] <- aall[F51M..S12T.S1...] - 
#   zerofiller(aall[F51M..S12T.S12T...]) - zerofiller(aall[F51M..S12T.S11...]) - 
#   zerofiller(aall[F51M..S12T.S12O...]) - zerofiller(aall[F51M..S12T.S12Q...])
# 
# aall[F51M..S12O+S1+S1M+S11+S12T+S124+S12Q+S13.S13.LE._S.2023q4]
# aall[F51M..S12T.S13.LE..][which(aall[F51M..S12T.S13.LE..]<0)] <- 0
# 
# ###  OFI Holdings of Government
# # Calculate as residual: Total domestic - all other sectors
# aall[F51M..S12O.S13..., onlyna=TRUE] = aall[F51M..S1.S13...] - zerofiller(aall[F51M..S1M.S13...])- zerofiller(aall[F51M..S11.S13...])- zerofiller(aall[F51M..S12T.S13...])- zerofiller(aall[F51M..S124.S13...])- zerofiller(aall[F51M..S12Q.S13...])- zerofiller(aall[F51M..S13.S13...])
# aall[F51M..S12O.S13.LE._S.2022q4]
# 
# ###  NFC Holdings of CB
# # Economic assumption: NFCs do not hold equity in central banks
# aall[F51M..S11.S121..., onlyna=TRUE] = 0
# 
# ###  Banks Holdings of CB
# # Economic assumption: Commercial banks do not hold equity in central banks
# aall[F51M..S12T.S121..., onlyna=TRUE] = 0
# 
# ### Government Holdings of CB
# # Calculate government holdings of CB equity as residual
# aall[F51M..S13.S121..., onlyna=TRUE] = aall[F51M..S1.S121...] - zerofiller(aall[F51M..S1M.S121...]) - zerofiller(aall[F51M..S11.S121...])- zerofiller(aall[F51M..S121.S121...])- zerofiller(aall[F51M..S12T.S121...])- zerofiller(aall[F51M..S124.S121...])-- zerofiller(aall[F51M..S12Q.S121...])- zerofiller(aall[F51M..S12O.S121...])
# aall[F51M..S13.S121.LE._S.2022q4]
# 
# aall["F51M..S13.S121..."][which(aall["F51M..S13.S121..."]<0)]<-0
# 
# ### Set remaining sectors' holdings of CB to zero
# aall[F51M..S1M+S11+S121+S12T+S124+S12Q+S12O.S121..., onlyna=TRUE] = 0
# 
# # First set all the zero assumptions for S124
# # MFI holdings of S124 - Banks don't typically hold non-MMF fund equity
# aall[F51M..S12T.S124..., onlyna=TRUE] = 0
# 
# # NFC holdings of S124 - NFCs don't typically hold investment fund equity
# aall[F51M..S11.S124..., onlyna=TRUE] = 0
# 
# # HH holdings of S124 and S12Q
# aall[F51M..S1M.S124+S12Q..., onlyna=TRUE] = 0
# 
# # Insurance and government holdings of S124
# aall[F51M..S12Q+S13.S124..., onlyna=TRUE] = 0
# 
# # NOW calculate OFI holdings of S124 as residual (after setting the zeros)
# aall[F51M..S12O.S124..., onlyna=TRUE] = aall[F51M..S1.S124...] - zerofiller(aall[F51M..S1.S12T...])- zerofiller(aall[F51M..S12Q.S12T...])- zerofiller(aall[F51M..S13.S12T...])-- zerofiller(aall[F51M..S1M.S12T...])- zerofiller(aall[F51M..S11.S12T...])
# aall[F51M..S12O.S124.LE._S.2022q4]
# 
# aall["F51M..S12O.S124.LE.."][which(aall["F51M..S12O.S124.LE.."]<0)] <- 0
# 
# ### S12Q (Insurance) Interconnections
# # Insurance doesn't hold MFI unlisted equity directly
# aall[F51M..S12Q.S12T..., onlyna=TRUE] <- 0
# 
# # NFC and S124 don't hold insurance unlisted equity
# aall[F51M..S11+S124.S12Q..., onlyna=TRUE] <- 0
# 
# ### OFI Holdings of Insurance
# # Calculate OFI holdings in insurance as residual
# aall[F51M..S12O.S12Q..., onlyna=TRUE] = aall[F51M..S12O.S1...] - zerofiller(aall[F51M..S12O.S11...])-zerofiller(aall[F51M..S12O.S121...])-zerofiller(aall[F51M..S12O.S12T...])-zerofiller(aall[F51M..S12O.S124...])-zerofiller(aall[F51M..S12O.S12O...])-zerofiller(aall[F51M..S12O.S13...])
# aall[F51M..S12O.S12Q+S11+S121+S12T+S124+S12O+S13.LE._S.2022q4]
# aall[F51M..S12O.S12Q...][which(aall[F51M..S12O.S12Q...]<0)]<-0  

saveRDS(aall, file.path(data_dir, 'intermediate_domestic_data_files/aall_f51m.rds'))

aall[F51M.AT.S0+S1+S11+S12+S121+S124+S12K+S12Q+S12R+S12T+S13+S1M+S2.S1+S11+S121+S124+S12K+S12T+S13+S1M+S0+S12+S2.LE._S.2022q4]

aall[F51M.IT.S0+S1+S11+S12+S121+S124+S12K+S12Q+S12R+S12T+S13+S1M+S2.S1+S11+S121+S124+S12K+S12T+S13+S1M+S0+S12+S2.LE._S.2022q4]

aall[F51M.DE.S0+S1+S11+S12+S121+S124+S12K+S12Q+S12R+S12T+S13+S1M+S2.S1+S11+S121+S124+S12K+S12T+S13+S1M+S0+S12+S2.LE._S.2022q4]

aall[F51M.AT.S0+S1+S11+S12+S121+S124+S12K+S12Q+S12R+S12T+S13+S1M+S2.S1+S0+S2.LE._S.2022q4]

aall["F51M.AT.S12T.S1+S0+S2.LE._S+_T.2022q4"]
