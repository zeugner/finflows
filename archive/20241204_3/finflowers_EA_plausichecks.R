#source('https://s-ecfin-web.net1.cec.eu.int/directorates/db/u1/R/routines/installMDecfin.txt')


library(MDecfin)
#BRUSSELS
#setwd('U:/Topics/Spillovers_and_EA/flowoffunds/finflows2024/gitcodedata')
#setwd('C:/Users/aruqaer/R/finflow/gitclone/finflows')

#ISPRA
#setwd('X:/Finflows/zeugner')

aall=readRDS('data/aall1.rds')

#dimcodes(aall)


#################### CONSISTENCY CHECKS ####################

# SECTORAL CONSISTENCY CHECK 1: Total Economy Assets Composition
# Verify if total economy (S1) assets equal sum of all institutional sectors
# Sectors checked: Non-financial corps (S11), Households (S1M), Banks (S12K),
# Other financial (S12O), Insurance/Pension (S12Q), Investment funds (S124), Government (S13)
check1=aall[F..S1.S0.LE._T.2023q4]-rowSums(aall[F..S11+S1M+S12K+S12O+S12Q+S124+S13.S0.LE._T.2023q4])
result_check1 <- check1[abs(check1) > 1]
# Extract actual values for problematic cases
print("Problematic values in S1 subsectors assets stocks:")
result_check1


# SECTORAL CONSISTENCY CHECK 2: Total Economy Liabilities Composition
# Verify if total economy (S1) liabilities equal sum of all institutional sectors
check2=aall[F..S0.S1.LE._T.2023q4]-rowSums(aall[F..S0.S11+S1M+S12K+S12O+S12Q+S124+S13.LE._T.2023q4])
result_check2 <- check2[abs(check2) > 1]
# Extract actual values for problematic cases
print("Problematic values in S1 subsectors liabilities stocks:")
result_check2

# SECTORAL CONSISTENCY CHECK 3a: Currency Liabilities (F21)
# Verify if currency liabilities are only held by central bank (S12K) and government (S13)
check3a=aall[F21..S0.S1.LE._T.2023q4]-rowSums(aall[F21..S0.S13+S12K.LE._T.2023q4])
result_check3a <- check3a[abs(check3a) > 1]
# Extract actual values for problematic cases
print("Problematic values in currency liabilities:")
result_check3a

# SECTORAL CONSISTENCY CHECK 3b: Deposit Liabilities (F2M)
# Verify if deposit liabilities are only held by banks (S12K) and government (S13)
check3b=aall[F2M..S0.S1.LE._T.2023q4]-rowSums(aall[F2M..S0.S13+S12K.LE._T.2023q4])
result_check3b <- check3b[abs(check3b) > 1]
# Extract actual values for problematic cases
print("Problematic values in deposit liabilities:")
result_check3b

#!todo open: include a check if S0 is zero also  check if S1 is zero or NA (should be not filled)
#!todo: how to handle time (quarter/years) + 
check4a=aall[...S0.LE._T.2023q4]
check4b=aall[...S1.LE._T.2023q4]
result_check4a <- check4a[abs(check4a) == 0] 
result_check4b <- check4b[abs(check4a) == 0]
check4 <- result_check4a-result_check4b
result_check4 <- check4[abs(check4) > 1]
# Extract actual values for problematic cases
print("Problematic values in S0:")
result_check4


####financial instruments checks
# Note: While rowSums() works for sector additions in MD3 objects, it doesn't work properly
# for instrument additions. This is because rowSums() interprets the + operator differently
# across dimensions: it correctly sums across sectors but concatenates across instruments.
# Therefore, we need to explicitly add each instrument component.


#################### INSTRUMENT SUBCOMPONENT CHECKS ####################
# These checks verify if main instrument categories equal the sum of their subcomponents
# For each check:
# - Assets: S1.S0 (total economy holds assets against all counterparts)
# - Liabilities: S0.S1 (total economy has liabilities to all holders)
# Only problematic values (exceeding 1% threshold) are shown

#################### DEBT SECURITIES (F3 = F3S + F3L) ####################
# ASSETS check for F3
f3_values_assets = aall[F3..S1.S0.LE._T.2023q4]
threshold_assets = abs(f3_values_assets) * 0.01
check_f3_assets = aall[F3..S1.S0.LE._T.2023q4] - 
                (aall[F3S..S1.S0.LE._T.2023q4] + aall[F3L..S1.S0.LE._T.2023q4])
result_f3_assets <- check_f3_assets[abs(check_f3_assets) > threshold_assets]
print("Problematic values in F3 assets:")
print(result_f3_assets)

# LIABILITIES check for F3
f3_values_liab = aall[F3..S0.S1.LE._T.2023q4]
threshold_liab = abs(f3_values_liab) * 0.01
check_f3_liab = aall[F3..S0.S1.LE._T.2023q4] - 
              (aall[F3S..S0.S1.LE._T.2023q4] + aall[F3L..S0.S1.LE._T.2023q4])
result_f3_liab <- check_f3_liab[abs(check_f3_liab) > threshold_liab]
print("Problematic values in F3 liabilities:")
print(result_f3_liab)

#################### LOANS (F4 = F4S + F4L) ####################
# ASSETS check for F4
f4_values_assets = aall[F4..S1.S0.LE._T.2023q4]
threshold_assets = abs(f4_values_assets) * 0.01
check_f4_assets = aall[F4..S1.S0.LE._T.2023q4] - 
                (aall[F4S..S1.S0.LE._T.2023q4] + aall[F4L..S1.S0.LE._T.2023q4])
result_f4_assets <- check_f4_assets[abs(check_f4_assets) > threshold_assets]
print("Problematic values in F4 assets:")
print(result_f4_assets)

# LIABILITIES check for F4
f4_values_liab = aall[F4..S0.S1.LE._T.2023q4]
threshold_liab = abs(f4_values_liab) * 0.01
check_f4_liab = aall[F4..S0.S1.LE._T.2023q4] - 
              (aall[F4S..S0.S1.LE._T.2023q4] + aall[F4L..S0.S1.LE._T.2023q4])
result_f4_liab <- check_f4_liab[abs(check_f4_liab) > threshold_liab]
print("Problematic values in F4 liabilities:")
print(result_f4_liab)

#################### EQUITY (F51 = F511 + F51M) ####################
# ASSETS check for F51
f51_values_assets = aall[F51..S1.S0.LE._T.2023q4]
threshold_assets = abs(f51_values_assets) * 0.01
check_f51_assets = aall[F51..S1.S0.LE._T.2023q4] - 
                 (aall[F511..S1.S0.LE._T.2023q4] + aall[F51M..S1.S0.LE._T.2023q4])
result_f51_assets <- check_f51_assets[abs(check_f51_assets) > threshold_assets]
print("Problematic values in F51 assets:")
print(result_f51_assets)

# LIABILITIES check for F51
f51_values_liab = aall[F51..S0.S1.LE._T.2023q4]
threshold_liab = abs(f51_values_liab) * 0.01
check_f51_liab = aall[F51..S0.S1.LE._T.2023q4] - 
               (aall[F511..S0.S1.LE._T.2023q4] + aall[F51M..S0.S1.LE._T.2023q4])
result_f51_liab <- check_f51_liab[abs(check_f51_liab) > threshold_liab]
print("Problematic values in F51 liabilities:")
print(result_f51_liab)


#################### INSURANCE (F6 = F6N + F6O) ####################
# ASSETS check for F6
f6_values_assets = aall[F6..S1.S0.LE._T.2023q4]
threshold_assets = abs(f6_values_assets) * 0.01
check_f6_assets = aall[F6..S1.S0.LE._T.2023q4] - 
                (aall[F6N..S1.S0.LE._T.2023q4] + aall[F6O..S1.S0.LE._T.2023q4])
result_f6_assets <- check_f6_assets[abs(check_f6_assets) > threshold_assets]
print("Problematic values in F6 assets:")
print(result_f6_assets)

# LIABILITIES check for F6
f6_values_liab = aall[F6..S0.S1.LE._T.2023q4]
threshold_liab = abs(f6_values_liab) * 0.01
check_f6_liab = aall[F6..S0.S1.LE._T.2023q4] - 
              (aall[F6N..S0.S1.LE._T.2023q4] + aall[F6O..S0.S1.LE._T.2023q4])
result_f6_liab <- check_f6_liab[abs(check_f6_liab) > threshold_liab]
print("Problematic values in F6 liabilities:")
print(result_f6_liab)

#################### TOTAL INSTRUMENTS CHECK ####################
# Verify if total (F) equals sum of all instrument components
# F = F21 + F2M + F3 + F4 + F51 + F52 + F6 + F7 + F81 + F89

# ASSETS check
total_assets = aall[F..S1.S0.LE._T.2023q4]
threshold_assets = abs(total_assets) * 0.001

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

check_total_assets = total_assets - components_assets
result_total_assets <- check_total_assets[abs(check_total_assets) > threshold_assets]
print("Problematic values in total assets:")
print(result_total_assets)

# LIABILITIES check
total_liab = aall[F..S0.S1.LE._T.2023q4]
threshold_liab = abs(total_liab) * 0.01

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

check_total_liab = total_liab - components_liab
result_total_liab <- check_total_liab[abs(check_total_liab) > threshold_liab]
print("Problematic values in total liabilities:")
print(result_total_liab)

