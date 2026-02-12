# Load required packages
library(MDstats)
library(MD3)

# Set data directory
if (!exists("data_dir")) data_dir = getwd()

aall=readRDS(file.path(data_dir, 'intermediate_domestic_data_files/aall_NASQ.rds'))
setkey(aall, NULL)

# Load unconsolidated data
la = readRDS(file.path(data_dir, "domestic_loading_data_files/nasa_unconsolidated_stocks_assets.rds"))
lat = readRDS(file.path(data_dir, "domestic_loading_data_files/nasa_unconsolidated_flows_assets.rds"))
la_l = readRDS(file.path(data_dir, "domestic_loading_data_files/nasa_unconsolidated_stocks_LIAB.rds"))
lat_l = readRDS(file.path(data_dir, "domestic_loading_data_files/nasa_unconsolidated_flows_LIAB.rds"))

names(dimnames(la))[[1]] = names(dimnames(lat))[[1]] = names(dimnames(la_l))[[1]] = names(dimnames(lat_l))[[1]] = 'REF_AREA'
names(dimnames(la))[[2]] = names(dimnames(lat))[[2]] = names(dimnames(la_l))[[2]] = names(dimnames(lat_l))[[2]] = 'INSTR'
names(dimnames(la))[[3]] = names(dimnames(lat))[[3]] = 'REF_SECTOR'
names(dimnames(la_l))[[3]] = names(dimnames(lat_l))[[3]] = 'COUNTERPART_SECTOR'

####### RENAME SECTORS AND INSTRUMENTS!

# Sector mappings
dimnames(la)$REF_SECTOR[dimnames(la)$REF_SECTOR=='S14_S15'] = dimnames(la_l)$COUNTERPART_SECTOR[dimnames(la_l)$COUNTERPART_SECTOR=='S14_S15'] = dimnames(lat_l)$COUNTERPART_SECTOR[dimnames(lat_l)$COUNTERPART_SECTOR=='S14_S15'] = dimnames(lat)$REF_SECTOR[dimnames(lat)$REF_SECTOR=='S14_S15'] = 'S1M'
dimnames(la)$REF_SECTOR[dimnames(la)$REF_SECTOR=='S121_S122_S123'] = dimnames(la_l)$COUNTERPART_SECTOR[dimnames(la_l)$COUNTERPART_SECTOR=='S121_S122_S123'] = dimnames(lat_l)$COUNTERPART_SECTOR[dimnames(lat_l)$COUNTERPART_SECTOR=='S121_S122_S123'] = dimnames(lat)$REF_SECTOR[dimnames(lat)$REF_SECTOR=='S121_S122_S123'] = 'S12K'
dimnames(la)$REF_SECTOR[dimnames(la)$REF_SECTOR=='S122_S123'] = dimnames(la_l)$COUNTERPART_SECTOR[dimnames(la_l)$COUNTERPART_SECTOR=='S122_S123'] = dimnames(lat_l)$COUNTERPART_SECTOR[dimnames(lat_l)$COUNTERPART_SECTOR=='S122_S123'] = dimnames(lat)$REF_SECTOR[dimnames(lat)$REF_SECTOR=='S122_S123'] = 'S12T'
dimnames(la)$REF_SECTOR[dimnames(la)$REF_SECTOR=='S128_S129'] = dimnames(la_l)$COUNTERPART_SECTOR[dimnames(la_l)$COUNTERPART_SECTOR=='S128_S129'] = dimnames(lat_l)$COUNTERPART_SECTOR[dimnames(lat_l)$COUNTERPART_SECTOR=='S128_S129'] = dimnames(lat)$REF_SECTOR[dimnames(lat)$REF_SECTOR=='S128_S129'] = 'S12Q'
dimnames(la)$REF_SECTOR[dimnames(la)$REF_SECTOR=='S125_S126_S127'] = dimnames(la_l)$COUNTERPART_SECTOR[dimnames(la_l)$COUNTERPART_SECTOR=='S125_S126_S127'] = dimnames(lat_l)$COUNTERPART_SECTOR[dimnames(lat_l)$COUNTERPART_SECTOR=='S125_S126_S127'] = dimnames(lat)$REF_SECTOR[dimnames(lat)$REF_SECTOR=='S125_S126_S127'] = 'S12O'

# Financial instrument mappings
dimnames(la)$INSTR[dimnames(la)$INSTR=='F63_F64_F65'] = dimnames(la_l)$INSTR[dimnames(la_l)$INSTR=='F63_F64_F65'] = dimnames(lat_l)$INSTR[dimnames(lat_l)$INSTR=='F63_F64_F65'] = dimnames(lat)$INSTR[dimnames(lat)$INSTR=='F63_F64_F65'] = 'F6M'
dimnames(la)$INSTR[dimnames(la)$INSTR=='F31'] = dimnames(la_l)$INSTR[dimnames(la_l)$INSTR=='F31'] = dimnames(lat_l)$INSTR[dimnames(lat_l)$INSTR=='F31'] = dimnames(lat)$INSTR[dimnames(lat)$INSTR=='F31'] = 'F3S'
dimnames(la)$INSTR[dimnames(la)$INSTR=='F32'] = dimnames(la_l)$INSTR[dimnames(la_l)$INSTR=='F32'] = dimnames(lat_l)$INSTR[dimnames(lat_l)$INSTR=='F32'] = dimnames(lat)$INSTR[dimnames(lat)$INSTR=='F32'] = 'F3L'
dimnames(la)$INSTR[dimnames(la)$INSTR=='F41'] = dimnames(la_l)$INSTR[dimnames(la_l)$INSTR=='F41'] = dimnames(lat_l)$INSTR[dimnames(lat_l)$INSTR=='F41'] = dimnames(lat)$INSTR[dimnames(lat)$INSTR=='F41'] = 'F4S'
dimnames(la)$INSTR[dimnames(la)$INSTR=='F42'] = dimnames(la_l)$INSTR[dimnames(la_l)$INSTR=='F42'] = dimnames(lat_l)$INSTR[dimnames(lat_l)$INSTR=='F42'] = dimnames(lat)$INSTR[dimnames(lat)$INSTR=='F42'] = 'F4L'

#### sums now:
la[.F51M..]<-la[.F512..]+la[.F519..]
la[.F2M..]<-la[.F22..]+la[.F29..]
la[.F6N..]<-la[.F62..]+la[.F6M..]

lat[.F51M..]<-lat[.F512..]+lat[.F519..]
lat[.F2M..]<-lat[.F22..]+lat[.F29..]
lat[.F6N..]<-lat[.F62..]+lat[.F6M..]

la_l[.F51M..]<-la_l[.F512..]+la_l[.F519..]
la_l[.F2M..]<-la_l[.F22..]+la_l[.F29..]
la_l[.F6N..]<-la_l[.F62..]+la_l[.F6M..]

lat_l[.F51M..]<-lat_l[.F512..]+lat_l[.F519..]
lat_l[.F2M..]<-lat_l[.F22..]+lat_l[.F29..]
lat_l[.F6N..]<-lat_l[.F62..]+lat_l[.F6M..]

### quarterly
la_q=copy(la); frequency(la_q)='Q'
lat_q=copy(lat); frequency(lat_q)='Q'
lal_q=copy(la_l); frequency(lal_q)='Q'
latl_q=copy(lat_l); frequency(latl_q)='Q'

####EA18=EA19=EA20
la_q["EA18..."]=la_q["EA19..."]<-la_q["EA20..."]
lat_q["EA18..."]=lat_q["EA19..."]<-lat_q["EA20..."]
lal_q["EA18..."]=lal_q["EA19..."]<-lal_q["EA20..."]
latl_q["EA18..."]=latl_q["EA19..."]<-latl_q["EA20..."]

aall[...S0.LE._T., onlyna=TRUE] <- la_q["...1999q4:"]
aall[...S0.F._T., onlyna=TRUE] <- lat_q["...1999q4:"]
aall[..S0..LE._T., onlyna=TRUE] <- lal_q["...1999q4:"]
aall[..S0..F._T., onlyna=TRUE] <- latl_q["...1999q4:"]

saveRDS(aall, file.path(data_dir, 'intermediate_domestic_data_files/aall_NASA_S0.rds'))
saveRDS(la_q, file.path(data_dir, 'intermediate_domestic_data_files/la_q.rds'))
saveRDS(lat_q, file.path(data_dir, 'intermediate_domestic_data_files/lat_q.rds'))
saveRDS(lal_q, file.path(data_dir, 'intermediate_domestic_data_files/lal_q.rds'))
saveRDS(latl_q, file.path(data_dir, 'intermediate_domestic_data_files/latl_q.rds'))
