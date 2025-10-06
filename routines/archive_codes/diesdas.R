library(MDstats); 

# Set data directory
#data_dir= file.path(getwd(),'data')
if (!exists("data_dir")) data_dir = '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/data/'
source('\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/routines/utilities.R')
gc()


## load filled iip bop
aa=readRDS(file.path(data_dir,'aa_iip_agg.rds')); gc()

#listed shares held by AT sectors
eaaa=aa[F511.AT.S1M+S13+S11.S11+S1.LE._T.2022q4.W2]


dfea=as.data.frame(eaaa)

library(highcharter)
library(dplyr)
library(tidyr)
library(tidyverse)

sankey_data <- dfea %>%
  mutate(.keep='none',from = as.character(REF_SECTOR),
            to   = as.character(COUNTERPART_SECTOR),
            weight = as.numeric(obs_value)) %>%
  filter(!is.na(weight), weight > 0)

# Build node list with separate IDs for source/target sides (intrasectoral exposure)
sectors <- union(sankey_data$from, sankey_data$to)

nodes <- c(
  lapply(sectors, function(s) list(id = paste0(s, "_src"), name = s, column = 0)),
  lapply(sectors, function(s) list(id = paste0(s, "_dst"), name = s, column = 1))
)

# Map links to those IDs (so S11->S11 becomes S11_src -> S11_dst)
links <- sankey_data %>%
  transmute(from = paste0(from, "_src"),
            to   = paste0(to,   "_dst"),
            weight = weight) 


highchart() %>%
  hc_add_series(
    type = "sankey",
    data = links,
    nodes = nodes,
    hcaes(from = from, to = to, weight = weight)
  )


#############
eat=aa[Fx7.EA20.S1M+S13+S11.S11+S1.LE._T.2022q4.W2+WRL_REST+US]
dfeat=as.data.frame(eat)

library(highcharter)
library(dplyr)
library(tidyr)
library(tidyverse)

sankey_data <- dfeat %>%
  mutate(.keep='none',from = as.character(REF_SECTOR),
         to   = as.character(COUNTERPART_SECTOR),
         weight = as.numeric(obs_value)) %>%
  filter(!is.na(weight), weight > 0)

# Build node list with separate IDs for source/target sides (intrasectoral exposure)
sectors <- union(sankey_data$from, sankey_data$to)

nodes <- c(
  lapply(sectors, function(s) list(id = paste0(s, "_src"), name = s, column = 0)),
  lapply(sectors, function(s) list(id = paste0(s, "_dst"), name = s, column = 1))
)

# Map links to those IDs (so S11->S11 becomes S11_src -> S11_dst)
links <- sankey_data %>%
  transmute(from = paste0(from, "_src"),
            to   = paste0(to,   "_dst"),
            weight = weight) 


highchart() %>%
  hc_add_series(
    type = "sankey",
    data = links,
    nodes = nodes,
    hcaes(from = from, to = to, weight = weight)
  )

