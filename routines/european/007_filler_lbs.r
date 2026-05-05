library(MDstats)
library(MD3)
library(data.table)

# Set data directory
if (!exists("data_dir")) data_dir = '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/data/'

source('V:/FinFlows/githubrepo/finflows/routines/utilities.R')
gc()


## Load by asset/liabilites split
aa=readRDS(file.path(data_dir,'aa_iip_fdi.rds')); gc()
ll=readRDS(file.path(data_dir,'ll_iip_fdi.rds')); gc()

## Load BIS LBS data (both Assets and Liabilites)
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
map_instr <- c("A" = "F", "B" = "F2_F3_F4","D" = "F3",
               "G" = "F2_F4", "M" = "F3S", "I" = "F7_F89")

dimnames(alllbs)$INSTR <- map_instr[dimnames(alllbs)$INSTR]

# Rename sectors 

## Check to see distribution - alllbs["C.F.US.A+B+F+M+P+I.5J..2022q4"]
# S12 = B + F =  A - P (non-bank)
# I ( Banks,related offices) and M (Banks, CB) seem like subsets of  B, but something missing
# So probably S12K = B = M + I + "Banks, unrelated offices", but latter not present
# Challenge: how to get S12T from these, perhaps cant 

# drop irrelevant sectors
alllbs <- alllbs["...A+B+C+F+G+H+M+N..."]

map_sector <- c("A" = "S1", "B" = "S12K", "C" = "S11",
                "F" = "S12_ext_S12K", "G" = "S13", "H" = "S1M",
                "M" = "S121", "N" = "S1_ext_S12K")

dimnames(alllbs)$COUNTERPART_SECTOR <- map_sector[dimnames(alllbs)$COUNTERPART_SECTOR]

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
 

## Compute S12 and S12T 
alllbs["...S12..."] <- NA
alllbs["...S12..."] <- alllbs["...S12K..."] + alllbs["...S12_ext_S12K..."]
alllbs["...S12T..."] <- NA
alllbs["...S12T..."] <- alllbs["...S12K..."] - alllbs["...S121..."]


## Calculate remaining instruments 
alllbs[".F3L....."] <- NA
alllbs[".F3L....."] <- alllbs[".F3....."] - alllbs[".F3S....."]

# alllbs[".F2M_F4+F+F3+F3_F4.5A.S1.HU.N.2022q4"]
# Remember that F2+F4
# Assume that all loans are held against "non-banks"
alllbs["A.F4..S1..."] <- NA
alllbs["A.F4..S1..."] <- alllbs["A.F2_F4..S1_ext_S12K..."]
alllbs["A.F2..S1..."] <- NA
alllbs["A.F2..S1..."] <- alllbs["A.F2_F4..S1..."] - alllbs["A.F4..S1..."]
# Assume that banks don't hold any loans on the liability side (only deposits)
alllbs["L.F2..S1..."] <- NA
alllbs["L.F2..S1..."] <- alllbs["L.F2_F4..S1..."]

## Calculate other sectors as such too!!

### Start filling (only _O=_T in this case)

aa["..S12K..LE._O..W0", usenames=TRUE, onlyna=TRUE] <- alllbs["A...S1_ext_S12K..A.1998q4:"]
aa["..S12K..LE._T..W0", usenames=TRUE, onlyna=TRUE] <- alllbs["A...S1_ext_S12K..A.1998q4:"]
aa["..S12K..LE._O..W2", usenames=TRUE, onlyna=TRUE] <- alllbs["A...S1_ext_S12K..R.1998q4:"]
aa["..S12K..LE._T..W2", usenames=TRUE, onlyna=TRUE] <- alllbs["A...S1_ext_S12K..R.1998q4:"]

# Create list of cross-border counterpart areas
all_ca <- dimnames(alllbs)$COUNTERPART_AREA
ca_vec <- all_ca[!all_ca %in% c("W0", "W2")]
ca_string <- paste(ca_vec, collapse = "+")

aa[paste("..S12K..LE._O..",ca_string), usenames=TRUE, onlyna=TRUE] <- alllbs["A...S1_ext_S12K..N.1998q4:"]
aa[paste("..S12K..LE._T..",ca_string), usenames=TRUE, onlyna=TRUE] <- alllbs["A...S1_ext_S12K..N.1998q4:"]

# do the same for liabilities

ll[".W0..S12K.LE._O..", usenames=TRUE, onlyna=TRUE] <- alllbs["L...S1_ext_S12K..A.1998q4:"]
ll[".W0..S12K.LE._T..", usenames=TRUE, onlyna=TRUE] <- alllbs["L...S1_ext_S12K..A.1998q4:"]
ll[".W2..S12K.LE._O..", usenames=TRUE, onlyna=TRUE] <- alllbs["L...S1_ext_S12K..R.1998q4:"]
ll[".W2..S12K.LE._T..", usenames=TRUE, onlyna=TRUE] <- alllbs["L...S1_ext_S12K..R.1998q4:"]
ll[paste(ca_string,"...S12K.LE._O.."), usenames=TRUE, onlyna=TRUE] <- alllbs["L...S1_ext_S12K..N.1998q4:"]
ll[paste(ca_string,"...S12K.LE._T.."), usenames=TRUE, onlyna=TRUE] <- alllbs["L...S1_ext_S12K..N.1998q4:"]

## Export 
gc()
saveRDS(aa,file.path(data_dir,'aa_iip_lbs.rds'))
saveRDS(ll,file.path(data_dir,'ll_iip_lbs.rds'))

saveRDS(aa,file.path(data_dir,'vintages/aa_iip_lbs_' %&% format(Sys.time(),'%F') %&% '_.rds'))
saveRDS(ll,file.path(data_dir,'vintages/ll_iip_lbs_' %&% format(Sys.time(),'%F') %&% '_.rds'))

