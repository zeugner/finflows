#################### LOADING QUARTERLY SECTOR ACCOUNTS FROM EUROSTAT ####################

# Create list to store all unconsolidated data

aa5=mds("Estat/nasq_10_f_bs/Q.MIO_EUR...F511+F512_F519+F51.")
aa5t=mds("Estat/nasq_10_f_tr/Q.MIO_EUR...F511+F512_F519+F51.")


# - Estat/nasq_10_f_bs: Eurostat's quarterly financial balance sheets

saveRDS(aa5,file='data/domestic_loading_data_files/aa5.rds')
saveRDS(aa5t,file='data/domestic_loading_data_files/aa5t.rds')