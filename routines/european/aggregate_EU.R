library(MDstats); library(MD3)

# Set data directory
setwd("V:/FinFlows/githubrepo/finflows")
data_dir= file.path(getwd(),'data')
if (!exists("data_dir")) data_dir = '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/data/'

aa=readRDS(file.path(data_dir,'aa_iip_cpis.rds')); gc()
ll=readRDS(file.path(data_dir,'ll_iip_cpis.rds')); gc()

#setstructure
dimnames(aa)
dim(aa)


##--------------------------------------------------------------------
## S124 EU Aggregate !!!WORK IN PROGRESS!!!
##--------------------------------------------------------------------

Ftotal=aa[F.EA20.S1M.S1.LE..2022q4.WRL_REST+W0+W2+EXT_EA20]
F2M=aa[F2M.EA20.S1M.S1.LE..2022q4.WRL_REST+W0+W2+EXT_EA20]
F3=aa[F3.EA20.S1M.S1.LE..2022q4.WRL_REST+W0+W2+EXT_EA20]
F511=aa[F511.EA20.S1M.S1.LE..2022q4.WRL_REST+W0+W2+EXT_EA20]
F52=aa[F52.EA20.S1M.S1.LE..2022q4.WRL_REST+W0+W2+EXT_EA20]

aa[F52.AT.S124.S1.LE._T.2022q4.WRL_REST+W0+W2]
aa[.HU.S124.S1.LE._X.2022q4.WRL_REST+EA20+EXT_EA20+EU27+EXT_EU27]
aa[.DK.S124.S1.LE._X.2022q4.WRL_REST+EA20+EXT_EA20+EU27+EXT_EU27]
aa[.SE.S124.S1.LE._X.2022q4.WRL_REST+EA20+EXT_EA20+EU27+EXT_EU27]
aa[.BG.S124.S1.LE._X.2022q4.WRL_REST+EA20+EXT_EA20+EU27+EXT_EU27]
aa[.CZ.S124.S1.LE._X.2022q4.WRL_REST+EA20+EXT_EA20+EU27+EXT_EU27]
aa[.RO.S124.S1.LE._X.2022q4.WRL_REST+EA20+EXT_EA20+EU27+EXT_EU27]
aa[.PL.S124.S1.LE._X.2022q4.WRL_REST+EA20+EXT_EA20+EU27+EXT_EU27]