library(MDecfin)

# Load assets data
laiip = readRDS(file.path(data_dir,"iip6_assets.rds"))
labop = readRDS(file.path(data_dir,"bop6_assets.rds"))
# Load liabilities data
lliip = readRDS(file.path(data_dir,"iip6_liabilities.rds"))
llbop = readRDS(file.path(data_dir,"bop6_liabilities.rds"))

#temp load current aall version
aall=readRDS(file.path(data_dir,'aall6.rds'))
setkey(aall, NULL)

### data structure
names(dimnames(laiip))[[1]] = 'REF_AREA'
names(dimnames(laiip))[[2]] = 'REF_SECTOR'
names(dimnames(labop))[[1]] = 'REF_AREA'
names(dimnames(labop))[[2]] = 'REF_SECTOR'
names(dimnames(lliip))[[1]] = 'REF_AREA'
names(dimnames(lliip))[[2]] = 'REF_SECTOR'
names(dimnames(llbop))[[1]] = 'REF_AREA'
names(dimnames(llbop))[[2]] = 'REF_SECTOR'


############ FUNCTIONAL CATEGORY

#check dimensions
dimnames(aall)
#change dimension name
names(dimnames(aall))[[6]] = 'FUNCTIONAL_CAT'

#Get the current dimcodes structure
current_dimcodes <- dimcodes(aall)

# Create new codes for FUNCTIONAL_CAT
new_functional_cat <- data.frame(
  code = c("_D", "_T", "_F", "_O", "_T", "_R"),  # New set of codes including _T and renamed FND->_D
  stringsAsFactors = FALSE
)

# Replace the FUNCTIONAL_CAT dimension codes
current_dimcodes$FUNCTIONAL_CAT <- new_functional_cat

# Assign the modified dimcodes back to the object
dimcodes(aall) = current_dimcodes

gc()

# Initialize the new elements with NA
aall[....._F.] <- NA
aall[....._O.] <- NA
aall[....._T.] <- NA
aall[....._R.] <- NA


dimcodes(aall)

#### no use of zerofiller - want to keep the NAs for the later filling of _T

### direct investment  from ECB QSA

###direct investment assets 
aall[..S1.S2.LE._D., usenames=TRUE, onlyna=TRUE] = aall[..S1.S0.LE._D.]
aall[..S121.S2.LE._D., usenames=TRUE, onlyna=TRUE] = aall[..S121.S0.LE._D.]
aall[..S12T.S2.LE._D., usenames=TRUE, onlyna=TRUE] = aall[..S12T.S0.LE._D.]
aall[..S13.S2.LE._D., usenames=TRUE, onlyna=TRUE] = aall[..S13.S0.LE._D.]
aall[..S11.S2.LE._D., usenames=TRUE, onlyna=TRUE] = aall[..S11.S0.LE._D.]
aall[..S1M.S2.LE._D., usenames=TRUE, onlyna=TRUE] = aall[..S1M.S0.LE._D.]
aall[..S124.S2.LE._D., usenames=TRUE, onlyna=TRUE] = aall[..S124.S0.LE._D.]
aall[..S12O.S2.LE._D., usenames=TRUE, onlyna=TRUE] = aall[..S12O.S0.LE._D.]
aall[..S12Q.S2.LE._D., usenames=TRUE, onlyna=TRUE] = aall[..S12Q.S0.LE._D.]
aall[..S12R.S2.LE._D., usenames=TRUE, onlyna=TRUE] = aall[..S124.S0.LE._D.]+aall[..S12O.S0.LE._D.]+aall[..S12Q.S0.LE._D.]

aall[..S1.S2.F._D., usenames=TRUE, onlyna=TRUE] = aall[..S1.S0.F._D.]
aall[..S121.S2.F._D., usenames=TRUE, onlyna=TRUE] = aall[..S121.S0.F._D.]
aall[..S12T.S2.F._D., usenames=TRUE, onlyna=TRUE] = aall[..S12T.S0.F._D.]
aall[..S13.S2.F._D., usenames=TRUE, onlyna=TRUE] = aall[..S13.S0.F._D.]
aall[..S11.S2.F._D., usenames=TRUE, onlyna=TRUE] = aall[..S11.S0.F._D.]
aall[..S1M.S2.F._D., usenames=TRUE, onlyna=TRUE] = aall[..S1M.S0.F._D.]
aall[..S124.S2.F._D., usenames=TRUE, onlyna=TRUE] = aall[..S124.S0.F._D.]
aall[..S12O.S2.F._D., usenames=TRUE, onlyna=TRUE] = aall[..S12O.S0.F._D.]
aall[..S12Q.S2.F._D., usenames=TRUE, onlyna=TRUE] = aall[..S12Q.S0.F._D.]
aall[..S12R.S2.F._D., usenames=TRUE, onlyna=TRUE] = aall[..S124.S0.F._D.]+aall[..S12O.S0.F._D.]+aall[..S12Q.S0.F._D.]

###direct investment liabilities 
aall[..S2.S1.LE._D., usenames=TRUE, onlyna=TRUE] = aall[..S0.S1.LE._D.]
aall[..S2.S121.LE._D., usenames=TRUE, onlyna=TRUE] = aall[..S0.S121.LE._D.]
aall[..S2.S12T.LE._D., usenames=TRUE, onlyna=TRUE] = aall[..S0.S12T.LE._D.]
aall[..S2.S13.LE._D., usenames=TRUE, onlyna=TRUE] = aall[..S0.S13.LE._D.]
aall[..S2.S11.LE._D., usenames=TRUE, onlyna=TRUE] = aall[..S0.S11.LE._D.]
aall[..S2.S1M.LE._D., usenames=TRUE, onlyna=TRUE] = aall[..S0.S1M.LE._D.]
aall[..S2.S124.LE._D., usenames=TRUE, onlyna=TRUE] = aall[..S0.S124.LE._D.]
aall[..S2.S12O.LE._D., usenames=TRUE, onlyna=TRUE] = aall[..S0.S12O.LE._D.]
aall[..S2.S12Q.LE._D., usenames=TRUE, onlyna=TRUE] = aall[..S0.S12Q.LE._D.]
aall[..S2.S12R.LE._D., usenames=TRUE, onlyna=TRUE] = aall[..S0.S124.LE._D.]+aall[..S0.S12O.LE._D.]+aall[..S0.S12Q.LE._D.]

aall[..S2.S1.F._D., usenames=TRUE, onlyna=TRUE] = aall[..S0.S1.F._D.]
aall[..S2.S121.F._D., usenames=TRUE, onlyna=TRUE] = aall[..S0.S121.F._D.]
aall[..S2.S12T.F._D., usenames=TRUE, onlyna=TRUE] = aall[..S0.S12T.F._D.]
aall[..S2.S13.F._D., usenames=TRUE, onlyna=TRUE] = aall[..S0.S13.F._D.]
aall[..S2.S11.F._D., usenames=TRUE, onlyna=TRUE] = aall[..S0.S11.F._D.]
aall[..S2.S1M.F._D., usenames=TRUE, onlyna=TRUE] = aall[..S0.S1M.F._D.]
aall[..S2.S124.F._D., usenames=TRUE, onlyna=TRUE] = aall[..S0.S124.F._D.]
aall[..S2.S12O.F._D., usenames=TRUE, onlyna=TRUE] = aall[..S0.S12O.F._D.]
aall[..S2.S12Q.F._D., usenames=TRUE, onlyna=TRUE] = aall[..S0.S12Q.F._D.]
aall[..S2.S12R.F._D., usenames=TRUE, onlyna=TRUE] = aall[..S0.S124.F._D.]+aall[..S0.S12O.F._D.]+aall[..S0.S12Q.F._D.]

### rest of functional categories from ESTAT

## stocks F total - Assets for Qdata 
aaF = laiip[..FA__D__F+FA__P__F+FA__O__F+FA__R__F+FA__F__F7.]
ppFA=copy(aaF[..FA__D__F+FA__P__F+FA__O__F+FA__R__F+FA__F__F7.])
aall[F..S121.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppFA[".S121.FA__O__F.1999q4:"]
aall[F..S12T.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppFA[".S12T.FA__O__F.1999q4:"]
aall[F..S13.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppFA[".S13.FA__O__F.1999q4:"]
aall[F..S11.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppFA[".S11.FA__O__F.1999q4:"]
aall[F..S1M.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppFA[".S1M.FA__O__F.1999q4:"]
aall[F..S124.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppFA[".S124.FA__O__F.1999q4:"]
aall[F..S12O.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppFA[".S12O.FA__O__F.1999q4:"]
aall[F..S12Q.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppFA[".S12Q.FA__O__F.1999q4:"]
aall[F..S12R.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppFA[".S12M.FA__O__F.1999q4:"]

aall[F..S121.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppFA[".S121.FA__P__F.1999q4:"]
aall[F..S12T.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppFA[".S12T.FA__P__F.1999q4:"]
aall[F..S13.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppFA[".S13.FA__P__F.1999q4:"]
aall[F..S11.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppFA[".S11.FA__P__F.1999q4:"]
aall[F..S1M.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppFA[".S1M.FA__P__F.1999q4:"]
aall[F..S124.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppFA[".S124.FA__P__F.1999q4:"]
aall[F..S12O.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppFA[".S12O.FA__P__F.1999q4:"]
aall[F..S12Q.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppFA[".S12Q.FA__P__F.1999q4:"]
aall[F..S12R.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppFA[".S12M.FA__P__F.1999q4:"]

aall[F..S121.S2.LE._F., usenames=TRUE, onlyna=TRUE] = ppFA[".S121.FA__F__F7.1999q4:"]
aall[F..S12T.S2.LE._F., usenames=TRUE, onlyna=TRUE] = ppFA[".S12T.FA__F__F7.1999q4:"]
aall[F..S13.S2.LE._F., usenames=TRUE, onlyna=TRUE] = ppFA[".S13.FA__F__F7.1999q4:"]
aall[F..S11.S2.LE._F., usenames=TRUE, onlyna=TRUE] = ppFA[".S11.FA__F__F7.1999q4:"]
aall[F..S1M.S2.LE._F., usenames=TRUE, onlyna=TRUE] = ppFA[".S1M.FA__F__F7.1999q4:"]
aall[F..S124.S2.LE._F., usenames=TRUE, onlyna=TRUE] = ppFA[".S124.FA__F__F7.1999q4:"]
aall[F..S12O.S2.LE._F., usenames=TRUE, onlyna=TRUE] = ppFA[".S12O.FA__F__F7.1999q4:"]
aall[F..S12Q.S2.LE._F., usenames=TRUE, onlyna=TRUE] = ppFA[".S12Q.FA__F__F7.1999q4:"]
aall[F..S12R.S2.LE._F., usenames=TRUE, onlyna=TRUE] = ppFA[".S12M.FA__F__F7.1999q4:"]

aall[F..S121.S2.LE._R., usenames=TRUE, onlyna=TRUE] = ppFA[".S121.FA__R__F.1999q4:"]


## flows F total - Assets for Qdata
aaFt = labop[..FA__D__F+FA__P__F+FA__O__F+FA__R__F+FA__F__F7.]
ppFAt=copy(aaFt[..FA__D__F+FA__P__F+FA__O__F+FA__R__F+FA__F__F7.])
aall[F..S121.S2.F._O., usenames=TRUE, onlyna=TRUE] = ppFAt[".S121.FA__O__F.1999q4:"]
aall[F..S12T.S2.F._O., usenames=TRUE, onlyna=TRUE] = ppFAt[".S12T.FA__O__F.1999q4:"]
aall[F..S13.S2.F._O., usenames=TRUE, onlyna=TRUE] = ppFAt[".S13.FA__O__F.1999q4:"]
aall[F..S11.S2.F._O., usenames=TRUE, onlyna=TRUE] = ppFAt[".S1P.FA__O__F.1999q4:"]
aall[F..S124.S2.F._O., usenames=TRUE, onlyna=TRUE] = ppFAt[".S124.FA__O__F.1999q4:"]
aall[F..S12O.S2.F._O., usenames=TRUE, onlyna=TRUE] = ppFAt[".S12O.FA__O__F.1999q4:"]
aall[F..S12Q.S2.F._O., usenames=TRUE, onlyna=TRUE] = ppFAt[".S12Q.FA__O__F.1999q4:"]
aall[F..S12R.S2.F._O., usenames=TRUE, onlyna=TRUE] = ppFAt[".S12M.FA__O__F.1999q4:"]

aall[F..S121.S2.F._P., usenames=TRUE, onlyna=TRUE] = ppFAt[".S121.FA__P__F.1999q4:"]
aall[F..S12T.S2.F._P., usenames=TRUE, onlyna=TRUE] = ppFAt[".S12T.FA__P__F.1999q4:"]
aall[F..S13.S2.F._P., usenames=TRUE, onlyna=TRUE] = ppFAt[".S13.FA__P__F.1999q4:"]
aall[F..S11.S2.F._P., usenames=TRUE, onlyna=TRUE] = ppFAt[".S1P.FA__P__F.1999q4:"]
aall[F..S124.S2.F._P., usenames=TRUE, onlyna=TRUE] = ppFAt[".S124.FA__P__F.1999q4:"]
aall[F..S12O.S2.F._P., usenames=TRUE, onlyna=TRUE] = ppFAt[".S12O.FA__P__F.1999q4:"]
aall[F..S12Q.S2.F._P., usenames=TRUE, onlyna=TRUE] = ppFAt[".S12Q.FA__P__F.1999q4:"]
aall[F..S12R.S2.F._P., usenames=TRUE, onlyna=TRUE] = ppFAt[".S12M.FA__P__F.1999q4:"]

aall[F..S121.S2.F._F., usenames=TRUE, onlyna=TRUE] = ppFAt[".S121.FA__F__F7.1999q4:"]
aall[F..S12T.S2.F._F., usenames=TRUE, onlyna=TRUE] = ppFAt[".S12T.FA__F__F7.1999q4:"]
aall[F..S13.S2.F._F., usenames=TRUE, onlyna=TRUE] = ppFAt[".S13.FA__F__F7.1999q4:"]
aall[F..S11.S2.F._F., usenames=TRUE, onlyna=TRUE] = ppFAt[".S1P.FA__F__F7.1999q4:"]
aall[F..S124.S2.F._F., usenames=TRUE, onlyna=TRUE] = ppFAt[".S124.FA__F__F7.1999q4:"]
aall[F..S12O.S2.F._F., usenames=TRUE, onlyna=TRUE] = ppFAt[".S12O.FA__F__F7.1999q4:"]
aall[F..S12Q.S2.F._F., usenames=TRUE, onlyna=TRUE] = ppFAt[".S12Q.FA__F__F7.1999q4:"]
aall[F..S12R.S2.F._F., usenames=TRUE, onlyna=TRUE] = ppFAt[".S12M.FA__F__F7.1999q4:"]

aall[F..S121.S2.F._R., usenames=TRUE, onlyna=TRUE] = ppFAt[".S121.FA__R__F.1999q4:"]


# Process F (sum of F per functional categories)
print('filling NAs of crossborder financial liabilities')

## stocks F total - liabilities for Qdata
llF = lliip[..FA__D__F+FA__P__F+FA__O__F+FA__F__F7.]
ppFL = copy(llF[..FA__D__F+FA__P__F+FA__O__F+FA__F__F7.])
aall[F..S2.S121.LE._O., usenames=TRUE, onlyna=TRUE] = ppFL[".S121.FA__O__F.1999q4:"]
aall[F..S2.S12T.LE._O., usenames=TRUE, onlyna=TRUE] = ppFL[".S12T.FA__O__F.1999q4:"]
aall[F..S2.S13.LE._O., usenames=TRUE, onlyna=TRUE] = ppFL[".S13.FA__O__F.1999q4:"]
aall[F..S2.S11.LE._O., usenames=TRUE, onlyna=TRUE] = ppFL[".S11.FA__O__F.1999q4:"]
aall[F..S2.S1M.LE._O., usenames=TRUE, onlyna=TRUE] = ppFL[".S1M.FA__O__F.1999q4:"]
aall[F..S2.S124.LE._O., usenames=TRUE, onlyna=TRUE] = ppFL[".S124.FA__O__F.1999q4:"]
aall[F..S2.S12O.LE._O., usenames=TRUE, onlyna=TRUE] = ppFL[".S12O.FA__O__F.1999q4:"]
aall[F..S2.S12Q.LE._O., usenames=TRUE, onlyna=TRUE] = ppFL[".S12Q.FA__O__F.1999q4:"]
aall[F..S2.S12R.LE._O., usenames=TRUE, onlyna=TRUE] = ppFL[".S12M.FA__O__F.1999q4:"]

aall[F..S2.S121.LE._P., usenames=TRUE, onlyna=TRUE] = ppFL[".S121.FA__P__F.1999q4:"]
aall[F..S2.S12T.LE._P., usenames=TRUE, onlyna=TRUE] = ppFL[".S12T.FA__P__F.1999q4:"]
aall[F..S2.S13.LE._P., usenames=TRUE, onlyna=TRUE] = ppFL[".S13.FA__P__F.1999q4:"]
aall[F..S2.S11.LE._P., usenames=TRUE, onlyna=TRUE] = ppFL[".S11.FA__P__F.1999q4:"]
aall[F..S2.S1M.LE._P., usenames=TRUE, onlyna=TRUE] = ppFL[".S1M.FA__P__F.1999q4:"]
aall[F..S2.S124.LE._P., usenames=TRUE, onlyna=TRUE] = ppFL[".S124.FA__P__F.1999q4:"]
aall[F..S2.S12O.LE._P., usenames=TRUE, onlyna=TRUE] = ppFL[".S12O.FA__P__F.1999q4:"]
aall[F..S2.S12Q.LE._P., usenames=TRUE, onlyna=TRUE] = ppFL[".S12Q.FA__P__F.1999q4:"]
aall[F..S2.S12R.LE._P., usenames=TRUE, onlyna=TRUE] = ppFL[".S12M.FA__P__F.1999q4:"]

aall[F..S2.S121.LE._F., usenames=TRUE, onlyna=TRUE] = ppFL[".S121.FA__F__F7.1999q4:"]
aall[F..S2.S12T.LE._F., usenames=TRUE, onlyna=TRUE] = ppFL[".S12T.FA__F__F7.1999q4:"]
aall[F..S2.S13.LE._F., usenames=TRUE, onlyna=TRUE] = ppFL[".S13.FA__F__F7.1999q4:"]
aall[F..S2.S11.LE._F., usenames=TRUE, onlyna=TRUE] = ppFL[".S11.FA__F__F7.1999q4:"]
aall[F..S2.S1M.LE._F., usenames=TRUE, onlyna=TRUE] = ppFL[".S1M.FA__F__F7.1999q4:"]
aall[F..S2.S124.LE._F., usenames=TRUE, onlyna=TRUE] = ppFL[".S124.FA__F__F7.1999q4:"]
aall[F..S2.S12O.LE._F., usenames=TRUE, onlyna=TRUE] = ppFL[".S12O.FA__F__F7.1999q4:"]
aall[F..S2.S12Q.LE._F., usenames=TRUE, onlyna=TRUE] = ppFL[".S12Q.FA__F__F7.1999q4:"]
aall[F..S2.S12R.LE._F., usenames=TRUE, onlyna=TRUE] = ppFL[".S12M.FA__F__F7.1999q4:"]


## flows F total - liabilities for Qdata
lltF = llbop[..FA__D__F+FA__P__F+FA__O__F+FA__R__F+FA__F__F7.]
ppFLt = copy(lltF[..FA__D__F+FA__P__F+FA__O__F+FA__R__F+FA__F__F7.])
aall[F..S2.S121.F._O., usenames=TRUE, onlyna=TRUE] = ppFLt[".S121.FA__O__F.1999q4:"]
aall[F..S2.S12T.F._O., usenames=TRUE, onlyna=TRUE] = ppFLt[".S12T.FA__O__F.1999q4:"]
aall[F..S2.S13.F._O., usenames=TRUE, onlyna=TRUE] = ppFLt[".S13.FA__O__F.1999q4:"]
aall[F..S2.S11.F._O., usenames=TRUE, onlyna=TRUE] = ppFLt[".S1P.FA__O__F.1999q4:"]
aall[F..S2.S124.F._O., usenames=TRUE, onlyna=TRUE] = ppFLt[".S124.FA__O__F.1999q4:"]
aall[F..S2.S12O.F._O., usenames=TRUE, onlyna=TRUE] = ppFLt[".S12O.FA__O__F.1999q4:"]
aall[F..S2.S12Q.F._O., usenames=TRUE, onlyna=TRUE] = ppFLt[".S12Q.FA__O__F.1999q4:"]
aall[F..S2.S12R.F._O., usenames=TRUE, onlyna=TRUE] = ppFLt[".S12M.FA__O__F.1999q4:"]

aall[F..S2.S121.F._P., usenames=TRUE, onlyna=TRUE] = ppFLt[".S121.FA__P__F.1999q4:"]
aall[F..S2.S12T.F._P., usenames=TRUE, onlyna=TRUE] = ppFLt[".S12T.FA__P__F.1999q4:"]
aall[F..S2.S13.F._P., usenames=TRUE, onlyna=TRUE] = ppFLt[".S13.FA__P__F.1999q4:"]
aall[F..S2.S11.F._P., usenames=TRUE, onlyna=TRUE] = ppFLt[".S1P.FA__P__F.1999q4:"]
aall[F..S2.S124.F._P., usenames=TRUE, onlyna=TRUE] = ppFLt[".S124.FA__P__F.1999q4:"]
aall[F..S2.S12O.F._P., usenames=TRUE, onlyna=TRUE] = ppFLt[".S12O.FA__P__F.1999q4:"]
aall[F..S2.S12Q.F._P., usenames=TRUE, onlyna=TRUE] = ppFLt[".S12Q.FA__P__F.1999q4:"]
aall[F..S2.S12R.F._P., usenames=TRUE, onlyna=TRUE] = ppFLt[".S12M.FA__P__F.1999q4:"]

aall[F..S2.S121.F._F., usenames=TRUE, onlyna=TRUE] = ppFLt[".S121.FA__F__F7.1999q4:"]
aall[F..S2.S12T.F._F., usenames=TRUE, onlyna=TRUE] =ppFLt[".S12T.FA__F__F7.1999q4:"]
aall[F..S2.S13.F._F., usenames=TRUE, onlyna=TRUE] = ppFLt[".S13.FA__F__F7.1999q4:"]
aall[F..S2.S11.F._F., usenames=TRUE, onlyna=TRUE] = ppFLt[".S1P.FA__F__F7.1999q4:"]
aall[F..S2.S124.F._F., usenames=TRUE, onlyna=TRUE] = ppFLt[".S124.FA__F__F7.1999q4:"]
aall[F..S2.S12O.F._F., usenames=TRUE, onlyna=TRUE] = ppFLt[".S12O.FA__F__F7.1999q4:"]
aall[F..S2.S12Q.F._F., usenames=TRUE, onlyna=TRUE] = ppFLt[".S12Q.FA__F__F7.1999q4:"]
aall[F..S2.S12R.F._F., usenames=TRUE, onlyna=TRUE] = ppFLt[".S12M.FA__F__F7.1999q4:"]

# Process F2M (sum of F22 and F29)
print('filling NAs of crossborder F2M assets')
##stocks F2 deposits and currency - Assets for Qdata
aaF2 = laiip[..FA__O__F2+FA__R__F2.]
ppF2M = copy(aaF2[..FA__O__F2+FA__R__F2.])
aall[F2M..S121.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF2M[".S121.FA__O__F2.1999q4:"]
aall[F2M..S121.S2.LE._R., usenames=TRUE, onlyna=TRUE] =ppF2M[".S121.FA__R__F2.1999q4:"]
aall[F2M..S121.S2.LE.FNR., usenames=TRUE] = ppF2M[".S121.FA__R__F2.1999q4:"]
aall[F2M..S12T.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF2M[".S12T.FA__O__F2.1999q4:"]
aall[F2M..S13.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF2M[".S13.FA__O__F2.1999q4:"]
aall[F2M..S11.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF2M[".S11.FA__O__F2.1999q4:"]
aall[F2M..S1M.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF2M[".S1M.FA__O__F2.1999q4:"]
aall[F2M..S124.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF2M[".S124.FA__O__F2.1999q4:"]
aall[F2M..S12O.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF2M[".S12O.FA__O__F2.1999q4:"]
aall[F2M..S12Q.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF2M[".S12Q.FA__O__F2.1999q4:"]
aall[F2M..S12R.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF2M[".S12M.FA__O__F2.1999q4:"]

##flows F2 deposits and currency - Assets for Qdata
aaF2t = labop[..FA__O__F2+FA__R__F2.]
ppF2Mt = copy(aaF2t[..FA__O__F2+FA__R__F2.])
aall[F2M..S121.S2.F._O., usenames=TRUE, onlyna=TRUE] = ppF2Mt[".S121.FA__O__F2.1999q4:"]
aall[F2M..S121.S2.F._R., usenames=TRUE, onlyna=TRUE] = ppF2Mt[".S121.FA__R__F2.1999q4:"]
aall[F2M..S121.S2.F.FNR., usenames=TRUE] = ppF2Mt[".S121.FA__R__F2.1999q4:"]
aall[F2M..S12T.S2.F._O., usenames=TRUE, onlyna=TRUE] = ppF2Mt[".S12T.FA__O__F2.1999q4:"]
aall[F2M..S13.S2.F._O., usenames=TRUE, onlyna=TRUE] = ppF2Mt[".S13.FA__O__F2.1999q4:"]
aall[F2M..S11.S2.F._O., usenames=TRUE, onlyna=TRUE] = ppF2Mt[".S1P.FA__O__F2.1999q4:"]
aall[F2M..S124.S2.F._O., usenames=TRUE, onlyna=TRUE] = ppF2Mt[".S124.FA__O__F2.1999q4:"]
aall[F2M..S12O.S2.F._O., usenames=TRUE, onlyna=TRUE] = ppF2Mt[".S12O.FA__O__F2.1999q4:"]
aall[F2M..S12Q.S2.F._O., usenames=TRUE, onlyna=TRUE] = ppF2Mt[".S12Q.FA__O__F2.1999q4:"]
aall[F2M..S12R.S2.F._O., usenames=TRUE, onlyna=TRUE] = ppF2Mt[".S12M.FA__O__F2.1999q4:"]


# Process F2M (sum of F22 and F29)
print('filling NAs of crossborder F2M liabilities')
## stocks F2 deposits and currency - Liabilities for Qdata
llF2 = lliip[..FA__O__F2+FA__R__F2.]
ppF2M = copy(llF2[..FA__O__F2+FA__R__F2.])
aall[F2M..S2.S121.LE._O., usenames=TRUE, onlyna=TRUE] = ppF2M[".S121.FA__O__F2.1999q4:"]
aall[F2M..S2.S121.LE._R., usenames=TRUE, onlyna=TRUE] = ppF2M[".S121.FA__R__F2.1999q4:"]
aall[F2M..S2.S12T.LE._O., usenames=TRUE, onlyna=TRUE] = ppF2M[".S12T.FA__O__F2.1999q4:"]
aall[F2M..S2.S13.LE._O., usenames=TRUE, onlyna=TRUE] = ppF2M[".S13.FA__O__F2.1999q4:"]

## flows F2 deposits and currency - Liabilities for Qdata
llF2t = llbop[..FA__O__F2+FA__R__F2.]
ppF2Mt = copy(llF2t[..FA__O__F2+FA__R__F2.])
aall[F2M..S2.S121.F._O., usenames=TRUE, onlyna=TRUE] = ppF2Mt[".S121.FA__O__F2.1999q4:"]
aall[F2M..S2.S121.F._R., usenames=TRUE, onlyna=TRUE] = ppF2Mt[".S121.FA__R__F2.1999q4:"]
aall[F2M..S2.S12T.F._O., usenames=TRUE, onlyna=TRUE] = ppF2Mt[".S12T.FA__O__F2.1999q4:"]
aall[F2M..S2.S13.F._O., usenames=TRUE, onlyna=TRUE] = ppF2Mt[".S13.FA__O__F2.1999q4:"]


# Process F3 (from Direct Investment, Portfolio Investment, Reserve Assets)
print('filling NAs of crossborder F3 assets')
## stocks F3 bonds total - Assets for Qdata
aaF3M = laiip[..FA__D__F3+FA__P__F3+FA__R__F3.]
ppF3MA = copy(aaF3M[..FA__D__F3+FA__P__F3+FA__R__F3.])
aall[F3..S121.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF3MA[".S121.FA__P__F3.1999q4:"]
aall[F3..S121.S2.LE._R., usenames=TRUE, onlyna=TRUE] = ppF3MA[".S121.FA__R__F3.1999q4:"]
aall[F3..S12T.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF3MA[".S12T.FA__P__F3.1999q4:"]
aall[F3..S13.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF3MA[".S13.FA__P__F3.1999q4:"]
aall[F3..S11.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF3MA[".S11.FA__P__F3.1999q4:"]
aall[F3..S1M.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF3MA[".S1M.FA__P__F3.1999q4:"]
aall[F3..S124.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF3MA[".S124.FA__P__F3.1999q4:"]
aall[F3..S12O.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF3MA[".S12O.FA__P__F3.1999q4:"]
aall[F3..S12Q.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF3MA[".S12Q.FA__P__F3.1999q4:"]
aall[F3..S12R.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF3MA[".S12M.FA__P__F3.1999q4:"]

## flows F3 bonds total - Assets for Qdata
aaF3Mt = labop[..FA__D__F3+FA__P__F3+FA__R__F3.]
ppF3MAt = copy(aaF3Mt[..FA__D__F3+FA__P__F3+FA__R__F3.])
aall[F3..S121.S2.F._T., usenames=TRUE, onlyna=TRUE] = ppF3MAt[".S121.FA__D__F3.1999q4:"])+ppF3MAt[".S121.FA__T__F3.1999q4:"])+ppF3MAt[".S121.FA__R__F3.1999q4:"])
aall[F3..S12T.S2.F._T., usenames=TRUE, onlyna=TRUE] = ppF3MAt[".S12T.FA__D__F3.1999q4:"])+ppF3MAt[".S12T.FA__T__F3.1999q4:"])
aall[F3..S13.S2.F._T., usenames=TRUE, onlyna=TRUE] = ppF3MAt[".S13.FA__D__F3.1999q4:"])+ppF3MAt[".S13.FA__T__F3.1999q4:"])
aall[F3..S11.S2.F._T., usenames=TRUE, onlyna=TRUE] = ppF3MAt[".S1P.FA__D__F3.1999q4:"])+ppF3MAt[".S1P.FA__T__F3.1999q4:"])
aall[F3..S124.S2.F._T., usenames=TRUE, onlyna=TRUE] = ppF3MAt[".S124.FA__D__F3.1999q4:"])+ppF3MAt[".S124.FA__T__F3.1999q4:"])
aall[F3..S12O.S2.F._T., usenames=TRUE, onlyna=TRUE] = ppF3MAt[".S12O.FA__D__F3.1999q4:"])+ppF3MAt[".S12O.FA__T__F3.1999q4:"])
aall[F3..S12Q.S2.F._T., usenames=TRUE, onlyna=TRUE] = ppF3MAt[".S12Q.FA__D__F3.1999q4:"])+ppF3MAt[".S12Q.FA__T__F3.1999q4:"])
aall[F3..S12R.S2.F._T., usenames=TRUE, onlyna=TRUE] = ppF3MAt[".S12M.FA__D__F3.1999q4:"])+ppF3MAt[".S12M.FA__T__F3.1999q4:"])


## F3 bonds total - liabilities for Qdata
# Process F3 (from Direct Investment, Portfolio Investment)
print('filling NAs of crossborder F3 liabilities')
## stocks F3 bonds total - liabilities for Qdata
llF3M = lliip[..FA__D__F3+FA__P__F3.]
ppF3ML = copy(llF3M[..FA__D__F3+FA__P__F3.])
aall[F3..S2.S121.LE._P., usenames=TRUE, onlyna=TRUE] = ppF3ML[".S121.FA__P__F3.1999q4:"]
aall[F3..S2.S12T.LE._P., usenames=TRUE, onlyna=TRUE] = ppF3ML[".S12T.FA__P__F3.1999q4:"]
aall[F3..S2.S13.LE._P., usenames=TRUE, onlyna=TRUE] = ppF3ML[".S13.FA__P__F3.1999q4:"]
aall[F3..S2.S11.LE._P., usenames=TRUE, onlyna=TRUE] = ppF3ML[".S11.FA__P__F3.1999q4:"]
aall[F3..S2.S1M.LE._P., usenames=TRUE, onlyna=TRUE] = ppF3ML[".S1M.FA__P__F3.1999q4:"]
aall[F3..S2.S124.LE._P., usenames=TRUE, onlyna=TRUE] = ppF3ML[".S124.FA__P__F3.1999q4:"]
aall[F3..S2.S12O.LE._P., usenames=TRUE, onlyna=TRUE] = ppF3ML[".S12O.FA__P__F3.1999q4:"]
aall[F3..S2.S12Q.LE._P., usenames=TRUE, onlyna=TRUE] = ppF3ML[".S12Q.FA__P__F3.1999q4:"]
aall[F3..S2.S12R.LE._P., usenames=TRUE, onlyna=TRUE] = ppF3ML[".S12M.FA__P__F3.1999q4:"]

## flows F3 bonds total - liabilities for Qdata
llF3Mt = llbop[..FA__D__F3+FA__P__F3.]
ppF3MLt = copy(llF3Mt[..FA__D__F3+FA__P__F3.])
aall[F3..S2.S121.F._P., usenames=TRUE, onlyna=TRUE] = ppF3MLt[".S121.FA__P__F3.1999q4:"]
aall[F3..S2.S12T.F._P., usenames=TRUE, onlyna=TRUE] = ppF3MLt[".S12T.FA__P__F3.1999q4:"]
aall[F3..S2.S13.F._P., usenames=TRUE, onlyna=TRUE] = ppF3MLt[".S13.FA__P__F3.1999q4:"]
aall[F3..S2.S11.F._P., usenames=TRUE, onlyna=TRUE] = ppF3MLt[".S1P.FA__P__F3.1999q4:"]
aall[F3..S2.S124.F._P., usenames=TRUE, onlyna=TRUE] = ppF3MLt[".S124.FA__P__F3.1999q4:"]
aall[F3..S2.S12O.F._P., usenames=TRUE, onlyna=TRUE] = ppF3MLt[".S12O.FA__P__F3.1999q4:"]
aall[F3..S2.S12Q.F._P., usenames=TRUE, onlyna=TRUE] = ppF3MLt[".S12Q.FA__P__F3.1999q4:"]
aall[F3..S2.S12R.F._P., usenames=TRUE, onlyna=TRUE] = ppF3MLt[".S12M.FA__P__F3.1999q4:"]


# Process F4 (sum of F4 from Direct Investment, Other Investment)
print('filling NAs of crossborder F4 assets')
## stocks F4 loans total - Assets for Qdata
aaF4 = laiip[..FA__D__F4+FA__O__F4.]
ppF4A = copy(aaF4[..FA__D__F4+FA__O__F4.])
aall[F4..S121.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF4A[".S121.FA__O__F4.1999q4:"]
aall[F4..S12T.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF4A[".S12T.FA__O__F4.1999q4:"]
aall[F4..S13.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF4A[".S13.FA__O__F4.1999q4:"]
aall[F4..S11.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF4A[".S11.FA__O__F4.1999q4:"]
aall[F4..S1M.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF4A[".S1M.FA__O__F4.1999q4:"]
aall[F4..S124.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF4A[".S124.FA__O__F4.1999q4:"]
aall[F4..S12O.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF4A[".S12O.FA__O__F4.1999q4:"]
aall[F4..S12Q.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF4A[".S12Q.FA__O__F4.1999q4:"]
aall[F4..S12R.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF4A[".S12M.FA__O__F4.1999q4:"]

## flows F4 loans total - Assets for Qdata
aaF4t = labop[..FA__D__F4+FA__O__F4.]
ppF4At = copy(aaF4t[..FA__D__F4+FA__O__F4.])
aall[F4..S121.S2.F._O., usenames=TRUE, onlyna=TRUE] = ppF4At[".S121.FA__O__F4.1999q4:"]
aall[F4..S12T.S2.F._O., usenames=TRUE, onlyna=TRUE] = ppF4At[".S12T.FA__O__F4.1999q4:"]
aall[F4..S13.S2.F._O., usenames=TRUE, onlyna=TRUE] = ppF4At[".S13.FA__O__F4.1999q4:"]
aall[F4..S11.S2.F._O., usenames=TRUE, onlyna=TRUE] = ppF4At[".S1P.FA__O__F4.1999q4:"]
aall[F4..S124.S2.F._O., usenames=TRUE, onlyna=TRUE] = ppF4At[".S124.FA__O__F4.1999q4:"]
aall[F4..S12O.S2.F._O., usenames=TRUE, onlyna=TRUE] = ppF4At[".S12O.FA__O__F4.1999q4:"]
aall[F4..S12Q.S2.F._O., usenames=TRUE, onlyna=TRUE] = ppF4At[".S12Q.FA__O__F4.1999q4:"]
aall[F4..S12R.S2.F._O., usenames=TRUE, onlyna=TRUE] = ppF4At[".S12M.FA__O__F4.1999q4:"]


# Process F4 (sum of F4 from Direct Investment, Other Investment)
print('filling NAs of crossborder F4 liabilities')
## stocks F4 loans total - liabilities for Qdata
llF4 = lliip[..FA__D__F4+FA__O__F4.]
ppF4L = copy(llF4[..FA__D__F4+FA__O__F4.])
aall[F4..S2.S121.LE._O., usenames=TRUE, onlyna=TRUE] = ppF4L[".S121.FA__O__F4.1999q4:"]
aall[F4..S2.S12T.LE._O., usenames=TRUE, onlyna=TRUE] = ppF4L[".S12T.FA__O__F4.1999q4:"]
aall[F4..S2.S13.LE._O., usenames=TRUE, onlyna=TRUE] = ppF4L[".S13.FA__O__F4.1999q4:"]
aall[F4..S2.S11.LE._O., usenames=TRUE, onlyna=TRUE] = ppF4L[".S11.FA__O__F4.1999q4:"]
aall[F4..S2.S1M.LE._O., usenames=TRUE, onlyna=TRUE] = ppF4L[".S1M.FA__O__F4.1999q4:"]
aall[F4..S2.S124.LE._O., usenames=TRUE, onlyna=TRUE] = ppF4L[".S124.FA__O__F4.1999q4:"]
aall[F4..S2.S12O.LE._O., usenames=TRUE, onlyna=TRUE] = ppF4L[".S12O.FA__O__F4.1999q4:"]
aall[F4..S2.S12Q.LE._O., usenames=TRUE, onlyna=TRUE] = ppF4L[".S12Q.FA__O__F4.1999q4:"]
aall[F4..S2.S12R.LE._O., usenames=TRUE, onlyna=TRUE] = ppF4L[".S12R.FA__O__F4.1999q4:"]

## flows F4 loans total - liabilities for Qdata
llF4t = llbop[..FA__D__F4+FA__O__F4.]
ppF4Lt = copy(llF4t[..FA__D__F4+FA__O__F4.])
aall[F4..S2.S121.F._O., usenames=TRUE, onlyna=TRUE] = ppF4Lt[".S121.FA__O__F4.1999q4:"]
aall[F4..S2.S12T.F._O., usenames=TRUE, onlyna=TRUE] = ppF4Lt[".S12T.FA__O__F4.1999q4:"]
aall[F4..S2.S13.F._O., usenames=TRUE, onlyna=TRUE] = ppF4Lt[".S13.FA__O__F4.1999q4:"]
aall[F4..S2.S11.F._O., usenames=TRUE, onlyna=TRUE] = ppF4Lt[".S1P.FA__O__F4.1999q4:"]
aall[F4..S2.S124.F._O., usenames=TRUE, onlyna=TRUE] = ppF4Lt[".S124.FA__O__F4.1999q4:"]
aall[F4..S2.S12O.F._O., usenames=TRUE, onlyna=TRUE] = ppF4Lt[".S12O.FA__O__F4.1999q4:"]
aall[F4..S2.S12Q.F._O., usenames=TRUE, onlyna=TRUE] = ppF4Lt[".S12Q.FA__O__F4.1999q4:"]
aall[F4..S2.S12R.F._O., usenames=TRUE, onlyna=TRUE] = ppF4Lt[".S12R.FA__O__F4.1999q4:"]

# Process F52 ( Portfolio Investment)
print('filling NAs of crossborder F52 assets')
## stocks F52 investment fund shares - Assets for Qdata
aaF52 = laiip[..FA__P__F52., drop=FALSE]
ppF52A = copy(aaF52[..FA__P__F52., drop=FALSE])
aall[F52..S121.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF52A[".S121.FA__P__F52.1999q4:"]
aall[F52..S12T.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF52A[".S12T.FA__P__F52.1999q4:"]
aall[F52..S11.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF52A[".S11.FA__P__F52.1999q4:"]
aall[F52..S1M.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF52A[".S1M.FA__P__F52.1999q4:"]
aall[F52..S13.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF52A[".S13.FA__P__F52.1999q4:"]
aall[F52..S124.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF52A[".S124.FA__P__F52.1999q4:"]
aall[F52..S12O.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF52A[".S12O.FA__P__F52.1999q4:"]
aall[F52..S12Q.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF52A[".S12Q.FA__P__F52.1999q4:"]
aall[F52..S12R.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF52A[".S12M.FA__P__F52.1999q4:"]

## stocks F52 investment fund shares - Assets for Qdata
aaF52t = labop[..FA__P__F52., drop=FALSE]
ppF52At = copy(aaF52t[..FA__P__F52., drop=FALSE])
aall[F52..S121.S2.F._P., usenames=TRUE, onlyna=TRUE] = ppF52At[".S121.FA__P__F52.1999q4:"]
aall[F52..S12T.S2.F._P., usenames=TRUE, onlyna=TRUE] = ppF52At[".S12T.FA__P__F52.1999q4:"]
aall[F52..S11.S2.F._P., usenames=TRUE, onlyna=TRUE] = ppF52At[".S1P.FA__P__F52.1999q4:"]
aall[F52..S13.S2.F._P., usenames=TRUE, onlyna=TRUE] = ppF52At[".S13.FA__P__F52.1999q4:"]
aall[F52..S124.S2.F._P., usenames=TRUE, onlyna=TRUE] = ppF52At[".S124.FA__P__F52.1999q4:"]
aall[F52..S12O.S2.F._P., usenames=TRUE, onlyna=TRUE] = ppF52At[".S12O.FA__P__F52.1999q4:"]
aall[F52..S12Q.S2.F._P., usenames=TRUE, onlyna=TRUE] = ppF52At[".S12Q.FA__P__F52.1999q4:"]
aall[F52..S12R.S2.F._P., usenames=TRUE, onlyna=TRUE] = ppF52At[".S12M.FA__P__F52.1999q4:"]


# Process F52 ( Portfolio Investment)
print('filling NAs of crossborder F52 liabilities')
## stocks F52 investment fund shares - Liabilities for Qdata
llF52 = lliip[..FA__P__F52., drop=FALSE]
ppF52L = copy(llF52[..FA__P__F52., drop=FALSE])
aall[F52..S2.S121.LE._P., usenames=TRUE, onlyna=TRUE] = ppF52L[".S121.FA__P__F52.1999q4:"]
aall[F52..S2.S12T.LE._P., usenames=TRUE, onlyna=TRUE] = ppF52L[".S12T.FA__P__F52.1999q4:"]
aall[F52..S2.S124.LE._P., usenames=TRUE, onlyna=TRUE] = ppF52L[".S124.FA__P__F52.1999q4:"]
aall[F52..S2.S12O.LE._P., usenames=TRUE, onlyna=TRUE] = ppF52L[".S12O.FA__P__F52.1999q4:"]
aall[F52..S2.S12Q.LE._P., usenames=TRUE, onlyna=TRUE] = ppF52L[".S12Q.FA__P__F52.1999q4:"]
aall[F52..S2.S12R.LE._P., usenames=TRUE, onlyna=TRUE] = ppF52L[".S12M.FA__P__F52.1999q4:"]

## flows F52 investment fund shares - Liabilities for Qdata
llF52t = llbop[..FA__P__F52., drop=FALSE]
ppF52Lt = copy(llF52t[..FA__P__F52., drop=FALSE])
aall[F52..S2.S121.F._P., usenames=TRUE, onlyna=TRUE] = ppF52Lt[".S121.FA__P__F52.1999q4:"]
aall[F52..S2.S12T.F._P., usenames=TRUE, onlyna=TRUE] = ppF52Lt[".S12T.FA__P__F52.1999q4:"]
aall[F52..S2.S124.F._P., usenames=TRUE, onlyna=TRUE] = ppF52Lt[".S124.FA__P__F52.1999q4:"]
aall[F52..S2.S12O.F._P., usenames=TRUE, onlyna=TRUE] = ppF52Lt[".S12O.FA__P__F52.1999q4:"]
aall[F52..S2.S12Q.F._P., usenames=TRUE, onlyna=TRUE] = ppF52Lt[".S12Q.FA__P__F52.1999q4:"]
aall[F52..S2.S12R.F._P., usenames=TRUE, onlyna=TRUE] = ppF52Lt[".S12M.FA__P__F52.1999q4:"]


# Process F511 (sum of F511 from Direct Investment and Portfolio Investment)
print('filling NAs of crossborder F511 assets')
## stocks F511 listed shares - Assets for Qdata
aaF511 = laiip[..FA__D__F511+FA__P__F511.]
ppF511A = copy(aaF511[..FA__D__F511+FA__P__F511.])
aall[F511..S121.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF511A[".S121.FA__P__F511.1999q4:"]
aall[F511..S12T.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF511A[".S12T.FA__P__F511.1999q4:"]
aall[F511..S11.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF511A[".S11.FA__P__F511.1999q4:"]
aall[F511..S1M.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF511A[".S1M.FA__P__F511.1999q4:"]
aall[F511..S13.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF511A[".S13.FA__P__F511.1999q4:"]
aall[F511..S124.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF511A[".S124.FA__P__F511.1999q4:"]
aall[F511..S12O.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF511A[".S12O.FA__P__F511.1999q4:"]
aall[F511..S12Q.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF511A[".S12Q.FA__P__F511.1999q4:"]
aall[F511..S12R.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF511A[".S12M.FA__P__F511.1999q4:"]

## flows F511 listed shares - Assets for Qdata
aaF511t = labop[..FA__D__F511+FA__T__F511.]
ppF511At = copy(aaF511t[..FA__D__F511+FA__T__F511.])
aall[F511..S121.S2.F._P., usenames=TRUE, onlyna=TRUE] = ppF511At[".S121.FA__P__F511.1999q4:"]
aall[F511..S12T.S2.F._P., usenames=TRUE, onlyna=TRUE] = ppF511At[".S12T.FA__P__F511.1999q4:"]
aall[F511..S11.S2.F._P., usenames=TRUE, onlyna=TRUE] = ppF511At[".S1P.FA__P__F511.1999q4:"]
aall[F511..S13.S2.F._P., usenames=TRUE, onlyna=TRUE] = ppF511At[".S13.FA__P__F511.1999q4:"]
aall[F511..S124.S2.F._P., usenames=TRUE, onlyna=TRUE] = ppF511At[".S124.FA__P__F511.1999q4:"]
aall[F511..S12O.S2.F._P., usenames=TRUE, onlyna=TRUE] = ppF511At[".S12O.FA__P__F511.1999q4:"]
aall[F511..S12Q.S2.F._P., usenames=TRUE, onlyna=TRUE] = ppF511At[".S12Q.FA__P__F511.1999q4:"]
aall[F511..S12R.S2.F._P., usenames=TRUE, onlyna=TRUE] = ppF511At[".S12M.FA__P__F511.1999q4:"]


# Process F511 (sum of F511 from Direct Investment and Portfolio Investment)
print('filling NAs of crossborder F511 liabiities')
## stocks F511 listed shares - Liabilities for Qdata
llF511 = lliip[..FA__D__F511+FA__P__F511.]
ppF511L = copy(llF511[..FA__D__F511+FA__P__F511.])
aall[F511..S2.S121.LE._P., usenames=TRUE, onlyna=TRUE] = ppF511L[".S121.FA__P__F511.1999q4:"]
aall[F511..S2.S12T.LE._P., usenames=TRUE, onlyna=TRUE] = ppF511L[".S12T.FA__P__F511.1999q4:"]
aall[F511..S2.S11.LE._P., usenames=TRUE, onlyna=TRUE] = ppF511L[".S11.FA__P__F511.1999q4:"]
aall[F511..S2.S13.LE._P., usenames=TRUE, onlyna=TRUE] = ppF511L[".S13.FA__P__F511.1999q4:"]
aall[F511..S2.S124.LE._P., usenames=TRUE, onlyna=TRUE] = ppF511L[".S124.FA__P__F511.1999q4:"]
aall[F511..S2.S12O.LE._P., usenames=TRUE, onlyna=TRUE] = ppF511L[".S12O.FA__P__F511.1999q4:"]
aall[F511..S2.S12Q.LE._P., usenames=TRUE, onlyna=TRUE] = ppF511L[".S12Q.FA__P__F511.1999q4:"]
aall[F511..S2.S12R.LE._P., usenames=TRUE, onlyna=TRUE] = ppF511L[".S12M.FA__P__F511.1999q4:"]

## flows F511 listed shares - Liabilities for Qdata
llF511t = llbop[..FA__D__F511+FA__P__F511.]
ppF511Lt = copy(llF511t[..FA__D__F511+FA__P__F511.])
aall[F511..S2.S121.F._P., usenames=TRUE, onlyna=TRUE] = ppF511Lt[".S121.FA__P__F511.1999q4:"]
aall[F511..S2.S12T.F._P., usenames=TRUE, onlyna=TRUE] = ppF511Lt[".S12T.FA__P__F511.1999q4:"]
aall[F511..S2.S11.F._P., usenames=TRUE, onlyna=TRUE] = ppF511Lt[".S11.FA__P__F511.1999q4:"]
aall[F511..S2.S13.F._P., usenames=TRUE, onlyna=TRUE] = ppF511Lt[".S13.FA__P__F511.1999q4:"]
aall[F511..S2.S124.F._P., usenames=TRUE, onlyna=TRUE] = ppF511Lt[".S124.FA__P__F511.1999q4:"]
aall[F511..S2.S12O.F._P., usenames=TRUE, onlyna=TRUE] = ppF511Lt[".S12O.FA__P__F511.1999q4:"]
aall[F511..S2.S12Q.F._P., usenames=TRUE, onlyna=TRUE] = ppF511Lt[".S12Q.FA__P__F511.1999q4:"]
aall[F511..S2.S12R.F._P., usenames=TRUE, onlyna=TRUE] = ppF511Lt[".S12M.FA__P__F511.1999q4:"]



# Process F51M (sum of F512 and F519 from Direct Investment, Other Investment, Portfolio Investment)
# checkFDI to see if F51M or F512+F519 are filled for Q data 
#check = aa[..FA__D__F51M.2022q4]- aa[..FA__D__F512+FA__D__F519.2022q4] 
print('filling NAs of crossborder F52M assets')
## stocks F51M other equity - Assets for Qdata
aaF51M = laiip[..FA__D__F51M+FA__O__F519+FA__P__F512.]
ppF51MA = copy(aaF51M[..FA__D__F51M+FA__O__F519+FA__P__F512.])
aall[F51M..S121.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF51MA[".S121.FA__P__F512.1999q4:"]
aall[F51M..S12T.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF51MA[".S12T.FA__P__F512.1999q4:"]
aall[F51M..S11.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF51MA[".S11.FA__P__F512.1999q4:"]
aall[F51M..S1M.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF51MA[".S1M.FA__P__F512.1999q4:"]
aall[F51M..S13.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF51MA[".S13.FA__P__F512.1999q4:"]
aall[F51M..S124.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF51MA[".S124.FA__P__F512.1999q4:"]
aall[F51M..S12O.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF51MA[".S12O.FA__P__F512.1999q4:"]
aall[F51M..S12Q.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF51MA[".S12Q.FA__P__F512.1999q4:"]
aall[F51M..S12R.S2.LE._P., usenames=TRUE, onlyna=TRUE] = ppF51MA[".S12M.FA__P__F512.1999q4:"]

aall[F51M..S121.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF51MA[".S121.FA__O__F519.1999q4:"]
aall[F51M..S12T.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF51MA[".S12T.FA__O__F519.1999q4:"]
aall[F51M..S11.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF51MA[".S11.FA__O__F519.1999q4:"]
aall[F51M..S1M.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF51MA[".S1M.FA__O__F519.1999q4:"]
aall[F51M..S13.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF51MA[".S13.FA__O__F519.1999q4:"]
aall[F51M..S124.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF51MA[".S124.FA__O__F519.1999q4:"]
aall[F51M..S12O.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF51MA[".S12O.FA__O__F519.1999q4:"]
aall[F51M..S12Q.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF51MA[".S12Q.FA__O__F519.1999q4:"]
aall[F51M..S12R.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF51MA[".S12M.FA__O__F519.1999q4:"]

## flows F51M other equity - Assets for Qdata
aaF51Mt = labop[..FA__D__F51M+FA__O__F519+FA__P__F512.]
ppF51MAt = copy(aaF51Mt[..FA__D__F51M+FA__O__F519+FA__P__F512.])
aall[F51M..S121.S2.F._P., usenames=TRUE, onlyna=TRUE] = ppF51MAt[".S121.FA__P__F512.1999q4:"]
aall[F51M..S12T.S2.F._P., usenames=TRUE, onlyna=TRUE] = ppF51MAt[".S12T.FA__P__F512.1999q4:"]
aall[F51M..S11.S2.F._P., usenames=TRUE, onlyna=TRUE] = ppF51MAt[".S11.FA__P__F512.1999q4:"]
aall[F51M..S1M.S2.F._P., usenames=TRUE, onlyna=TRUE] = ppF51MAt[".S1M.FA__P__F512.1999q4:"]
aall[F51M..S13.S2.F._P., usenames=TRUE, onlyna=TRUE] = ppF51MAt[".S13.FA__P__F512.1999q4:"]
aall[F51M..S124.S2.F._P., usenames=TRUE, onlyna=TRUE] = ppF51MAt[".S124.FA__P__F512.1999q4:"]
aall[F51M..S12O.S2.F._P., usenames=TRUE, onlyna=TRUE] = ppF51MAt[".S12O.FA__P__F512.1999q4:"]
aall[F51M..S12Q.S2.F._P., usenames=TRUE, onlyna=TRUE] = ppF51MAt[".S12Q.FA__P__F512.1999q4:"]
aall[F51M..S12R.S2.F._P., usenames=TRUE, onlyna=TRUE] = ppF51MAt[".S12M.FA__P__F512.1999q4:"]

aall[F51M..S121.S2.F._O., usenames=TRUE, onlyna=TRUE] = ppF51MAt[".S121.FA__O__F519.1999q4:"]
aall[F51M..S12T.S2.F._O., usenames=TRUE, onlyna=TRUE] = ppF51MAt[".S12T.FA__O__F519.1999q4:"]
aall[F51M..S11.S2.F._O., usenames=TRUE, onlyna=TRUE] = ppF51MAt[".S11.FA__O__F519.1999q4:"]
aall[F51M..S1M.S2.F._O., usenames=TRUE, onlyna=TRUE] = ppF51MAt[".S1M.FA__O__F519.1999q4:"]
aall[F51M..S13.S2.F._O., usenames=TRUE, onlyna=TRUE] = ppF51MAt[".S13.FA__O__F519.1999q4:"]
aall[F51M..S124.S2.F._O., usenames=TRUE, onlyna=TRUE] = ppF51MAt[".S124.FA__O__F519.1999q4:"]
aall[F51M..S12O.S2.F._O., usenames=TRUE, onlyna=TRUE] = ppF51MAt[".S12O.FA__O__F519.1999q4:"]
aall[F51M..S12Q.S2.F._O., usenames=TRUE, onlyna=TRUE] = ppF51MAt[".S12Q.FA__O__F519.1999q4:"]
aall[F51M..S12R.S2.F._O., usenames=TRUE, onlyna=TRUE] = ppF51MAt[".S12M.FA__O__F519.1999q4:"]


## F51M other equity - Liabilities for Qdata
# Process F51M (sum of F512 and F519 from Direct Investment, Other Investment, Portfolio Investment)
# checkFDI to see if F51M or F512+F519 are filled for Q data 
#check = aa[..FA__D__F51M.2022q4]- aa[..FA__D__F512+FA__D__F519.2022q4] 
print('filling NAs of crossborder F52M liabilities')
llF51M = lliip[..FA__D__F51M+FA__O__F519+FA__P__F512.]
ppF51ML = copy(llF51M[..FA__D__F51M+FA__O__F519+FA__P__F512.])
aall[F51M..S2.S121.LE._P., usenames=TRUE, onlyna=TRUE] = ppF51ML[".S121.FA__P__F512.1999q4:"]
aall[F51M..S2.S12T.LE._P., usenames=TRUE, onlyna=TRUE] = ppF51ML[".S12T.FA__P__F512.1999q4:"]
aall[F51M..S2.S11.LE._P., usenames=TRUE, onlyna=TRUE] = ppF51ML[".S11.FA__P__F512.1999q4:"]
aall[F51M..S2.S1M.LE._P., usenames=TRUE, onlyna=TRUE] = ppF51ML[".S1M.FA__P__F512.1999q4:"]
aall[F51M..S2.S13.LE._P., usenames=TRUE, onlyna=TRUE] = ppF51ML[".S13.FA__P__F512.1999q4:"]
aall[F51M..S2.S124.LE._P., usenames=TRUE, onlyna=TRUE] = ppF51ML[".S124.FA__P__F512.1999q4:"]
aall[F51M..S2.S12O.LE._P., usenames=TRUE, onlyna=TRUE] = ppF51ML[".S12O.FA__P__F512.1999q4:"]
aall[F51M..S2.S12Q.LE._P., usenames=TRUE, onlyna=TRUE] = ppF51ML[".S12Q.FA__P__F512.1999q4:"]
aall[F51M..S2.S12R.LE._P., usenames=TRUE, onlyna=TRUE] = ppF51ML[".S12M.FA__P__F512.1999q4:"]

aall[F51M..S2.S121.LE._O., usenames=TRUE, onlyna=TRUE] = ppF51ML[".S121.FA__O__F519.1999q4:"]
aall[F51M..S2.S12T.LE._O., usenames=TRUE, onlyna=TRUE] = ppF51ML[".S12T.FA__O__F519.1999q4:"]
aall[F51M..S2.S11.LE._O., usenames=TRUE, onlyna=TRUE] = ppF51ML[".S11.FA__O__F519.1999q4:"]
aall[F51M..S2.S1M.LE._O., usenames=TRUE, onlyna=TRUE] = ppF51ML[".S1M.FA__O__F519.1999q4:"]
aall[F51M..S2.S13.LE._O., usenames=TRUE, onlyna=TRUE] = ppF51ML[".S13.FA__O__F519.1999q4:"]
aall[F51M..S2.S124.LE._O., usenames=TRUE, onlyna=TRUE] = ppF51ML[".S124.FA__O__F519.1999q4:"]
aall[F51M..S2.S12O.LE._O., usenames=TRUE, onlyna=TRUE] = ppF51ML[".S12O.FA__O__F519.1999q4:"]
aall[F51M..S2.S12Q.LE._O., usenames=TRUE, onlyna=TRUE] = ppF51ML[".S12Q.FA__O__F519.1999q4:"]
aall[F51M..S2.S12R.LE._O., usenames=TRUE, onlyna=TRUE] = ppF51ML[".S12M.FA__O__F519.1999q4:"]


## F6  - Assets for Qdata
# Process F6 Other Investment
print('filling NAs of crossborder F6 assets')
aaF6 = laiip[..FA__O__F6., drop=FALSE]
ppF6A = copy(aaF6[..FA__O__F6., drop=FALSE])
aall[F6..S121.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF6A[".S121.FA__O__F6.1999q4:"]
aall[F6..S12T.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF6A[".S12T.FA__O__F6.1999q4:"]
aall[F6..S11.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF6A[".S11.FA__O__F6.1999q4:"]
aall[F6..S1M.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF6A[".S1M.FA__O__F6.1999q4:"]
aall[F6..S13.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF6A[".S13.FA__O__F6.1999q4:"]
aall[F6..S124.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF6A[".S124.FA__O__F6.1999q4:"]
aall[F6..S12O.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF6A[".S12O.FA__O__F6.1999q4:"]
aall[F6..S12Q.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF6A[".S12Q.FA__O__F6.1999q4:"]
aall[F6..S12R.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF6A[".S12M.FA__O__F6.1999q4:"]

## F6  - liabilities for Qdata
# Process F6 Other Investment
print('filling NAs of crossborder F6 liabilities')
llF6 = lliip[..FA__O__F6., drop=FALSE]
ppF6L = copy(llF6[..FA__O__F6., drop=FALSE])
aall[F6..S2.S121.LE._O., usenames=TRUE, onlyna=TRUE] = ppF6L[".S121.FA__O__F6.1999q4:"]
aall[F6..S2.S12T.LE._O., usenames=TRUE, onlyna=TRUE] = ppF6L[".S12T.FA__O__F6.1999q4:"]
aall[F6..S2.S11.LE._O., usenames=TRUE, onlyna=TRUE] = ppF6L[".S11.FA__O__F6.1999q4:"]
aall[F6..S2.S1M.LE._O., usenames=TRUE, onlyna=TRUE] = ppF6L[".S1M.FA__O__F6.1999q4:"]
aall[F6..S2.S13.LE._O., usenames=TRUE, onlyna=TRUE] = ppF6L[".S13.FA__O__F6.1999q4:"]
aall[F6..S2.S124.LE._O., usenames=TRUE, onlyna=TRUE] = ppF6L[".S124.FA__O__F6.1999q4:"]
aall[F6..S2.S12O.LE._O., usenames=TRUE, onlyna=TRUE] = ppF6L[".S12O.FA__O__F6.1999q4:"]
aall[F6..S2.S12Q.LE._O., usenames=TRUE, onlyna=TRUE] = ppF6L[".S12Q.FA__O__F6.1999q4:"]
aall[F6..S2.S12R.LE._O., usenames=TRUE, onlyna=TRUE] = ppF6L[".S12M.FA__O__F6.1999q4:"]

## F81  - Assets for Qdata
# Process F81 from Direct Investment and Other Investment
print('filling NAs of crossborder F81 assets')
aaF81 = laiip[..FA__D__F81+FA__O__F81.]
ppF81A = copy(aaF81[..FA__D__F81+FA__O__F81.])
aall[F81..S121.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF81A[".S121.FA__O__F81.1999q4:"]
aall[F81..S12T.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF81A[".S12T.FA__O__F81.1999q4:"]
aall[F81..S11.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF81A[".S11.FA__O__F81.1999q4:"]
aall[F81..S1M.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF81A[".S1M.FA__O__F81.1999q4:"]
aall[F81..S13.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF81A[".S13.FA__O__F81.1999q4:"]
aall[F81..S124.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF81A[".S124.FA__O__F81.1999q4:"]
aall[F81..S12O.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF81A[".S12O.FA__O__F81.1999q4:"]
aall[F81..S12Q.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF81A[".S12M.FA__O__F81.1999q4:"]

print('filling NAs of crossborder F81 liabilities')
llF81 = lliip[..FA__D__F81+FA__O__F81.]
ppF81L = copy(llF81[..FA__D__F81+FA__O__F81.])
aall[F81..S2.S121.LE._O., usenames=TRUE, onlyna=TRUE] = ppF81L[".S121.FA__O__F81.1999q4:"]
aall[F81..S2.S12T.LE._O., usenames=TRUE, onlyna=TRUE] = ppF81L[".S12T.FA__O__F81.1999q4:"]
aall[F81..S2.S11.LE._O., usenames=TRUE, onlyna=TRUE] = ppF81L[".S11.FA__O__F81.1999q4:"]
aall[F81..S2.S1M.LE._O., usenames=TRUE, onlyna=TRUE] = ppF81L[".S1M.FA__O__F81.1999q4:"]
aall[F81..S2.S13.LE._O., usenames=TRUE, onlyna=TRUE] = ppF81L[".S13.FA__O__F81.1999q4:"]
aall[F81..S2.S124.LE._O., usenames=TRUE, onlyna=TRUE] = ppF81L[".S124.FA__O__F81.1999q4:"]
aall[F81..S2.S12O.LE._O., usenames=TRUE, onlyna=TRUE] = ppF81L[".S12O.FA__O__F81.1999q4:"]
aall[F81..S2.S12Q.LE._O., usenames=TRUE, onlyna=TRUE] = ppF81L[".S12Q.FA__O__F81.1999q4:"]
aall[F81..S2.S12R.LE._O., usenames=TRUE, onlyna=TRUE] = ppF81L[".S12M.FA__O__F81.1999q4:"]

## F89  - Assets for Qdata
# Process F89 from Other Investment
print('filling NAs of crossborder F89 assets')
aaF89 = laiip[..FA__O__F89., drop=FALSE]
ppF89A = copy(aaF89[..FA__O__F89., drop=FALSE])
aall[F89..S121.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF89A[".S121.FA__O__F89.1999q4:"]
aall[F89..S12T.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF89A[".S12T.FA__O__F89.1999q4:"]
aall[F89..S11.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF89A[".S11.FA__O__F89.1999q4:"]
aall[F89..S1M.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF89A[".S1M.FA__O__F89.1999q4:"]
aall[F89..S13.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF89A[".S13.FA__O__F89.1999q4:"]
aall[F89..S124.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF89A[".S124.FA__O__F89.1999q4:"]
aall[F89..S12O.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF89A[".S12O.FA__O__F89.1999q4:"]
aall[F89..S12Q.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF89A[".S12Q.FA__O__F89.1999q4:"]
aall[F89..S12R.S2.LE._O., usenames=TRUE, onlyna=TRUE] = ppF89A[".S12M.FA__O__F89.1999q4:"]

## F89  - Liabilities for Qdata
# Process F89 from Other Investment
print('filling NAs of crossborder F89 liabilities')
llF89 = lliip[..FA__O__F89., drop=FALSE]
ppF89L = copy(llF89[..FA__O__F89., drop=FALSE])
aall[F89..S2.S121.LE._O., usenames=TRUE, onlyna=TRUE] = ppF89L[".S121.FA__O__F89.1999q4:"]
aall[F89..S2.S12T.LE._O., usenames=TRUE, onlyna=TRUE] = ppF89L[".S12T.FA__O__F89.1999q4:"]
aall[F89..S2.S11.LE._O., usenames=TRUE, onlyna=TRUE] = ppF89L[".S11.FA__O__F89.1999q4:"]
aall[F89..S2.S1M.LE._O., usenames=TRUE, onlyna=TRUE] = ppF89L[".S1M.FA__O__F89.1999q4:"]
aall[F89..S2.S13.LE._O., usenames=TRUE, onlyna=TRUE] = ppF89L[".S13.FA__O__F89.1999q4:"]
aall[F89..S2.S124.LE._O., usenames=TRUE, onlyna=TRUE] = ppF89L[".S124.FA__O__F89.1999q4:"]
aall[F89..S2.S12O.LE._O., usenames=TRUE, onlyna=TRUE] = ppF89L[".S12O.FA__O__F89.1999q4:"]
aall[F89..S2.S12Q.LE._O., usenames=TRUE, onlyna=TRUE] = ppF89L[".S12Q.FA__O__F89.1999q4:"]
aall[F89..S2.S12R.LE._O., usenames=TRUE, onlyna=TRUE] = ppF89L[".S12M.FA__O__F89.1999q4:"]

saveRDS(aall,file='data/aall7_funcat.rds')