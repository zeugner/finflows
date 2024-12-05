<<<<<<< HEAD
#source('https://s-ecfin-web.net1.cec.eu.int/directorates/db/u1/R/routines/installMDecfin.txt')


library(MDecfin)
#setwd('U:/Topics/Spillovers_and_EA/flowoffunds/finflows2024/gitcodedata')


aall=readRDS('data/aall.rds')

#dimcodes(aall)


######### plausibility checks of data to assure consistency ######### 

####secotral checks
## @ Erza: implement for the abs check a level - currently hard coded at 0.01 

#### ASSETS S1 = S11+S1M+S12K+S13+S12O+S12Q+S124+S13
#!todo: how to handle time (quarter/years) +   
check1=aall[F..S1.S0.LE._T.2023q4]-rowSums(aall[F..S11+S1M+S12K+S12O+S12Q+S124+S13.S0.LE._T.2023q4])
see_check1 <- check1[abs(check1) > 0.01]

##instead of having array with fifelse(abs(check1)>0.01,yes='nok',no='ok',na=NA)

#### LIAB S1 = S11+S1M+S12K+S13+S12O+S12Q+S124+S13
#!todo: how to handle time (quarter/years) +   
check2=aall[F..S0.S1.LE._T.2023q4]-rowSums(aall[F..S0.S11+S1M+S12K+S12O+S12Q+S124+S13.LE._T.2023q4])
#!todo: implement to check only if abs value is >0.00
fifelse(abs(check2)>0.01,yes='nok',no='ok',na=NA)

#if not S12K or S13 sectors are filled when FI = F21+F2M (should be not filled)
#!todo: how to handle time (quarter/years) + 
check3a=aall[F21..S0.S1.LE._T.2023q4]-rowSums(aall[F21..S0.S13+S12K.LE._T.2023q4])
#!todo: implement to check only if abs value is >0.00
fifelse(abs(check3a)>0.01,yes='nok',no='ok',na=NA)
#!todo: how to handle time (quarter/years) + 
check3b=aall[F2M..S0.S1.LE._T.2023q4]-rowSums(aall[F2M..S0.S13+S12K.LE._T.2023q4])
#!todo: implement to check only if abs value is >0.00
fifelse(abs(check3b)>0.01,yes='nok',no='ok',na=NA)

#!todo open: include a check if S0 is zero also  check if S1 is zero or NA (should be not filled)
#!todo: how to handle time (quarter/years) + 
check4=aall[.AT.S1..LE._T.2023q4]-rowSums(aall[F21..S0.S13+S12K.LE._T.2023q4])
fifelse(check4>0,yes='ok',no='nok',na=NA) 



####financial instruments checks
#!todo: @ Stefano check for assets and liabilities if F=F21+F2M+F3+F4+F51+F52+F6+F7+F81+F89
#!todo: @ Stefano check for assets and liabilities if F3=F3S+F3L
#!todo: @ Stefano check for assets and liabilities if F4=F4S+F4L
#!todo: @ Stefano check for assets and liabilities if F51=F511+F51M
#!todo: @ Stefano check for assets and liabilities if F6=F6N+F6O


=======
#source('https://s-ecfin-web.net1.cec.eu.int/directorates/db/u1/R/routines/installMDecfin.txt')


library(MDecfin)
#BRUSSELS
#setwd('U:/Topics/Spillovers_and_EA/flowoffunds/finflows2024/gitcodedata')

#ISPRA
#setwd('X:/Finflows/zeugner')

aall=readRDS('data/aall.rds')

#dimcodes(aall)


#################### CONSISTENCY CHECKS ####################

# SECTORAL CONSISTENCY CHECK 1: Total Economy Assets Composition
# Verify if total economy (S1) assets equal sum of all institutional sectors
# Sectors checked: Non-financial corps (S11), Households (S1M), Banks (S12K),
# Other financial (S12O), Insurance/Pension (S12Q), Investment funds (S124), Government (S13)
check1=aall[F..S1.S0.LE._T.2023q4]-rowSums(aall[F..S11+S1M+S12K+S12O+S12Q+S124+S13.S0.LE._T.2023q4])
# Flag differences > 0.01 as 'nok' (not OK)
fifelse(abs(check1)>0.01,yes='nok',no='ok',na=NA)

# Extract actual values for problematic cases
values <- check1$"_.obs_value"
countries <- check1$REF_AREA
result <- fifelse(abs(values) > 0.01, 
                  yes = abs(values), 
                  no = 0, 
                  na = NA)
names(result) <- countries
result

# SECTORAL CONSISTENCY CHECK 2: Total Economy Liabilities Composition
# Verify if total economy (S1) liabilities equal sum of all institutional sectors
check2=aall[F..S0.S1.LE._T.2023q4]-rowSums(aall[F..S0.S11+S1M+S12K+S12O+S12Q+S124+S13.LE._T.2023q4])
fifelse(abs(check2)>0.01,yes='nok',no='ok',na=NA)

# SECTORAL CONSISTENCY CHECK 3a: Currency Liabilities (F21)
# Verify if currency liabilities are only held by central bank (S12K) and government (S13)
check3a=aall[F21..S0.S1.LE._T.2023q4]-rowSums(aall[F21..S0.S13+S12K.LE._T.2023q4])
fifelse(abs(check3a)>0.01,yes='nok',no='ok',na=NA)

# SECTORAL CONSISTENCY CHECK 3b: Deposit Liabilities (F2M)
# Verify if deposit liabilities are only held by banks (S12K) and government (S13)
check3b=aall[F2M..S0.S1.LE._T.2023q4]-rowSums(aall[F2M..S0.S13+S12K.LE._T.2023q4])
fifelse(abs(check3b)>0.01,yes='nok',no='ok',na=NA)



#!todo open: include a check if S0 is zero also  check if S1 is zero or NA (should be not filled)
#!todo: how to handle time (quarter/years) + 
check4=aall[.AT.S1..LE._T.2023q4]-rowSums(aall[F21..S0.S13+S12K.LE._T.2023q4])
fifelse(check4>0,yes='ok',no='nok',na=NA) 



####financial instruments checks
#!todo: @ Stefano check for assets and liabilities if F=F21+F2M+F3+F4+F51+F52+F6+F7+F81+F89
#### ASSETS F=F21+F2M+F3+F4+F51+F52+F6+F7+F81+F89

# FINANCIAL INSTRUMENTS CHECK 5: Verify if total financial instruments (F) equals sum of components
# Checking both assets and liabilities sides of the balance sheet.

# Note: While rowSums() works for sector additions in MD3 objects, it doesn't work properly
# for instrument additions. This is because rowSums() interprets the + operator differently
# across dimensions: it correctly sums across sectors but concatenates across instruments.
# Therefore, we need to explicitly add each instrument component.

#################### ASSETS CHECK ####################
# Check if total financial assets (F) equals sum of instrument components
# Assets are identified by S1.S0 where S1 (total economy) holds assets against all counterparts (S0)
total_assets = aall[F..S1.S0.LE._T.2023q4]

# Sum individual asset components
# Components: Currency (F21), Deposits (F2M), Debt securities (F3), Loans (F4),
# Equity (F51), Investment fund shares (F52), Insurance (F6), 
# Financial derivatives (F7), Trade credits (F81), Other (F89)
components_assets = aall[F21..S1.S0.LE._T.2023q4] +
  aall[F2M..S1.S0.LE._T.2023q4] +
  aall[F3..S1.S0.LE._T.2023q4] +
  aall[F4..S1.S0.LE._T.2023q4] +
  aall[F51..S1.S0.LE._T.2023q4] +
  aall[F52..S1.S0.LE._T.2023q4] +
  aall[F6..S1.S0.LE._T.2023q4] +
  aall[F7..S1.S0.LE._T.2023q4] +
  aall[F81..S1.S0.LE._T.2023q4] +
  aall[F89..S1.S0.LE._T.2023q4]

# Compare total assets with sum of components
check5_assets = total_assets - components_assets

# Flag differences > 0.01 as 'nok' (not OK) for assets
fifelse(abs(check5_assets)>0.01, yes='nok', no='ok', na=NA)

# Extract actual values for problematic cases in assets
values_assets <- check5_assets$"_.obs_value"
countries <- check5_assets$REF_AREA
result_assets <- fifelse(abs(values_assets) > 0.01, 
                         yes = abs(values_assets), 
                         no = 0, 
                         na = NA)
names(result_assets) <- countries

result_assets

#################### LIABILITIES CHECK ####################
# Check if total financial liabilities (F) equals sum of instrument components
# Liabilities are identified by S0.S1 where S1 (total economy) has liabilities to all holders (S0)
total_liab = aall[F..S0.S1.LE._T.2023q4]

# Sum individual liability components
components_liab = aall[F21..S0.S1.LE._T.2023q4] +
  aall[F2M..S0.S1.LE._T.2023q4] +
  aall[F3..S0.S1.LE._T.2023q4] +
  aall[F4..S0.S1.LE._T.2023q4] +
  aall[F51..S0.S1.LE._T.2023q4] +
  aall[F52..S0.S1.LE._T.2023q4] +
  aall[F6..S0.S1.LE._T.2023q4] +
  aall[F7..S0.S1.LE._T.2023q4] +
  aall[F81..S0.S1.LE._T.2023q4] +
  aall[F89..S0.S1.LE._T.2023q4]

# Compare total liabilities with sum of components
check5_liab = total_liab - components_liab

# Flag differences > 0.01 as 'nok' (not OK) for liabilities

fifelse(abs(check5_liab)>0.01, yes='nok', no='ok', na=NA)

# Extract actual values for problematic cases in liabilities
values_liab <- check5_liab$"_.obs_value"
countries <- check5_liab$REF_AREA
result_liab <- fifelse(abs(values_liab) > 0.01, 
                       yes = abs(values_liab), 
                       no = 0, 
                       na = NA)
names(result_liab) <- countries
result_liab


#################### INSTRUMENT SUBCOMPONENT CHECKS ####################
# These checks verify if main instrument categories equal the sum of their subcomponents
# Both assets (S1.S0) and liabilities (S0.S1) are checked for each instrument

#################### DEBT SECURITIES CHECK (F3 = F3S + F3L) ####################
# Check if total debt securities equals sum of short-term and long-term securities

# ASSETS side check for F3
check6a_assets = aall[F3..S1.S0.LE._T.2023q4] - 
  (aall[F3S..S1.S0.LE._T.2023q4] + aall[F3L..S1.S0.LE._T.2023q4])

print("F3 Assets check results:")
fifelse(abs(check6a_assets)>0.01, yes='nok', no='ok', na=NA)

# Extract problematic values for F3 assets
values_f3_assets <- check6a_assets$"_.obs_value"
countries <- check6a_assets$REF_AREA
result_f3_assets <- fifelse(abs(values_f3_assets) > 0.01, 
                            yes = abs(values_f3_assets), 
                            no = 0, 
                            na = NA)
names(result_f3_assets) <- countries
print("Problematic values in F3 assets:")
result_f3_assets

# LIABILITIES side check for F3
check6a_liab = aall[F3..S0.S1.LE._T.2023q4] - 
  (aall[F3S..S0.S1.LE._T.2023q4] + aall[F3L..S0.S1.LE._T.2023q4])

print("F3 Liabilities check results:")
fifelse(abs(check6a_liab)>0.01, yes='nok', no='ok', na=NA)

# Extract problematic values for F3 liabilities
values_f3_liab <- check6a_liab$"_.obs_value"
countries <- check6a_liab$REF_AREA
result_f3_liab <- fifelse(abs(values_f3_liab) > 0.01, 
                          yes = abs(values_f3_liab), 
                          no = 0, 
                          na = NA)
names(result_f3_liab) <- countries
print("Problematic values in F3 liabilities:")
result_f3_liab

#################### LOANS CHECK (F4 = F4S + F4L) ####################
# Check if total loans equals sum of short-term and long-term loans

# ASSETS side check for F4
check6b_assets = aall[F4..S1.S0.LE._T.2023q4] - 
  (aall[F4S..S1.S0.LE._T.2023q4] + aall[F4L..S1.S0.LE._T.2023q4])

print("F4 Assets check results:")
fifelse(abs(check6b_assets)>0.01, yes='nok', no='ok', na=NA)

# Extract problematic values for F4 assets
values_f4_assets <- check6b_assets$"_.obs_value"
countries <- check6b_assets$REF_AREA
result_f4_assets <- fifelse(abs(values_f4_assets) > 0.01, 
                            yes = abs(values_f4_assets), 
                            no = 0, 
                            na = NA)
names(result_f4_assets) <- countries
print("Problematic values in F4 assets:")
result_f4_assets

# LIABILITIES side check for F4
check6b_liab = aall[F4..S0.S1.LE._T.2023q4] - 
  (aall[F4S..S0.S1.LE._T.2023q4] + aall[F4L..S0.S1.LE._T.2023q4])

print("F4 Liabilities check results:")
fifelse(abs(check6b_liab)>0.01, yes='nok', no='ok', na=NA)

# Extract problematic values for F4 liabilities
values_f4_liab <- check6b_liab$"_.obs_value"
countries <- check6b_liab$REF_AREA
result_f4_liab <- fifelse(abs(values_f4_liab) > 0.01, 
                          yes = abs(values_f4_liab), 
                          no = 0, 
                          na = NA)
names(result_f4_liab) <- countries
print("Problematic values in F4 liabilities:")
result_f4_liab

#################### EQUITY CHECK (F51 = F511 + F51M) ####################
# Check if total equity equals sum of listed shares and unlisted shares/other equity

# ASSETS side check for F51
check6c_assets = aall[F51..S1.S0.LE._T.2023q4] - 
  (aall[F511..S1.S0.LE._T.2023q4] + aall[F51M..S1.S0.LE._T.2023q4])

print("F51 Assets check results:")
fifelse(abs(check6c_assets)>0.01, yes='nok', no='ok', na=NA)

# Extract problematic values for F51 assets
values_f51_assets <- check6c_assets$"_.obs_value"
countries <- check6c_assets$REF_AREA
result_f51_assets <- fifelse(abs(values_f51_assets) > 0.01, 
                             yes = abs(values_f51_assets), 
                             no = 0, 
                             na = NA)
names(result_f51_assets) <- countries
print("Problematic values in F51 assets:")
result_f51_assets

# LIABILITIES side check for F51
check6c_liab = aall[F51..S0.S1.LE._T.2023q4] - 
  (aall[F511..S0.S1.LE._T.2023q4] + aall[F51M..S0.S1.LE._T.2023q4])

print("F51 Liabilities check results:")
fifelse(abs(check6c_liab)>0.01, yes='nok', no='ok', na=NA)

# Extract problematic values for F51 liabilities
values_f51_liab <- check6c_liab$"_.obs_value"
countries <- check6c_liab$REF_AREA
result_f51_liab <- fifelse(abs(values_f51_liab) > 0.01, 
                           yes = abs(values_f51_liab), 
                           no = 0, 
                           na = NA)
names(result_f51_liab) <- countries
print("Problematic values in F51 liabilities:")
result_f51_liab

#################### INSURANCE CHECK (F6 = F6N + F6O) ####################
# Check if total insurance equals sum of life insurance/pension and non-life insurance

# ASSETS side check for F6
check6d_assets = aall[F6..S1.S0.LE._T.2023q4] - 
  (aall[F6N..S1.S0.LE._T.2023q4] + aall[F6O..S1.S0.LE._T.2023q4])

print("F6 Assets check results:")
fifelse(abs(check6d_assets)>0.01, yes='nok', no='ok', na=NA)

# Extract problematic values for F6 assets
values_f6_assets <- check6d_assets$"_.obs_value"
countries <- check6d_assets$REF_AREA
result_f6_assets <- fifelse(abs(values_f6_assets) > 0.01, 
                            yes = abs(values_f6_assets), 
                            no = 0, 
                            na = NA)
names(result_f6_assets) <- countries
print("Problematic values in F6 assets:")
result_f6_assets

# LIABILITIES side check for F6
check6d_liab = aall[F6..S0.S1.LE._T.2023q4] - 
  (aall[F6N..S0.S1.LE._T.2023q4] + aall[F6O..S0.S1.LE._T.2023q4])

print("F6 Liabilities check results:")
fifelse(abs(check6d_liab)>0.01, yes='nok', no='ok', na=NA)

# Extract problematic values for F6 liabilities
values_f6_liab <- check6d_liab$"_.obs_value"
countries <- check6d_liab$REF_AREA
result_f6_liab <- fifelse(abs(values_f6_liab) > 0.01, 
                          yes = abs(values_f6_liab), 
                          no = 0, 
                          na = NA)
names(result_f6_liab) <- countries
print("Problematic values in F6 liabilities:")
result_f6_liab


>>>>>>> 406e5b309d90df7b20a5f2e44d5fbaf32b8b98ce
#!todo: check if they are NA or not filled or zero before filling with 0 (rule 3+2) (should be not filled)