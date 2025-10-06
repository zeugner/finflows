#################### LOADING QUARTERLY SECTOR ACCOUNTS FROM EUROSTAT ####################


nasq_S=mds("Estat/nasq_10_f_bs/Q.MIO_EUR...F+F1+F2+F21+F22+F22_F29+F29+F3+F31+F32+F4+F41+F42+F5+F51+F511+F512+F512_F519+F519+F52+F6+F61_F66+F62+F63+F63_F64_F65+F64_F65+F7+F8+F81+F89.")
nasq_F=mds("Estat/nasq_10_f_tr/Q.MIO_EUR...F1+F2+F21+F22+F22_F29+F29+F3+F31+F32+F4+F41+F42+F5+F51+F511+F512+F512_F519+F519+F52+F6+F61_F66+F62+F63+F63_F64_F65+F64_F65+F7+F8+F81+F89.")


# - Estat/nasq_10_f_bs: Eurostat's quarterly financial balance sheets

saveRDS(nasq_S,file='data/domestic_loading_data_files/nasq_S.rds')
saveRDS(nasq_F,file='data/domestic_loading_data_files/nasq_F.rds')
