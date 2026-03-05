library(MDstats)
if (!exists("data_dir")) data_dir = getwd()

#fnda1=mds('ECB/QSA/Q.N..W1..S1.N.A.F+LE.._Z+T._Z.XDC._T.S.V.N.FND')
fnda0=mds('ECB/QSA/Q.N..W0..S1.N.A.F+LE.._Z+T._Z.XDC._T.S.V.N.FND')
#fndl1=mds('ECB/QSA/Q.N..W1..S1.N.L.F+LE.._Z+T._Z.XDC._T.S.V.N.FND')
fndl0=mds('ECB/QSA/Q.N..W0..S1.N.L.F+LE.._Z+T._Z.XDC._T.S.V.N.FND')

fndl0[....T. ,onlyna=TRUE] =fndl0[...._Z.]
fnda0[....T. ,onlyna=TRUE] =fnda0[...._Z.]


names(dimnames(fndl0)) =gsub('REF_SECTOR','COUNTERPART_SECTOR',names(dimnames(fndl0)))
mysl=add.dim(fndl0[....T.],'REF_SECTOR',.dimcodes = 'S0')


mysa=add.dim(fnda0[....T.],'COUNTERPART_SECTOR',.dimcodes = 'S0')
mys=merge(mysa,mysl)
saveRDS(mys, file.path(data_dir, 'fndqsa.rds'))
