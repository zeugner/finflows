<<<<<<< HEAD
#############################################
# SHSS/SHS loader & harmonise (ECB datasets)
# -------------------------------------------
# Purpose:
#   - Download ECB Securities Holdings Statistics (SHS) and 
#     Securities Holdings Statistics by Sector (SHSS)
#   - Enforce key accounting identities and naming consistency
#   - Harmonise dimensions, build aggregates, and merge into a single cube
#
# Notes:
#   - Values are in million EUR / market valuation as per SDMX queries
#   - SHSS available from 2021Q1; SHS (EA19 holder) from 2013Q4–2022Q1.
#     Overlap window used to align logic: 2021Q1–2022Q1.
#############################################

# Load required packages
library(MDstats)
library(MD3)

# Set data directory
if (!exists("data_dir")) data_dir = getwd()

# Faster paste0 via internal (used nowhere below, but kept if needed)
`%&%` = function (..., collapse = NULL, recycle0 = FALSE)  .Internal(paste0(list(...), collapse, recycle0))

##--------------------------------------------------------------------
## Load raw data from ECB 
##--------------------------------------------------------------------

# --- SHSS ---
# In MIO EUR, market valuation.
# Reference area with breakdown of reference sectors vis-à-vis W0/W1/W2 counterpart areas
# and counterpart-sector breakdown; available as of 2021Q1.
ashssraw=mds('ECB/SHSS/Q.N.....N.A.LE+F.F3+F511+F521+F522.._Z.XDC._T.M.V.N._T', labels=TRUE, ccode = NULL)
saveRDS(ashssraw, file=file.path(data_dir, 'ashssraw.rds'))

# --- SHS ---
# In MEUR, market valuation. Holder country = EA19 (I8). 2013Q4–2022Q1.
ashsraw=mds('ECB/SHS/Q.I8...._X.LE...EUR.M.A.A.A._X._X.V._T.ZZZ',labels=TRUE, ccode = NULL) ##EA holdings
saveRDS(ashsraw, file=file.path(data_dir, 'ashsraw.rds'))

gc()

##--------------------------------------------------------------------
## Data preparation
##--------------------------------------------------------------------

## Work copies
ashss=ashssraw
ashs=ashsraw

## --- Enforce accounting identities --- ##

# --- SHSS ---

# total debt securities by maturity
ashss[,,,,,'F3S',,]=NA; ashss[,,,,,'F3L',,]=NA;
ashss[.....F3S._Z.] = ashss[.....F3.S.]; gc()
ashss[.....F3L._Z.] = ashss[.....F3.L.]; gc() 

# total investment fund shares
ashss[.....F52..]=ashss[.....F521..]+ashss[.....F522..]; gc()

# fill missing aggregates from components only if NA
ashss[,,,,,,'_Z',, onlyna=TRUE] = ashss[,,,,,,'T',]; gc()

#adjust iso code
dimnames(ashss)[['REF_AREA']] = ccode(dimnames(ashss)[['REF_AREA']],2,'iso2m'); gc()
dimnames(ashss)[['COUNTERPART_AREA']] = ccode(dimnames(ashss)[['COUNTERPART_AREA']],2,'iso2m',leaveifNA=TRUE); gc()
gc()

# --- SHS ---

# total debt securities by maturity
ashs[,,,'F3S',,]=NA; ashs[,,,'F3L',,]=NA;
ashs[,,,'F3S','_Z',] =  ashs[,,,'F3','S',]; gc()
ashs[,,,'F3L','_Z',] =  ashs[,,,'F3','L',]; gc()

# total investment fund shares are already included as F52

# fill missing aggregates from components only if NA
ashs[...._Z., onlyna=TRUE]=ashs[....L.] + ashs[....S.]

## please describe EU institutions logic behind this step @stefano  
ashs['4Y','S1ZK',,,,]=ashs['4Y','S1N',,,,] ##all EU institutions
ashs['4Y',,'S1ZK',,,]=ashs['4Y',,'S1N',,,] ##all EU institutions
ashs['4Y','S1ZK',,,,,onlyna=TRUE]=0

# Rename dimensions for clarity (matches SHSS naming later on merge)
names(dimnames(ashs))[1] = 'COUNTERPART_AREA'
names(dimnames(ashs))[2] = 'REF_SECTOR'
names(dimnames(ashs))[3] = 'COUNTERPART_SECTOR'
gc()

# Add REF_AREA (EA19) and STO (LE) dims to mirror SHSS structure
ashs=add.dim(ashs,.dimname = 'REF_AREA', .dimcodes = 'I8')
ashs=add.dim(ashs,.dimname = 'STO', .dimcodes = 'LE')
gc()

# Harmonise iso codes
dimnames(ashs)[['REF_AREA']] = ccode(dimnames(ashs)[['REF_AREA']],2,'iso2m'); gc()
dimnames(ashs)[['COUNTERPART_AREA']] = ccode(dimnames(ashs)[['COUNTERPART_AREA']],2,'iso2m',leaveifNA=TRUE); gc()

gc()
# Reorder to
ashs=aperm(ashs,c(2:5,1,6:8))

##--------------------------------------------------------------------
## Merge SHSS & SHS and keep aggregate maturity (_Z)
##--------------------------------------------------------------------
ash = merge(ashss,ashs, along='source', newcodes=c('shss','shs')); gc()
ash=ash['......._Z.']; gc()

##--------------------------------------------------------------------
## Save results
##--------------------------------------------------------------------

=======
#############################################
# SHSS/SHS loader & harmonise (ECB datasets)
# -------------------------------------------
# Purpose:
#   - Download ECB Securities Holdings Statistics (SHS) and 
#     Securities Holdings Statistics by Sector (SHSS)
#   - Enforce key accounting identities and naming consistency
#   - Harmonise dimensions, build aggregates, and merge into a single cube
#
# Notes:
#   - Values are in million EUR / market valuation as per SDMX queries
#   - SHSS available from 2021Q1; SHS (EA19 holder) from 2013Q4–2022Q1.
#     Overlap window used to align logic: 2021Q1–2022Q1.
#############################################

# Load required packages
library(MDstats)
library(MD3)

# Set data directory
if (!exists("data_dir")) data_dir = getwd()

# Faster paste0 via internal (used nowhere below, but kept if needed)
`%&%` = function (..., collapse = NULL, recycle0 = FALSE)  .Internal(paste0(list(...), collapse, recycle0))

##--------------------------------------------------------------------
## Load raw data from ECB 
##--------------------------------------------------------------------

# --- SHSS ---
# In MIO EUR, market valuation.
# Reference area with breakdown of reference sectors vis-à-vis W0/W1/W2 counterpart areas
# and counterpart-sector breakdown; available as of 2021Q1.
ashssraw=mds('ECB/SHSS/Q.N.....N.A.LE+F.F3+F511+F521+F522.._Z.XDC._T.M.V.N._T', labels=TRUE, ccode = NULL)
saveRDS(ashssraw, file=file.path(data_dir, 'ashssraw.rds'))

# --- SHS ---
# In MEUR, market valuation. Holder country = EA19 (I8). 2013Q4–2022Q1.
ashsraw=mds('ECB/SHS/Q.I8...._X.LE...EUR.M.A.A.A._X._X.V._T.ZZZ',labels=TRUE, ccode = NULL) ##EA holdings
saveRDS(ashsraw, file=file.path(data_dir, 'ashsraw.rds'))

gc()

##--------------------------------------------------------------------
## Data preparation
##--------------------------------------------------------------------

## Work copies
ashss=ashssraw
ashs=ashsraw

## --- Enforce accounting identities --- ##

# --- SHSS ---

# total debt securities by maturity
ashss[,,,,,'F3S',,]=NA; ashss[,,,,,'F3L',,]=NA;
ashss[.....F3S._Z.] = ashss[.....F3.S.]; gc()
ashss[.....F3L._Z.] = ashss[.....F3.L.]; gc() 

# total investment fund shares
ashss[.....F52..]=ashss[.....F521..]+ashss[.....F522..]; gc()

# fill missing aggregates from components only if NA
ashss[,,,,,,'_Z',, onlyna=TRUE] = ashss[,,,,,,'T',]; gc()

#adjust iso code
dimnames(ashss)[['REF_AREA']] = ccode(dimnames(ashss)[['REF_AREA']],2,'iso2m'); gc()
dimnames(ashss)[['COUNTERPART_AREA']] = ccode(dimnames(ashss)[['COUNTERPART_AREA']],2,'iso2m',leaveifNA=TRUE); gc()
gc()

# --- SHS ---

# total debt securities by maturity
ashs[,,,'F3S',,]=NA; ashs[,,,'F3L',,]=NA;
ashs[,,,'F3S','_Z',] =  ashs[,,,'F3','S',]; gc()
ashs[,,,'F3L','_Z',] =  ashs[,,,'F3','L',]; gc()

# total investment fund shares are already included as F52

# fill missing aggregates from components only if NA
ashs[...._Z., onlyna=TRUE]=ashs[....L.] + ashs[....S.]

## please describe EU institutions logic behind this step @stefano  
ashs['4Y','S1ZK',,,,]=ashs['4Y','S1N',,,,] ##all EU institutions
ashs['4Y',,'S1ZK',,,]=ashs['4Y',,'S1N',,,] ##all EU institutions
ashs['4Y','S1ZK',,,,,onlyna=TRUE]=0

# Rename dimensions for clarity (matches SHSS naming later on merge)
names(dimnames(ashs))[1] = 'COUNTERPART_AREA'
names(dimnames(ashs))[2] = 'REF_SECTOR'
names(dimnames(ashs))[3] = 'COUNTERPART_SECTOR'
gc()

# Add REF_AREA (EA19) and STO (LE) dims to mirror SHSS structure
ashs=add.dim(ashs,.dimname = 'REF_AREA', .dimcodes = 'I8')
ashs=add.dim(ashs,.dimname = 'STO', .dimcodes = 'LE')
gc()

# Harmonise iso codes
dimnames(ashs)[['REF_AREA']] = ccode(dimnames(ashs)[['REF_AREA']],2,'iso2m'); gc()
dimnames(ashs)[['COUNTERPART_AREA']] = ccode(dimnames(ashs)[['COUNTERPART_AREA']],2,'iso2m',leaveifNA=TRUE); gc()

gc()
# Reorder to
ashs=aperm(ashs,c(2:5,1,6:8))

##--------------------------------------------------------------------
## Merge SHSS & SHS and keep aggregate maturity (_Z)
##--------------------------------------------------------------------
ash = merge(ashss,ashs, along='source', newcodes=c('shss','shs')); gc()
ash=ash['......._Z.']; gc()

##--------------------------------------------------------------------
## Save results
##--------------------------------------------------------------------

>>>>>>> 55a5a789115f3c6e93936ceaded19180b9724739
saveRDS(ash, file=file.path(data_dir, 'ash.rds'))