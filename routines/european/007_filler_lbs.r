library(MDstats); library(MD3); library(data.table)

# Set data directory
if (!exists("data_dir")) data_dir = '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/data/'

source('V:/FinFlows/githubrepo/finflows/routines/utilities.R')
gc()

## Load data
alllbs <- readRDS(file.path(data_dir,'lbsbuffer/alllbs.rds'))

alllbs <- do.call(rbind,alllbs)


alllbs <- as.md3(alllbs,
                 id.vars=c("L_MEASURE", "L_POSITION", "L_INSTR", "L_DENOM", "L_CURR_TYPE", "L_PARENT_CTY", "L_REP_BANK_TYPE", 
                                  "L_REP_CTY", "L_CP_SECTOR", "L_CP_COUNTRY", "L_POS_TYPE", "TIME"),
                 obsattr=c("_.obs_status","_.obs_conf","_.obs_pre_break"))

alllbs <- alllbs["..........."]

# Dimensions (11 excl TIME):
# L_POSITION (Claim/Liability), L_INSTR, L_REP_CTY, L_CP_SECTOR, L_CP_COUNTRY, L_POS_TYPE (All, Cross-border, Local)

## Exchange rate conversion

exr <- mds('ECB/EXR/Q.USD.EUR.SP00.E')

alllbs <- alllbs/exr

## USD millions, so dont need to change order of magnitude

# dim(alllbs)
# alllbs["C.A.AT.A.US.N.2024q4"] # Austrian MFI claims (assets) vs. US (S1), should be 10964 EUR


## Data manipulation

# Rename dimensions

nms <- names(dimnames(alllbs))
nms[nms == "L_POSITION"] <- "POS"
nms[nms == "L_INSTR"] <- "INSTR"
nms[nms == "L_REP_CTY"] <- "REF_AREA"
nms[nms == "L_CP_COUNTRY"] <- "COUNTERPART_AREA"
nms[nms == "L_CP_SECTOR"] <- "COUNTERPART_SECTOR"
names(dimnames(alllbs)) <- nms

# Recode instruments 
map_instr <- c("A" = "F", "B" = "F3_F4", "D" = "F3",
               "G" = "F2M_F4", "M" = "F3S", "I" = "F7_F89")

alllbs$INSTR <- map_instr[alllbs$INSTR]

# Rename sectors 

map_sector <- c("A" = "S1", "B" = "S12K", "C" = "S11",
               "F" = "S12_ext_S12K", "G" = "S13", "H" = "S1M",
               "M" = "S121")

## alllbs["C.F.US.A+B+F+M+P+I.5J..2022q4"]
# S12 = B + F =  A - P (non-bank)
# I ( Banks related offices) and M (CB) seem like subsets of  B, but something missing
# So probably S12K = B = M + I + "Banks: unrelated offices", but latter not present
# Challenge: how to get S12T from these, perhaps cant 

alllbs$COUNTERPART_SECTOR <- map_sector[alllbs$COUNTERPART_SECTOR]

## Change country codes - Already iso2 seemingly, only relevant aggregates should be renamed
#  Relevant: 5C (EA), 5J (W0), 

 dimnames(alllbs)$COUNTERPART_AREA[
   dimnames(alllbs)$COUNTERPART_AREA == '5C'] <- 'EA20'
 
 dimnames(alllbs)$COUNTERPART_AREA[
   dimnames(alllbs)$COUNTERPART_AREA == '5J'] <- 'W0'
 
 dimnames(alllbs)$REF_AREA[
   dimnames(alllbs)$REF_AREA == '5C'] <- 'EA20'

## Rename Claims to Assets to avoid confusion
 
dimnames(alllbs)$POS[
  dimnames(alllbs)$POS == 'C'] <- 'A'
 

### Start matrix calculations 
# Financial sector is Banks + non-Bank Financial Sector 
alllbs["...S12..."] <- alllbs["...S12K..."] + alllbs["...S12_ext_S12K..."]





## Export 
saveRDS(alllbs, file.path(data_dir,"aall_lbs.rds"))

dim(alllbs)
