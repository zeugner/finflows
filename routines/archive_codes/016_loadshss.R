library(MDstats); library(MD3)
`%&%` = function (..., collapse = NULL, recycle0 = FALSE)  .Internal(paste0(list(...), collapse, recycle0))

# Set data directory
setwd("V:/FinFlows/githubrepo/trialarea")
data_dir= file.path(getwd(),'data')
if (!exists("data_dir")) data_dir = '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/data/'

#### F3 F511 AND F52 FROM SHS/s
ashssraw=mds('ECB/SHSS/Q.N.....N.A.LE+F.F3+F511+F521+F522.._Z.XDC._T.M.V.N._T', ccode = NULL)
saveRDS(ashssraw,file='data/ashssraw.rds')
#ashssraw=readRDS("V:/FinFlows/githubrepo/trialarea/data/ashssraw.rds"); gc()

gc()
ashss=ashssraw
dimnames(ashss)

ashss[,,,,,,'_Z',, onlyna=TRUE] = ashss[,,,,,,'T',]
ashss[.....F3S._Z.] = ashss[.....F3.S.] 
ashss[.....F3L._Z.] = ashss[.....F3.L.] 
ashss[.....F52..]=ashss[.....F521..]+ashss[.....F522..]

shss<-ashss[.W2....F3+F511+F52+F3S+F3L._Z.]

dimnames(shss)

dimnames(shss)$REF_AREA[dimnames(shss)$REF_AREA=='GR'] ='EL'

saveRDS(shss,file='data/shss_domestic.rds')

dimnames(shss)


shss[..S1.S1.LE.F511.2023q4]
