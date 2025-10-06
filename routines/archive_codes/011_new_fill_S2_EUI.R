library(MDecfin)

# Load assets data
laiip = readRDS(file.path(data_dir,"iip6_assets_EUIeu.rds"))
labop = readRDS(file.path(data_dir,"bop6_assets_EUIeu.rds"))
# Load liabilities data
lliip = readRDS(file.path(data_dir,"iip6_liabilities_EUIeu.rds"))
llbop = readRDS(file.path(data_dir,"bop6_liabilities_EUIeu.rds"))

#temp load current aall version
aall=readRDS(file.path(data_dir,'aall7_funcat.rds'))
setkey(aall, NULL)

### data structure
names(dimnames(laiip))[[1]] = 'REF_AREA'
names(dimnames(laiip))[[2]] = 'REF_SECTOR'
names(dimnames(labop))[[1]] = 'REF_AREA'
names(dimnames(labop))[[2]] = 'REF_SECTOR'
names(dimnames(lliip))[[1]] = 'REF_AREA'
names(dimnames(lliip))[[2]] = 'REF_SECTOR'
names(dimnames(llbop))[[1]] = 'REF_AREA'
names(dimnames(llbop))[[2]] = 'REF_SECTOR'


### sectors
sss=c('S121','S12T','S13','S11','S1M','S124','S12O','S12Q','S1')

## stocks F total - Assets for Qdata 
aaF = laiip[..FA__D__F+FA__P__F+FA__O__F+FA__R__F+FA__F__F7.]
ppFA=copy(aaF["..FA__D__F+FA__P__F+FA__O__F+FA__R__F+FA__F__F7.1999q4:"])

aall['F',,sss,'S2','LE','_D',,'4A', usenames=TRUE, onlyna=TRUE] = ppFA[,sss,"FA__D__F",]
aall[F..S12R.S2.LE._D..4A, usenames=TRUE, onlyna=TRUE] = ppFA[".S12M.FA__D__F.1999q4:"]
aall['F',,sss,'S2','LE','_O',,'4A', usenames=TRUE, onlyna=TRUE] = ppFA[,sss,"FA__O__F",]
aall[F..S12R.S2.LE._O..4A, usenames=TRUE, onlyna=TRUE] = ppFA[".S12M.FA__O__F.1999q4:"]
aall['F',,sss,'S2','LE','_P',,'4A', usenames=TRUE, onlyna=TRUE] = ppFA[,sss,"FA__P__F",]
aall[F..S12R.S2.LE._P..4A, usenames=TRUE, onlyna=TRUE] = ppFA[".S12M.FA__P__F.1999q4:"]
aall['F',,sss,'S2','LE','_F',,'4A', usenames=TRUE, onlyna=TRUE] = ppFA[,sss,"FA__F__F7",]
aall[F..S12R.S2.LE._P..4A, usenames=TRUE, onlyna=TRUE] = ppFA[".S12M.FA__F__F7.1999q4:"]
aall[F..S121.S2.LE._R..4A, usenames=TRUE, onlyna=TRUE] = ppFA[".S121.FA__R__F.1999q4:"]

## flows F total - Assets for Qdata
aaFt = labop[..FA__D__F+FA__P__F+FA__O__F+FA__R__F+FA__F__F7.]
ppFAt=copy(aaFt["..FA__D__F+FA__P__F+FA__O__F+FA__R__F+FA__F__F7.1999q4:"])

aall['F',,sss,'S2','F','_D',,'4A', usenames=TRUE, onlyna=TRUE] = ppFAt[,sss,"FA__D__F",]
aall[F..S11.S2.F._D..4A, usenames=TRUE, onlyna=TRUE] = ppFAt[".S1V.FA__D__F.1999q4:"]
aall[F..S12R.S2.F._D..4A, usenames=TRUE, onlyna=TRUE] = ppFAt[".S12M.FA__D__F.1999q4:"]
aall['F',,sss,'S2','F','_O',,'4A', usenames=TRUE, onlyna=TRUE] = ppFAt[,sss,"FA__O__F",]
aall[F..S11.S2.F._O..4A, usenames=TRUE, onlyna=TRUE] = ppFAt[".S1V.FA__O__F.1999q4:"]
aall[F..S12R.S2.F._O..4A, usenames=TRUE, onlyna=TRUE] = ppFAt[".S12M.FA__O__F.1999q4:"]
aall['F',,sss,'S2','F','_P',,'4A', usenames=TRUE, onlyna=TRUE] = ppFAt[,sss,"FA__P__F",]
aall[F..S11.S2.F._P..4A, usenames=TRUE, onlyna=TRUE] = ppFAt[".S1V.FA__P__F.1999q4:"]
aall[F..S12R.S2.F._P..4A, usenames=TRUE, onlyna=TRUE] = ppFAt[".S12M.FA__P__F.1999q4:"]
aall['F',,sss,'S2','F','_F',,'4A', usenames=TRUE, onlyna=TRUE] = ppFAt[,sss,"FA__F__F7",]
aall[F..S11.S2.F._F..4A, usenames=TRUE, onlyna=TRUE] = ppFAt[".S1V.FA__F__F7.1999q4:"]
aall[F..S12R.S2.F._F..4A, usenames=TRUE, onlyna=TRUE] = ppFAt[".S12M.FA__F__F7.1999q4:"]
aall[F..S121.S2.F._R..4A, usenames=TRUE, onlyna=TRUE] = ppFAt[".S121.FA__R__F.1999q4:"]

# Process F (sum of F per functional categories)
print('filling NAs of crossborder financial liabilities')

## stocks F total - liabilities for Qdata
llF = lliip[..FA__D__F+FA__P__F+FA__O__F+FA__F__F7.]
ppFL = copy(llF["..FA__D__F+FA__P__F+FA__O__F+FA__F__F7.1999q4:"])
names(dimnames(ppFL))[[2]] = 'COUNTERPART_SECTOR'

aall['F',,'S2',sss,'LE','_D',,'4A', usenames=TRUE, onlyna=TRUE] = ppFL[,sss,"FA__D__F",]
aall[F..S2.S12R.LE._D..4A, usenames=TRUE, onlyna=TRUE] = ppFL[".S12M.FA__D__F.1999q4:"]
aall['F',,'S2',sss,'LE','_O',,'4A', usenames=TRUE, onlyna=TRUE] = ppFL[,sss,"FA__O__F",]
aall[F..S2.S12R.LE._O..4A, usenames=TRUE, onlyna=TRUE] = ppFL[".S12M.FA__O__F.1999q4:"]
aall['F',,'S2',sss,'LE','_P',,'4A', usenames=TRUE, onlyna=TRUE] = ppFL[,sss,"FA__P__F",]
aall[F..S2.S12R.LE._P..4A, usenames=TRUE, onlyna=TRUE] = ppFL[".S12M.FA__P__F.1999q4:"]
aall['F',,'S2',sss,'LE','_F',,'4A', usenames=TRUE, onlyna=TRUE] = ppFL[,sss,"FA__F__F7",]
aall[F..S2.S12R.LE._F..4A, usenames=TRUE, onlyna=TRUE] = ppFL[".S12M.FA__F__F7.1999q4:"]


## flows F total - liabilities for Qdata
lltF = llbop[..FA__D__F+FA__P__F+FA__O__F+FA__F__F7.]
ppFLt = copy(lltF["..FA__D__F+FA__P__F+FA__O__F+FA__F__F7.1999q4:"])
names(dimnames(ppFLt))[[2]] = 'COUNTERPART_SECTOR'

aall['F',,'S2',sss,'F','_D',,'4A', usenames=TRUE, onlyna=TRUE] = ppFLt[,sss,"FA__D__F",]
aall[F..S2.S11.F._D..4A, usenames=TRUE, onlyna=TRUE] = ppFLt[".S1V.FA__D__F.1999q4:"]
aall[F..S2.S12R.F._D..4A, usenames=TRUE, onlyna=TRUE] = ppFLt[".S12M.FA__D__F.1999q4:"]
aall['F',,'S2',sss,'F','_O',,'4A', usenames=TRUE, onlyna=TRUE] = ppFLt[,sss,"FA__O__F",]
aall[F..S2.S11.F._O..4A, usenames=TRUE, onlyna=TRUE] = ppFLt[".S1V.FA__O__F.1999q4:"]
aall[F..S2.S12R.F._O..4A, usenames=TRUE, onlyna=TRUE] = ppFLt[".S12M.FA__O__F.1999q4:"]
aall['F',,'S2',sss,'F','_P',,'4A', usenames=TRUE, onlyna=TRUE] = ppFLt[,sss,"FA__P__F",]
aall[F..S2.S11.F._P..4A, usenames=TRUE, onlyna=TRUE] = ppFLt[".S1V.FA__P__F.1999q4:"]
aall[F..S2.S12R.F._P..4A, usenames=TRUE, onlyna=TRUE] = ppFLt[".S12M.FA__P__F.1999q4:"]
aall['F',,'S2',sss,'F','_F',,'4A', usenames=TRUE, onlyna=TRUE] = ppFLt[,sss,"FA__F__F7",]
aall[F..S2.S11.F._F..4A, usenames=TRUE, onlyna=TRUE] = ppFLt[".S1V.FA__F__F7.1999q4:"]
aall[F..S2.S12R.F._F..4A, usenames=TRUE, onlyna=TRUE] = ppFLt[".S12M.FA__F__F7.1999q4:"]

# Process F2M (sum of F22 and F29)
print('filling NAs of crossborder F2M assets')
##stocks F2 deposits and currency - Assets for Qdata
aaF2 = laiip[..FA__O__F2+FA__R__F2.]
ppF2M = copy(aaF2["..FA__O__F2+FA__R__F2.1999q4:"])

aall['F2M',,sss,'S2','LE','_O',,'4A', usenames=TRUE, onlyna=TRUE] = ppF2M[,sss,"FA__O__F2",]
aall[F2M..S12R.S2.LE._O..4A, usenames=TRUE, onlyna=TRUE] = ppF2M[".S12M.FA__O__F2.1999q4:"]
aall[F2M..S121.S2.LE.FNR..4A, usenames=TRUE] = ppF2M[".S121.FA__R__F2.1999q4:"]

##flows F2 deposits and currency - Assets for Qdata
aaF2t = labop[..FA__O__F2+FA__R__F2.]
ppF2Mt = copy(aaF2t["..FA__O__F2+FA__R__F2.1999q4:"])

aall['F2M',,sss,'S2','F','_O',,'4A', usenames=TRUE, onlyna=TRUE] = ppF2Mt[,sss,"FA__O__F2",]
aall[F2M..S12R.S2.F._O..4A, usenames=TRUE, onlyna=TRUE] = ppF2Mt[".S12M.FA__O__F2.1999q4:"]
aall[F2M..S121.S2.F.FNR..4A, usenames=TRUE] = ppF2Mt[".S121.FA__R__F2.1999q4:"]

# Process F2M (sum of F22 and F29)
print('filling NAs of crossborder F2M liabilities')
## stocks F2 deposits and currency - Liabilities for Qdata
llF2 = lliip[..FA__O__F2+FA__R__F2.]
ppF2M = copy(llF2["..FA__O__F2+FA__R__F2.1999q4:"])
names(dimnames(ppF2M))[[2]] = 'COUNTERPART_SECTOR'

aall['F2M',,'S2',sss,'LE','_O',,'4A', usenames=TRUE, onlyna=TRUE] = ppF2M[,sss,"FA__O__F2",]
aall[F2M..S2.S121.LE._R..4A, usenames=TRUE, onlyna=TRUE] = ppF2M[".S121.FA__R__F2.1999q4:"]

## flows F2 deposits and currency - Liabilities for Qdata
llF2t = llbop[..FA__O__F2+FA__R__F2.]
ppF2Mt = copy(llF2t["..FA__O__F2+FA__R__F2.1999q4:"])
names(dimnames(ppF2Mt))[[2]] = 'COUNTERPART_SECTOR'

aall['F2M',,'S2',sss,'F','_O',,'4A', usenames=TRUE, onlyna=TRUE] = ppF2M[,sss,"FA__O__F2",]
aall[F2M..S2.S121.F._R..4A, usenames=TRUE, onlyna=TRUE] = ppF2Mt[".S121.FA__R__F2.1999q4:"]

# Process F3 (from Direct Investment, Portfolio Investment, Reserve Assets)
print('filling NAs of crossborder F3 assets')
## stocks F3 bonds total - Assets for Qdata
aaF3M = laiip[..FA__D__F3+FA__P__F3+FA__R__F3.]
ppF3MA = copy(aaF3M["..FA__D__F3+FA__P__F3+FA__R__F3.1999q4:"])

aall['F3',,sss,'S2','LE','_D',,'4A', usenames=TRUE, onlyna=TRUE] = ppF3MA[,sss,"FA__D__F3",]
aall[F3..S12R.S2.LE._D..4A, usenames=TRUE, onlyna=TRUE] = ppF3MA[".S12M.FA__D__F3.1999q4:"]
aall['F3',,sss,'S2','LE','_P',,'4A', usenames=TRUE, onlyna=TRUE] = ppF3MA[,sss,"FA__P__F3",]
aall[F3..S12R.S2.LE._P..4A, usenames=TRUE, onlyna=TRUE] = ppF3MA[".S12M.FA__P__F3.1999q4:"]
aall[F3..S121.S2.LE._R..4A, usenames=TRUE, onlyna=TRUE] = ppF3MA[".S121.FA__R__F3.1999q4:"]

## flows F3 bonds total - Assets for Qdata
aaF3Mt = labop[..FA__D__F3+FA__P__F3+FA__R__F3.]
ppF3MAt = copy(aaF3Mt["..FA__D__F3+FA__P__F3+FA__R__F3.1994q4:"])

aall['F3',,sss,'S2','F','_D',,'4A', usenames=TRUE, onlyna=TRUE] = ppF3MAt[,sss,"FA__D__F3",]
aall[F3..S11.S2.F._D..4A, usenames=TRUE, onlyna=TRUE] = ppF3MAt[".S1V.FA__D__F3.1999q4:"]
aall[F3..S12R.S2.F._D..4A, usenames=TRUE, onlyna=TRUE] = ppF3MAt[".S12M.FA__D__F3.1999q4:"]
aall['F3',,sss,'S2','F','_P',,'4A', usenames=TRUE, onlyna=TRUE] = ppF3MAt[,sss,"FA__P__F3",]
aall[F3..S11.S2.F._P..4A, usenames=TRUE, onlyna=TRUE] = ppF3MAt[".S1V.FA__P__F3.1999q4:"]
aall[F3..S12R.S2.F._P..4A, usenames=TRUE, onlyna=TRUE] = ppF3MAt[".S12M.FA__P__F3.1999q4:"]
aall[F3..S121.S2.F._R..4A, usenames=TRUE, onlyna=TRUE] = ppF3MAt[".S121.FA__R__F3.1999q4:"]

## F3 bonds total - liabilities for Qdata
# Process F3 (from Direct Investment, Portfolio Investment)
print('filling NAs of crossborder F3 liabilities')
## stocks F3 bonds total - liabilities for Qdata
llF3M = lliip[..FA__D__F3+FA__P__F3.]
ppF3ML = copy(llF3M["..FA__D__F3+FA__P__F3.1999q4:"])
names(dimnames(ppF3ML))[[2]] = 'COUNTERPART_SECTOR'

aall['F3',,'S2',sss,'LE','_D',,'4A', usenames=TRUE, onlyna=TRUE] = ppF3ML[,sss,"FA__D__F3",]
aall[F3..S2.S12R.LE._D..4A, usenames=TRUE, onlyna=TRUE] = ppF3ML[".S12M.FA__D__F3.1999q4:"]
aall['F3',,'S2',sss,'LE','_P',,'4A', usenames=TRUE, onlyna=TRUE] = ppF3ML[,sss,"FA__P__F3",]
aall[F3..S2.S12R.LE._P..4A, usenames=TRUE, onlyna=TRUE] = ppF3ML[".S12M.FA__P__F3.1999q4:"]

## flows F3 bonds total - liabilities for Qdata
llF3Mt = llbop[..FA__D__F3+FA__P__F3.]
ppF3MLt = copy(llF3Mt["..FA__D__F3+FA__P__F3.1994q4:"])
names(dimnames(ppF3MLt))[[2]] = 'COUNTERPART_SECTOR'

aall['F3',,'S2',sss,'F','_D',,'4A', usenames=TRUE, onlyna=TRUE] = ppF3MLt[,sss,"FA__D__F3",]
aall[F3..S2.S11.F._D..4A, usenames=TRUE, onlyna=TRUE] = ppF3MLt[".S1V.FA__D__F3.1999q4:"]
aall[F3..S2.S12R.F._D..4A, usenames=TRUE, onlyna=TRUE] = ppF3MLt[".S12M.FA__D__F3.1999q4:"]
aall['F3',,'S2',sss,'F','_P',,'4A', usenames=TRUE, onlyna=TRUE] = ppF3MLt[,sss,"FA__P__F3",]
aall[F3..S2.S11.F._P..4A, usenames=TRUE, onlyna=TRUE] = ppF3MLt[".S1V.FA__P__F3.1999q4:"]
aall[F3..S2.S12R.F._P..4A, usenames=TRUE, onlyna=TRUE] = ppF3MLt[".S12M.FA__P__F3.1999q4:"]

# Process F4 (sum of F4 from Direct Investment, Other Investment)
print('filling NAs of crossborder F4 assets')
## stocks F4 loans total - Assets for Qdata
aaF4 = laiip[..FA__D__F4+FA__O__F4.]
ppF4A = copy(aaF4["..FA__D__F4+FA__O__F4.1994q4:"])

aall['F4',,sss,'S2','LE','_D',,'4A', usenames=TRUE, onlyna=TRUE] = ppF4A[,sss,"FA__D__F4",]
aall[F4..S12R.S2.LE._D..4A, usenames=TRUE, onlyna=TRUE] = ppF4A[".S12M.FA__D__F4.1999q4:"]
aall['F4',,sss,'S2','LE','_O',,'4A', usenames=TRUE, onlyna=TRUE] = ppF4A[,sss,"FA__O__F4",]
aall[F4..S12R.S2.LE._O..4A, usenames=TRUE, onlyna=TRUE] = ppF4A[".S12M.FA__O__F4.1999q4:"]

## flows F4 loans total - Assets for Qdata
aaF4t = labop[..FA__D__F4+FA__O__F4.]
ppF4At = copy(aaF4t["..FA__D__F4+FA__O__F4.1994q4:"])

aall['F4',,sss,'S2','F','_D',,'4A', usenames=TRUE, onlyna=TRUE] = ppF4At[,sss,"FA__D__F4",]
aall[F4..S11.S2.F._D..4A, usenames=TRUE, onlyna=TRUE] = ppF4At[".S1V.FA__D__F4.1999q4:"]
aall[F4..S12R.S2.F._D..4A, usenames=TRUE, onlyna=TRUE] = ppF4At[".S12M.FA__D__F4.1999q4:"]

aall['F4',,sss,'S2','F','_O',,'4A', usenames=TRUE, onlyna=TRUE] = ppF4At[,sss,"FA__O__F4",]
aall[F4..S11.S2.F._O..4A, usenames=TRUE, onlyna=TRUE] = ppF4At[".S1V.FA__O__F4.1999q4:"]
aall[F4..S12R.S2.F._O..4A, usenames=TRUE, onlyna=TRUE] = ppF4At[".S12M.FA__O__F4.1999q4:"]


# Process F4 (sum of F4 from Direct Investment, Other Investment)
print('filling NAs of crossborder F4 liabilities')
## stocks F4 loans total - liabilities for Qdata
llF4 = lliip[..FA__D__F4+FA__O__F4.]
ppF4L = copy(llF4["..FA__D__F4+FA__O__F4.1999q4:"])
names(dimnames(ppF4L))[[2]] = 'COUNTERPART_SECTOR'

aall['F4',,'S2',sss,'LE','_D',,'4A', usenames=TRUE, onlyna=TRUE] = ppF4L[,sss,"FA__D__F4",]
aall[F4..S2.S12R.LE._D..4A, usenames=TRUE, onlyna=TRUE] = ppF4L[".S12R.FA__D__F4.1999q4:"]
aall['F4',,'S2',sss,'LE','_O',,'4A', usenames=TRUE, onlyna=TRUE] = ppF4L[,sss,"FA__O__F4",]
aall[F4..S2.S12R.LE._O..4A, usenames=TRUE, onlyna=TRUE] = ppF4L[".S12R.FA__O__F4.1999q4:"]

## flows F4 loans total - liabilities for Qdata
llF4t = llbop[..FA__D__F4+FA__O__F4.]
ppF4Lt = copy(llF4t["..FA__D__F4+FA__O__F4.1999q4:"])
names(dimnames(ppF4Lt))[[2]] = 'COUNTERPART_SECTOR'

aall['F4',,'S2',sss,'F','_D',,'4A', usenames=TRUE, onlyna=TRUE] = ppF4Lt[,sss,"FA__D__F4",]
aall[F4..S2.S11.F._D..4A, usenames=TRUE, onlyna=TRUE] = ppF4Lt[".S1V.FA__D__F4.1999q4:"]
aall[F4..S2.S12R.F._D..4A, usenames=TRUE, onlyna=TRUE] = ppF4Lt[".S12R.FA__D__F4.1999q4:"]
aall['F4',,'S2',sss,'F','_O',,'4A', usenames=TRUE, onlyna=TRUE] = ppF4Lt[,sss,"FA__O__F4",]
aall[F4..S2.S11.F._O..4A, usenames=TRUE, onlyna=TRUE] = ppF4Lt[".S1V.FA__O__F4.1999q4:"]
aall[F4..S2.S12R.F._O..4A, usenames=TRUE, onlyna=TRUE] = ppF4Lt[".S12R.FA__O__F4.1999q4:"]

# Process F52 ( Portfolio Investment)
print('filling NAs of crossborder F52 assets')
## stocks F52 investment fund shares - Assets for Qdata
aaF52 = laiip[..FA__P__F52., drop=FALSE]
ppF52A = copy(aaF52["..FA__P__F52.1999q4:", drop=FALSE])

aall['F52',,sss,'S2','LE','_P',,'4A', usenames=TRUE, onlyna=TRUE] = ppF52A[,sss,"FA__P__F52",]
aall[F52..S12R.S2.LE._P..4A, usenames=TRUE, onlyna=TRUE] = ppF52A[".S12M.FA__P__F52.1999q4:"]

## flows F52 investment fund shares - Assets for Qdata
aaF52t = labop[..FA__P__F52., drop=FALSE]
ppF52At = copy(aaF52t["..FA__P__F52.1999q4:", drop=FALSE])

aall['F52',,sss,'S2','F','_P',,'4A', usenames=TRUE, onlyna=TRUE] = ppF52At[,sss,"FA__P__F52",]
aall[F52..S12R.S2.F._P..4A, usenames=TRUE, onlyna=TRUE] = ppF52At[".S12M.FA__P__F52.1999q4:"]

# Process F52 ( Portfolio Investment)
print('filling NAs of crossborder F52 liabilities')
## stocks F52 investment fund shares - Liabilities for Qdata
llF52 = lliip[..FA__P__F52., drop=FALSE]
ppF52L = copy(llF52["..FA__P__F52.1999q4:", drop=FALSE])
names(dimnames(ppF52L))[[2]] = 'COUNTERPART_SECTOR'

aall['F52',,'S2',sss,'LE','_P',,'4A', usenames=TRUE, onlyna=TRUE] = ppF52L[,sss,"FA__P__F52",]
aall[F52..S2.S12R.LE._P..4A, usenames=TRUE, onlyna=TRUE] = ppF52L[".S12M.FA__P__F52.1999q4:"]

## flows F52 investment fund shares - Liabilities for Qdata
llF52t = llbop[..FA__P__F52., drop=FALSE]
ppF52Lt = copy(llF52t["..FA__P__F52.1999q4:", drop=FALSE])
names(dimnames(ppF52Lt))[[2]] = 'COUNTERPART_SECTOR'

aall['F52',,'S2',sss,'F','_P',,'4A', usenames=TRUE, onlyna=TRUE] = ppF52Lt[,sss,"FA__P__F52",]
aall[F52..S2.S11.F._P..4A, usenames=TRUE, onlyna=TRUE] = ppF52Lt[".S1V.FA__P__F52.1999q4:"]
aall[F52..S2.S12R.F._P..4A, usenames=TRUE, onlyna=TRUE] = ppF52Lt[".S12M.FA__P__F52.1999q4:"]

# Process F511 (sum of F511 from Direct Investment and Portfolio Investment)
print('filling NAs of crossborder F511 assets')
## stocks F511 listed shares - Assets for Qdata
aaF511 = laiip[..FA__D__F511+FA__P__F511.]
ppF511A = copy(aaF511["..FA__D__F511+FA__P__F511.1999q4:"])

aall['F511',,sss,'S2','LE','_D',,'4A', usenames=TRUE, onlyna=TRUE] = ppF511A[,sss,"FA__D__F511",]
aall[F511..S12R.S2.LE._D..4A, usenames=TRUE, onlyna=TRUE] = ppF511A[".S12M.FA__D__F511.1999q4:"]
aall['F511',,sss,'S2','LE','_P',,'4A', usenames=TRUE, onlyna=TRUE] = ppF511A[,sss,"FA__P__F511",]
aall[F511..S12R.S2.LE._P..4A, usenames=TRUE, onlyna=TRUE] = ppF511A[".S12M.FA__P__F511.1999q4:"]

## flows F511 listed shares - Assets for Qdata
aaF511t = labop[..FA__D__F511+FA__T__F511.]
ppF511At = copy(aaF511t["..FA__D__F511+FA__T__F511.1999q4:"])

aall['F511',,sss,'S2','F','_D',,'4A', usenames=TRUE, onlyna=TRUE] = ppF511At[,sss,"FA__D__F511",]
aall[F511..S11.S2.F._D..4A, usenames=TRUE, onlyna=TRUE] = ppF511At[".S1V.FA__D__F511.1999q4:"]
aall[F511..S12R.S2.F._D..4A, usenames=TRUE, onlyna=TRUE] = ppF511At[".S12M.FA__D__F511.1999q4:"]
aall['F511',,sss,'S2','F','_P',,'4A', usenames=TRUE, onlyna=TRUE] = ppF511At[,sss,"FA__P__F511",]
aall[F511..S11.S2.F._P..4A, usenames=TRUE, onlyna=TRUE] = ppF511At[".S1V.FA__P__F511.1999q4:"]
aall[F511..S12R.S2.F._P..4A, usenames=TRUE, onlyna=TRUE] = ppF511At[".S12M.FA__P__F511.1999q4:"]

# Process F511 (sum of F511 from Direct Investment and Portfolio Investment)
print('filling NAs of crossborder F511 liabiities')
## stocks F511 listed shares - Liabilities for Qdata
llF511 = lliip[..FA__D__F511+FA__P__F511.]
ppF511L = copy(llF511["..FA__D__F511+FA__P__F511.1999q4:"])
names(dimnames(ppF511L))[[2]] = 'COUNTERPART_SECTOR'

aall['F511',,'S2',sss,'LE','_D',,'4A', usenames=TRUE, onlyna=TRUE] = ppF511L[,sss,"FA__D__F511",]
aall[F511..S2.S12R.LE._D..4A, usenames=TRUE, onlyna=TRUE] = ppF511L[".S12M.FA__D__F511.1999q4:"]
aall['F511',,'S2',sss,'LE','_P',,'4A', usenames=TRUE, onlyna=TRUE] = ppF511L[,sss,"FA__P__F511",]
aall[F511..S2.S12R.LE._P..4A, usenames=TRUE, onlyna=TRUE] = ppF511L[".S12M.FA__P__F511.1999q4:"]

## flows F511 listed shares - Liabilities for Qdata
llF511t = llbop[..FA__D__F511+FA__P__F511.]
ppF511Lt = copy(llF511t["..FA__D__F511+FA__P__F511.1999q4:"])
names(dimnames(ppF511Lt))[[2]] = 'COUNTERPART_SECTOR'

aall['F511',,'S2',sss,'F','_D',,'4A', usenames=TRUE, onlyna=TRUE] = ppF511Lt[,sss,"FA__D__F511",]
aall[F511..S2.S11.F._D..4A, usenames=TRUE, onlyna=TRUE] = ppF511L[".S1V.FA__D__F511.1999q4:"]
aall[F511..S2.S12R.F._D..4A, usenames=TRUE, onlyna=TRUE] = ppF511L[".S12M.FA__D__F511.1999q4:"]

aall['F511',,'S2',sss,'F','_P',,'4A', usenames=TRUE, onlyna=TRUE] = ppF511Lt[,sss,"FA__P__F511",]
aall[F511..S2.S11.F._P..4A, usenames=TRUE, onlyna=TRUE] = ppF511Lt[".S1V.FA__P__F511.1999q4:"]
aall[F511..S2.S12R.F._P..4A, usenames=TRUE, onlyna=TRUE] = ppF511Lt[".S12M.FA__P__F511.1999q4:"]

##############################################################
################special case for HH assets ###################
##############################################################
# Process F511 from PI as F511 due to missing regional information otherwise
## stocks F511 listed shares - Assets for Qdata
aaF511 = laiip[..FA__P__F51.]
ppF511A = copy(aaF511[..FA__P__F51.])

aall[F511..S1M.S2.LE._P.4A, usenames=TRUE, onlyna=TRUE] = ppF511A[".S1M.FA__P__F51.1999q4:"]

## flows F511 listed shares - Assets for Qdata
aaF511t = labop[..FA__D__F511+FA__T__F511.]
ppF511At = copy(aaF511t["..FA__D__F511+FA__T__F511.1999q4:"])

aall[F511..S11.S2.F._P., usenames=TRUE, onlyna=TRUE] = ppF511At[".S1V.FA__P__F511.1999q4:"]

##############################################################
##############################################################
##############################################################



# Process F51M (sum of F512 and F519 from Direct Investment, Other Investment, Portfolio Investment)
# checkFDI to see if F51M or F512+F519 are filled for Q data 
#check = aa[..FA__D__F51M.2022q4]- aa[..FA__D__F512+FA__D__F519.2022q4] 
print('filling NAs of crossborder F52M assets')
## stocks F51M other equity - Assets for Qdata
aaF51M = laiip[..FA__D__F51M+FA__O__F519+FA__P__F512.]
ppF51MA = copy(aaF51M["..FA__D__F51M+FA__O__F519+FA__P__F512.1999q4:"])

aall['F51M',,sss,'S2','LE','_D',,'4A', usenames=TRUE, onlyna=TRUE] = ppF51MA[,sss,"FA__D__F51M",]
aall[F51M..S12R.S2.LE._D..4A, usenames=TRUE, onlyna=TRUE] = ppF51MA[".S12M.FA__D__F51M.1999q4:"]
aall['F51M',,sss,'S2','LE','_P',,'4A', usenames=TRUE, onlyna=TRUE] = ppF51MA[,sss,".FA__P__F512",]
aall[F51M..S12R.S2.LE._P..4A, usenames=TRUE, onlyna=TRUE] = ppF51MA[".S12M.FA__P__F512.1999q4:"]
aall['F51M',,sss,'S2','LE','_O',,'4A', usenames=TRUE, onlyna=TRUE] = ppF51MA[,sss,"FA__O__F519",]
aall[F51M..S12R.S2.LE._O..4A, usenames=TRUE, onlyna=TRUE] = ppF51MA[".S12M.FA__O__F519.1999q4:"]

## flows F51M other equity - Assets for Qdata
aaF51Mt = labop[..FA__D__F51M+FA__O__F519+FA__P__F512.]
ppF51MAt = copy(aaF51Mt["..FA__D__F51M+FA__O__F519+FA__P__F512.1999q4:"])

aall['F51M',,sss,'S2','F','_D',,'4A', usenames=TRUE, onlyna=TRUE] = ppF51MAt[,sss,"FA__D__F51M",]
aall[F51M..S11.S2.F._D..4A, usenames=TRUE, onlyna=TRUE] = ppF51MAt[".S1V.FA__D__F51M.1999q4:"]
aall[F51M..S12R.S2.F._D..4A, usenames=TRUE, onlyna=TRUE] = ppF51MAt[".S12M.FA__D__F51M.1999q4:"]
aall['F51M',,sss,'S2','F','_P',,'4A', usenames=TRUE, onlyna=TRUE] = ppF51MAt[,sss,"FFA__P__F512",]
aall[F51M..S11.S2.F._P..4A, usenames=TRUE, onlyna=TRUE] = ppF51MAt[".S1V.FA__P__F512.1999q4:"]
aall[F51M..S12R.S2.F._P..4A, usenames=TRUE, onlyna=TRUE] = ppF51MAt[".S12M.FA__P__F512.1999q4:"]
aall['F51M',,sss,'S2','F','_O',,'4A', usenames=TRUE, onlyna=TRUE] = ppF51MAt[,sss,"FA__O__F519",]
aall[F51M..S11.S2.F._O..4A, usenames=TRUE, onlyna=TRUE] = ppF51MAt[".S1V.FA__O__F519.1999q4:"]
aall[F51M..S12R.S2.F._O..4A, usenames=TRUE, onlyna=TRUE] = ppF51MAt[".S12M.FA__O__F519.1999q4:"]

# Process F51M (sum of F512 and F519 from Direct Investment, Other Investment, Portfolio Investment)
print('filling NAs of crossborder F52M liabilities')
## stocks F51M other equity - Liabilities for Qdata
llF51M = lliip[..FA__D__F51M+FA__O__F519+FA__P__F512.]
ppF51ML = copy(llF51M["..FA__D__F51M+FA__O__F519+FA__P__F512.1999q4:"])
names(dimnames(ppF51ML))[[2]] = 'COUNTERPART_SECTOR'

aall['F51M',,'S2',sss,'LE','_D',,'4A', usenames=TRUE, onlyna=TRUE] = ppF51ML[,sss,"FA__D__F51M",]
aall[F51M..S2.S12R.LE._D..4A, usenames=TRUE, onlyna=TRUE] = ppF51ML[".S12M.FA__D__F51M.1999q4:"]
aall['F51M',,'S2',sss,'LE','_P',,'4A', usenames=TRUE, onlyna=TRUE] = ppF51ML[,sss,"FA__P__F512",]
aall[F51M..S2.S12R.LE._P..4A, usenames=TRUE, onlyna=TRUE] = ppF51ML[".S12M.FA__P__F512.1999q4:"]
aall['F51M',,'S2',sss,'LE','_O',,'4A', usenames=TRUE, onlyna=TRUE] = ppF51ML[,sss,"FA__O__F519",]
aall[F51M..S2.S12R.LE._O..4A, usenames=TRUE, onlyna=TRUE] = ppF51ML[".S12M.FA__O__F519.1999q4:"]

## flows F51M other equity - Liabilities for Qdata
llF51Mt = llbop[..FA__D__F51M+FA__O__F519+FA__P__F512.]
ppF51MLt = copy(llF51Mt["..FA__D__F51M+FA__O__F519+FA__P__F512.1999q4:"])
names(dimnames(ppF51MLt))[[2]] = 'COUNTERPART_SECTOR'

aall['F51M',,'S2',sss,'F','_D',,'4A', usenames=TRUE, onlyna=TRUE] = ppF51MLt[,sss,"FA__D__F51M",]
aall[F51M..S2.S11.F._D..4A, usenames=TRUE, onlyna=TRUE] = ppF51MLt[".S1V.FA__D__F51M.1999q4:"]
aall[F51M..S2.S12R.F._D..4A, usenames=TRUE, onlyna=TRUE] = ppF51MLt[".S12M.FA__D__F51M.1999q4:"]
aall['F51M',,'S2',sss,'F','_P',,'4A', usenames=TRUE, onlyna=TRUE] = ppF51MLt[,sss,"FA__P__F512",]
aall[F51M..S2.S11.F._P..4A, usenames=TRUE, onlyna=TRUE] = ppF51MLt[".S1V.FA__P__F512.1999q4:"]
aall[F51M..S2.S12R.F._P., usenames=TRUE, onlyna=TRUE] = ppF51MLt[".S12M.FA__P__F512.1999q4:"]
aall['F51M',,'S2',sss,'F','_O',,'4A', usenames=TRUE, onlyna=TRUE] = ppF51MLt[,sss,"FA__O__F519",]
aall[F51M..S2.S11.F._O..4A, usenames=TRUE, onlyna=TRUE] = ppF51MLt[".S1V.FA__O__F519.1999q4:"]
aall[F51M..S2.S12R.F._O..4A, usenames=TRUE, onlyna=TRUE] = ppF51MLt[".S12M.FA__O__F519.1999q4:"]


# Process F6 Other Investment
print('filling NAs of crossborder F6 assets')
## stocks F6  - Assets for Qdata
aaF6 = laiip[..FA__O__F6., drop=FALSE]
ppF6A = copy(aaF6["..FA__O__F6.1999q4:", drop=FALSE])

aall['F6',,sss,'S2','LE','_O',,'4A', usenames=TRUE, onlyna=TRUE] = ppF6A[,sss,"FA__O__F6",]
aall[F6..S12R.S2.LE._O..4A, usenames=TRUE, onlyna=TRUE] = ppF6A[".S12M.FA__O__F6.1999q4:"]

## flows F6  - Assets for Qdata
aaF6t = labop[..FA__O__F6., drop=FALSE]
ppF6At = copy(aaF6t["..FA__O__F6.1999q4:", drop=FALSE])

aall['F6',,sss,'S2','F','_O',,'4A', usenames=TRUE, onlyna=TRUE] = ppF6At[,sss,"FA__O__F6",]
aall[F6..S11.S2.F._O..4A, usenames=TRUE, onlyna=TRUE] = ppF6At[".S1V.FA__O__F6.1999q4:"]
aall[F6..S12R.S2.F._O..4A, usenames=TRUE, onlyna=TRUE] = ppF6At[".S12M.FA__O__F6.1999q4:"]

# Process F6 Other Investment
print('filling NAs of crossborder F6 liabilities')
## stocks F6  - liabilities for Qdata
llF6 = lliip[..FA__O__F6., drop=FALSE]
ppF6L = copy(llF6["..FA__O__F6.1999q4:", drop=FALSE])
names(dimnames(ppF6L))[[2]] = 'COUNTERPART_SECTOR'

aall['F6',,'S2',sss,'LE','_O',,'4A', usenames=TRUE, onlyna=TRUE] = ppF6L[,sss,"FA__O__F6",]
aall[F6..S2.S12R.LE._O..4A, usenames=TRUE, onlyna=TRUE] = ppF6L[".S12M.FA__O__F6.1999q4:"]

## flows F6  - liabilities for Qdata
llF6t = llbop[..FA__O__F6., drop=FALSE]
ppF6Lt = copy(llF6t["..FA__O__F6.1999q4:", drop=FALSE])
names(dimnames(ppF6Lt))[[2]] = 'COUNTERPART_SECTOR'

aall['F6',,'S2',sss,'F','_O',,'4A', usenames=TRUE, onlyna=TRUE] = ppF6Lt[,sss,"FA__O__F6",]
aall[F6..S2.S11.F._O..4A, usenames=TRUE, onlyna=TRUE] = ppF6Lt[".S1V.FA__O__F6.1999q4:"]
aall[F6..S2.S12R.F._O..4A, usenames=TRUE, onlyna=TRUE] = ppF6Lt[".S12M.FA__O__F6.1999q4:"]


# Process F81 from Direct Investment and Other Investment
print('filling NAs of crossborder F81 assets')
## stocks F81  - Assets for Qdata
aaF81 = laiip[..FA__D__F81+FA__O__F81.]
ppF81A = copy(aaF81["..FA__D__F81+FA__O__F81.1999q4:"])

aall['F81',,sss,'S2','LE','_D',,'4A', usenames=TRUE, onlyna=TRUE] = ppF81A[,sss,"FA__D__F81",]
aall[F81..S12Q.S2.LE._D..4A, usenames=TRUE, onlyna=TRUE] = ppF81A[".S12M.FA__D__F81.1999q4:"]
aall['F81',,sss,'S2','LE','_O',,'4A', usenames=TRUE, onlyna=TRUE] = ppF81A[,sss,"FA__O__F81",]
aall[F81..S12Q.S2.LE._O..4A, usenames=TRUE, onlyna=TRUE] = ppF81A[".S12M.FA__O__F81.1999q4:"]

## flows F81  - Assets for Qdata
aaF81t = labop[..FA__D__F81+FA__O__F81.]
ppF81At = copy(aaF81t["..FA__D__F81+FA__O__F81.1999q4:"])

aall['F81',,sss,'S2','F','_D',,'4A', usenames=TRUE, onlyna=TRUE] = ppF81At[,sss,"FA__D__F81",]
aall[F81..S11.S2.F._D..4A, usenames=TRUE, onlyna=TRUE] = ppF81At[".S1V.FA__D__F81.1999q4:"]
aall[F81..S12Q.S2.F._D..4A, usenames=TRUE, onlyna=TRUE] = ppF81At[".S12M.FA__D__F81.1999q4:"]
aall['F81',,sss,'S2','F','_O',,'4A', usenames=TRUE, onlyna=TRUE] = ppF81At[,sss,"FA__O__F81",]
aall[F81..S11.S2.F._O..4A, usenames=TRUE, onlyna=TRUE] = ppF81At[".S1V.FA__O__F81.1999q4:"]
aall[F81..S12Q.S2.F._O..4A, usenames=TRUE, onlyna=TRUE] = ppF81At[".S12M.FA__O__F81.1999q4:"]


print('filling NAs of crossborder F81 liabilities')

## stocks F81  - Liabilities for Qdata
llF81 = lliip[..FA__D__F81+FA__O__F81.]
ppF81L = copy(llF81["..FA__D__F81+FA__O__F81.1999q4:"])
names(dimnames(ppF81L))[[2]] = 'COUNTERPART_SECTOR'

aall['F81',,'S2',sss,'LE','_D',,'4A', usenames=TRUE, onlyna=TRUE] = ppF81L[,sss,"FA__D__F81",]
aall[F81..S2.S12R.LE._D..4A, usenames=TRUE, onlyna=TRUE] = ppF81L[".S12M.FA__D__F81.1999q4:"]
aall['F81',,'S2',sss,'LE','_O',,'4A', usenames=TRUE, onlyna=TRUE] = ppF81L[,sss,"FA__O__F81",]
aall[F81..S2.S12R.LE._O..4A, usenames=TRUE, onlyna=TRUE] = ppF81L[".S12M.FA__O__F81.1999q4:"]

## flows F81  - Liabilities for Qdata
llF81t = llbop[..FA__D__F81+FA__O__F81.]
ppF81Lt = copy(llF81t["..FA__D__F81+FA__O__F81.1999q4:"])
names(dimnames(ppF81Lt))[[2]] = 'COUNTERPART_SECTOR'

aall['F81',,'S2',sss,'F','_D',,'4A', usenames=TRUE, onlyna=TRUE] = ppF81Lt[,sss,"FA__D__F81",]
aall[F81..S2.S11.F._D..4A, usenames=TRUE, onlyna=TRUE] = ppF81Lt[".S1V.FA__D__F81.1999q4:"]
aall[F81..S2.S12R.F._D..4A, usenames=TRUE, onlyna=TRUE] = ppF81Lt[".S12M.FA__D__F81.1999q4:"]
aall['F81',,'S2',sss,'F','_O',,'4A', usenames=TRUE, onlyna=TRUE] = ppF81Lt[,sss,"FA__O__F81",]
aall[F81..S2.S11.F._O..4A, usenames=TRUE, onlyna=TRUE] = ppF81Lt[".S1V.FA__O__F81.1999q4:"]
aall[F81..S2.S12R.F._O..4A, usenames=TRUE, onlyna=TRUE] = ppF81Lt[".S12M.FA__O__F81.1999q4:"]


# Process F89 from Other Investment
print('filling NAs of crossborder F89 assets')
## stocks F89  - Assets for Qdata
aaF89 = laiip[..FA__O__F89., drop=FALSE]
ppF89A = copy(aaF89["..FA__O__F89.1999q4:", drop=FALSE])

aall['F89',,sss,'S2','LE','_O',,'4A', usenames=TRUE, onlyna=TRUE] = ppF81A[,sss,"FA__O__F89",]
aall[F89..S12R.S2.LE._O..4A, usenames=TRUE, onlyna=TRUE] = ppF89A[".S12M.FA__O__F89.1999q4:"]

## flows F89  - Assets for Qdata
aaF89t = labop[..FA__O__F89., drop=FALSE]
ppF89At = copy(aaF89t["..FA__O__F89.1999q4:", drop=FALSE])

aall['F89',,sss,'S2','F','_O',,'4A', usenames=TRUE, onlyna=TRUE] = ppF89At[,sss,"FA__O__F89",]
aall[F89..S11.S2.F._O..4A, usenames=TRUE, onlyna=TRUE] = ppF89At[".S1V.FA__O__F89.1999q4:"]
aall[F89..S12R.S2.F._O..4A, usenames=TRUE, onlyna=TRUE] = ppF89At[".S12M.FA__O__F89.1999q4:"]


# Process F89 from Other Investment
print('filling NAs of crossborder F89 liabilities')
## stocks F89  - Liabilities for Qdata
llF89 = lliip[..FA__O__F89., drop=FALSE]
ppF89L = copy(llF89["..FA__O__F89.1999q4:", drop=FALSE])
names(dimnames(ppF89L))[[2]] = 'COUNTERPART_SECTOR'

aall['F89',,'S2',sss,'LE','_O',,'4A', usenames=TRUE, onlyna=TRUE] = ppF89L[,sss,"FA__O__F89",]
aall[F89..S2.S12R.LE._O..4A, usenames=TRUE, onlyna=TRUE] = ppF89L[".S12M.FA__O__F89.1999q4:"]

## stocks F89  - Liabilities for Qdata
llF89t = llbop[..FA__O__F89., drop=FALSE]
ppF89Lt = copy(llF89t["..FA__O__F89.1999q4:", drop=FALSE])
names(dimnames(ppF89Lt))[[2]] = 'COUNTERPART_SECTOR'

aall['F89',,'S2',sss,'F','_O',,'4A', usenames=TRUE, onlyna=TRUE] = ppF89Lt[,sss,"FA__O__F89",]
aall[F89..S2.S11.F._O..4A, usenames=TRUE, onlyna=TRUE] = ppF89Lt[".S1V.FA__O__F89.1999q4:"]
aall[F89..S2.S12R.F._O..4A, usenames=TRUE, onlyna=TRUE] = ppF89Lt[".S12M.FA__O__F89.1999q4:"]

#####################################################
### calculating S2 based on functional categories

zerofiller=function(x, fillscalar=0){
  temp=copy(x)
  temp[onlyna=TRUE]=fillscalar
  temp
}

aall[..S1.S2.._R..4A, usenames=TRUE, onlyna=TRUE] = zerofiller(aall[..S121.S2.._R..4A]) 
aall[..S1.S2.._T..4A, usenames=TRUE, onlyna=TRUE] = zerofiller(aall[..S1.S2.._D..4A]) +zerofiller(aall[..S1.S2.._P..4A]) +zerofiller(aall[..S1.S2.._O..4A]) +zerofiller(aall[..S1.S2.._F..4A])++zerofiller(aall[..S1.S2.._R..4A])
aall[...S2.._T..4A, usenames=TRUE, onlyna=TRUE] = zerofiller(aall[...S2.._D..4A]) +zerofiller(aall[...S2.._P..4A]) +zerofiller(aall[...S2.._O..4A]) +zerofiller(aall[...S2.._F..4A])
aall[..S2..._T..4A, usenames=TRUE, onlyna=TRUE] = zerofiller(aall[..S2..._D..4A]) +zerofiller(aall[..S2..._P..4A]) +zerofiller(aall[..S2..._O.]) +zerofiller(aall[..S2..._F..4A]) 
aall[F...S2.._T..4A] <- NA
aall[F..S2..._T..4A] <- NA
aall[F...S2.._T..4A, usenames=TRUE, onlyna=TRUE]=zerofiller(aall[F2M...S2.LE._T..4A])+zerofiller(aall[F21...S2.LE._T..4A])+zerofiller(aall[F3...S2.LE._T..4A])+zerofiller(aall[F4...S2.LE._T..4A])+zerofiller(aall[F511...S2.LE._T..4A])+zerofiller(aall[F51M...S2.LE._T..4A])+zerofiller(aall[F52...S2.LE._T..4A])+zerofiller(aall[F6...S2.LE._T..4A])+zerofiller(aall[F7...S2.LE._T..4A])+zerofiller(aall[F81...S2.LE._T..4A])+zerofiller(aall[F89...S2.LE._T..4A])
aall[F..S2..._T..4A, usenames=TRUE, onlyna=TRUE]=zerofiller(aall[F2M..S2..LE._T..4A])+zerofiller(aall[F21..S2..LE._T..4A])+zerofiller(aall[F3..S2..LE._T..4A])+zerofiller(aall[F4..S2..LE._T..4A])+zerofiller(aall[F511..S2..LE._T..4A])+zerofiller(aall[F51M..S2..LE._T..4A])+zerofiller(aall[F52..S2..LE._T..4A])+zerofiller(aall[F6..S2..LE._T..4A)+zerofiller(aall[F7..S2..LE._T..4A])+zerofiller(aall[F81..S2..LE._T..4A])+zerofiller(aall[F89..S2..LE._T..4A])


##calculate S1 as a residual after having filled S2 
#stocks and flows
aall[...S1.._T..4A, usenames=TRUE, onlyna=TRUE]=aall[...S0.._T..4A]-aall[...S2.._T..4A]
aall[..S1..._T..4A, usenames=TRUE, onlyna=TRUE]=aall[..S0..._T..4A]-aall[..S2..._T..4A]

saveRDS(aall,file='data/aall9_EUIeu.rds')