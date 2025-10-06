# la = readRDS("data/domestic_loading_data_files/nasa_unconsolidated_stocks_assets.rds")
# lat = readRDS("data/domestic_loading_data_files/nasa_unconsolidated_flows_assets.rds")

lc = readRDS("data/domestic_loading_data_files/nasa_consolidated_stocks_assets.rds")
lct = readRDS("data/domestic_loading_data_files/nasa_consolidated_flows_assets.rds")
aall=readRDS("data/intermediate_domestic_data_files/aall_NASA_S0.rds")


la_q= readRDS('data/intermediate_domestic_data_files/la_q.rds')
lat_q= readRDS('data/intermediate_domestic_data_files/lat_q.rds')
lal_q= readRDS('data/intermediate_domestic_data_files/lal_q.rds')
latl_q= readRDS('data/intermediate_domestic_data_files/latl_q.rds')

# FROM NOW ON COMMENTED BECAUSE ALL THIS HAS ALREADY BEEN DONE IN THE PREVIOUS FILE
# 
# 
# names(dimnames(la))[[1]] = names(dimnames(lat))[[1]] = names(dimnames(la_l))[[1]] = names(dimnames(lat_l))[[1]] = 'REF_AREA'
# names(dimnames(la))[[2]] = names(dimnames(lat))[[2]] = names(dimnames(la_l))[[2]] = names(dimnames(lat_l))[[2]] = 'INSTR'
# names(dimnames(la))[[3]] = names(dimnames(lat))[[3]] = names(dimnames(la_l))[[3]] = names(dimnames(lat_l))[[3]] = 'REF_SECTOR'
# 
# ####### RENAME SECTORS AND INSTRUMENTS!
# 
# # Sector mappings
# dimnames(la)$REF_SECTOR[dimnames(la)$REF_SECTOR=='S14_S15'] = dimnames(la_l)$REF_SECTOR[dimnames(la_l)$REF_SECTOR=='S14_S15'] = dimnames(lat_l)$REF_SECTOR[dimnames(lat_l)$REF_SECTOR=='S14_S15'] = dimnames(lat)$REF_SECTOR[dimnames(lat)$REF_SECTOR=='S14_S15'] = 'S1M'
# dimnames(la)$REF_SECTOR[dimnames(la)$REF_SECTOR=='S121_S122_S123'] = dimnames(la_l)$REF_SECTOR[dimnames(la_l)$REF_SECTOR=='S121_S122_S123'] = dimnames(lat_l)$REF_SECTOR[dimnames(lat_l)$REF_SECTOR=='S121_S122_S123'] = dimnames(lat)$REF_SECTOR[dimnames(lat)$REF_SECTOR=='S121_S122_S123'] = 'S12K'
# dimnames(la)$REF_SECTOR[dimnames(la)$REF_SECTOR=='S122_S123'] = dimnames(la_l)$REF_SECTOR[dimnames(la_l)$REF_SECTOR=='S122_S123'] = dimnames(lat_l)$REF_SECTOR[dimnames(lat_l)$REF_SECTOR=='S122_S123'] = dimnames(lat)$REF_SECTOR[dimnames(lat)$REF_SECTOR=='S122_S123'] = 'S12T'
# dimnames(la)$REF_SECTOR[dimnames(la)$REF_SECTOR=='S128_S129'] = dimnames(la_l)$REF_SECTOR[dimnames(la_l)$REF_SECTOR=='S128_S129'] = dimnames(lat_l)$REF_SECTOR[dimnames(lat_l)$REF_SECTOR=='S128_S129'] = dimnames(lat)$REF_SECTOR[dimnames(lat)$REF_SECTOR=='S128_S129'] = 'S12Q'
# dimnames(la)$REF_SECTOR[dimnames(la)$REF_SECTOR=='S125_S126_S127'] = dimnames(la_l)$REF_SECTOR[dimnames(la_l)$REF_SECTOR=='S125_S126_S127'] = dimnames(lat_l)$REF_SECTOR[dimnames(lat_l)$REF_SECTOR=='S125_S126_S127'] = dimnames(lat)$REF_SECTOR[dimnames(lat)$REF_SECTOR=='S125_S126_S127'] = 'S12O'
# 
# # Financial instrument mappings
# dimnames(la)$INSTR[dimnames(la)$INSTR=='F63_F64_F65'] = dimnames(la_l)$INSTR[dimnames(la_l)$INSTR=='F63_F64_F65'] = dimnames(lat_l)$INSTR[dimnames(lat_l)$INSTR=='F63_F64_F65'] = dimnames(lat)$INSTR[dimnames(lat)$INSTR=='F63_F64_F65'] = 'F6M'
# dimnames(la)$INSTR[dimnames(la)$INSTR=='F31'] = dimnames(la_l)$INSTR[dimnames(la_l)$INSTR=='F31'] = dimnames(lat_l)$INSTR[dimnames(lat_l)$INSTR=='F31'] = dimnames(lat)$INSTR[dimnames(lat)$INSTR=='F31'] = 'F3S'
# dimnames(la)$INSTR[dimnames(la)$INSTR=='F32'] = dimnames(la_l)$INSTR[dimnames(la_l)$INSTR=='F32'] = dimnames(lat_l)$INSTR[dimnames(lat_l)$INSTR=='F32'] = dimnames(lat)$INSTR[dimnames(lat)$INSTR=='F32'] = 'F3L'
# dimnames(la)$INSTR[dimnames(la)$INSTR=='F41'] = dimnames(la_l)$INSTR[dimnames(la_l)$INSTR=='F41'] = dimnames(lat_l)$INSTR[dimnames(lat_l)$INSTR=='F41'] = dimnames(lat)$INSTR[dimnames(lat)$INSTR=='F41'] = 'F4S'
# dimnames(la)$INSTR[dimnames(la)$INSTR=='F42'] = dimnames(la_l)$INSTR[dimnames(la_l)$INSTR=='F42'] = dimnames(lat_l)$INSTR[dimnames(lat_l)$INSTR=='F42'] = dimnames(lat)$INSTR[dimnames(lat)$INSTR=='F42'] = 'F4L'
# 
# 
# #### sums now:
# la[.F51M..]<-la[.F512..]+la[.F519..]
# la[.F2M..]<-la[.F22..]+la[.F29..]
# la[.F6N..]<-la[.F62..]+la[.F6M..]
# 
# lat[.F51M..]<-lat[.F512..]+lat[.F519..]
# lat[.F2M..]<-lat[.F22..]+lat[.F29..]
# lat[.F6N..]<-lat[.F62..]+lat[.F6M..]
# 
# la_l[.F51M..]<-la_l[.F512..]+la_l[.F519..]
# la_l[.F2M..]<-la_l[.F22..]+la_l[.F29..]
# la_l[.F6N..]<-la_l[.F62..]+la_l[.F6M..]
# 
# 
# lat_l[.F51M..]<-lat_l[.F512..]+lat_l[.F519..]
# lat_l[.F2M..]<-lat_l[.F22..]+lat_l[.F29..]
# lat_l[.F6N..]<-lat_l[.F62..]+lat_l[.F6M..]
# 
# 
# ### quarterly
# la_q=copy(la); frequency(la_q)='Q'
# lat_q=copy(lat); frequency(lat_q)='Q'
# lal_q=copy(la_l); frequency(lal_q)='Q'
# latl_q=copy(lat_l); frequency(latl_q)='Q'
# 
# ####EA18=EA19=EA20
# la_q["EA18..."]=la_q["EA19..."]<-la_q["EA20..."]
# lat_q["EA18..."]=lat_q["EA19..."]<-lat_q["EA20..."]
# lal_q["EA18..."]=lal_q["EA19..."]<-lal_q["EA20..."]
# latl_q["EA18..."]=latl_q["EA19..."]<-latl_q["EA20..."]

### SAME FOR CONSOLIDATED (NO NEED FOR LIABILITIES AS WE ARE LOOKING AT INTRASECTOR WHERE ASSETS==LIABILITIES!)


names(dimnames(lc))[[1]] = names(dimnames(lct))[[1]] = 'REF_AREA'
names(dimnames(lc))[[2]] = names(dimnames(lct))[[2]] = 'INSTR'
names(dimnames(lc))[[3]] = names(dimnames(lct))[[3]] = 'REF_SECTOR'

####### RENAME SECTORS AND INSTRUMENTS!

# Sector mappings
dimnames(lc)$REF_SECTOR[dimnames(lc)$REF_SECTOR=='S14_S15'] = dimnames(lct)$REF_SECTOR[dimnames(lct)$REF_SECTOR=='S14_S15'] = 'S1M'
dimnames(lc)$REF_SECTOR[dimnames(lc)$REF_SECTOR=='S121_S122_S123'] = dimnames(lct)$REF_SECTOR[dimnames(lct)$REF_SECTOR=='S121_S122_S123'] = 'S12K'
dimnames(lc)$REF_SECTOR[dimnames(lc)$REF_SECTOR=='S122_S123'] = dimnames(lct)$REF_SECTOR[dimnames(lct)$REF_SECTOR=='S122_S123'] = 'S12T'
dimnames(lc)$REF_SECTOR[dimnames(lc)$REF_SECTOR=='S128_S129'] = dimnames(lct)$REF_SECTOR[dimnames(lct)$REF_SECTOR=='S128_S129'] = 'S12Q'
dimnames(lc)$REF_SECTOR[dimnames(lc)$REF_SECTOR=='S125_S126_S127'] = dimnames(lct)$REF_SECTOR[dimnames(lct)$REF_SECTOR=='S125_S126_S127'] = 'S12O'

# Financial instrument mappings
dimnames(lc)$INSTR[dimnames(lc)$INSTR=='F63_F64_F65'] = dimnames(lct)$INSTR[dimnames(lct)$INSTR=='F63_F64_F65'] = 'F6M'
dimnames(lc)$INSTR[dimnames(lc)$INSTR=='F31'] = dimnames(lct)$INSTR[dimnames(lct)$INSTR=='F31'] = 'F3S'
dimnames(lc)$INSTR[dimnames(lc)$INSTR=='F32'] = dimnames(lct)$INSTR[dimnames(lct)$INSTR=='F32'] = 'F3L'
dimnames(lc)$INSTR[dimnames(lc)$INSTR=='F41'] = dimnames(lct)$INSTR[dimnames(lct)$INSTR=='F41'] = 'F4S'
dimnames(lc)$INSTR[dimnames(lc)$INSTR=='F42'] = dimnames(lct)$INSTR[dimnames(lct)$INSTR=='F42'] = 'F4L'


#### sums now:
lc[.F51M..]<-lc[.F512..]+lc[.F519..]
lc[.F2M..]<-lc[.F22..]+lc[.F29..]
lc[.F6N..]<-lc[.F62..]+lc[.F6M..]

lct[.F51M..]<-lct[.F512..]+lct[.F519..]
lct[.F2M..]<-lct[.F22..]+lct[.F29..]
lct[.F6N..]<-lct[.F62..]+lct[.F6M..]



### quarterly
lc_q=copy(lc); frequency(lc_q)='Q'
lct_q=copy(lct); frequency(lct_q)='Q'


####EA18=EA19=EA20
lc_q["EA18..."]=lc_q["EA19..."]<-lc_q["EA20..."]
lct_q["EA18..."]=lct_q["EA19..."]<-lct_q["EA20..."]

intra_stock_assets <- la_q-lc_q
# la_q[AT.F3.S12T.2022q4]
# lc_q[AT.F3.S12T.2022q4]
# intra_stock_assets[AT.F3.S12T.2022q4]


dim_sa=dimnames(intra_stock_assets)
sa_sectors<-dim_sa[["REF_SECTOR"]]

stock_assets<-intra_stock_assets
temp=add.dim(stock_assets, .dimname = 'COUNTERPART_SECTOR', .dimcodes = c(sa_sectors), .fillall = FALSE)
temp[S1....]<-NA
temp[S1...S1.]<-intra_stock_assets[..S1.]
temp[S11...S11.]<-intra_stock_assets[..S11.]
temp[S12...S12.] <- intra_stock_assets[..S12.]
temp[S121...S121.] <- intra_stock_assets[..S121.]
temp[S12K...S12K.] <- intra_stock_assets[..S12K.]
temp[S122...S122.] <- intra_stock_assets[..S122.]
temp[S12T...S12T.] <- intra_stock_assets[..S12T.]
temp[S123...S123.] <- intra_stock_assets[..S123.]
temp[S124...S124.] <- intra_stock_assets[..S124.]
temp[S125...S125.] <- intra_stock_assets[..S125.]
temp[S12O...S12O.] <- intra_stock_assets[..S12O.]
temp[S126...S126.] <- intra_stock_assets[..S126.]
temp[S127...S127.] <- intra_stock_assets[..S127.]
temp[S128...S128.] <- intra_stock_assets[..S128.]
temp[S12Q...S12Q.] <- intra_stock_assets[..S12Q.]
temp[S129...S129.] <- intra_stock_assets[..S129.]
temp[S13...S13.] <- intra_stock_assets[..S13.]
temp[S14...S14.] <- intra_stock_assets[..S14.]
temp[S1M...S1M.] <- intra_stock_assets[..S1M.]
temp[S15...S15.] <- intra_stock_assets[..S15.]
temp[S2...S2.] <- intra_stock_assets[..S2.]
temp[S21...S21.] <- intra_stock_assets[..S21.]
temp[S2I...S2I.] <- intra_stock_assets[..S2I.]
intra_stock_assets<-temp

gc()
intra_flows_assets <- lat_q-lct_q
dim_fa=dimnames(intra_flows_assets)
fa_sectors<-dim_fa[["REF_SECTOR"]]
flows_assets<-intra_flows_assets
temp=add.dim(flows_assets, .dimname = 'COUNTERPART_SECTOR', .dimcodes = c(fa_sectors), .fillall = FALSE)
temp[S1....]<-NA
temp[S1...S1.]<-intra_flows_assets[..S1.]
temp[S11...S11.]<-intra_flows_assets[..S11.]
temp[S12...S12.] <- intra_flows_assets[..S12.]
temp[S121...S121.] <- intra_flows_assets[..S121.]
temp[S12K...S12K.] <- intra_flows_assets[..S12K.]
temp[S122...S122.] <- intra_flows_assets[..S122.]
temp[S12T...S12T.] <- intra_flows_assets[..S12T.]
temp[S123...S123.] <- intra_flows_assets[..S123.]
temp[S124...S124.] <- intra_flows_assets[..S124.]
temp[S125...S125.] <- intra_flows_assets[..S125.]
temp[S12O...S12O.] <- intra_flows_assets[..S12O.]
temp[S126...S126.] <- intra_flows_assets[..S126.]
temp[S127...S127.] <- intra_flows_assets[..S127.]
temp[S128...S128.] <- intra_flows_assets[..S128.]
temp[S12Q...S12Q.] <- intra_flows_assets[..S12Q.]
temp[S129...S129.] <- intra_flows_assets[..S129.]
temp[S13...S13.] <- intra_flows_assets[..S13.]
temp[S14...S14.] <- intra_flows_assets[..S14.]
temp[S1M...S1M.] <- intra_flows_assets[..S1M.]
temp[S15...S15.] <- intra_flows_assets[..S15.]
temp[S2...S2.] <- intra_flows_assets[..S2.]
intra_flows_assets<-temp

gc()

aall[....LE._T.,onlyna=TRUE]<-intra_stock_assets["....1999q4:"]
aall[....F._T.,onlyna=TRUE]<-intra_flows_assets["....1999q4:"]


saveRDS(aall, 'data/intermediate_domestic_data_files/aall_NASA_intrasector.rds')
