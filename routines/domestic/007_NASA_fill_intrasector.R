# Load required packages
library(MDstats)
library(MD3)

# Set data directory
if (!exists("data_dir")) data_dir = getwd()

# Load consolidated data
lc = readRDS(file.path(data_dir, "domestic_loading_data_files/nasa_consolidated_stocks_assets.rds"))
lct = readRDS(file.path(data_dir, "domestic_loading_data_files/nasa_consolidated_flows_assets.rds"))
aall=readRDS(file.path(data_dir, "intermediate_domestic_data_files/aall_NASA_S0.rds"))

# Load processed quarterly data
la_q= readRDS(file.path(data_dir, 'intermediate_domestic_data_files/la_q.rds'))
lat_q= readRDS(file.path(data_dir, 'intermediate_domestic_data_files/lat_q.rds'))
lal_q= readRDS(file.path(data_dir, 'intermediate_domestic_data_files/lal_q.rds'))
lall_q= readRDS(file.path(data_dir, 'intermediate_domestic_data_files/latl_q.rds'))

### PROCESS CONSOLIDATED DATA (NO NEED FOR LIABILITIES AS WE ARE LOOKING AT INTRASECTOR WHERE ASSETS==LIABILITIES!)

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

# Calculate intrasector stocks and flows (unconsolidated - consolidated)
intra_stock_assets <- la_q-lc_q
intra_flows_assets <- lat_q-lct_q

# Get sector dimensions
dim_sa=dimnames(intra_stock_assets)
sa_sectors<-dim_sa[["REF_SECTOR"]]

# Process stock assets
stock_assets<-intra_stock_assets
temp=add.dim(stock_assets, .dimname = 'COUNTERPART_SECTOR', .dimcodes = c(sa_sectors), .fillall = FALSE)
temp[S1....]<-NA

# Apply the same logic to all sectors in the list
sectors_list <- c('S1', 'S11', 'S12', 'S121', 'S12K', 'S122', 'S12T', 'S123', 'S124', 'S125', 'S12O', 'S126', 'S127', 'S128', 'S12Q', 'S129', 'S13', 'S14', 'S1M', 'S15', 'S2', 'S21', 'S2I')

for (sector in sectors_list) {
  temp[paste0(sector, '...', sector, '.')] <- intra_stock_assets[paste0('..', sector, '.')]
}

intra_stock_assets<-temp
gc()

# Process flows assets
dim_fa=dimnames(intra_flows_assets)
fa_sectors<-dim_fa[["REF_SECTOR"]]
flows_assets<-intra_flows_assets
temp=add.dim(flows_assets, .dimname = 'COUNTERPART_SECTOR', .dimcodes = c(fa_sectors), .fillall = FALSE)
temp[S1....]<-NA

for (sector in sectors_list) {
  if (sector %in% fa_sectors) {
    temp[paste0(sector, '...', sector, '.')] <- intra_flows_assets[paste0('..', sector, '.')]
  }
}

intra_flows_assets<-temp
gc()

# Fill aall with intrasector data
aall[....LE._T.,onlyna=TRUE]<-intra_stock_assets["....1999q4:"]
aall[....F._T.,onlyna=TRUE]<-intra_flows_assets["....1999q4:"]

saveRDS(aall, file.path(data_dir, 'intermediate_domestic_data_files/aall_NASA_intrasector.rds'))