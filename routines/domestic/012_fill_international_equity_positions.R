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

# Country code conversion mapping (ISO3 to ISO2)
country_map <- c(
  "AUT" = "AT", "BEL" = "BE", "BGR" = "BG", "CYP" = "CY", 
  "CZE" = "CZ", "DEU" = "DE", "DNK" = "DK", "EST" = "EE",
  "ESP" = "ES", "FIN" = "FI", "FRA" = "FR", "GBR" = "GB",
  "GRC" = "GR", "HRV" = "HR", "HUN" = "HU", "IRL" = "IE",
  "ITA" = "IT", "LTU" = "LT", "LUX" = "LU", "LVA" = "LV",
  "MLT" = "MT", "NLD" = "NL", "POL" = "PL", "PRT" = "PT",
  "ROU" = "RO", "SVK" = "SK", "SVN" = "SI", "SWE" = "SE"
)

####### FUNCTIONAL CATEGORY DIMENSION
aall <- readRDS(file.path(data_dir, "intermediate_domestic_data_files/aall_cp.rds"))
aall=unflag(aall)["....._T+FND."]
gc()
names(dimnames(aall))[6] = 'FUNCTIONAL_CAT'
dimnames(aall)$FUNCTIONAL_CAT[dimnames(aall)$FUNCTIONAL_CAT=='FND'] = '_D'
gc()
aall['....._F+_O+_P+_R.'] <- NA

### STEP ZERO: INITIAL DATA LOADING 
af5_eur <- readRDS(file.path(data_dir, "af5_eur.rds"))
lf5_eur <- readRDS(file.path(data_dir, "lf5_eur.rds"))

names(dimnames(af5_eur))[1]=names(dimnames(lf5_eur))[1]='REF_AREA'  

# Convert country codes from ISO3 to ISO2
dimnames(af5_eur)$REF_AREA <- country_map[dimnames(af5_eur)$REF_AREA]
dimnames(lf5_eur)$REF_AREA <- country_map[dimnames(lf5_eur)$REF_AREA]

# Load af51 object containing F512 (unlisted shares), F519 (other equity), and F51M data
af51=readRDS(file.path(data_dir, 'af51.rds'))
gc()

# Load government equity data containing F51, F511, F51M, and F52
gov_equity=readRDS(file.path(data_dir, 'gov_equity.rds'))
gc()


### FILL S2 (REST OF WORLD) FROM IIP DATA

# Fill equity instruments for stocks (LE) from af51 into aall, only filling NA values
aall[F512....LE._D.,onlyna=TRUE]<-af51["FND....F512."]
aall[F519....LE._D.,onlyna=TRUE]<-af51["FND....F519."]
aall[F51M....LE._D.,onlyna=TRUE]<-af51["FND....F51M."]
aall[F52....LE._D.,onlyna=TRUE]<-af51["FND....F52."]

aall[F512....LE._P.,onlyna=TRUE]<-af51["_P....F512."]
aall[F519....LE._O.,onlyna=TRUE]<-af51["_O....F519."]
aall[F52....LE._P.,onlyna=TRUE]<-af51["_P....F52."]

### FILL S13 (GOVERNMENT) EQUITY DATA

# Fill government sector equity instruments 
aall[F5..S13..LE._T.,onlyna=TRUE]<-gov_equity["F5..."]
aall[F511..S13..LE._T.,onlyna=TRUE]<-gov_equity["F511..."]
aall[F51M..S13..LE._T.,onlyna=TRUE]<-gov_equity["F51M..."]
aall[F52..S13..LE._T.,onlyna=TRUE]<-gov_equity["F52..."]


################## ASSETS - PORTFOLIO INVESTMENT (_P) ############

### Total equity (F5) by sector - ASSETS
aall[F5..S1Z.S2.LE._P., onlyna=TRUE]<-af5_eur[".P_F5_S1Z.1999q4:"] # Other sectors (S1Z)
aall[F5..S12R.S2.LE._P., onlyna=TRUE]<-af5_eur[".P_F5_S12R.1999q4:"] # Other Financial Corporations
aall[F5..S1.S2.LE._P., onlyna=TRUE]<-af5_eur[".P_F5.1999q4:"] # Total economy
aall[F5..S122.S2.LE._P., onlyna=TRUE]<-af5_eur[".P_F5_S122.1999q4:"] # Deposit-taking Corporations, Except Central Bank
aall[F5..S11_S14_S15.S2.LE._P., onlyna=TRUE]<-af5_eur[".P_F5_S1V.1999q4:"] # Nonfinancial Corporations, Households, and NPISHs
aall[F5..S121.S2.LE._P., onlyna=TRUE]<-af5_eur[".P_F5_S121.1999q4:"] # Central Bank
aall[F5..S13.S2.LE._P., onlyna=TRUE]<-af5_eur[".P_F5_S13.1999q4:"] # General Government
aall[F5..S1X.S2.LE._P., onlyna=TRUE]<-af5_eur[".P_F5_S1X.1999q4:"] # Monetary Authorities

################## ASSETS - PORTFOLIO INVESTMENT (_P) ############

### Equity securities (F51) - ASSETS
aall[F51..S1.S2.LE._P., onlyna=TRUE]<-af5_eur[".P_F51.1999q4:"] # Total F51

### Listed shares (F511) - ASSETS
aall[F511..S1.S2.LE._P., onlyna=TRUE]<-af5_eur[".P_F511.1999q4:"] # Total F511

### Unlisted shares (F512) - ASSETS
aall[F512..S1.S2.LE._P., onlyna=TRUE]<-af5_eur[".P_F512.1999q4:"] # Total F512

### Investment fund shares (F52) - ASSETS
aall[F52..S1.S2.LE._P., onlyna=TRUE]<-af5_eur[".P_F52.1999q4:"] # Total F52
aall[F52..S123.S2.LE._P., onlyna=TRUE]<-af5_eur[".P_F52_S123.1999q4:"] # Money market funds

### Compute S12 (Financial Corporations) as sum of components - ASSETS
aall[F5..S12.S2.LE._P.]<- aall[F5..S12R.S2.LE._P.] + 
  zerofiller(aall[F5..S122.S2.LE._P.]) + 
  zerofiller(aall[F5..S121.S2.LE._P.])


################## LIABILITIES - PORTFOLIO INVESTMENT (_P) ############

### Total equity (F5) by sector - LIABILITIES
aall[F5..S2.S1P.LE._P., onlyna=TRUE]<-lf5_eur[".P_F5_S1Z.1999q4:"] # Other sectors (S1Z)
aall[F5..S2.S12R.LE._P., onlyna=TRUE]<-lf5_eur[".P_F5_S12R.1999q4:"] # Other Financial Corporations
aall[F5..S2.S1.LE._P., onlyna=TRUE]<-lf5_eur[".P_F5.1999q4:"] # Total economy
aall[F5..S2.S122.LE._P., onlyna=TRUE]<-lf5_eur[".P_F5_S122.1999q4:"] # Deposit-taking Corporations, Except Central Bank
aall[F5..S2.S11_S14_S15.LE._P., onlyna=TRUE]<-lf5_eur[".P_F5_S1V.1999q4:"] # Nonfinancial Corporations, Households, and NPISHs
aall[F5..S2.S121.LE._P., onlyna=TRUE]<-lf5_eur[".P_F5_S121.1999q4:"] # Central Bank
aall[F5..S2.S13.LE._P., onlyna=TRUE]<-lf5_eur[".P_F5_S13.1999q4:"] # General Government
aall[F5..S2.S1X.LE._P., onlyna=TRUE]<-lf5_eur[".P_F5_S1X.1999q4:"] # Monetary Authorities

### Equity securities (F51) - LIABILITIES
aall[F51..S2.S1.LE._P., onlyna=TRUE]<-lf5_eur[".P_F51.1999q4:"] # Total F51

### Listed shares (F511) - LIABILITIES
aall[F511..S2.S1.LE._P., onlyna=TRUE]<-lf5_eur[".P_F511.1999q4:"] # Total F511

### Unlisted shares (F512) - LIABILITIES
aall[F512..S2.S1.LE._P., onlyna=TRUE]<-lf5_eur[".P_F512.1999q4:"] # Total F512

### Investment fund shares (F52) - LIABILITIES
aall[F52..S2.S1.LE._P., onlyna=TRUE]<-lf5_eur[".P_F52.1999q4:"] # Total F52
aall[F52..S2.S123.LE._P., onlyna=TRUE]<-lf5_eur[".P_F52_S123.1999q4:"] # Money market funds

### Compute S12 (Financial Corporations) as sum of components - LIABILITIES
aall[F5..S2.S12.LE._P.]<- aall[F5..S2.S12R.LE._P.] + 
  aall[F5..S2.S122.LE._P.] + 
  zerofiller(aall[F5..S2.S121.LE._P.])


################## ASSETS - OTHER INVESTMENT (_O) ############

### Other equity (F519) - ASSETS (NEW: not available in old IMF data)
# Fill total economy level since sectoral breakdown is not available
aall[F519..S1.S2.LE._O., onlyna=TRUE]<-af5_eur[".O_F519.1999q4:"] # Total economy


################## LIABILITIES - OTHER INVESTMENT (_O) ############

### Other equity (F519) - LIABILITIES
# Note: Sectoral breakdown not available in new IMF data, filling only total economy
aall[F519..S2.S1.LE._O., onlyna=TRUE]<-lf5_eur[".O_F519.1999q4:"] # Total economy

gc()

saveRDS(aall, file.path(data_dir, 'intermediate_domestic_data_files/aall_equity_bilateral_imf_gov.rds'))

