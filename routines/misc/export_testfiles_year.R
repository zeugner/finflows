library(MDstats); library(MD3)

# Set data directory
setwd("V:/FinFlows/githubrepo/finflows")
data_dir= file.path(getwd(),'data')
if (!exists("data_dir")) data_dir = '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/data/'

aa=readRDS(file.path(data_dir,'aa_iip_cpis.rds')); gc()
ll=readRDS(file.path(data_dir,'ll_iip_cpis.rds')); gc()

#######################################################
# export for stocks 2022q4 fore selected cp areas #
#######################################################
dim(aa)
ref_areas = c("EA20", "EU27", "AT", "BG", "CY",
                          "CZ", "DE", "DK", "EE", "GR", "ES", "FI",
                          "FR",  "HR", "HU", "IE",  "IT", "LT", "LU", "LV", 
                          "MT", "NL", "PL", "PT", "RO",  "SE", "SI", "SK", "BE")

cp_areas  = c("W2","W0","WRL_REST","EA20","EU27","US","CH")

for (ra in ref_areas) {
  slice <- aa[ , ra, , , "LE", , "2022q4", cp_areas, drop = FALSE ]
  dt <- as.data.table(as.list(slice))
  fwrite(dt, "output/aa_stocks_2022q4_selected_cp.csv", append = file.exists("aa_stocks_2022q4_selected_cp.csv"))
}
dim(ll)
for (ra in ref_areas) {
  slicell <- ll[ , cp_areas, , , "LE", , "2022q4", ra, drop = FALSE ]
  dtl <- as.data.table(as.list(slicell))
  fwrite(dtl, "output/ll_stocks_2022q4_selected_cp.csv", append = file.exists("ll_stocks_2022q4_selected_cp.csv"))
}