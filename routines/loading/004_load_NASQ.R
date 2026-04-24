# Load required packages
library(MDstats)
library(MD3)

# Set data directory
if (!exists("data_dir")) data_dir = getwd()

#################### LOADING QUARTERLY SECTOR ACCOUNTS FROM EUROSTAT ####################

# Load quarterly stocks

nasq_10_f_bs=mds("Estat/nasq_10_f_bs/")
dimnames(nasq_10_f_bs)
nasq_S=nasq_10_f_bs[MIO_EUR...F+F1+F2+F21+F22+F22_F29+F29+F3+F31+F32+F4+F41+F42+F5+F51+F511+F512+F512_F519+F519+F52+F6+F61_F66+F62+F63+F63_F64_F65+F64_F65+F7+F8+F81+F89..]
  
saveRDS(nasq_S, file=file.path(data_dir, 'domestic_loading_data_files/nasq_S.rds'))

# Load quarterly flows
nasq_10_f_tr=mds("Estat/nasq_10_f_tr/")
nasq_F=nasq_10_f_tr[MIO_EUR...F1+F2+F21+F22+F22_F29+F29+F3+F31+F32+F4+F41+F42+F5+F51+F511+F512+F512_F519+F519+F52+F6+F61_F66+F62+F63+F63_F64_F65+F64_F65+F7+F8+F81+F89..]
saveRDS(nasq_F, file=file.path(data_dir, 'domestic_loading_data_files/nasq_F.rds'))
