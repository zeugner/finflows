library(MDecfin)

# Load assets data
laiip = readRDS("data/iip6_assets.rds")
# Load liabilities data
lliip = readRDS("data/iip6_liabilities.rds")

#temp load current aall version
aall=readRDS('data/aall5.rds')
setkey(aall, NULL)

### data structure
names(dimnames(laiip))[[1]] = 'REF_AREA'
names(dimnames(laiip))[[2]] = 'REF_SECTOR'
names(dimnames(lliip))[[1]] = 'REF_AREA'
names(dimnames(lliip))[[2]] = 'REF_SECTOR'

zerofiller=function(x, fillscalar=0){
  temp=copy(x)
  temp[onlyna=TRUE]=fillscalar
  temp
}

# Process F (sum of F per functional categories)
print('filling NAs of crossborder financial assets')

## F total - Assets for Qdata
aaF = laiip[..FA__D__F+FA__O__F+FA__P__F+FA__R__F+FA__F__F7.]
ppFA=copy(aaF[..FA__D__F+FA__O__F+FA__P__F+FA__R__F+FA__F__F7.])
aall[F..S121.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppFA[".S121.FA__D__F.1999q4:"])+zerofiller(ppFA[".S121.FA__O__F.1999q4:"])+zerofiller(ppFA[".S121.FA__P__F.1999q4:"])+zerofiller(ppFA[".S121.FA__F__F7.1999q4:"])+zerofiller(ppFA[".S121.FA__R__F.1999q4:"])
aall[F..S12T.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppFA[".S12T.FA__D__F.1999q4:"])+zerofiller(ppFA[".S12T.FA__O__F.1999q4:"])+zerofiller(ppFA[".S12T.FA__P__F.1999q4:"])+zerofiller(ppFA[".S12T.FA__F__F7.1999q4:"])
aall[F..S13.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppFA[".S13.FA__D__F.1999q4:"])+zerofiller(ppFA[".S13.FA__O__F.1999q4:"])+zerofiller(ppFA[".S13.FA__P__F.1999q4:"])+zerofiller(ppFA[".S13.FA__F__F7.1999q4:"])
aall[F..S11.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppFA[".S11.FA__D__F.1999q4:"])+zerofiller(ppFA[".S11.FA__O__F.1999q4:"])+zerofiller(ppFA[".S11.FA__P__F.1999q4:"])+zerofiller(ppFA[".S11.FA__F__F7.1999q4:"])
aall[F..S1M.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppFA[".S1M.FA__D__F.1999q4:"])+zerofiller(ppFA[".S1M.FA__O__F.1999q4:"])+zerofiller(ppFA[".S1M.FA__P__F.1999q4:"])+zerofiller(ppFA[".S1M.FA__F__F7.1999q4:"])
aall[F..S124.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppFA[".S124.FA__D__F.1999q4:"])+zerofiller(ppFA[".S124.FA__O__F.1999q4:"])+zerofiller(ppFA[".S124.FA__P__F.1999q4:"])+zerofiller(ppFA[".S124.FA__F__F7.1999q4:"])
aall[F..S12O.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppFA[".S12O.FA__D__F.1999q4:"])+zerofiller(ppFA[".S12O.FA__O__F.1999q4:"])+zerofiller(ppFA[".S12O.FA__P__F.1999q4:"])+zerofiller(ppFA[".S12O.FA__F__F7.1999q4:"])
aall[F..S12Q.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppFA[".S12Q.FA__D__F.1999q4:"])+zerofiller(ppFA[".S12Q.FA__O__F.1999q4:"])+zerofiller(ppFA[".S12Q.FA__P__F.1999q4:"])+zerofiller(ppFA[".S12Q.FA__F__F7.1999q4:"])
aall[F..S12R.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppFA[".S12M.FA__D__F.1999q4:"])+zerofiller(ppFA[".S12M.FA__O__F.1999q4:"])+zerofiller(ppFA[".S12M.FA__P__F.1999q4:"])+zerofiller(ppFA[".S12M.FA__F__F7.1999q4:"])

## F total - liabilities for Qdata
# Process F (sum of F per functional categories)
print('filling NAs of crossborder financial liabilities')
llF = lliip[..FA__D__F+FA__O__F+FA__P__F+FA__R__F+FA__F__F7.]
ppFL = copy(llF[..FA__D__F+FA__O__F+FA__P__F+FA__R__F+FA__F__F7.])
aall[F..S2.S121.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppFL[".S121.FA__D__F.1999q4:"])+zerofiller(ppFL[".S121.FA__O__F.1999q4:"])+zerofiller(ppFL[".S121.FA__P__F.1999q4:"])+zerofiller(ppFL[".S121.FA__F__F7.1999q4:"])
aall[F..S2.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppFL[".S12T.FA__D__F.1999q4:"])+zerofiller(ppFL[".S12T.FA__O__F.1999q4:"])+zerofiller(ppFL[".S12T.FA__P__F.1999q4:"])+zerofiller(ppFL[".S12T.FA__F__F7.1999q4:"])
aall[F..S2.S13.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppFL[".S13.FA__D__F.1999q4:"])+zerofiller(ppFL[".S13.FA__O__F.1999q4:"])+zerofiller(ppFL[".S13.FA__P__F.1999q4:"])+zerofiller(ppFL[".S13.FA__F__F7.1999q4:"])
aall[F..S2.S11.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppFL[".S11.FA__D__F.1999q4:"])+zerofiller(ppFL[".S11.FA__O__F.1999q4:"])+zerofiller(ppFL[".S11.FA__P__F.1999q4:"])+zerofiller(ppFL[".S11.FA__F__F7.1999q4:"])
aall[F..S2.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppFL[".S1M.FA__D__F.1999q4:"])+zerofiller(ppFL[".S1M.FA__O__F.1999q4:"])+zerofiller(ppFL[".S1M.FA__P__F.1999q4:"])+zerofiller(ppFL[".S1M.FA__F__F7.1999q4:"])
aall[F..S2.S124.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppFL[".S124.FA__D__F.1999q4:"])+zerofiller(ppFL[".S124.FA__O__F.1999q4:"])+zerofiller(ppFL[".S124.FA__P__F.1999q4:"])+zerofiller(ppFL[".S124.FA__F__F7.1999q4:"])
aall[F..S2.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppFL[".S12O.FA__D__F.1999q4:"])+zerofiller(ppFL[".S12O.FA__O__F.1999q4:"])+zerofiller(ppFL[".S12O.FA__P__F.1999q4:"])+zerofiller(ppFL[".S12O.FA__F__F7.1999q4:"])
aall[F..S2.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppFL[".S12Q.FA__D__F.1999q4:"])+zerofiller(ppFL[".S12Q.FA__O__F.1999q4:"])+zerofiller(ppFL[".S12Q.FA__P__F.1999q4:"])+zerofiller(ppFL[".S12Q.FA__F__F7.1999q4:"])
aall[F..S2.S12R.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppFL[".S12M.FA__D__F.1999q4:"])+zerofiller(ppFL[".S12M.FA__O__F.1999q4:"])+zerofiller(ppFL[".S12M.FA__P__F.1999q4:"])+zerofiller(ppFL[".S12M.FA__F__F7.1999q4:"])


## F2 deposits and currency - Assets for Qdata
# Process F2M (sum of F22 and F29)
print('filling NAs of crossborder F2M assets')
aaF2 = laiip[..FA__O__F2+FA__R__F2.]
ppF2M = copy(aaF2[..FA__O__F2+FA__R__F2.])
aall[F2M..S121.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF2M[".S121.FA__O__F2.1999q4:"])+zerofiller(ppF2M[".S121.FA__R__F2.1999q4:"])
aall[F2M..S121.S2.LE.FNR., usenames=TRUE] = zerofiller(ppF2M[".S121.FA__R__F2.1999q4:"])
aall[F2M..S12T.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF2M[".S12T.FA__O__F2.1999q4:"])
aall[F2M..S13.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF2M[".S13.FA__O__F2.1999q4:"])
aall[F2M..S11.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF2M[".S11.FA__O__F2.1999q4:"])
aall[F2M..S1M.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF2M[".S1M.FA__O__F2.1999q4:"])
aall[F2M..S124.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF2M[".S124.FA__O__F2.1999q4:"])
aall[F2M..S12O.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF2M[".S12O.FA__O__F2.1999q4:"])
aall[F2M..S12Q.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF2M[".S12Q.FA__O__F2.1999q4:"])
aall[F2M..S12R.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF2M[".S12M.FA__O__F2.1999q4:"])

## F2 deposits and currency - Liabilities for Qdata
# Process F2M (sum of F22 and F29)
print('filling NAs of crossborder F2M liabilities')
llF2 = lliip[..FA__O__F2+FA__R__F2.]
ppF2M = copy(llF2[..FA__O__F2+FA__R__F2.])
aall[F2M..S2.S121.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF2M[".S121.FA__O__F2.1999q4:"])+zerofiller(ppF2M[".S121.FA__R__F2.1999q4:"])
aall[F2M..S2.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF2M[".S12T.FA__O__F2.1999q4:"])
aall[F2M..S2.S13.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF2M[".S13.FA__O__F2.1999q4:"])

## F3 bonds total - Assets for Qdata
# Process F3 (from Direct Investment, Portfolio Investment, Reserve Assets)
print('filling NAs of crossborder F3 assets')
aaF3M = laiip[..FA__D__F3+FA__P__F3+FA__R__F3.]
ppF3MA = copy(aaF3M[..FA__D__F3+FA__P__F3+FA__R__F3.])
aall[F3..S121.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF3MA[".S121.FA__D__F3.1999q4:"])+zerofiller(ppF3MA[".S121.FA__P__F3.1999q4:"])+zerofiller(ppF3MA[".S121.FA__R__F3.1999q4:"])
aall[F3..S12T.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF3MA[".S12T.FA__D__F3.1999q4:"])+zerofiller(ppF3MA[".S12T.FA__P__F3.1999q4:"])
aall[F3..S13.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF3MA[".S13.FA__D__F3.1999q4:"])+zerofiller(ppF3MA[".S13.FA__P__F3.1999q4:"])
aall[F3..S11.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF3MA[".S11.FA__D__F3.1999q4:"])+zerofiller(ppF3MA[".S11.FA__P__F3.1999q4:"])
aall[F3..S1M.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF3MA[".S1M.FA__D__F3.1999q4:"])+zerofiller(ppF3MA[".S1M.FA__P__F3.1999q4:"])
aall[F3..S124.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF3MA[".S124.FA__D__F3.1999q4:"])+zerofiller(ppF3MA[".S124.FA__P__F3.1999q4:"])
aall[F3..S12O.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF3MA[".S12O.FA__D__F3.1999q4:"])+zerofiller(ppF3MA[".S12O.FA__P__F3.1999q4:"])
aall[F3..S12Q.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF3MA[".S12Q.FA__D__F3.1999q4:"])+zerofiller(ppF3MA[".S12Q.FA__P__F3.1999q4:"])
aall[F3..S12R.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF3MA[".S12M.FA__D__F3.1999q4:"])+zerofiller(ppF3MA[".S12M.FA__P__F3.1999q4:"])

## F3 bonds total - liabilities for Qdata
# Process F3 (from Direct Investment, Portfolio Investment)
print('filling NAs of crossborder F3 liabilities')
llF3M = lliip[..FA__D__F3+FA__P__F3.]
ppF3ML = copy(llF3M[..FA__D__F3+FA__P__F3.])
aall[F3..S2.S121.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF3ML[".S121.FA__D__F3.1999q4:"])+zerofiller(ppF3ML[".S121.FA__P__F3.1999q4:"])
aall[F3..S2.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF3ML[".S12T.FA__D__F3.1999q4:"])+zerofiller(ppF3ML[".S12T.FA__P__F3.1999q4:"])
aall[F3..S2.S13.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF3ML[".S13.FA__D__F3.1999q4:"])+zerofiller(ppF3ML[".S13.FA__P__F3.1999q4:"])
aall[F3..S2.S11.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF3ML[".S11.FA__D__F3.1999q4:"])+zerofiller(ppF3ML[".S11.FA__P__F3.1999q4:"])
aall[F3..S2.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF3ML[".S1M.FA__D__F3.1999q4:"])+zerofiller(ppF3ML[".S1M.FA__P__F3.1999q4:"])
aall[F3..S2.S124.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF3ML[".S124.FA__D__F3.1999q4:"])+zerofiller(ppF3ML[".S124.FA__P__F3.1999q4:"])
aall[F3..S2.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF3ML[".S12O.FA__D__F3.1999q4:"])+zerofiller(ppF3ML[".S12O.FA__P__F3.1999q4:"])
aall[F3..S2.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF3ML[".S12Q.FA__D__F3.1999q4:"])+zerofiller(ppF3ML[".S12Q.FA__P__F3.1999q4:"])
aall[F3..S2.S12R.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF3ML[".S12M.FA__D__F3.1999q4:"])+zerofiller(ppF3ML[".S12M.FA__P__F3.1999q4:"])

## F4 loans total - Assets for Qdata
# Process F4 (sum of F4 from Direct Investment, Other Investment)
print('filling NAs of crossborder F4 assets')
aaF4 = laiip[..FA__D__F4+FA__O__F4.]
ppF4A = copy(aaF4[..FA__D__F4+FA__O__F4.])
aall[F4..S121.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4A[".S121.FA__D__F4.1999q4:"])+zerofiller(ppF4A[".S121.FA__O__F4.1999q4:"])
aall[F4..S12T.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4A[".S12T.FA__D__F4.1999q4:"])+zerofiller(ppF4A[".S12T.FA__O__F4.1999q4:"])
aall[F4..S13.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4A[".S13.FA__D__F4.1999q4:"])+zerofiller(ppF4A[".S13.FA__O__F4.1999q4:"])
aall[F4..S11.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4A[".S11.FA__D__F4.1999q4:"])+zerofiller(ppF4A[".S11.FA__O__F4.1999q4:"])
aall[F4..S1M.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4A[".S1M.FA__D__F4.1999q4:"])+zerofiller(ppF4A[".S1M.FA__O__F4.1999q4:"])
aall[F4..S124.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4A[".S124.FA__D__F4.1999q4:"])+zerofiller(ppF4A[".S124.FA__O__F4.1999q4:"])
aall[F4..S12O.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4A[".S12O.FA__D__F4.1999q4:"])+zerofiller(ppF4A[".S12O.FA__O__F4.1999q4:"])
aall[F4..S12Q.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4A[".S12Q.FA__D__F4.1999q4:"])+zerofiller(ppF4A[".S12Q.FA__O__F4.1999q4:"])
aall[F4..S12R.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4A[".S12M.FA__D__F4.1999q4:"])+zerofiller(ppF4A[".S12M.FA__O__F4.1999q4:"])

## F4 loans total - liabilities for Qdata
# Process F4 (sum of F4 from Direct Investment, Other Investment)
print('filling NAs of crossborder F4 liabilities')
llF4 = lliip[..FA__D__F4+FA__O__F4.]
ppF4L = copy(llF4[..FA__D__F4+FA__O__F4.])
aall[F4..S2.S121.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4L[".S121.FA__D__F4.1999q4:"])+zerofiller(ppF4L[".S121.FA__O__F4.1999q4:"])
aall[F4..S2.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4L[".S12T.FA__D__F4.1999q4:"])+zerofiller(ppF4L[".S12T.FA__O__F4.1999q4:"])
aall[F4..S2.S13.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4L[".S13.FA__D__F4.1999q4:"])+zerofiller(ppF4L[".S13.FA__O__F4.1999q4:"])
aall[F4..S2.S11.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4L[".S11.FA__D__F4.1999q4:"])+zerofiller(ppF4L[".S11.FA__O__F4.1999q4:"])
aall[F4..S2.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4L[".S1M.FA__D__F4.1999q4:"])+zerofiller(ppF4L[".S1M.FA__O__F4.1999q4:"])
aall[F4..S2.S124.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4L[".S124.FA__D__F4.1999q4:"])+zerofiller(ppF4L[".S124.FA__O__F4.1999q4:"])
aall[F4..S2.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4L[".S12O.FA__D__F4.1999q4:"])+zerofiller(ppF4L[".S12O.FA__O__F4.1999q4:"])
aall[F4..S2.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4L[".S12Q.FA__D__F4.1999q4:"])+zerofiller(ppF4L[".S12Q.FA__O__F4.1999q4:"])
aall[F4..S2.S12R.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4L[".S12R.FA__D__F4.1999q4:"])+zerofiller(ppF4L[".S12R.FA__O__F4.1999q4:"])

## F52 investment fund shares - Assets for Qdata
# Process F52 ( Portfolio Investment)
print('filling NAs of crossborder F52 assets')
aaF52 = laiip[..FA__P__F52., drop=FALSE]
ppF52A = copy(aaF52[..FA__P__F52., drop=FALSE])
aall[F52..S121.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF52A[".S121.FA__P__F52.1999q4:"])
aall[F52..S12T.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF52A[".S12T.FA__P__F52.1999q4:"])
aall[F52..S11.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF52A[".S11.FA__P__F52.1999q4:"])
aall[F52..S1M.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF52A[".S1M.FA__P__F52.1999q4:"])
aall[F52..S13.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF52A[".S13.FA__P__F52.1999q4:"])
aall[F52..S124.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF52A[".S124.FA__P__F52.1999q4:"])
aall[F52..S12O.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF52A[".S12O.FA__P__F52.1999q4:"])
aall[F52..S12Q.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF52A[".S12Q.FA__P__F52.1999q4:"])
aall[F52..S12R.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF52A[".S12M.FA__P__F52.1999q4:"])

## F52 investment fund shares - Liabilities for Qdata
# Process F52 ( Portfolio Investment)
print('filling NAs of crossborder F52 liabilities')
llF52 = lliip[..FA__P__F52., drop=FALSE]
ppF52L = copy(llF52[..FA__P__F52., drop=FALSE])
aall[F52..S2.S121.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF52L[".S121.FA__P__F52.1999q4:"])
aall[F52..S2.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF52L[".S12T.FA__P__F52.1999q4:"])
aall[F52..S2.S124.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF52L[".S124.FA__P__F52.1999q4:"])
aall[F52..S2.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF52L[".S12O.FA__P__F52.1999q4:"])
aall[F52..S2.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF52L[".S12Q.FA__P__F52.1999q4:"])
aall[F52..S2.S12R.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF52L[".S12M.FA__P__F52.1999q4:"])

## F511 listed shares - Assets for Qdata
# Process F511 (sum of F511 from Direct Investment and Portfolio Investment)
print('filling NAs of crossborder F511 assets')
aaF511 = laiip[..FA__D__F511+FA__P__F511.]
ppF511A = copy(aaF511[..FA__D__F511+FA__P__F511.])
aall[F511..S121.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF511A[".S121.FA__D__F511.1999q4:"])+zerofiller(ppF511A[".S121.FA__P__F511.1999q4:"])
aall[F511..S12T.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF511A[".S12T.FA__D__F511.1999q4:"])+zerofiller(ppF511A[".S12T.FA__P__F511.1999q4:"])
aall[F511..S11.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF511A[".S11.FA__D__F511.1999q4:"])+zerofiller(ppF511A[".S11.FA__P__F511.1999q4:"])
aall[F511..S1M.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF511A[".S1M.FA__D__F511.1999q4:"])+zerofiller(ppF511A[".S1M.FA__P__F511.1999q4:"])
aall[F511..S13.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF511A[".S13.FA__D__F511.1999q4:"])+zerofiller(ppF511A[".S13.FA__P__F511.1999q4:"])
aall[F511..S124.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF511A[".S124.FA__D__F511.1999q4:"])+zerofiller(ppF511A[".S124.FA__P__F511.1999q4:"])
aall[F511..S12O.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF511A[".S12O.FA__D__F511.1999q4:"])+zerofiller(ppF511A[".S12O.FA__P__F511.1999q4:"])
aall[F511..S12Q.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF511A[".S12Q.FA__D__F511.1999q4:"])+zerofiller(ppF511A[".S12Q.FA__P__F511.1999q4:"])
aall[F511..S12R.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF511A[".S12M.FA__D__F511.1999q4:"])+zerofiller(ppF511A[".S12M.FA__P__F511.1999q4:"])

## F511 listed shares - Liabilities for Qdata
# Process F511 (sum of F511 from Direct Investment and Portfolio Investment)
print('filling NAs of crossborder F511 liabiities')
llF511 = lliip[..FA__D__F511+FA__P__F511.]
ppF511L = copy(llF511[..FA__D__F511+FA__P__F511.])
aall[F511..S2.S121.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF511L[".S121.FA__D__F511.1999q4:"])+zerofiller(ppF511L[".S121.FA__P__F511.1999q4:"])
aall[F511..S2.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF511L[".S12T.FA__D__F511.1999q4:"])+zerofiller(ppF511L[".S12T.FA__P__F511.1999q4:"])
aall[F511..S2.S11.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF511L[".S11.FA__D__F511.1999q4:"])+zerofiller(ppF511L[".S11.FA__P__F511.1999q4:"])
aall[F511..S2.S13.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF511L[".S13.FA__D__F511.1999q4:"])+zerofiller(ppF511L[".S13.FA__P__F511.1999q4:"])
aall[F511..S2.S124.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF511L[".S124.FA__D__F511.1999q4:"])+zerofiller(ppF511L[".S124.FA__P__F511.1999q4:"])
aall[F511..S2.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF511L[".S12O.FA__D__F511.1999q4:"])+zerofiller(ppF511L[".S12O.FA__P__F511.1999q4:"])
aall[F511..S2.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF511L[".S12Q.FA__D__F511.1999q4:"])+zerofiller(ppF511L[".S12Q.FA__P__F511.1999q4:"])
aall[F511..S2.S12R.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF511L[".S12M.FA__D__F511.1999q4:"])+zerofiller(ppF511L[".S12M.FA__P__F511.1999q4:"])

## F51M other equity - Assets for Qdata
# Process F51M (sum of F512 and F519 from Direct Investment, Other Investment, Portfolio Investment)
# checkFDI to see if F51M or F512+F519 are filled for Q data 
#check = aa[..FA__D__F51M.2022q4]- aa[..FA__D__F512+FA__D__F519.2022q4] 
print('filling NAs of crossborder F52M assets')
aaF51M = laiip[..FA__D__F51M+FA__O__F519+FA__P__F512.]
ppF51MA = copy(aaF51M[..FA__D__F51M+FA__O__F519+FA__P__F512.])
aall[F51M..S121.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF51MA[".S121.FA__D__F51M.1999q4:"])+zerofiller(ppF51MA[".S121.FA__O__F519.1999q4:"])+zerofiller(ppF51MA[".S121.FA__P__F512.1999q4:"])
aall[F51M..S12T.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF51MA[".S12T.FA__D__F51M.1999q4:"])+zerofiller(ppF51MA[".S12T.FA__O__F519.1999q4:"])+zerofiller(ppF51MA[".S12T.FA__P__F512.1999q4:"])
aall[F51M..S11.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF51MA[".S11.FA__D__F51M.1999q4:"])+zerofiller(ppF51MA[".S11.FA__O__F519.1999q4:"])+zerofiller(ppF51MA[".S11.FA__P__F512.1999q4:"])
aall[F51M..S1M.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF51MA[".S1M.FA__D__F51M.1999q4:"])+zerofiller(ppF51MA[".S1M.FA__O__F519.1999q4:"])+zerofiller(ppF51MA[".S1M.FA__P__F512.1999q4:"])
aall[F51M..S13.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF51MA[".S13.FA__D__F51M.1999q4:"])+zerofiller(ppF51MA[".S13.FA__O__F519.1999q4:"])+zerofiller(ppF51MA[".S13.FA__P__F512.1999q4:"])
aall[F51M..S124.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF51MA[".S124.FA__D__F51M.1999q4:"])+zerofiller(ppF51MA[".S124.FA__O__F519.1999q4:"])+zerofiller(ppF51MA[".S124.FA__P__F512.1999q4:"])
aall[F51M..S12O.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF51MA[".S12O.FA__D__F51M.1999q4:"])+zerofiller(ppF51MA[".S12O.FA__O__F519.1999q4:"])+zerofiller(ppF51MA[".S12O.FA__P__F512.1999q4:"])
aall[F51M..S12Q.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF51MA[".S12Q.FA__D__F51M.1999q4:"])+zerofiller(ppF51MA[".S12Q.FA__O__F519.1999q4:"])+zerofiller(ppF51MA[".S12Q.FA__P__F512.1999q4:"])
aall[F51M..S12R.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF51MA[".S12M.FA__D__F51M.1999q4:"])+zerofiller(ppF51MA[".S12M.FA__O__F519.1999q4:"])+zerofiller(ppF51MA[".S12M.FA__P__F512.1999q4:"])

## F51M other equity - Liabilities for Qdata
# Process F51M (sum of F512 and F519 from Direct Investment, Other Investment, Portfolio Investment)
# checkFDI to see if F51M or F512+F519 are filled for Q data 
#check = aa[..FA__D__F51M.2022q4]- aa[..FA__D__F512+FA__D__F519.2022q4] 
print('filling NAs of crossborder F52M liabilities')
llF51M = lliip[..FA__D__F51M+FA__O__F519+FA__P__F512.]
ppF51ML = copy(llF51M[..FA__D__F51M+FA__O__F519+FA__P__F512.])
aall[F51M..S2.S121.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF51ML[".S121.FA__D__F51M.1999q4:"])+zerofiller(ppF51ML[".S121.FA__O__F519.1999q4:"])+zerofiller(ppF51ML[".S121.FA__P__F512.1999q4:"])
aall[F51M..S2.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF51ML[".S12T.FA__D__F51M.1999q4:"])+zerofiller(ppF51ML[".S12T.FA__O__F519.1999q4:"])+zerofiller(ppF51ML[".S12T.FA__P__F512.1999q4:"])
aall[F51M..S2.S11.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF51ML[".S11.FA__D__F51M.1999q4:"])+zerofiller(ppF51ML[".S11.FA__O__F519.1999q4:"])+zerofiller(ppF51ML[".S11.FA__P__F512.1999q4:"])
aall[F51M..S2.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF51ML[".S1M.FA__D__F51M.1999q4:"])+zerofiller(ppF51ML[".S1M.FA__O__F519.1999q4:"])+zerofiller(ppF51ML[".S1M.FA__P__F512.1999q4:"])
aall[F51M..S2.S13.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF51ML[".S13.FA__D__F51M.1999q4:"])+zerofiller(ppF51ML[".S13.FA__O__F519.1999q4:"])+zerofiller(ppF51ML[".S13.FA__P__F512.1999q4:"])
aall[F51M..S2.S124.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF51ML[".S124.FA__D__F51M.1999q4:"])+zerofiller(ppF51ML[".S124.FA__O__F519.1999q4:"])+zerofiller(ppF51ML[".S124.FA__P__F512.1999q4:"])
aall[F51M..S2.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF51ML[".S12O.FA__D__F51M.1999q4:"])+zerofiller(ppF51ML[".S12O.FA__O__F519.1999q4:"])+zerofiller(ppF51ML[".S12O.FA__P__F512.1999q4:"])
aall[F51M..S2.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF51ML[".S12Q.FA__D__F51M.1999q4:"])+zerofiller(ppF51ML[".S12Q.FA__O__F519.1999q4:"])+zerofiller(ppF51ML[".S12Q.FA__P__F512.1999q4:"])
aall[F51M..S2.S12R.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF51ML[".S12M.FA__D__F51M.1999q4:"])+zerofiller(ppF51ML[".S12M.FA__O__F519.1999q4:"])+zerofiller(ppF51ML[".S12M.FA__P__F512.1999q4:"])

## F6  - Assets for Qdata
# Process F6 Other Investment
print('filling NAs of crossborder F6 assets')
aaF6 = laiip[..FA__O__F6., drop=FALSE]
ppF6A = copy(aaF6[..FA__O__F6., drop=FALSE])
aall[F6..S121.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF6A[".S121.FA__O__F6.1999q4:"])
aall[F6..S12T.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF6A[".S12T.FA__O__F6.1999q4:"])
aall[F6..S11.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF6A[".S11.FA__O__F6.1999q4:"])
aall[F6..S1M.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF6A[".S1M.FA__O__F6.1999q4:"])
aall[F6..S13.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF6A[".S13.FA__O__F6.1999q4:"])
aall[F6..S124.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF6A[".S124.FA__O__F6.1999q4:"])
aall[F6..S12O.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF6A[".S12O.FA__O__F6.1999q4:"])
aall[F6..S12Q.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF6A[".S12Q.FA__O__F6.1999q4:"])
aall[F6..S12R.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF6A[".S12M.FA__O__F6.1999q4:"])

## F6  - liabilities for Qdata
# Process F6 Other Investment
print('filling NAs of crossborder F6 liabilities')
llF6 = lliip[..FA__O__F6., drop=FALSE]
ppF6L = copy(llF6[..FA__O__F6., drop=FALSE])
aall[F6..S2.S121.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF6L[".S121.FA__O__F6.1999q4:"])
aall[F6..S2.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF6L[".S12T.FA__O__F6.1999q4:"])
aall[F6..S2.S11.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF6L[".S11.FA__O__F6.1999q4:"])
aall[F6..S2.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF6L[".S1M.FA__O__F6.1999q4:"])
aall[F6..S2.S13.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF6L[".S13.FA__O__F6.1999q4:"])
aall[F6..S2.S124.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF6L[".S124.FA__O__F6.1999q4:"])
aall[F6..S2.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF6L[".S12O.FA__O__F6.1999q4:"])
aall[F6..S2.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF6L[".S12Q.FA__O__F6.1999q4:"])
aall[F6..S2.S12R.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF6L[".S12M.FA__O__F6.1999q4:"])

## F81  - Assets for Qdata
# Process F81 from Direct Investment and Other Investment
print('filling NAs of crossborder F81 assets')
aaF81 = laiip[..FA__D__F81+FA__O__F81.]
ppF81A = copy(aaF81[..FA__D__F81+FA__O__F81.])
aall[F81..S121.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF81A[".S121.FA__D__F81.1999q4:"])+zerofiller(ppF81A[".S121.FA__O__F81.1999q4:"])
aall[F81..S12T.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF81A[".S12T.FA__D__F81.1999q4:"])+zerofiller(ppF81A[".S12T.FA__O__F81.1999q4:"])
aall[F81..S11.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF81A[".S11.FA__D__F81.1999q4:"])+zerofiller(ppF81A[".S11.FA__O__F81.1999q4:"])
aall[F81..S1M.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF81A[".S1M.FA__D__F81.1999q4:"])+zerofiller(ppF81A[".S1M.FA__O__F81.1999q4:"])
aall[F81..S13.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF81A[".S13.FA__D__F81.1999q4:"])+zerofiller(ppF81A[".S13.FA__O__F81.1999q4:"])
aall[F81..S124.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF81A[".S124.FA__D__F81.1999q4:"])+zerofiller(ppF81A[".S124.FA__O__F81.1999q4:"])
aall[F81..S12O.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF81A[".S12O.FA__D__F81.1999q4:"])+zerofiller(ppF81A[".S12O.FA__O__F81.1999q4:"])
aall[F81..S12Q.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF81A[".S12M.FA__D__F81.1999q4:"])+zerofiller(ppF81A[".S12M.FA__O__F81.1999q4:"])

print('filling NAs of crossborder F81 liabilities')
llF81 = lliip[..FA__D__F81+FA__O__F81.]
ppF81L = copy(llF81[..FA__D__F81+FA__O__F81.])
aall[F81..S2.S121.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF81L[".S121.FA__D__F81.1999q4:"])+zerofiller(ppF81L[".S121.FA__O__F81.1999q4:"])
aall[F81..S2.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF81L[".S12T.FA__D__F81.1999q4:"])+zerofiller(ppF81L[".S12T.FA__O__F81.1999q4:"])
aall[F81..S2.S11.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF81L[".S11.FA__D__F81.1999q4:"])+zerofiller(ppF81L[".S11.FA__O__F81.1999q4:"])
aall[F81..S2.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF81L[".S1M.FA__D__F81.1999q4:"])+zerofiller(ppF81L[".S1M.FA__O__F81.1999q4:"])
aall[F81..S2.S13.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF81L[".S13.FA__D__F81.1999q4:"])+zerofiller(ppF81L[".S13.FA__O__F81.1999q4:"])
aall[F81..S2.S124.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF81L[".S124.FA__D__F81.1999q4:"])+zerofiller(ppF81L[".S124.FA__O__F81.1999q4:"])
aall[F81..S2.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF81L[".S12O.FA__D__F81.1999q4:"])+zerofiller(ppF81L[".S12O.FA__O__F81.1999q4:"])
aall[F81..S2.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF81L[".S12Q.FA__D__F81.1999q4:"])+zerofiller(ppF81L[".S12Q.FA__O__F81.1999q4:"])
aall[F81..S2.S12R.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF81L[".S12M.FA__D__F81.1999q4:"])+zerofiller(ppF81L[".S12M.FA__O__F81.1999q4:"])

## F89  - Assets for Qdata
# Process F89 from Other Investment
print('filling NAs of crossborder F89 assets')
aaF89 = laiip[..FA__O__F89., drop=FALSE]
ppF89A = copy(aaF89[..FA__O__F89., drop=FALSE])
aall[F89..S121.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF89A[".S121.FA__O__F89.1999q4:"])
aall[F89..S12T.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF89A[".S12T.FA__O__F89.1999q4:"])
aall[F89..S11.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF89A[".S11.FA__O__F89.1999q4:"])
aall[F89..S1M.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF89A[".S1M.FA__O__F89.1999q4:"])
aall[F89..S13.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF89A[".S13.FA__O__F89.1999q4:"])
aall[F89..S124.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF89A[".S124.FA__O__F89.1999q4:"])
aall[F89..S12O.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF89A[".S12O.FA__O__F89.1999q4:"])
aall[F89..S12Q.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF89A[".S12Q.FA__O__F89.1999q4:"])
aall[F89..S12R.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF89A[".S12M.FA__O__F89.1999q4:"])

## F89  - Liabilities for Qdata
# Process F89 from Other Investment
print('filling NAs of crossborder F89 liabilities')
llF89 = lliip[..FA__O__F89., drop=FALSE]
ppF89L = copy(llF89[..FA__O__F89., drop=FALSE])
aall[F89..S2.S121.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF89L[".S121.FA__O__F89.1999q4:"])
aall[F89..S2.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF89L[".S12T.FA__O__F89.1999q4:"])
aall[F89..S2.S11.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF89L[".S11.FA__O__F89.1999q4:"])
aall[F89..S2.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF89L[".S1M.FA__O__F89.1999q4:"])
aall[F89..S2.S13.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF89L[".S13.FA__O__F89.1999q4:"])
aall[F89..S2.S124.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF89L[".S124.FA__O__F89.1999q4:"])
aall[F89..S2.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF89L[".S12O.FA__O__F89.1999q4:"])
aall[F89..S2.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF89L[".S12Q.FA__O__F89.1999q4:"])
aall[F89..S2.S12R.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF89L[".S12M.FA__O__F89.1999q4:"])

# Save final rounded data
saveRDS(aall, file.path(data_dir, 'aall6.rds'))
