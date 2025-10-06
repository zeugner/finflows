library(MD3)
library(MDstats)

zerofiller=function(x, fillscalar=0){
  temp=copy(x)
  temp[onlyna=TRUE]=fillscalar
  temp
}


####### FUNCTIONAL CATEGORY DIMENSION
aall <- readRDS("Z:/FinFlows/githubrepo/finflows/data/intermediate_domestic_data_files/aall_cp.rds")
dimnames(aall)
aall=unflag(aall)["....._T+FND."]
gc()
names(dimnames(aall))[6] = 'FUNCTIONAL_CAT'
dimnames(aall)$FUNCTIONAL_CAT[dimnames(aall)$FUNCTIONAL_CAT=='FND'] = '_D'
gc()
str(aall)
aall['....._F+_O+_P+_R.'] <- NA




### then we have to compute the totals as _p+_o+_d
### STEP ZERO: INITIAL DATA LOADING 

### FILL S2 (REST OF WORLD) FROM IIP DATA
# Load af51 object containing F512 (unlisted shares), F519 (other equity), and F51M data
# This data comes from the f51stufffromstefan.R script
af51=readRDS(file.path(data_dir,'af51.rds')); gc()

# Fill all three equity instruments (F512, F519, F51M) for stocks (LE) 
# from af51 into aall, only filling NA values


# aall[F512....LE._S.,onlyna=TRUE]<-af51["_S....F512."]
# aall[F519....LE._S.,onlyna=TRUE]<-af51["_S....F519."]
# aall[F51M....LE._S.,onlyna=TRUE]<-af51["_S....F51M."]
# aall[F52....LE._S.,onlyna=TRUE]<-af51["_S....F52."]

aall[F512....LE._D.,onlyna=TRUE]<-af51["FND....F512."]
aall[F519....LE._D.,onlyna=TRUE]<-af51["FND....F519."]
aall[F51M....LE._D.,onlyna=TRUE]<-af51["FND....F51M."]
aall[F52....LE._D.,onlyna=TRUE]<-af51["FND....F52."]

aall[F512....LE._P.,onlyna=TRUE]<-af51["_P....F512."]
aall[F519....LE._O.,onlyna=TRUE]<-af51["_O....F519."]
aall[F52....LE._P.,onlyna=TRUE]<-af51["_P....F52."]



### FILL S13 (GOVERNMENT) EQUITY DATA
# Load government equity data containing F51, F511, F51M, and F52
# This data comes from the govF5.R script
gov_equity=readRDS(file.path(data_dir,'gov_equity.rds')); gc()


# Fill government sector equity instruments 
# These will be used later in the calculations
aall[F5..S13..LE._T.,onlyna=TRUE]<-gov_equity["F5..."]
aall[F511..S13..LE._T.,onlyna=TRUE]<-gov_equity["F511..."]
aall[F51M..S13..LE._T.,onlyna=TRUE]<-gov_equity["F51M..."]
aall[F52..S13..LE._T.,onlyna=TRUE]<-gov_equity["F52..."]

ccc='AT+BE+BG+CY+CZ+DE+DK+EE+ES+FI+FR+UK+EL+HR+HU+IE+IT+LT+LU+LV+MT+NL+PL+PT+RO+SE+SI+SK+U2'

af5p=mds('IMF/BOP/Q.' %&% ccc %&% '.IAPECB_BP6_USD+IAPEDC_BP6_USD+IAPEG_BP6_USD+IAPEMA_BP6_USD+IAPEOF_BP6_USD+IAPEONF_BP6_USD+IAPEO_BP6_USD+IAPE_BP6_SPE_USD+IAPE_BP6_USD', labels=TRUE, ccode = NULL)
lf5p=mds('IMF/BOP/Q.' %&% ccc %&% '.ILPECB_BP6_USD+ILPEDC_BP6_USD+ILPEG_BP6_USD+ILPEMA_BP6_USD+ILPEOF_BP6_USD+ILPEONF_BP6_USD+ILPEO_BP6_USD+ILPE_BP6_SPE_USD+ILPE_BP6_USD', labels=TRUE, ccode = NULL)
lf519o=mds('IMF/BOP/Q.' %&% ccc %&% '.ILOOCBFR_BP6_USD+ILOODC_BP6_USD+ILOOFR_BP6_USD+ILOOGFR_BP6_USD+ILOOOF_BP6_USD+ILOOO_BP6_USD', labels=TRUE, ccode = NULL)

#### HERE SAVE THE THREE 
saveRDS(af5p,'data/af5p.rds')
saveRDS(lf5p,'data/lf5p.rds')
saveRDS(lf519o,'data/lf519o.rds')

#### EXCHANGE RATE!
usd_eur = mds('ECB/EXR/Q.USD.EUR.SP00.E')
#####conversion in euros
af5p_eur=af5p/usd_eur

lf5p_eur=lf5p/usd_eur

lf519o_eur=lf519o/usd_eur

################## af5p ############
aall[F5..S1P.S2.LE._P., onlyna=TRUE]<-af5p_eur[".IAPEO_BP6_USD.1998q4:"] # Other sectors
aall[F5..S12R.S2.LE._P., onlyna=TRUE]<-af5p_eur[".IAPEOF_BP6_USD.1998q4:"] # Other Financial Corporations
aall[F5..S1.S2.LE._P., onlyna=TRUE]<-af5p_eur[".IAPE_BP6_USD.1998q4:"] # Total economy
aall[F5..S122.S2.LE._P., onlyna=TRUE]<-af5p_eur[".IAPEDC_BP6_USD.1998q4:"] # Deposit-taking Corporations, Except Central Bank
aall[F5..S11_S14_S15.S2.LE._P., onlyna=TRUE]<-af5p_eur[".IAPEONF_BP6_USD.1998q4:"] # Nonfinancial Corporations, Households, and NPISHs
aall[F5..S121.S2.LE._P., onlyna=TRUE]<-af5p_eur[".IAPECB_BP6_USD.1998q4:"] # Central Bank
aall[F5..S13.S2.LE._P., onlyna=TRUE]<-af5p_eur[".IAPEG_BP6_USD.1998q4:"] # General Government
aall[F5..S1X.S2.LE._P., onlyna=TRUE]<-af5p_eur[".IAPEMA_BP6_USD.1998q4:"] # Monetary Authorities
aall[F5..S12SP.S2.LE._P., onlyna=TRUE]<-af5p_eur[".IAPE_BP6_SPE_USD.1998q4:"] # Special Purpose Entities

### compute s12 as the sum of the components
#### zerofiller for S12SP which is often not there
# NO S122 FOR CYPRUS: ZEROFILLER
# NO DATA FOR BUNDESBANK: ZEROFILLER EXCEPT IF STEFAN FINDS THEM

aall[F5..S12.S2.LE._P.]<- aall[F5..S12R.S2.LE._P.]+zerofiller(aall[F5..S122.S2.LE._P.])+zerofiller(aall[F5..S121.S2.LE._P.])+zerofiller(aall[F5..S12SP.S2.LE._P.])


##### liabilities f5 portfolio
aall[F5..S2.S1P.LE._P., onlyna=TRUE]<-lf5p_eur[".ILPEO_BP6_USD.1998q4:"] # Other sectors
aall[F5..S2.S12R.LE._P., onlyna=TRUE]<-lf5p_eur[".ILPEOF_BP6_USD.1998q4:"] # Other Financial Corporations
aall[F5..S2.S1.LE._P., onlyna=TRUE]<-lf5p_eur[".ILPE_BP6_USD.1998q4:"] # Total economy
aall[F5..S2.S122.LE._P., onlyna=TRUE]<-lf5p_eur[".ILPEDC_BP6_USD.1998q4:"] # Deposit-taking Corporations, Except Central Bank
aall[F5..S2.S11_S14_S15.LE._P., onlyna=TRUE]<-lf5p_eur[".ILPEONF_BP6_USD.1998q4:"] # Nonfinancial Corporations, Households, and NPISHs
aall[F5..S2.S121.LE._P., onlyna=TRUE]<-lf5p_eur[".ILPECB_BP6_USD.1998q4:"] # Central Bank
aall[F5..S2.S13.LE._P., onlyna=TRUE]<-lf5p_eur[".ILPEG_BP6_USD.1998q4:"] # General Government
aall[F5..S2.S1X.LE._P., onlyna=TRUE]<-lf5p_eur[".ILPEMA_BP6_USD.1998q4:"] # Monetary Authorities
aall[F5..S2.S12SP.LE._P., onlyna=TRUE]<-lf5p_eur[".ILPE_BP6_SPE_USD.1998q4:"] # Special Purpose Entities

### compute s12 as the sum of the components
### S121 MISSING FOR DE AND PL: IMPOSE ZERO
### S122 MISSING FOR AUSTRIA AND CYPRUS!!!! #### TELL ERZA
aall[F5..S2.S12.LE._P.]<- aall[F5..S2.S12R.LE._P.]+aall[F5..S2.S122.LE._P.]+zerofiller(aall[F5..S2.S121.LE._P.])+zerofiller(aall[F5..S2.S12SP.LE._P.])

###### liabilities _other investment
aall[F519..S2.S122.LE._O., onlyna=TRUE]<- lf519o_eur[".ILOODC_BP6_USD.1998q4:"] # Deposit-taking Corporations, Except Central Bank
aall[F519..S2.S121.LE._O., onlyna=TRUE]<- lf519o_eur[".ILOOCBFR_BP6_USD.1998q4:"] # Central Bank
aall[F519..S2.S12R.LE._O., onlyna=TRUE]<- lf519o_eur[".ILOOOF_BP6_USD.1998q4:"] # Other Financial Corporations
aall[F519..S2.S13.LE._O., onlyna=TRUE]<- lf519o_eur[".ILOOO_BP6_USD.1998q4:"] # Other sectors
aall[F519..S2.S1P.LE._O., onlyna=TRUE]<- lf519o_eur[".ILOOGFR_BP6_USD.1998q4:"] # General Government
aall[F519..S2.S1.LE._O., onlyna=TRUE]<- lf519o_eur[".ILOOFR_BP6_USD.1998q4:"] # Total economy


### S12R lacking for FI and SE
### S122 lacking for CY and IE
aall[F519..S2.S12.LE._O., onlyna=TRUE]<- zerofiller(aall[F519..S2.S121.LE._O.])+aall[F519..S2.S122.LE._O.]+aall[F519..S2.S12R.LE._O.]

gc()
gc()






saveRDS(aall,'data/intermediate_domestic_data_files/aall_equity_bilateral_imf_gov.rds')





