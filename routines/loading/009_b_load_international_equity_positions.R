# Load required packages
library(MDstats)
library(MD3)


# Set the project directories
if (!exists("data_dir")) data_dir = getwd()


# Define paste0 operator
`%&%` = function (..., collapse = NULL, recycle0 = FALSE)  .Internal(paste0(list(...), collapse, recycle0))



# Country codes for IMF data
ccc='AUT+BEL+BGR+CYP+CZE+DEU+DNK+EST+ESP+FIN+FRA+GBR+GRC+HRV+HUN+IRL+ITA+LTU+LUX+LVA+MLT+NLD+POL+PRT+ROU+SWE+SVN+SVK'

# Load IMF data
af5 = mds('IMF/BOP/' %&% ccc %&% '.A_NFA_T.O_F519+P_F5+P_F51+P_F52+P_F52_S123+P_F5_S121+P_F5_S122+P_F5_S12R+P_F5_S13+P_F5_S1V+P_F5_S1Z.USD.Q',startPeriod = "1999q4")
lf5 = mds('IMF/BOP/' %&% ccc %&% '.L_NIL_T.O_F519+P_F5+P_F51+P_F52+P_F52_S123+P_F5_S121+P_F5_S122+P_F5_S12R+P_F5_S13+P_F5_S1V+P_F5_S1Z.USD.Q',startPeriod = "1999q4")

#### Save the two data sources
saveRDS(af5, file.path(data_dir, 'af5.rds'))
saveRDS(lf5, file.path(data_dir, 'lf5.rds'))

#### EXCHANGE RATE!
usd_eur = mds('ECB/EXR/Q.USD.EUR.SP00.E')
#####conversion in euros
af5_eur=af5/usd_eur
lf5_eur=lf5/usd_eur


saveRDS(af5_eur, file.path(data_dir, 'af5_eur.rds'))
saveRDS(lf5_eur, file.path(data_dir, 'lf5_eur.rds'))
