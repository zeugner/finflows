library(MDstats); library(MD3)

# Set data directory
setwd("V:/FinFlows/githubrepo/finflows")
#data_dir= file.path(getwd(),'data')
if (!exists("data_dir")) data_dir = '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/data'

aa=readRDS(file.path(data_dir,'aa_iip_pip.rds')); gc()
ll=readRDS(file.path(data_dir,'ll_iip_pip.rds')); gc()


dim(aa)
dimnames(aa)
aa['F+F2M+F3+F4+F51+F511+F51M+F52+F6+F81+F89.EA20.S1.S1.LE..2024q4.WRL_REST+US+EXT_EA20']
aa['F+F2M+F3+F4+F51+F511+F51M+F52+F6+F81+F89.EA20.S1+S11+S12K+S124+S12O+S12P+S13+S1M.S1.LE..2024q4.US']


dim(ll)
ll['F+F2M+F3+F4+F51+F511+F51M+F52+F6+F81+F89.WRL_REST+US+EXT_EA20.S1.S1.LE..2024q4.EA20']


