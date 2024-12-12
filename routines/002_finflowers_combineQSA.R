library(MDecfin)
# Set data directory
data_dir <- if (exists("data_dir")) data_dir else "data"


#setwd('U:/Topics/Spillovers_and_EA/flowoffunds/finflows2024/gitcodedata')
#setwd('C:/Users/aruqaer/R/finflow/gitclone/finflows')

# Load the list of financial flow matrices/arrays from ECB's QSA data
lll=readRDS(file.path(data_dir, 'fflist.rds'))
# The list contains two main components:
# - A: Assets matrices
# - L: Liabilities matrices

# Matrix dimensions in lll:
# 1. INSTR: Financial instrument (e.g., F2M for Deposits)
# 2. REF_AREA: Country holding the stock/receiving flow
# 3. REF_SECTOR: Sector of economic activity holding stock/receiving flow
# 4. COUNTERPART_SECTOR: Sector of economic activity of the counterpart
# 5. STO: Stock (LE) or flow (F) indicator
# 6. CUST_BREAKDOWN: Investment intermediation types
# 7. TIME: Quarter

# Debug/check lines:
#dim(lll$A$F511)  # Check dimensions of F511 instrument in assets
#lapply(lll$L, \(x) {names(dim(x)) })  # List dimension names of liability matrices

# Extract unique reference sectors from all assets matrices
# Creates vector sss containing all unique sectors holding assets
sss=unique(unlist(lapply(lll$A, \(x) {dimnames(x)$REF_SECTOR })))

# Create adjusted copy of liabilities matrices for modification
# Ladj will be used to enforce rules about which sectors can hold which liabilities
lll$Ladj = lll$L

# For deposits (F2M), filter to keep only World (W0) as reference area
# [...] syntax keeps all other dimensions unchanged
# This maintains all sector, time, and other information while focusing on global scope
lll$Ladj$F2M= lll$Ladj$F2M[.W0...]

# Standardize nomenclature: rename second dimension to COUNTERPART_SECTOR 
# Applied to all matrices in adjusted liabilities
lll$Ladj = lapply(lll$Ladj, \(x) {names(dimnames(x))[2L]='COUNTERPART_SECTOR'; x})

# Create a new array 'aall' for F511 (Listed shares) by:
# 1. Starting with F511 assets with domestic scope (W2)
# 2. Adding 'INSTR' as a new dimension with single code 'F511'
# Note: add.dim() creates a new MD3 array with an additional dimension
# The new dimension 'INSTR' will contain the existing data in the 'F511' element
aall=copy(add.dim(lll$A$F511[.W2.....],.dimname = 'INSTR', .dimcodes = 'F511'))

# Fill data for total economy domestic+abroad (S0) using world scope (W0) data
# from assets where sector is total economy (S1)
aall['F511',,,'S0',,,] = lll$A$F511[.W0..S1...]

# Replace data for total economy domestic+abroad (S0) with adjusted liabilities data
aall['F511',,'S0',,,,] = lll$Ladj$F511

# Set NA for any reference sectors that exist in sss (from assets) 
# but not in the current array's REF_SECTOR dimension
# This ensures consistent sector coverage
aall[,,setdiff(sss,dimnames(aall)$REF_SECTOR),,,,]=NA

# Create backup copy
aaraw=copy(aall); #aall=aaraw

# Handle Investment Fund Shares (F52)
# Rule : Only investment funds (S124) can have investment fund shares as liabilities
# Question for Erza/Stefan: Should we add explicit checks to enforce this rule? Or we do it later on?
aall['F52',,,,,'_T',]  =NA  # Clear all F52 data
#aall['F52',,'S124',,,'_T',]  = lll$A$F52[.W2.S124...]  # Why commented?
aall['F52',,,,,'_T',]  = lll$A$F52[.W2....]  # Fill with domestic scope data
aall['F52',,,'S0',,'_T',] = lll$A$F52[.W0..S1..]  # World scope data for total economy
aall['F52',,'S0',,,'_T',] = lll$Ladj$F52  # Adjusted liability data for total economy

# Backup copy
aaraw=copy(aall); #aall=aaraw

# Handle Deposits (F2M)
# Rule : Only banks (S12K - MFIs) and government can have deposits on liabilities side
aall['F2M',,,,,,]  =NA  # Clear all deposits data
aall['F2M',,,,,,]  = lll$A$F2M[.W2.....]  # Fill with domestic scope data
aall['F2M',,,'S12K',,,]  = lll$L$F2M[.W2...]  # Special handling for MFIs (banks) with domestic scope

## FOR ERZA Error: object '.W2.....' not found

aall['F2M',,,'S0',,,] = lll$A$F2M[.W0..S1...]  # World scope data for total economy
# Split flows and stocks for total economy
aall['F2M',,'S0',,'F','_T',] = lll$Ladj$F2M[..F.]  # Flows
aall['F2M',,'S0',,'LE','_T',] = lll$Ladj$F2M[..LE.]  # Stocks

# Backup copy
aaraw=copy(aall); #aall=aaraw

# Handle Loans (F4) - with breakdown by maturity (Total, Short-term, Long-term)
aall['F4',,,,,,]  =NA  # Clear all F4 data
# Total Loans (T)
aall['F4',,,,,,]  = lll$A$F4[.W2....T..]  # Domestic scope
aall['F4',,,'S0',,,] = lll$A$F4[.W0..S1..T..]  # World scope for total economy
aall['F4',,'S0',,,,] = lll$Ladj$F4[...T..]  # Adjusted liabilities

# Short-term Loans (S)
aall['F4S',,,,,,]  = lll$A$F4[.W2....S..]  # Domestic scope
aall['F4S',,,'S0',,,] = lll$A$F4[.W0..S1..S..]  # World scope for total economy
aall['F4S',,'S0',,,,] = lll$Ladj$F4[...S..]  # Adjusted liabilities

# Long-term Loans (L)
aall['F4L',,,,,,]  = lll$A$F4[.W2....L..]  # Domestic scope
aall['F4L',,,'S0',,,] = lll$A$F4[.W0..S1..L..]  # World scope for total economy
aall['F4L',,'S0',,,,] = lll$Ladj$F4[...L..]  # Adjusted liabilities

# Initialize aggregate Debt Securities category
aall['F3+F3S+F3L',,,,,,] = NA

# Handle Debt Securities (F3) - with breakdown by maturity (Total, Short-term, Long-term)
# Total Debt Securities (T)
aall['F3',,,,,,]  = lll$A$F3[.W2....T..]  # Domestic scope base data
aall['F3',,,'S0',,,]  = lll$A$F3[.W0..S1..T..]  # World scope for total economy
aall['F3',,'S0',   ,,,]  = lll$Ladj$F3[...T..]  # Adjusted liabilities

# Short-term Debt Securities (S)
aall['F3S',,,,,,]  = lll$A$F3[.W2....S..]  # Domestic scope
aall['F3S',,,'S0',,,]  = lll$A$F3[.W0..S1..S..]  # World scope for total economy
aall['F3S',,'S0',   ,,,]  = lll$Ladj$F3[...S..]  # Adjusted liabilities

# Long-term Debt Securities (L)
aall['F3L',,,,,,]  = lll$A$F3[.W2....L..]  # Domestic scope
aall['F3L',,,'S0',,,]  = lll$A$F3[.W0..S1..L..]  # World scope for total economy
aall['F3L',,'S0',   ,,,]  = lll$Ladj$F3[...L..]  # Adjusted liabilities

# Handle Currency (F21)
aall['F21',,,,,,]=NA  # Clear all F21 data
aall['F21',,,'S0',,'_T',] = lll$A$F21  # Set total economy assets
aall['F21',,'S0',,,'_T',] = lll$Ladj$F21  # Set total economy liabilities

# Handle remaining instruments
irest=setdiff(names(lll$A), dimnames(aall)[[1]])  # Find instruments not yet processed
for (i in irest) {
  message(' doing ',i, '  ...')
  aall[i,,,,,,]=NA  # Clear data for instrument
  aall[i,,,'S0',,,]=lll$A[[i]][]  # Set total economy assets
  # Handle liabilities based on whether they have CUST_BREAKDOWN dimension
  # Question for Erza: why???
  if ('CUST_BREAKDOWN' %in% names(dim(lll$Ladj[[i]]))) {
    aall[i,,'S0',,,,]=lll$Ladj[[i]]  # Use full breakdown if available
  } else {
    aall[i,,'S0',,,'_T',]=lll$Ladj[[i]]  # Use total if no breakdown
  }
}

### stetting order to sectors and calculating RoW (S2) - saving as aall1
dimnames(aall)[[3]]
dim(aall)

# set order for sectors 
sorder=strsplit('S121+S12T+S124+S12O+S12Q+S13+S11+S1M+S2+S0+S1+S12K',split='\\+')[[1L]]
aall[..S2....]=NA; aall[...S2...]=NA
dall=as.data.table(aall,na.rm=TRUE, simple=TRUE)
ddn=attr(dall,'dcstruct')
ddn$REF_SECTOR = ddn$REF_SECTOR[sorder,]
ddn$COUNTERPART_SECTOR = ddn$COUNTERPART_SECTOR[sorder,]
attr(dall,'dcstruct') = ddn
aall=as.md3(dall)
aall[..S2....] = aall[..S0....] - aall[..S1....]
aall[...S2...] = aall[...S0...] - aall[...S1...]
#aall[F511.DK...LE._T.2023q4]
# Save 
saveRDS(aall, file.path(data_dir, 'aall1.rds'))


