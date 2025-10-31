library(MDstats); library(MD3)

# Set data directory
#data_dir= file.path(getwd(),'data')
if (!exists("data_dir")) data_dir = '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/data/'

source('\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/routines/utilities.R')

gc()

## load filled iip bop
aa=readRDS(file.path(data_dir,'aa_iip_shss.rds')); gc()
ll=readRDS(file.path(data_dir,'ll_iip_shss.rds')); gc()
gc()

## load cpis raw data and create a new MD3 object "cpis"
cpisraw=readRDS("V:/FinFlows/githubrepo/finflows/data/cpisbuffer/allcresultslist.rds"); gc()
whatctries=readRDS('V:/FinFlows/githubrepo/finflows/data/cpisbuffer/whatctries.rds')
ccc=dimcodes(whatctries)[[1]]
AREA=ccc[,1]
gc()
str(cpisraw$CP)

## starting point DE
cpis=cpisraw$INV$DE["DE....."]

cpissmall = copy(cpis)
gc()
cpis1=add.dim(cpissmall, .dimname = 'REF_AREA', .dimcodes = 'DE', .fillall = FALSE)
cpis=add.dim(cpis1, .dimname = 'COUNTERPART_SECTOR', .dimcodes = 'T', .fillall = FALSE)
gc()

cpis=aperm(copy(cpis), c(2:4,1,5:6)); gc()
dim(cpis)

cpis['AT',,,,,]=cpisraw$INV$AT["AT....."]
#cpisraw$INV$AT["AT.I_A_E_T_T_BP6_USD.T.T.US.2023+2023s1+2023s2"]
#cpis["AT.I_A_E_T_T_BP6_USD.T.T.US.2023+2023s1+2023s2"]

#############################################################################
####### new MD3 object 'cpis' filled ####### 
#############################################################################

#filling the subsectors of the reporting sectors vis a vis total coutner part area
for (cty in AREA) {
    if (length(cpisraw$INV[[cty]])) {
      cpis[cty, , , , , ] <- cpisraw$INV[[cty]][cty,,,,, usenames=TRUE]
       }
}

#cpis[DE.I_A_D_T_T_BP6_USD...US.2023]

#filling the subsectors of the counterpart area vis a vis total reporting area
#tempcpis=cpis
for (cty in AREA) 
{cpis[cty, ,'T', , , , usenames=TRUE, onlyna=TRUE] <- cpisraw$CP[[cty]][cty,,'T',,,] 
  }

#cpis[DE.I_A_D_T_T_BP6_USD...US.2023]
str(cpis)


saveRDSvl(cpis,file='data/cpis_temp_first.rds'); gc()

saveRDS(cpis,file='data/cpis_temp_first.rds'); gc()

#saveRDSvl(cpis,file='data/cpis_temp_' %&% Sys.timo() %&% '.rds'); gc()
#cpis=readRDS(file.path(data_dir,'cpis_temp_first.rds')); gc()

#############################################################################
#######      adjust the data set     ####### 
#############################################################################

#cpis["DE.I_A_D_T_T_BP6_USD.T.T.US.2023:"]
##transformation into EUR
exra=mds('ECB/EXR/A.USD.EUR.SP00.E')
exrs=mds('ECB/EXR/Q.USD.EUR.SP00.E')
exrs=aggregate(exrs,'S',FUN=end)
exr=merge(exra,exrs)
cpis=cpis/exr
#cpis["DE.I_A_D_T_T_BP6_USD.T.T.US.2023:"]


saveRDSvl(cpis,file='data/cpis_temp_exr.rds'); gc()

saveRDS(cpis,file='data/cpis_temp_exr.rds'); gc()

#############################################################################
# --- transformation into MEUR
#############################################################################

dcpis=as.data.table(cpis,.simple=TRUE,na.rm=TRUE)
dcpis[, obs_value := round((obs_value / 1e6), digits=2)]
cpis=as.md3(dcpis); rm(dcpis)
gc()
#cpis["DE.I_A_D_T_T_BP6_USD.T.T.US.2023:"]

saveRDSvl(cpis,file='data/cpis_temp_MEUR.rds'); gc()

saveRDS(cpis,file='data/cpis_temp_MEUR.rds'); gc()

#############################################################################
# --- adjust $INDICATOR to financial instrument 
#############################################################################

names(dimnames(cpis))[2] = 'INSTR'
#cpis[DE.I_A_D_T_T_BP6_USD...US.2023]

dimnames(cpis)$INSTR[dimnames(cpis)$INSTR=='I_A_E_T_T_BP6_USD'] = 'F5'
dimnames(cpis)$INSTR[dimnames(cpis)$INSTR=='I_A_D_T_T_BP6_USD'] = 'F3'
dimnames(cpis)$INSTR[dimnames(cpis)$INSTR=='I_A_D_S_T_BP6_USD'] = 'F3S'
dimnames(cpis)$INSTR[dimnames(cpis)$INSTR=='I_A_D_L_T_BP6_USD'] = 'F3L'

gc()
cpis["DE.F3.T.T.US.y2023:"]

#############################################################################
# --- adjust $COUNTERPART_SECTOR + REF_SECTOR 
#############################################################################

map_sector <- c(
  "T"   = "S1",
  "CB"  = "S121",
  "DC"  = "S122",
  "FC"  = "S12",
  "NFC" = "S11",
  "GG"  = "S13",
  "HH"  = "S14",
  "IPF" = "S12Q",
  "MMF" = "S123",
  "NHN" = "S1P",
  "NP"  = "S15",
  "ODX" = "S12T",
  "OFI" = "S128",
  "OFM" = "S124",
  "OFT" = "S12other",
  "OFX" = "S12X",
  "OFO" = "S12Rest")

dimnames(cpis)$REF_SECTOR <- ifelse(
  dimnames(cpis)$REF_SECTOR %in% names(map_sector),
  map_sector[dimnames(cpis)$REF_SECTOR],
  dimnames(cpis)$REF_SECTOR)

dimnames(cpis)$COUNTERPART_SECTOR <- ifelse(
  dimnames(cpis)$COUNTERPART_SECTOR %in% names(map_sector),
  map_sector[dimnames(cpis)$COUNTERPART_SECTOR],
  dimnames(cpis)$COUNTERPART_SECTOR)

gc()

cpis["DE.F3.S1.S1.US.y2023:"]

saveRDSvl(cpis,file='data/cpis_temp_adj.rds'); gc()

saveRDS(cpis,file='data/cpis_temp_adj.rds'); gc()
#cpis=readRDS(file.path(data_dir,'cpis_temp_adj.rds')); gc()

#############################################################################
# -- includes annual data (2023) and bi-annual data (2023s1, 2023s2)
# -- use s2, otherwise annual; change s1 to q2
#############################################################################
rm(Acpis);rm(Qcpis);rm(Scpis);gc()
# adjusting the frequency to Q
frequency(cpis)
Acpis=cpis[A......]
Scpis=cpis[S......]
frequency(Acpis)=frequency(Scpis)='Q'
Scpis[onlyna=TRUE]=Acpis ;gc()
str(Scpis)

cpis=Scpis[".....2001q4:"]; gc()
dimnames(cpis)

cpis["DE.F3.S1.S1.US."] 




gc()

saveRDSvl(cpis,file='data/cpis_temp_time.rds'); gc()

#### with Stefan Z - impute NAs ?
#tcpis=imputena(cpis["...S1.."])
#cpis["DE.F3.S1.S1.US."] 

gc()

saveRDS(cpis,file='data/cpis_temp_time.rds'); gc()
#cpis=readRDS(file.path(data_dir,'cpis_temp_time.rds')); gc()

#############################################################################
# -- fill in for functional category _P
#############################################################################

#dimnames(cpis)[['REF_AREA']] = ccode(dimnames(cpis)[['REF_AREA']],2,'iso2m',leaveifNA=TRUE); gc()
#dimnames(cpis)[['COUNTERPART_AREA']] = ccode(dimnames(cpis)[['COUNTERPART_AREA']],2,'iso2m',leaveifNA=TRUE); gc()

# -- fill ASSETS in for functional category _P
dim(cpis)
dim(aa)

#before
cpis["DE.F3..S1.FR.2022q4"] 
aa[F3.DE..S1.LE..2022q4.FR]  
ll[F3.DE..S1.LE..2022q4.FR]

instr=dimnames(cpis)[['INSTR']]
for (i in instr) 
  { aa[i, , , ,"LE", "_P", , , usenames=TRUE, onlyna=TRUE] =cpis[,i,,,,] }

#after
cpis["DE.F3..S1.FR.2022q4"] 
aa[F3.DE..S1.LE..2022q4.FR]  
ll[F3.DE..S1.LE..2022q4.FR]

# -- fill LIABILITIES in for functional category _P
liabcpis=copy(cpis)
dim(liabcpis)
dim(ll)
#we want to use the counterpart information to fill the liabilities 
names(dimnames(liabcpis))[names(dimnames(liabcpis))=="REF_SECTOR"] <- 'COUNTERPART_SECTOR-TEMP'
names(dimnames(liabcpis))[names(dimnames(liabcpis))=="REF_AREA"] <- 'COUNTERPART_AREA-TEMP'
names(dimnames(liabcpis))[names(dimnames(liabcpis))=="COUNTERPART_SECTOR"] <- 'REF_SECTOR'
names(dimnames(liabcpis))[names(dimnames(liabcpis))=="COUNTERPART_AREA"] <- 'REF_AREA'
names(dimnames(liabcpis))[names(dimnames(liabcpis))=="COUNTERPART_SECTOR-TEMP"] <- 'COUNTERPART_SECTOR'
names(dimnames(liabcpis))[names(dimnames(liabcpis))=="COUNTERPART_AREA-TEMP"] <- 'COUNTERPART_AREA'

dim(liabcpis)
dim(ll)

for (i in instr) 
{
  ll[i, , , ,"LE", "_P", , , usenames=TRUE, onlyna=TRUE] =liabcpis[,i,,,,]
}

#special adjustment for S124
ll["F52", , , "S124","LE", "_P", , , usenames=TRUE, onlyna=TRUE] =liabcpis[,'F5',S124,,,]

#after
cpis["DE.F3..S1.FR.2022q4"] 
aa[F3.DE..S1.LE..2022q4.FR]  
ll[F3.DE..S1.LE..2022q4.FR] 

saveRDSvl(aa,file.path(data_dir,'aa_iip_cpis.rds'))
saveRDSvl(ll,file.path(data_dir,'ll_iip_cpis.rds'))

saveRDSvl(aa,file.path(data_dir,'vintages/aa_iip_cpis_' %&% format(Sys.time(),'%F') %&% '_.rds'))
saveRDSvl(ll,file.path(data_dir,'vintages/ll_iip_cpis_' %&% format(Sys.time(),'%F') %&% '_.rds'))


saveRDS(aa,file='data/aa_iip_cpis.rds')
saveRDS(ll,file='data/ll_iip_cpis.rds')
