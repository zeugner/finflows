setwd('U:/Topics/Spillovers_and_EA/flowoffunds/finflows2024/codealpha')

### this takes very long!!!\\\

library(MDecfin)
xss='S1+S11+S1M+S13+S12K+S12T+S121+S124+S12O+S12Q'

xii='F+F21+F2M+F3+F4+F51+F511+F51M+F52+F6+F6N+F6O+F7+F81+F89'

#iterate through instruments, becuase the request faces timeout issues otehrwise
lll=list(A=list(), L=list())
cat('___ ' %&% Sys.Date() %&% ' ___\n', file = 'data/finflows.log', append = FALSE)

for (ii in strsplit(xii,split='\\+')[[1]]) {
  message(ii); cat(format(Sys.time(),'%H:%M:%S') %&% ": " %&% ii %&% '\n', file = 'data/finflows.log', append = TRUE)
 lll[['L']][[ii]]=mds('ECB/QSA/Q.N..W0+W2.'%&% xss %&% '.S1.N.L.LE+F.' %&% ii %&% '.._Z.XDC._T.S.V.N.')
 saveRDS(lll,'data/fflist.rds')
}


gc()

for (ii in strsplit(xii,split='\\+')[[1]][-(1:5)]) {
  message(ii); cat(format(Sys.time(),'%H:%M:%S') %&% ": A " %&% ii %&% '\n', file = 'data/finflows.log', append = TRUE)
  lll[['A']][[ii]]=mds('ECB/QSA/Q.N..W0+W2.'%&% xss %&% '.' %&% xss %&% '.N.A.LE+F.' %&% ii %&% '.._Z.XDC._T.S.V.N.')
  saveRDS(lll,'data/fflist.rds')
}


lll$F2MLW2=mds('ECB/QSA/Q.N..W2.'%&% xss %&% '.' %&% xss %&% '.N.L..F2M.._Z.XDC._T.S.V.N.')
saveRDS(lll,'data/fflist.rds')
