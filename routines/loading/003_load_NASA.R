# Load required packages
library(MDstats)
library(MD3)

# Set data directory
if (!exists("data_dir")) data_dir = getwd()

# Load NASA unconsolidated assets
nasa_f_bs = mds("Estat/nasa_10_f_bs/")
la=nasa_f_bs[MIO_EUR.NCO.S1+S11+S12+S121+S121_S122_S123+S122+S122_S123+S123+S124+S125+S125_S126_S127+S126+S127+S128+S128_S129+S129+S13+S14+S14_S15+S15+S2+S21+S2I.ASS.F+F1+F2+F21+F22+F29+F3+F31+F32+F4+F41+F42+F5+F51+F511+F512+F519+F52+F6+F61+F62+F63+F63_F64_F65+F64+F65+F66+F7+F8+F81+F89..]
dimnames(la)

saveRDS(la, file=file.path(data_dir, 'domestic_loading_data_files/nasa_unconsolidated_stocks_assets.rds'))

# Load NASA unconsolidated flows
nasa_10_f_tr =mds("Estat/nasa_10_f_tr/")
dimnames(nasa_10_f_tr)

lat = nasa_10_f_tr[MIO_EUR.NCO.S1+S11+S12+S121+S121_S122_S123+S122+S122_S123+S123+S124+S125+S125_S126_S127+S126+S127+S128+S128_S129+S129+S13+S14+S14_S15+S15+S2.ASS.F1+F2+F21+F22+F29+F3+F31+F32+F4+F41+F42+F5+F51+F511+F512+F519+F52+F6+F61+F62+F63+F63_F64_F65+F64+F65+F66+F7+F8+F81+F89..]
dimnames(lat)
saveRDS(lat, file=file.path(data_dir, 'domestic_loading_data_files/nasa_unconsolidated_flows_assets.rds'))

# NASA consolidated stocks
lc = nasa_f_bs[MIO_EUR.CO.S1+S11+S12+S121+S121_S122_S123+S122+S122_S123+S123+S124+S125+S125_S126_S127+S126+S127+S128+S128_S129+S129+S13+S14+S14_S15+S15+S2+S21+S2I.ASS.F+F1+F2+F21+F22+F29+F3+F31+F32+F4+F41+F42+F5+F51+F511+F512+F519+F52+F6+F61+F62+F63+F63_F64_F65+F64+F65+F66+F7+F8+F81+F89..]
saveRDS(lc, file=file.path(data_dir, 'domestic_loading_data_files/nasa_consolidated_stocks_assets.rds'))

# NASA consolidated flows
lct = nasa_10_f_tr[MIO_EUR.CO.S1+S11+S12+S121+S121_S122_S123+S122+S122_S123+S123+S124+S125+S125_S126_S127+S126+S127+S128+S128_S129+S129+S13+S14+S14_S15+S15+S2.ASS.F1+F2+F21+F22+F29+F3+F31+F32+F4+F41+F42+F5+F51+F511+F512+F519+F52+F6+F61+F62+F63+F63_F64_F65+F64+F65+F66+F7+F8+F81+F89..]

saveRDS(lct, file=file.path(data_dir, 'domestic_loading_data_files/nasa_consolidated_flows_assets.rds'))

# NASA unconsolidated liabilities stocks
la_l = nasa_f_bs[MIO_EUR.NCO.S1+S11+S12+S121+S121_S122_S123+S122+S122_S123+S123+S124+S125+S125_S126_S127+S126+S127+S128+S128_S129+S129+S13+S14+S14_S15+S15+S2+S21+S2I.LIAB.F+F1+F2+F21+F22+F29+F3+F31+F32+F4+F41+F42+F5+F51+F511+F512+F519+F52+F6+F61+F62+F63+F63_F64_F65+F64+F65+F66+F7+F8+F81+F89..]
saveRDS(la_l, file=file.path(data_dir, 'domestic_loading_data_files/nasa_unconsolidated_stocks_LIAB.rds'))

# Load NASA unconsolidated liabilities flows
lat_l = nasa_10_f_tr[MIO_EUR.NCO.S1+S11+S12+S121+S121_S122_S123+S122+S122_S123+S123+S124+S125+S125_S126_S127+S126+S127+S128+S128_S129+S129+S13+S14+S14_S15+S15+S2.LIAB.F1+F2+F21+F22+F29+F3+F31+F32+F4+F41+F42+F5+F51+F511+F512+F519+F52+F6+F61+F62+F63+F63_F64_F65+F64+F65+F66+F7+F8+F81+F89..]
saveRDS(lat_l, file=file.path(data_dir, 'domestic_loading_data_files/nasa_unconsolidated_flows_LIAB.rds'))

# Load NASA consolidated liabilities stocks
lc_l = nasa_f_bs[MIO_EUR.CO.S1+S11+S12+S121+S121_S122_S123+S122+S122_S123+S123+S124+S125+S125_S126_S127+S126+S127+S128+S128_S129+S129+S13+S14+S14_S15+S15+S2+S21+S2I.LIAB.F+F1+F2+F21+F22+F29+F3+F31+F32+F4+F41+F42+F5+F51+F511+F512+F519+F52+F6+F61+F62+F63+F63_F64_F65+F64+F65+F66+F7+F8+F81+F89..]
saveRDS(lc_l, file=file.path(data_dir, 'domestic_loading_data_files/nasa_consolidated_stocks_LIAB.rds'))

# Load NASA consolidated liabilities flows
lct_l = nasa_10_f_tr[MIO_EUR.CO.S1+S11+S12+S121+S121_S122_S123+S122+S122_S123+S123+S124+S125+S125_S126_S127+S126+S127+S128+S128_S129+S129+S13+S14+S14_S15+S15+S2.LIAB.F1+F2+F21+F22+F29+F3+F31+F32+F4+F41+F42+F5+F51+F511+F512+F519+F52+F6+F61+F62+F63+F63_F64_F65+F64+F65+F66+F7+F8+F81+F89..]
saveRDS(lct_l, file=file.path(data_dir, 'domestic_loading_data_files/nasa_consolidated_flows_LIAB.rds'))
