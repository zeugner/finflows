library(MD3)
library(MDstats)

aall <- readRDS("data/aall_f89.rds")

insurancepensions_al=mds('ECB/QSA/Q.N..W0+W1...N.A+L.LE.F6._Z._Z.XDC._T.S.V.N._T')
saveRDS(insurancepensions_al,'data/insurancepensions_al.rds')
bopf6q=mds('Estat/bop_iip6_q/Q.MIO_EUR.FA__O__F6..S1.A_LE+L_LE.WRL_REST.')
bopf6_a=mds('Estat/bop_iip6_q/A.MIO_EUR.FA__O__F6..S1.A_LE+L_LE.WRL_REST.')
saveRDS(bopf6q,'data/bopf6q.rds')

#names(dimnames(insurancepensions_al)) =gsub("^INSTR.*$","INSTR",names(dimnames(insurancepensions_al)))
names(dimnames(insurancepensions_al)) =gsub("^COUNTER.*$","COUNTERPART_SECTOR",names(dimnames(insurancepensions_al)))
insurancepensions_al=aperm(insurancepensions_al,c("REF_AREA","REF_SECTOR","COUNTERPART_SECTOR","ACCOUNTING_ENTRY","TIME"))

insurancepensions=insurancepensions_al[...A.]

dimnames(insurancepensions)$COUNTERPART_SECTOR = c(W0='S0' , W1='S2')[dimnames(insurancepensions)$COUNTERPART_SECTOR]
insurancepensions[.S2.S0.] =insurancepensions_al[.S1.W1.L.]
insurancepensions[.S2.S1.] =insurancepensions_al[.S1.W1.L.]
insurancepensions[.S1.S1.] = insurancepensions[.S1.S0.] -insurancepensions[.S1.S2.] 
insurancepensions[.S0.S1.] = insurancepensions[.S1.S1.] +insurancepensions[.S2.S1.] 
saveRDS(insurancepensions,'data/insurancepensions.rds')
gc()
gc()

af6_=aall['F6....LE._T+_S+_O.1999q1:']
insurancepensions=add.dim(insurancepensions,.dimname = 'FUNCTIONAL_CAT',.dimcodes = '_T')
dimnames(insurancepensions)[[1]]='_T'
af6=merge(insurancepensions, af6_,along = 'FUNCTIONAL_CAT')

bopf6a=copy(bopf6_a); frequency(bopf6a)='Q'
saveRDS(bopf6a,'data/bopf6a.rds')

str(af6)

dimnames(bopf6q)
names(dimnames(bopf6a))[1]=names(dimnames(bopf6q))[1]='REF_AREA'  
names(dimnames(bopf6q))[2]=names(dimnames(bopf6a))[2]='REF_SECTOR'


af6['_O....'] <- NA
af6[.AT.S1..1999q1]

################ASSETS

af6['_O...S2.',onlyna=TRUE]<-bopf6q["..A_LE.1998q4:"]
af6['_O...S2.',onlyna=TRUE]<-bopf6a["..A_LE.1998q4:"]

af6['_T...S2.',onlyna=TRUE]<-af6['_O...S2.']
af6['_S...S2.',onlyna=TRUE]<-af6['_O...S2.']

############LIABILITIES

bopf6q_liab=copy(bopf6q)
names(dimnames(bopf6q_liab))[2]='COUNTERPART_SECTOR'

bopf6a_liab=copy(bopf6a)
names(dimnames(bopf6a_liab))[2]='COUNTERPART_SECTOR'

af6['_O..S2..',onlyna=TRUE]<-bopf6q_liab["..L_LE.1998q4:"]

af6['_O..S2..',onlyna=TRUE]<-bopf6a_liab["..L_LE.1998q4:"]

af6['_T..S2..',onlyna=TRUE]<-af6['_O..S2..']
af6['_S..S2..',onlyna=TRUE]<-af6['_O..S2..']

af6['.AT..S2.2022q4']

af6['..S1..',onlyna=TRUE]<-af6['..S0..']-af6['..S2..']

af6['...S1.',onlyna=TRUE]<-af6['...S0.']-af6['...S2.']

######FILLING


aall[F6....LE..,onlyna=TRUE]<-af6[....]

aall[F6.IT..S0.LE._S.2022q4]
# Set all F6 sectors to 0 where S0 counterpart is 0

temp=aall["F6....LE.."]
temp[temp[,"S0",,,]==0]=0
temp[temp[,,"S0",,]==0]=0
aall["F6....LE..", onlyna=TRUE]<-temp

#### create object where we store ref sector S0 or S1
F6_total<-aall[F6..S0..LE..]
F6_total["...",onlyna=TRUE]<-aall[F6..S1..LE..]
F6_total["AT.._T."]

#now we want to attribute to ref sector S1M the value of S0 or S1 for all CP sectors except S12Q 
#so we take the S1M.S12Q value
F6_S1M_S12Q<-aall[F6..S1M.S12Q.LE..]
aall[F6..S1M..LE..,onlyna=TRUE]<-F6_total
aall[F6..S1M.S12Q.LE..]<-F6_S1M_S12Q
aall[F6..S1M.S12Q.LE..,onlyna=TRUE]<-aall[F6..S1M.S1.LE..]-zerofiller(aall[F6..S1M.S121.LE..])-zerofiller(aall[F6..S1M.S12T.LE..])-zerofiller(aall[F6..S1M.S124.LE..])-zerofiller(aall[F6..S1M.S12O.LE..])-zerofiller(aall[F6..S1M.S12Q.LE..])-zerofiller(aall[F6..S1M.S13.LE..])-zerofiller(aall[F6..S1M.S11.LE..])-zerofiller(aall[F6..S1M.S1M.LE..])

aall[F6..S1M.S12Q.LE._T.]
saveRDS(aall,'data/aall_F6.rds')

aall[F6...S1.LE._T.2022q4]

dimnames(aall)
aall["....._T.",onlyna=TRUE]<-aall["....._S."]

aall_domestic_T <- aall["....._T."]

aall_domestic_T_D <- aall["....._T+_D."]

saveRDS(aall_domestic_T,'data/aall_domestic_T.rds')
saveRDS(aall_domestic_T_D,'data/aall_domestic_T_D.rds')

aall_cp <- readRDS("Z:/FinFlows/githubrepo/finflows/data/aall_cp.rds")
FND=aall_cp[".....FND."]
aall_domestic_T_D['.....FND.'] <- NA
aall_domestic_T_D['.....FND.'] <- FND 
aall_domestic_T_D_FND=aall_domestic_T_D

saveRDS(aall_domestic_T_D_FND,'data/aall_domestic_T_D_FND.rds')

aall_domestic_T_FND=aall_domestic_T_D_FND['....._T+FND.']
saveRDS(aall_domestic_T_FND,'data/intermediate_domestic_data_files/aall_domestic_T_FND.rds')
