# Load required packages
library(MDstats)
library(MD3)
library(tidyr)

# Set data directory
if (!exists("data_dir")) data_dir = getwd()

# Purpose: Load exchange rate data from multiple sources for conversion from national currencies to euro

# SECTION 1: Load Exchange Rate Data for Stocks
# Load quarterly financial stock data in national currency (NAC) and euro (EUR)
# Using debt securities (F3) held by total economy (S1) as the benchmark

aaF3_STO=mds("Estat/nasq_10_f_bs/Q.MIO_NAC+MIO_EUR.S1.ASS.F3.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE+UK")
saveRDS(aaF3_STO, file.path(data_dir, 'eurostat_f3_stocks.rds'))

# SECTION 2: Load Exchange Rate Data for Flows (Period average rates)
# Load quarterly financial flow data in both national currency and euro
# Using debt securities (F3) held by total economy (S1) as benchmark
aaF3_FLO=mds("Estat/nasq_10_f_tr/Q.MIO_NAC+MIO_EUR.S1.ASS.F3.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE+UK")
saveRDS(aaF3_FLO, file.path(data_dir, 'eurostat_f3_flows.rds'))

# SECTION 3: Load supplementary exchange rate data from IMF and ECB
# This data is used to fill gaps in Eurostat-derived exchange rates
fxpppQ <- read.csv(file.path(data_dir, 'static/fxpppQ.csv'))
saveRDS(fxpppQ, file.path(data_dir, 'imf_ecb_exchange_rates.rds'))
