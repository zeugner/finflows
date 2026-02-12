# Load required packages
library(MDstats)
library(MD3)

# Set data directory
if (!exists("data_dir")) data_dir = getwd()

# Load the list of financial flow matrices/arrays from ECB's QSA data
lll=readRDS(file.path(data_dir, 'fflist.rds'))
# The list contains two main components:
# - A: Assets matrices
# - L: Liabilities matrices

# Matrix dimensions in aall:
# 1. INSTR: Financial instrument (e.g., F2M for Deposits)
# 2. REF_AREA: Country holding the stock/receiving flow
# 3. REF_SECTOR: Sector of economic activity holding stock/receiving flow
# 4. COUNTERPART_SECTOR: Sector of economic activity of the counterpart
# 5. STO: Stock (LE) or flow (F) indicator
# 6. CUST_BREAKDOWN: Investment intermediation types
# 7. TIME: Quarter

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
aall=copy(add.dim(lll$A$F511[N..W2...N.A..F511._Z._Z.XDC._T.S.V.N..],.dimname = 'INSTR', .dimcodes = 'F511'))

#old:
#aall=copy(add.dim(lll$A$F511[.W2.....],.dimname = 'INSTR', .dimcodes = 'F511'))

# Fill data for total economy domestic+abroad (S0) using world scope (W0) data
# from assets where counterpart sector is total economy (S1)
aall['F511',,,'S0',,,] = lll$A$F511[N..W0..S1.N.A..F511._Z._Z.XDC._T.S.V.N..]
#OLD:
#aall['F511',,,'S0',,,]= lll$A$F511[.W2..S1...]
# Replace data for total economy domestic+abroad (S0) with adjusted liabilities data
aall['F511',,'S0',,,,] = lll$Ladj$F511

# Set NA for any reference sectors that exist in sss (from assets) 
# but not in the current array's REF_SECTOR dimension
# This ensures consistent sector coverage
aall[,,setdiff(sss,dimnames(aall)$REF_SECTOR),,,,]=NA
dimcodes(aall)

# Create backup copy
aaraw=copy(aall)

# Handle Investment Fund Shares (F52)
# Rule : Only investment funds (S124) can have investment fund shares as liabilities
aall['F52',,,,,'_T',]  =NA  # Clear all F52 data

aall['F52',,,,,'_T',]  = lll$A$F52[N..W2...N.A..F52._Z._Z.XDC._T.S.V.N._T.]  # Fill with domestic scope data 
#aall['F52',,,,,'_T',]  = lll$A$F52[.W2...._T.]  OLD 

aall['F52',,,'S0',,'_T',]  = lll$A$F52[N..W0..S1.N.A..F52._Z._Z.XDC._T.S.V.N._T.]  # Fill with domestic scope data 
#aall['F52',,,'S0',,'_T',] = lll$A$F52[.W0..S1.._T.]  # OLD

aall['F52',,'S0',,,'_T',] = lll$Ladj$F52  # Adjusted liability data for total economy

# Handle Deposits (F2M)
# Rule : Only banks (S12K - MFIs) and government can have deposits on liabilities side
aall['F2M',,,,,,]  =NA  # Clear all deposits data

aall['F2M',,,,,,]  = lll$A$F2M[N..W2...N.A..F2M._Z._Z.XDC._T.S.V.N..]  # Fill with domestic scope data 
#aall['F2M',,,,,,]  = lll$A$F2M[.W2.....]  # OLD

aall['F2M',,,'S12K',,,]  = lll$L$F2M[.W2...]  # Special handling for MFIs (banks) with domestic scope

aall['F2M',,,'S0',,,]  = lll$A$F2M[N..W0..S1.N.A..F2M._Z._Z.XDC._T.S.V.N..]  # World scope data for total economy
aall['F2M',,,'S0',,,] = lll$A$F2M[.W0..S1...]  # OLD


# Split flows and stocks for total economy
aall['F2M',,'S0',,'F','_T',] = lll$Ladj$F2M[..F.]  # Flows
aall['F2M',,'S0',,'LE','_T',] = lll$Ladj$F2M[..LE.]  # Stocks

# Handle Loans (F4) - with breakdown by maturity (Total, Short-term, Long-term)
aall['F4',,,,,,]  =NA  # Clear all F4 data
# Total Loans (T)
aall['F4',,,,,,] = lll$A$F4[N..W2...N.A..F4.T._Z.XDC._T.S.V.N..]  # Fill with domestic scope data 
#aall['F4',,,,,,] = lll$A$F4[.W2....T..]  # OLD

aall['F4',,,'S0',,,] = lll$A$F4[N..W0..S1.N.A..F4.T._Z.XDC._T.S.V.N..]  # # World scope for total economy 
#aall['F4',,,'S0',,,] = lll$A$F4[.W0..S1..T..]  # OLD

aall['F4',,'S0',,,,] = lll$Ladj$F4[...T..]  # Adjusted liabilities

# Short-term Loans (S)
aall['F4S',,,,,,] = lll$A$F4[N..W2...N.A..F4.S._Z.XDC._T.S.V.N..]  # Fill with domestic scope data 
aall['F4S',,,'S0',,,] = lll$A$F4[N..W0..S1.N.A..F4.S._Z.XDC._T.S.V.N..]  # # World scope for total economy 


#aall['F4S',,,,,,]  = lll$A$F4[.W2....S..]  # Domestic scope OLD
#aall['F4S',,,'S0',,,] = lll$A$F4[.W0..S1..S..]  # World scope for total economy OLD
aall['F4S',,'S0',,,,] = lll$Ladj$F4[...S..]  # Adjusted liabilities

# Long-term Loans (L)
aall['F4L',,,,,,] = lll$A$F4[N..W2...N.A..F4.L._Z.XDC._T.S.V.N..]  # Fill with domestic scope data 
aall['F4L',,,'S0',,,] = lll$A$F4[N..W0..S1.N.A..F4.L._Z.XDC._T.S.V.N..]  # # World scope for total economy 


#aall['F4L',,,,,,]  = lll$A$F4[.W2....L..]  # Domestic scope OLD
#aall['F4L',,,'S0',,,] = lll$A$F4[.W0..S1..L..]  # World scope for total economy OLD
aall['F4L',,'S0',,,,] = lll$Ladj$F4[...L..]  # Adjusted liabilities

# Initialize aggregate Debt Securities category
aall['F3+F3S+F3L',,,,,,] = NA

# Handle Debt Securities (F3) - with breakdown by maturity (Total, Short-term, Long-term)
# Total Debt Securities (T)
aall['F3',,,,,,] = lll$A$F3[N..W2...N.A..F3.T._Z.XDC._T.S.V.N..]  # Fill with domestic scope data 
#aall['F3',,,,,,]  = lll$A$F3[.W2....T..]  # Domestic scope base data OLD
aall['F3',,,'S0',,,] = lll$A$F3[N..W0..S1.N.A..F3.T._Z.XDC._T.S.V.N..]  # # World scope for total economy 
#aall['F3',,,'S0',,,]  = lll$A$F3[.W0..S1..T..]  # World scope for total economy OLD
aall['F3',,'S0',   ,,,]  = lll$Ladj$F3[...T..]  # Adjusted liabilities

# Short-term Debt Securities (S)
aall['F3S',,,,,,] = lll$A$F3[N..W2...N.A..F3.S._Z.XDC._T.S.V.N..]  # Fill with domestic scope data 
#aall['F3S',,,,,,]  = lll$A$F3[.W2....S..]  # Domestic scope
aall['F3S',,,'S0',,,] = lll$A$F3[N..W0..S1.N.A..F3.S._Z.XDC._T.S.V.N..]  # # World scope for total economy 
#aall['F3S',,,'S0',,,]  = lll$A$F3[.W0..S1..S..]  # World scope for total economy
aall['F3S',,'S0',   ,,,]  = lll$Ladj$F3[...S..]  # Adjusted liabilities

# Long-term Debt Securities (L)
aall['F3L',,,,,,] = lll$A$F3[N..W2...N.A..F3.L._Z.XDC._T.S.V.N..]  # Fill with domestic scope data 
#aall['F3L',,,,,,]  = lll$A$F3[.W2....L..]  # Domestic scope
aall['F3L',,,'S0',,,] = lll$A$F3[N..W0..S1.N.A..F3.L._Z.XDC._T.S.V.N..]  # # World scope for total economy 
#aall['F3L',,,'S0',,,]  = lll$A$F3[.W0..S1..L..]  # World scope for total economy
aall['F3L',,'S0',   ,,,]  = lll$Ladj$F3[...L..]  # Adjusted liabilities

# Handle Currency (F21)
aall['F21',,,,,,]=NA  # Clear all F21 data
aall['F21',,,'S0',,'_T',] = lll$A$F21[N....S0.N.A..F21.T._Z.XDC._T.S.V.N..]  # Set total economy assets 
#aall['F21',,,'S0',,'_T',] = lll$A$F21  # Set total economy assets
aall['F21',,'S0',,,'_T',] = lll$Ladj$F21  # Set total economy liabilities

# Handle Total Financial Assets (F)
aall['F',,,'S0',,,] = lll$A$F[N..W0..S1.N.A..F._Z._Z.XDC._T.S.V.N..]
aall['F',,'S0',,,,] = lll$Ladj$F

# Handle Equity Total (F51)
aall['F51',,,'S0',,,] = lll$A$F51[N..W0..S1.N.A..F51._Z._Z.XDC._T.S.V.N..]
aall['F51',,'S0',,,,] = lll$Ladj$F51

# Handle Unlisted Shares and Other Equity (F51M)
aall['F51M',,,'S0',,,] = lll$A$F51M[N..W0..S1.N.A..F51M._Z._Z.XDC._T.S.V.N..]
aall['F51M',,'S0',,,,] = lll$Ladj$F51M

# Handle Insurance, Pension and Standardised Guarantee Schemes Total (F6)
aall['F6',,,'S0',,,] = lll$A$F6[N..W0..S1.N.A..F6._Z._Z.XDC._T.S.V.N..]
aall['F6',,'S0',,,,] = lll$Ladj$F6

# Handle Non-life Insurance Technical Reserves (F6N)
aall['F6N',,,'S0',,,] = lll$A$F6N[N..W0..S1.N.A..F6N._Z._Z.XDC._T.S.V.N..]
aall['F6N',,'S0',,,,] = lll$Ladj$F6N

# Handle Life Insurance and Annuity Entitlements (F6O)
aall['F6O',,,'S0',,,] = lll$A$F6O[N..W0..S1.N.A..F6O._Z._Z.XDC._T.S.V.N..]
aall['F6O',,'S0',,,,] = lll$Ladj$F6O

# Handle Financial Derivatives and Employee Stock Options (F7)
aall['F7',,,'S0',,,] = lll$A$F7[N..W0..S1.N.A..F7.T._Z.XDC._T.S.V.N..]
aall['F7',,'S0',,,,] = lll$Ladj$F7

# Handle Trade Credits and Advances (F81)
aall['F81',,,'S0',,,] = lll$A$F81[N..W0..S1.N.A..F81.T._Z.XDC._T.S.V.N..]
aall['F81',,'S0',,,,] = lll$Ladj$F81

# Handle Other Accounts Receivable (F89)
aall['F89',,,'S0',,,] = lll$A$F89[N..W0..S1.N.A..F89.T._Z.XDC._T.S.V.N..]
aall['F89',,'S0',,,,] = lll$Ladj$F89

# Handle remaining instruments
#irest=setdiff(names(lll$A), dimnames(aall)[[1]])  # Find instruments not yet processed
# for (i in irest) {
#   message(' doing ',i, '  ...')
#   aall[i,,,,,,]=NA  # Clear data for instrument
#   aall[i,,,'S0',,,]=lll$A[[i]][]  # Set total economy assets
#   # Handle liabilities based on whether they have CUST_BREAKDOWN dimension
#   if ('CUST_BREAKDOWN' %in% names(dim(lll$Ladj[[i]]))) {
#     aall[i,,'S0',,,,]=lll$Ladj[[i]]  # Use full breakdown if available
#   } else {
#     aall[i,,'S0',,,'_T',]=lll$Ladj[[i]]  # Use total if no breakdown
#   }
# }

### setting order to sectors and calculating RoW (S2) + financial sector excluding S12K
# saving as aall

# set order for sectors 
sorder=strsplit('S121+S12T+S124+S12O+S12Q+S13+S11+S1M+S2+S0+S1+S12K+S12R',split='\\+')[[1L]]
aall[..S2....]=NA; aall[...S2...]=NA
aall[..S12R....]=NA; aall[...S12R...]=NA
dall=as.data.table(aall,na.rm=TRUE, .simple=TRUE)
ddn=attr(dall,'dcstruct')
ddn$REF_SECTOR = ddn$REF_SECTOR[sorder,]
ddn$COUNTERPART_SECTOR = ddn$COUNTERPART_SECTOR[sorder,]
attr(dall,'dcstruct') = ddn
aall=as.md3(dall)
aall[..S2....] = aall[..S0....] - aall[..S1....]
aall[...S2...] = aall[...S0...] - aall[...S1...]
aall[..S12R....] = aall[..S124....]+aall[..S12O....]+aall[..S12Q....]
aall[...S12R...] = aall[...S124...]+aall[...S12O...]+aall[...S12Q...]

### EURO AREA

dimnames(aall)$REF_AREA[dimnames(aall)$REF_AREA=='I7'] = 'EA18'
dimnames(aall)$REF_AREA[dimnames(aall)$REF_AREA=='I8'] = 'EA19'
dimnames(aall)$REF_AREA[dimnames(aall)$REF_AREA=='I9'] = 'EA20'

# Save 
saveRDS(aall, file.path(data_dir, 'intermediate_domestic_data_files/aall_qsa.rds'))
