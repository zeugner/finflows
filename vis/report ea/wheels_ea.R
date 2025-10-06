library(MDstats); 

# Set data directory
#data_dir= file.path(getwd(),'data')
if (!exists("data_dir")) data_dir = '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/data/'
source('\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/routines/utilities.R')
gc()


## load data
aa=readRDS(file.path(data_dir,'aa_iip_agg.rds')); gc()
ll=readRDS(file.path(data_dir,'ll_iip_agg.rds')); gc()


as1m=aa[Fx7.EA20.S1M+S1.S12+S11+S13+S1M+S1.LE._T.2025q1.W2+WRL_REST]
as12s=aa[Fx7.EA20.S1+S12.S12K+S12Q+S12O+S124+S11+S13+S1M+S1.LE._T.2025q1.W2+WRL_REST]
