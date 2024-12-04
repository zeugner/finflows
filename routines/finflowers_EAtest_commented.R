#source('https://s-ecfin-web.net1.cec.eu.int/directorates/db/u1/R/routines/installMDecfin.txt')


library(MDecfin)
#setwd('U:/Topics/Spillovers_and_EA/flowoffunds/finflows2024/gitcodedata')

# Load the previously created matrix with all financial instruments data
aall=readRDS('data/aall.rds')

#Matrix dimensions :
  # 1. INSTR: Financial instrument (e.g., F2M for Deposits)
  # 2. REF_AREA: Country holding the stock/receiving flow
  # 3. REF_SECTOR: Sector of economic activity holding stock/receiving flow
  # 4. COUNTERPART_SECTOR: Sector of economic activity of the counterpart
  # 5. STO: Stock (LE) or flow (F) indicator
  # 6. CUST_BREAKDOWN: Investment intermediation types
  # 7. TIME: Quarter

##### Example Austria (AT) #####
# Check who-to-whom relationships :
# Check holdings of Households and NPISH (S1M) in Austria in 2022Q4 (stocks - LE)
aall[.AT..S1M.LE._T.y2022q4]
# Check total financial instruments (F) in Austria with Direct Investment breakdown (FND) in 2022Q4 (stocks)
aall[F.AT...LE.FND.y2022q4]

##### Fill blanks assets #####
# TODOs noted for future implementation:
#!todo: include a check if S0 is zero also  check if S1 is zero or NA (should be not filled)
#!todo: if not S12K or S13 sectors are filled when FI = F21+F2M (should be not filled)
#!todo: check if they are NA or not filled or zero before filling with 0 (rule 3+2) (should be not filled)

### Rule 1: If total economy (S0) assets = 0, then all counterpart sectors should be 0
# If assets for total economy are 0, set all corresponding counterpart sectors to 0
aall[....LE._T. ][aall[...S0.LE._T.]==0, onlyna=TRUE] = 0
# Diagnostic check: MFI data for Austria in 2023Q4
aall[.AT.S12K..LE._T.2023q4 ]

### Rule 2: Deposits can only be liabilities of banks (S12K) or government (S13)
# Set deposits (F2M) and currency (F21) to 0 for non-bank/non-govt sectors
aall[F2M+F21...S1M+S11+S12O+S12Q+S124.LE._T.] = 0
# Diagnostic check: German MFI deposits in 2023Q1
aall[F2M.DE.S12K..LE._T.2023q1]

### Rule 3: Households and NPISH (S1M) cannot have certain liabilities
# Set to 0: listed shares (F511), investment fund shares (F52), and non-life insurance provisions (F6O)
aall[F511+F52+F6O...S1M.LE._T.] = 0
# Diagnostic check: S1M liabilities for Austria, Germany, Italy in 2023Q4
aall[.AT+DE+IT.S0.S1M.LE._T.2023q4]

### Rule 4: Investment fund shares (F52) restriction to specific sectors
# Initial diagnostic check for F52 in Austria
aall[F52.AT...LE._T.2023q4 ]
# Check if total F52 matches sum of investment funds and MFIs
aall[F52..S0.S1.LE._T.y2022q4]-rowSums(aall[F52..S0.S124+S12K.LE._T.y2022q4])
# Set F52 liabilities to 0 for sectors that cannot issue them:
# - Non-financial corporations (S11)
# - Other financial institutions (S12O)
# - Insurance corps and Pension Funds (S12Q)
# - General government (S13)
# - Households and NPISH (S1M)
aall[F52...S11+S12O+S12Q+S13+S1M.LE._T.] = 0
# Additional diagnostic checks
test=aall[F52.AT...LE._T.2023q4 ]
aall[F52.AT...LE._T.2023q4 ]
# Align monetary financial institutions data
aall[F52...S12T.._T.] = aall[F52...S12K.._T.]
# Check if total F52 equals sum of relevant sectors
tempix= aall[F52..S1.S1.LE._T.]==apply(aall[F52..S1.S124+S12K.LE._T.],c(1,3),sum)

# Final diagnostic checks
# Check MFI data for Austria
aall[.AT.S12K..LE._T.2023q4 ]
aall[.AT..S12K.LE._T.2023q4 ]

### Final checks for S121+S122 (Central bank + Deposit-taking corporations)
# Assets of MFIs vis-à-vis counterpart sectors per financial instrument
aall[.AT.S12K..LE._T.y2022q4]
# Liabilities of MFIs vis-à-vis counterpart sectors per financial instrument
aall[.AT..S12K.LE._T.y2022q4]


