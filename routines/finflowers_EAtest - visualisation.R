<<<<<<< HEAD
#source('https://s-ecfin-web.net1.cec.eu.int/directorates/db/u1/R/routines/installMDecfin.txt')


library(MDecfin)
library(highcharter)
#setwd('U:/Topics/Spillovers_and_EA/flowoffunds/finflows2024/gitcodedata')


aall=readRDS('data/aall1.rds')

#dimcodes(aall)

#####example F511 AT Assets Stocks #####

# Create sector label mapping 
sector_labels <- c(
  "S11" = "Non-Fin Corp",
  "S124" = "Inv Funds",
  "S12K" = "Banks",
  "S12O" = "Other Fin",
  "S12Q" = "Ins & Pens",
  "S13" = "Government",
  "S1M" = "HH & NPISH",
  "S0" = "Total Econ",
  "S2" = "RoW"
)

# Extract data as before
# excluded S0 which will be replaced by S2 (rest of the world)
f511a = aall[F511.AT.S11+S124+S12K+S12O+S12Q+S13+S1M+S2.S11+S124+S12K+S12O+S12Q+S13+S2.LE._T.y2022q4]
f511a_dt <- as.data.table(f511a)

# Reshape data
f511a_long <- melt(
  f511a_dt[, .(REF_SECTOR, COUNTERPART_SECTOR, obs_value)],
  id.vars = c("REF_SECTOR", "COUNTERPART_SECTOR"),
  measure.vars = "obs_value",
  variable.name = "Measure",
  value.name = "Value"
)

# Prepare data and replace codes with labels
dependency_data <- f511a_long[!is.na(Value) & Value > 0]
dependency_data <- dependency_data[, .(
  from = sector_labels[REF_SECTOR],
  to = sector_labels[COUNTERPART_SECTOR],
  weight = Value
)]

# Create enhanced dependency wheel
hw <- highchart() %>%
  hc_chart(type = "dependencywheel") %>%
  hc_add_series(
    data = list_parse(dependency_data),
    keys = c("from", "to", "weight"),
    name = "Flow Value"
  ) %>%
  hc_title(text = "Listed Shares (F511) Flows Between Sectors - Austria") %>%
  hc_subtitle(text = "2022 Q4 Stock Positions") %>%
  hc_size(height = 700) %>%
  hc_tooltip(
    formatter = JS("function() {
            return '<b>' + this.point.from + '</b> → <b>' + 
                   this.point.to + '</b>: ' + 
                   Highcharts.numberFormat(this.point.weight, 0) + ' million'
        }")
  ) %>%
  hc_add_theme(hc_theme_smpl())

# Save visualization in HTML because my RStudio Viewer Pane does not show anything
htmlwidgets::saveWidget(hw, "F511_AT_sectors_wheel.html", selfcontained = TRUE)
=======

#todo: we can adjust the colour scheme instead of hc_theme_smpl later on