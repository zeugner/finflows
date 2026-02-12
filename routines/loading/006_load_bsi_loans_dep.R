# ==============================================================================
# 006_load_bsi_loans_dep.R
# Consolidated loading of BSI loans (A20) and deposits (L20) data
# Broad download (all counterpart areas, all maturities A+F+K)
# Loading both domestic and cross-border
# Country-code harmonisation applied to domestic subset only
# ==============================================================================

# Load required packages
library(MDstats)
library(MD3)

# Set data directory
if (!exists("data_dir")) data_dir = getwd()

#### BSI LOADING OF BILATERAL LOANS AND DEPOSITS. S12T IS THE REFERENCE SECTOR

# ==============================================================================
# DOWNLOAD: quarterly and monthly (separating Q and M because of widely
# different elements that are filled)
# ==============================================================================

bbsirawq=mds('ECB/BSI/Q..N.A.A20+L20.A+F+K.1+4...Z01.E',labels=TRUE, ccode = NULL)
bbsirawm=mds('ECB/BSI/M..N.A.A20+L20.A+F+K.1+4...Z01.E',labels=FALSE, ccode = NULL)

gc()

# Aggregate monthly to quarterly
bbsiraw=aggregate(bbsirawm,'Q',FUN = end)

gc()

# ==============================================================================
# PROCESSING: merge quarterly into monthly, enrich labels, apply dictionary
# ==============================================================================

# Sector dictionary (BSI numeric codes -> ESA2010 sector codes)
dictbsisec= c('2260'='S124','0000'='S1','1000'='S12K','2220'='S12Q','2270'='S12O',
              '2100'='S13','2240'='S11','1100'='S121','1210'='S122',
              '2221'='S128','2222'='S129','2250'='S1M','2271'='S125A')

bbsiraw=copy(bbsiraw)

# Merge quarterly observations into the monthly-aggregated base
suppressWarnings(bbsiraw[usenames=TRUE] <- bbsirawq)

# Enrich dimension labels
for (i in setdiff(names(dimnames(bbsiraw)),'TIME')) {
  dimcodes(bbsiraw)[[i]][,'label:en'] = helpmds('ECB/BSI',dim=i,verbose = FALSE)[dimnames(bbsiraw)[[i]],'label:en']
}
dimcodes(bbsiraw)[['BS_COUNT_SECTOR']]['2270','label:en'] = 'OFIs (sum of S.125, S.126, S.127)'

# Rename dimensions
bbsi=copy(bbsiraw)
names(dimnames(bbsi))[[2]] = 'INSTR'
names(dimnames(bbsi))[[3]] = 'MATURITY'
names(dimnames(bbsi))[[4]] = 'STO'
names(dimnames(bbsi))[[5]] = 'COUNTERPART_AREA'
names(dimnames(bbsi))[[6]] = 'COUNTERPART_SECTOR'

# Apply sector dictionary: subset to dictionary sectors and rename codes
bbsi=bbsi[,,,,,names(dictbsisec),]
dimnames(bbsi)[[6]] = dictbsisec[dimnames(bbsi)[[6]]]

# Save full object before STO renaming
saveRDS(bbsi, file.path(data_dir, 'bbsi.rds'))

# Rename STO codes: 1 -> LE (stocks), 4 -> F (flows)
sto_values <- dimnames(bbsi)[["STO"]]
new_values <- sto_values
names(new_values) <- sto_values
if ("1" %in% sto_values) new_values["1"] <- "LE"
if ("4" %in% sto_values) new_values["4"] <- "F"
dimnames(bbsi)[["STO"]] <- new_values

# Save full object with STO renamed
saveRDS(bbsi, file.path(data_dir, 'bsi_loans_deposits.rds'))

# ==============================================================================
# SPLIT: loans (A20) and deposits (L20) for cross-border filling
# No country-code harmonisation (done in filler_bsi.R)
# ==============================================================================

basbsi=bbsi[.A20.....]
blibsi=bbsi[.L20.....]
names(dimnames(blibsi))[[5]] = 'REF_SECTOR'

saveRDS(basbsi, file.path(data_dir, 'bsi_loans.rds'))
saveRDS(blibsi, file.path(data_dir, 'bsi_deposits.rds'))

# ==============================================================================
# DOMESTIC SUBSET: bsi_loans_dep for domestic filling (009_BSI_F4_F2M_FILL.R)
# Filtered to U6 (domestic counterpart area)
# With country-code harmonisation and EA backfilling
# ==============================================================================

bsi_loans_dep=copy(bbsi)

# Filter to domestic counterpart area
bsi_loans_dep=bsi_loans_dep[....U6..]

# Country-code harmonisation
dimnames(bsi_loans_dep)$REF_AREA[dimnames(bsi_loans_dep)$REF_AREA=='GB'] = 'UK'
dimnames(bsi_loans_dep)$REF_AREA[dimnames(bsi_loans_dep)$REF_AREA=='GR'] = 'EL'
dimnames(bsi_loans_dep)$REF_AREA[dimnames(bsi_loans_dep)$REF_AREA=='U2'] = 'EA20'

# EA backfilling
bsi_loans_dep['EA19..... ']<- bsi_loans_dep['EA20..... ']
bsi_loans_dep['EA18..... ']<- bsi_loans_dep['EA20..... ']

# Filter to sectors used by domestic filler
bsi_loans_dep = bsi_loans_dep[....S12K+S121+S125A+S122+S13+S12Q+S11+S1M.]

saveRDS(bsi_loans_dep, file.path(data_dir, 'bsi_loans_dep.rds'))

gc()
