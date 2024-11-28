#source('https://s-ecfin-web.net1.cec.eu.int/directorates/db/u1/R/routines/installMDecfin.txt')
library(MDecfin)
library(highcharter)
#setwd('U:/Topics/Spillovers_and_EA/flowoffunds/finflows2024/gitcodedata')


aall=readRDS('data/aall.rds')

#dimcodes(aall)

#whom to whom example F511 AT Assets Stocks #####
fa=aall[F511.AT.S11+S124+S12K+S12O+S12Q+S13+S1M+S0.S11+S124+S12K+S12O+S12Q+S13+S0.LE._T.y2022q4]

fa_dt <- as.data.table(fa)
fa_long <- melt(
  fa_dt[, .(REF_SECTOR, COUNTERPART_SECTOR, obs_value)], # Keep only relevant columns
  id.vars = c("REF_SECTOR", "COUNTERPART_SECTOR"),         
  measure.vars = "obs_value",                              
  variable.name = "Measure",                               
  value.name = "Value")                                     

##prep data for dependency wheel

dependency_data <- fa_long[!is.na(Value) & Value > 0]

dependency_data <- dependency_data[, .(from = REF_SECTOR, 
                                       to = COUNTERPART_SECTOR, 
                                       weight = Value)]

highchart() %>%
  hc_chart(type = "dependencywheel") %>%
  hc_add_series(
    data = list_parse(dependency_data),  # Convert the data.table to a list
    keys = c("from", "to", "weight")     # Specify the key mappings
  ) %>%
  hc_title(text = "Dependency Wheel") %>%
  hc_add_theme(hc_theme_smpl())

