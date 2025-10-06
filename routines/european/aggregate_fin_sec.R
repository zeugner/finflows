library(MDstats); 

# Set data directory
#data_dir= file.path(getwd(),'data')
if (!exists("data_dir")) data_dir = '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/data/'
source('\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/routines/utilities.R')
gc()


## load filled iip bop
aa=readRDS(file.path(data_dir,'aa_iip_cpis.rds')); gc()
ll=readRDS(file.path(data_dir,'ll_iip_cpis.rds')); gc()
gc()

##--------------------------------------------------------------------
## check for NAs in countries
##--------------------------------------------------------------------

if (any(sapply(aa,anyNA))) { warning('aa contains NAs in these columns: ', paste(names(aa)[sapply(aa,anyNA)],collapse=', '))}
if (any(sapply(ll,anyNA))) { warning('ll contains NAs in these columns: ', paste(names(ll)[sapply(ll,anyNA)],collapse=', '))}
gc()

tempix=dimnames(aa)[[8]]
aa=copy(aa[,,,,,,,setdiff(tempix,c('NA'))])

tempix=dimnames(ll)[[2]]
ll=copy(ll[,setdiff(tempix,c('NA')),,,,,,])

if (any(sapply(aa,anyNA))) { warning('aa contains NAs in these columns: ', paste(names(aa)[sapply(aa,anyNA)],collapse=', '))}
if (any(sapply(ll,anyNA))) { warning('ll contains NAs in these columns: ', paste(names(ll)[sapply(ll,anyNA)],collapse=', '))}
gc()



##--------------------------------------------------------------------
## Tx7 Aggregate (sum over all functional categories -again- except F7)
##--------------------------------------------------------------------
## -Assets-
system("ipconfig/flushdns")
aa[....._Tx7..]=NA;gc()
daa=as.data.table(aa,.simple=TRUE); gc()
if (anyNA(daa[,COUNTERPART_AREA])) daa=daa[!is.na(COUNTERPART_AREA),]
dacast=dcast(daa, ... ~ FUNCTIONAL_CAT, id.vars=1:8, value.var = 'obs_value'); gc()
dacast=dacast[!(is.na(`_D`) & is.na(`_P`) & is.na(`_O`)& is.na(`_R`)),]
dacast[,Tx7:=apply(.SD[,c('_D','_P','_O','_R')],1,sum,na.rm=TRUE)]


#dacast[['Tx7']]=apply(dacast[,c('_D','_P','_O','_R')],1,sum,na.rm=TRUE);gc()
dacast2=copy(dacast[,intersect(c(colnames(daa),'Tx7'),colnames(dacast)),with=FALSE]);gc()
colnames(dacast2)[colnames(dacast2)=='Tx7']='obs_value';gc()
dacast2[,FUNCTIONAL_CAT:='Tx7'];gc()

#rm(dacast); rm(aa); gc()
daa=rbind(daa,dacast2,fill=TRUE);gc()     
aa2=as.md3(daa);gc()

aa=copy(aperm(aa2, c(1:6,8,7)))


dim(aa)
gc()

aa[.AT.S1.S1.LE..2022q4.WRL_REST]

## -Liabilities-
ll[....._Tx7..]=NA;gc()
dll=as.data.table(ll,.simple=TRUE); gc()
dacast=dcast(dll, ... ~ FUNCTIONAL_CAT, id.vars=1:8, value.var = 'obs_value'); gc()
dacast[['_Tx7']]=apply(dacast[,c('_D','_P','_O')],1,sum,na.rm=TRUE);gc()
dacast2=copy(dacast[,intersect(c(colnames(dll),'_Tx7'),colnames(dacast)),with=FALSE]);gc()
colnames(dacast2)[NCOL(dacast2)]='obs_value';gc()
dacast2[,FUNCTIONAL_CAT:='_Tx7'];gc()

dll=rbind(dll,dacast2,fill=TRUE);gc()     
ll2=as.md3(dll);gc()

ll=aperm(copy(ll2), c(1:6,8,7))
dim(dll)
gc()

ll[.WRL_REST.S1.S1.LE..2022q4.AT]


##--------------------------------------------------------------------
## Fx7 Aggregate (sum over all financial instruments except F7, F21)
##--------------------------------------------------------------------

# -Assets-
aa[Fx7.......]=NA;gc()
daa=as.data.table(aa,.simple=TRUE); gc()
dacast=dcast(daa, ... ~ INSTR, id.vars=1:8, value.var = 'obs_value'); gc()
dacast[['Fx7']]=apply(dacast[,c('F2M','F3','F4','F511','F51M','F52','F6','F81','F89')],1,sum,na.rm=TRUE);gc()
dacast2=copy(dacast[,intersect(c(colnames(daa),'Fx7'),colnames(dacast)),with=FALSE]);gc()
colnames(dacast2)[NCOL(dacast2)]='obs_value';gc()
dacast2[,INSTR:='Fx7'];gc()

daa=rbind(daa,dacast2,fill=TRUE);gc()
aa2=as.md3(daa);gc()

aa=aperm(copy(aa2), c(1:6,8,7))
dim(aa)
gc()

aa[.AT.S1.S1.LE.Tx7.2022q4.EA20+WRL_REST]

## -Liabilities-
ll[Fx7.......]=NA;gc()
dll=as.data.table(ll,.simple=TRUE); gc()
dacast=dcast(dll, ... ~ INSTR, id.vars=1:8, value.var = 'obs_value'); gc()
dacast[['Fx7']]=apply(dacast[,c('F2M','F3','F4','F511','F51M','F52','F6','F81','F89')],1,sum,na.rm=TRUE);gc()
dacast2=copy(dacast[,intersect(c(colnames(dll),'Fx7'),colnames(dacast)),with=FALSE]);gc()
colnames(dacast2)[NCOL(dacast2)]='obs_value';gc()
dacast2[,INSTR:='Fx7'];gc()

dll=rbind(dll,dacast2,fill=TRUE);gc()
ll2=as.md3(dll);gc()

ll=aperm(copy(ll2), c(1:6,8,7))
dim(ll)
gc()
ll[.WRL_REST.S1.S1M+S11.LE.Tx7.2022q4.AT]

saveRDSvl(aa,file.path(data_dir,'aa_iip_agg.rds'))
saveRDSvl(ll,file.path(data_dir,'ll_iip_agg.rds'))

saveRDSvl(aa,file.path(data_dir,'vintages/aa_iip_agg_' %&% format(Sys.time(),'%F') %&% '_.rds'))
saveRDSvl(ll,file.path(data_dir,'vintages/ll_iip_agg_' %&% format(Sys.time(),'%F') %&% '_.rds'))

##--------------------------------------------------------------------
## Sector Aggregate !!!WORK IN PROGRESS!!!
##--------------------------------------------------------------------

##--------------------------------------------------------------------
## Areas Aggregate
##--------------------------------------------------------------------

## load 
# aa=readRDS(file.path(data_dir,'aa_iip_agg.rds')); gc()
# ll=readRDS(file.path(data_dir,'ll_iip_agg.rds')); gc()
# gc()

## counterpart areas

at_aa=aa[Fx7.AT.S1.S1.LE..2022q4.]

at_aa[.EXA]=NA;gc()

daa=as.data.table(at_aa,.simple=TRUE); gc()
dacast=dcast(daa, ... ~ COUNTERPART_AREA , id.vars=1:2, value.var = 'obs_value'); gc()
dacast[['EXA']]=apply(dacast[,c('NL','LU','FI','DE','ES','SK','EE','EL','IT','SI','LT','LV',
                                'CY','MT','FR','BE','IE','PT')],1,sum,na.rm=TRUE);gc()
dacast2=copy(dacast[,intersect(c(colnames(daa),'EXA'),colnames(dacast)),with=FALSE]);gc()
colnames(dacast2)[NCOL(dacast2)]='obs_value';gc()
dacast2[,COUNTERPART_AREA:='EXA'];gc()

daa=rbind(daa,dacast2,fill=TRUE);gc()
at_aa=as.md3(daa);gc()

dim(at_aa)
gc()

