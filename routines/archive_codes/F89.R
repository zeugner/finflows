library(MD3)
library(MDstats)

aall <- readRDS("data/aall_f81.rds")

otheraccounts_al=mds('ECB/QSA/Q.N..W0+W1...N.A+L.LE.F89.T._Z.XDC._T.S.V.N._T')
saveRDS(otheraccounts_al,'data/otheraccounts_al.rds')
bopf89q=mds('Estat/bop_iip6_q/Q.MIO_EUR.FA__O__F89..S1.A_LE+L_LE.WRL_REST.')
bopf89_a=mds('Estat/bop_iip6_q/A.MIO_EUR.FA__O__F89..S1.A_LE+L_LE.WRL_REST.')
saveRDS(bopf89q,'data/bopf89q.rds')

#names(dimnames(otheraccounts_al)) =gsub("^INSTR.*$","INSTR",names(dimnames(otheraccounts_al)))
names(dimnames(otheraccounts_al)) =gsub("^COUNTER.*$","COUNTERPART_SECTOR",names(dimnames(otheraccounts_al)))
otheraccounts_al=aperm(otheraccounts_al,c("REF_AREA","REF_SECTOR","COUNTERPART_SECTOR","ACCOUNTING_ENTRY","TIME"))

otheraccounts=otheraccounts_al[...A.]

dimnames(otheraccounts)$COUNTERPART_SECTOR = c(W0='S0' , W1='S2')[dimnames(otheraccounts)$COUNTERPART_SECTOR]
otheraccounts[.S2.S0.] =otheraccounts_al[.S1.W1.L.]
otheraccounts[.S2.S1.] =otheraccounts_al[.S1.W1.L.]
otheraccounts[.S1.S1.] = otheraccounts[.S1.S0.] -otheraccounts[.S1.S2.] 
otheraccounts[.S0.S1.] = otheraccounts[.S1.S1.] +otheraccounts[.S2.S1.] 
saveRDS(otheraccounts,'data/otheraccounts.rds')
gc()
gc()

af89_=aall['F89....LE._T+_S+_O.1999q1:']
otheraccounts=add.dim(otheraccounts,.dimname = 'FUNCTIONAL_CAT',.dimcodes = '_T')
dimnames(otheraccounts)[[1]]='_T'
af89=merge(otheraccounts, af89_,along = 'FUNCTIONAL_CAT')

bopf89a=copy(bopf89_a); frequency(bopf89a)='Q'
saveRDS(bopf89a,'data/bopf89a.rds')

str(af89)
##check the following

names(dimnames(bopf89a))[1]=names(dimnames(bopf89q))[1]='REF_AREA'  
names(dimnames(bopf89q))[2]=names(dimnames(bopf89a))[2]='REF_SECTOR'


af89['_O....'] <- NA
af89[.AT.S1..1999q1]

################ASSETS

af89['_O...S2.',onlyna=TRUE]<-bopf89q["..A_LE.1998q4:"]
af89['_O...S2.',onlyna=TRUE]<-bopf89a["..A_LE.1998q4:"]

af89['_T...S2.',onlyna=TRUE]<-af89['_O...S2.']
af89['_S...S2.',onlyna=TRUE]<-af89['_O...S2.']

############LIABILITIES

bopf89q_liab=copy(bopf89q)
names(dimnames(bopf89q_liab))[2]='COUNTERPART_SECTOR'

bopf89a_liab=copy(bopf89a)
names(dimnames(bopf89a_liab))[2]='COUNTERPART_SECTOR'

af89['_O..S2..',onlyna=TRUE]<-bopf89q_liab["..L_LE.1998q4:"]

af89['_O..S2..',onlyna=TRUE]<-bopf89a_liab["..L_LE.1998q4:"]

af89['_T..S2..',onlyna=TRUE]<-af89['_O..S2..']
af89['_S..S2..',onlyna=TRUE]<-af89['_O..S2..']

af89['.AT..S2.2022q4']

af89['..S1..',onlyna=TRUE]<-af89['..S0..']-af89['..S2..']

af89['...S1.',onlyna=TRUE]<-af89['...S0.']-af89['...S2.']

######FILLING


######FILLING


aall[F89....LE..,onlyna=TRUE]<-af89[....]

aall[....._S.,onlyna=TRUE]<-aall[....._T.]
aall[F89.AT.S124..LE._S.2022q4]
# Set all F89 sectors to 0 where S0 counterpart is 0

temp=aall["F89....LE.."]
temp[temp[,"S0",,,]==0]=0
temp[temp[,,"S0",,]==0]=0

aall["F89....LE..", onlyna=TRUE]<-temp
aall[F89..S1+S11+S13+S1M+S12O.S1.LE._S.2022q4]

#### countries with nothing filled, everything goes to S13
aall["F89...S13.LE..", onlyna=TRUE]<-aall["F89...S1.LE.."]
aall[F89.AT...LE._S.2022q4]

#### all residual goes to S12O
aall["F89...S12O.LE..", onlyna=TRUE]<-aall["F89...S1.LE.."]-aall["F89...S11.LE.."]-zerofiller(aall["F89...S13.LE.."])-zerofiller(aall["F89...S1M.LE.."])-zerofiller(aall["F89...S12O.LE.."])--zerofiller(aall["F89...S12Q.LE.."])


aall[F89.AT...LE._S.2022q4]

saveRDS(aall,'data/aall_f89.rds')





