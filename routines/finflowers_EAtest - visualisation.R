#source('https://s-ecfin-web.net1.cec.eu.int/directorates/db/u1/R/routines/installMDecfin.txt')


library(MDecfin)
library(highcharter)
#setwd('U:/Topics/Spillovers_and_EA/flowoffunds/finflows2024/gitcodedata')


aall=readRDS('data/aall.rds')

#dimcodes(aall)

#####example F511 AT Assets Stocks #####

#whom to whom with F
f511a=aall[F511.AT.S11+S124+S12K+S12O+S12Q+S13+S1M+S0.S11+S124+S12K+S12O+S12Q+S13+S0.LE._T.y2022q4]

f511a_dt <- as.data.table(f511a)
f511a_long <- melt(
  f511a_dt[, .(REF_SECTOR, COUNTERPART_SECTOR, obs_value)], # Keep only relevant columns
  id.vars = c("REF_SECTOR", "COUNTERPART_SECTOR"),         
  measure.vars = "obs_value",                              
  variable.name = "Measure",                               
  value.name = "Value")                                     

##prep data for dependency wheel

dependency_data <- f511a_long[!is.na(Value) & Value > 0]

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
