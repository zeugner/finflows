#source('https://s-ecfin-web.net1.cec.eu.int/directorates/db/u1/R/routines/installMDecfin.txt')

##setwd('U:/Topics/Spillovers_and_EA/flowoffunds/finflows2024/gitcodedata')
#setwd('C:/Users/zeugnst/Documents/R/stuff/data')

### this takes very long!!!\\\

library(MDecfin)
# Set data directory
data_dir <- if (exists("data_dir")) data_dir else "data"

# Load and process data
xss='S1+S11+S1M+S13+S12K+S12T+S121+S124+S12O+S12Q'
xii='F+F21+F2M+F3+F4+F51+F511+F51M+F52+F6+F6N+F6O+F7+F81+F89'


#iterate through instruments, becuase the request faces timeout issues otehrwise
lll=list(A=list(), L=list())
cat('___ ' %&% Sys.Date() %&% ' ___\n', file = file.path(data_dir, 'finflows.log'), append = FALSE)

for (ii in strsplit(xii,split='\\+')[[1]]) {
  message(ii); cat(format(Sys.time(),'%H:%M:%S') %&% ": " %&% ii %&% '\n', 
                   file = file.path(data_dir, 'finflows.log'), append = TRUE)
  lll[['L']][[ii]]=mds('ECB/QSA/Q.N..W0+W2.'%&% xss %&% '.S1.N.L.LE+F.' %&% ii %&% '.._Z.XDC._T.S.V.N.')
  saveRDS(lll, file.path(data_dir, 'fflist.rds'))
}

gc()

for (ii in strsplit(xii,split='\\+')[[1]][-(1:5)]) {
  message(ii); cat(format(Sys.time(),'%H:%M:%S') %&% ": A " %&% ii %&% '\n', 
                   file = file.path(data_dir, 'finflows.log'), append = TRUE)
  lll[['A']][[ii]]=mds('ECB/QSA/Q.N..W0+W2.'%&% xss %&% '.' %&% xss %&% '.N.A.LE+F.' %&% ii %&% '.._Z.XDC._T.S.V.N.')
  saveRDS(lll, file.path(data_dir, 'fflist.rds'))
}

# Save code descriptions
codedescriptions=list()
codedescriptions$INSTR = helpmds('ECB/QSA',dim='INSTR_ASSET',verbose = FALSE)
codedescriptions$REF_SECTOR = helpmds('ECB/QSA',dim='REF_SECTOR',verbose = FALSE)
codedescriptions$COUNTERPART_SECTOR = helpmds('ECB/QSA',dim='COUNTERPART_SECTOR',verbose = FALSE)
codedescriptions$STO = helpmds('ECB/QSA',dim='STO',verbose = FALSE)
codedescriptions$CUST_BREAKDOWN = helpmds('ECB/QSA',dim='CUST_BREAKDOWN',verbose = FALSE)

saveRDS(codedescriptions, file.path(data_dir, 'codedescriptions.rds'))

