
# Load both consolidated and unconsolidated data
la = readRDS("data/domestic loading data files/nasa_unconsolidated.rds")
lc = readRDS("data/domestic loading data files/nasa_consolidated.rds")
###new
aall=readRDS('data/intermediate_domestic_data_files/aall_nasa_s12_flows.rds'))
setkey(aall, NULL)


# F51M (Unlisted shares and other equity)
intra512 = la$aa512nc - lc$aa512c
intra519 = la$aa519nc - lc$aa519c
intra51M = intra512 + intra519
names(dimnames(intra51M))[[1]] = 'REF_AREA'
names(dimnames(intra51M))[[2]] = 'REF_SECTOR'
ppIntra51M = copy(intra51M); frequency(ppIntra51M)='Q'

# Fill all individual sectors
aall[F51M..S1.S1.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51M[".S1.1999q4:"]
aall[F51M..S12.S12.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51M[".S12.1999q4:"]
aall[F51M..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51M[".S121.1999q4:"]
aall[F51M..S122.S122.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51M[".S122.1999q4:"]
aall[F51M..S123.S123.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51M[".S123.1999q4:"]
aall[F51M..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51M[".S124.1999q4:"]
aall[F51M..S125.S125.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51M[".S125.1999q4:"]
aall[F51M..S126.S126.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51M[".S126.1999q4:"]
aall[F51M..S127.S127.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51M[".S127.1999q4:"]
aall[F51M..S128.S128.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51M[".S128.1999q4:"]
aall[F51M..S129.S129.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51M[".S129.1999q4:"]
aall[F51M..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51M[".S11.1999q4:"]
aall[F51M..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51M[".S13.1999q4:"]
aall[F51M..S14.S14.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51M[".S14.1999q4:"]
aall[F51M..S15.S15.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51M[".S15.1999q4:"]
aall[F51M..S2.S2.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51M[".S2.1999q4:"]
aall[F51M..S21.S21.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51M[".S21.1999q4:"]
aall[F51M..S22.S22.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51M[".S22.1999q4:"]
aall[F51M..S2I.S2I.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51M[".S2I.1999q4:"]

# Fill combined sectors
aall[F51M..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51M[".S122_S123.1999q4:"]
aall[F51M..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51M[".S121_S122_S123.1999q4:"]
aall[F51M..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51M[".S125_S126_S127.1999q4:"]
aall[F51M..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51M[".S128_S129.1999q4:"]
aall[F51M..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51M[".S14_S15.1999q4:"]

# Calculate and fill S12R
aall[F51M..S12R.S12R.LE._T.] = aall[F51M..S124.S124.LE._T.] + aall[F51M..S12O.S12O.LE._T.] + aall[F51M..S12Q.S12Q.LE._T.]

# F511 (Listed shares)
intra511 = la$aa511nc - lc$aa511c
names(dimnames(intra511))[[1]] = 'REF_AREA'
names(dimnames(intra511))[[2]] = 'REF_SECTOR'
ppIntra511=copy(intra511); frequency(ppIntra511)='Q'

# Fill all individual sectors
aall[F511..S1.S1.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S1.1999q4:"]
aall[F511..S12.S12.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S12.1999q4:"]
aall[F511..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S121.1999q4:"]
aall[F511..S122.S122.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S122.1999q4:"]
aall[F511..S123.S123.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S123.1999q4:"]
aall[F511..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S124.1999q4:"]
aall[F511..S125.S125.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S125.1999q4:"]
aall[F511..S126.S126.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S126.1999q4:"]
aall[F511..S127.S127.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S127.1999q4:"]
aall[F511..S128.S128.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S128.1999q4:"]
aall[F511..S129.S129.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S129.1999q4:"]
aall[F511..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S11.1999q4:"]
aall[F511..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S13.1999q4:"]
aall[F511..S14.S14.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S14.1999q4:"]
aall[F511..S15.S15.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S15.1999q4:"]
aall[F511..S2.S2.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S2.1999q4:"]
aall[F511..S21.S21.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S21.1999q4:"]
aall[F511..S22.S22.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S22.1999q4:"]
aall[F511..S2I.S2I.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S2I.1999q4:"]

# Fill combined sectors
aall[F511..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S122_S123.1999q4:"]
aall[F511..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S121_S122_S123.1999q4:"]
aall[F511..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S125_S126_S127.1999q4:"]
aall[F511..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S128_S129.1999q4:"]
aall[F511..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S14_S15.1999q4:"]

# Calculate and fill S12R
aall[F511..S12R.S12R.LE._T.] = aall[F511..S124.S124.LE._T.] + aall[F511..S12O.S12O.LE._T.] + aall[F511..S12Q.S12Q.LE._T.]

# F52 (Investment fund shares)
intra52 = la$aa52nc - lc$aa52c
names(dimnames(intra52))[[1]] = 'REF_AREA'
names(dimnames(intra52))[[2]] = 'REF_SECTOR'
ppIntra52=copy(intra52); frequency(ppIntra52)='Q'

# Fill all individual sectors
aall[F52..S1.S1.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S1.1999q4:"]
aall[F52..S12.S12.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S12.1999q4:"]
aall[F52..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S121.1999q4:"]
aall[F52..S122.S122.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S122.1999q4:"]
aall[F52..S123.S123.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S123.1999q4:"]
aall[F52..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S124.1999q4:"]
aall[F52..S125.S125.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S125.1999q4:"]
aall[F52..S126.S126.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S126.1999q4:"]
aall[F52..S127.S127.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S127.1999q4:"]
aall[F52..S128.S128.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S128.1999q4:"]
aall[F52..S129.S129.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S129.1999q4:"]
aall[F52..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S11.1999q4:"]
aall[F52..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S13.1999q4:"]
aall[F52..S14.S14.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S14.1999q4:"]
aall[F52..S15.S15.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S15.1999q4:"]
aall[F52..S2.S2.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S2.1999q4:"]
aall[F52..S21.S21.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S21.1999q4:"]
aall[F52..S22.S22.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S22.1999q4:"]
aall[F52..S2I.S2I.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S2I.1999q4:"]

# Fill combined sectors
aall[F52..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S122_S123.1999q4:"]
aall[F52..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S121_S122_S123.1999q4:"]
aall[F52..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S125_S126_S127.1999q4:"]
aall[F52..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S128_S129.1999q4:"]
aall[F52..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S14_S15.1999q4:"]

# Calculate and fill S12R
aall[F52..S12R.S12R.LE._T.] = aall[F52..S124.S124.LE._T.] + aall[F52..S12O.S12O.LE._T.] + aall[F52..S12Q.S12Q.LE._T.]

# F2M (sum of F22 and F29)
intra22 = la$aa22nc - lc$aa22c
intra29 = la$aa29nc - lc$aa29c
intra2M = intra22 + intra29
names(dimnames(intra2M))[[1]] = 'REF_AREA'
names(dimnames(intra2M))[[2]] = 'REF_SECTOR'
ppIntra2M=copy(intra2M); frequency(ppIntra2M)='Q'

# Fill all individual sectors
aall[F2M..S1.S1.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra2M[".S1.1999q4:"]
aall[F2M..S12.S12.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra2M[".S12.1999q4:"]
aall[F2M..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra2M[".S121.1999q4:"]
aall[F2M..S122.S122.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra2M[".S122.1999q4:"]
aall[F2M..S123.S123.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra2M[".S123.1999q4:"]
aall[F2M..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra2M[".S124.1999q4:"]
aall[F2M..S125.S125.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra2M[".S125.1999q4:"]
aall[F2M..S126.S126.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra2M[".S126.1999q4:"]
aall[F2M..S127.S127.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra2M[".S127.1999q4:"]
aall[F2M..S128.S128.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra2M[".S128.1999q4:"]
aall[F2M..S129.S129.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra2M[".S129.1999q4:"]
aall[F2M..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra2M[".S11.1999q4:"]
aall[F2M..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra2M[".S13.1999q4:"]
aall[F2M..S14.S14.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra2M[".S14.1999q4:"]
aall[F2M..S15.S15.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra2M[".S15.1999q4:"]
aall[F2M..S2.S2.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra2M[".S2.1999q4:"]
aall[F2M..S21.S21.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra2M[".S21.1999q4:"]
aall[F2M..S22.S22.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra2M[".S22.1999q4:"]
aall[F2M..S2I.S2I.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra2M[".S2I.1999q4:"]

# Fill combined sectors
aall[F2M..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra2M[".S122_S123.1999q4:"]
aall[F2M..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra2M[".S121_S122_S123.1999q4:"]
aall[F2M..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra2M[".S125_S126_S127.1999q4:"]
aall[F2M..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra2M[".S128_S129.1999q4:"]
aall[F2M..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra2M[".S14_S15.1999q4:"]

# Calculate and fill S12R
aall[F2M..S12R.S12R.LE._T.] = aall[F2M..S124.S124.LE._T.] + aall[F2M..S12O.S12O.LE._T.] + aall[F2M..S12Q.S12Q.LE._T.]

# F4 (Loans)
intra4 = la$aa4nc - lc$aa4c
names(dimnames(intra4))[[1]] = 'REF_AREA'
names(dimnames(intra4))[[2]] = 'REF_SECTOR'
ppIntra4=copy(intra4); frequency(ppIntra4)='Q'

# Fill all individual sectors
aall[F4..S1.S1.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S1.1999q4:"]
aall[F4..S12.S12.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S12.1999q4:"]
aall[F4..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S121.1999q4:"]
aall[F4..S122.S122.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S122.1999q4:"]
aall[F4..S123.S123.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S123.1999q4:"]
aall[F4..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S124.1999q4:"]
aall[F4..S125.S125.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S125.1999q4:"]
aall[F4..S126.S126.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S126.1999q4:"]
aall[F4..S127.S127.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S127.1999q4:"]
aall[F4..S128.S128.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S128.1999q4:"]
aall[F4..S129.S129.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S129.1999q4:"]
aall[F4..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S11.1999q4:"]
aall[F4..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S13.1999q4:"]
aall[F4..S14.S14.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S14.1999q4:"]
aall[F4..S15.S15.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S15.1999q4:"]
aall[F4..S2.S2.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S2.1999q4:"]
aall[F4..S21.S21.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S21.1999q4:"]
aall[F4..S22.S22.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S22.1999q4:"]
aall[F4..S2I.S2I.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S2I.1999q4:"]

# Fill combined sectors
aall[F4..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S122_S123.1999q4:"]
aall[F4..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S121_S122_S123.1999q4:"]
aall[F4..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S125_S126_S127.1999q4:"]
aall[F4..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S128_S129.1999q4:"]
aall[F4..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S14_S15.1999q4:"]

# Calculate and fill S12R
aall[F4..S12R.S12R.LE._T.] = aall[F4..S124.S124.LE._T.] + aall[F4..S12O.S12O.LE._T.] + aall[F4..S12Q.S12Q.LE._T.]

# F4S (Short-term loans)
intra41 = la$aa41nc - lc$aa41c
names(dimnames(intra41))[[1]] = 'REF_AREA'
names(dimnames(intra41))[[2]] = 'REF_SECTOR'
ppIntra41=copy(intra41); frequency(ppIntra41)='Q'

# Fill all individual sectors
aall[F4S..S1.S1.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S1.1999q4:"]
aall[F4S..S12.S12.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S12.1999q4:"]
aall[F4S..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S121.1999q4:"]
aall[F4S..S122.S122.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S122.1999q4:"]
aall[F4S..S123.S123.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S123.1999q4:"]
aall[F4S..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S124.1999q4:"]
aall[F4S..S125.S125.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S125.1999q4:"]
aall[F4S..S126.S126.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S126.1999q4:"]
aall[F4S..S127.S127.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S127.1999q4:"]
aall[F4S..S128.S128.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S128.1999q4:"]
aall[F4S..S129.S129.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S129.1999q4:"]
aall[F4S..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S11.1999q4:"]
aall[F4S..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S13.1999q4:"]
aall[F4S..S14.S14.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S14.1999q4:"]
aall[F4S..S15.S15.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S15.1999q4:"]
aall[F4S..S2.S2.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S2.1999q4:"]
aall[F4S..S21.S21.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S21.1999q4:"]
aall[F4S..S22.S22.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S22.1999q4:"]
aall[F4S..S2I.S2I.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S2I.1999q4:"]

# Fill combined sectors
aall[F4S..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S122_S123.1999q4:"]
aall[F4S..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S121_S122_S123.1999q4:"]
aall[F4S..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S125_S126_S127.1999q4:"]
aall[F4S..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S128_S129.1999q4:"]
aall[F4S..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S14_S15.1999q4:"]

# Calculate and fill S12R
aall[F4S..S12R.S12R.LE._T.] = aall[F4S..S124.S124.LE._T.] + aall[F4S..S12O.S12O.LE._T.] + aall[F4S..S12Q.S12Q.LE._T.]

# F4L (Long-term loans)
intra42 = la$aa42nc - lc$aa42c
names(dimnames(intra42))[[1]] = 'REF_AREA'
names(dimnames(intra42))[[2]] = 'REF_SECTOR'
ppIntra42=copy(intra42); frequency(ppIntra42)='Q'

# Fill all individual sectors
aall[F4L..S1.S1.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S1.1999q4:"]
aall[F4L..S12.S12.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S12.1999q4:"]
aall[F4L..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S121.1999q4:"]
aall[F4L..S122.S122.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S122.1999q4:"]
aall[F4L..S123.S123.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S123.1999q4:"]
aall[F4L..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S124.1999q4:"]
aall[F4L..S125.S125.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S125.1999q4:"]
aall[F4L..S126.S126.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S126.1999q4:"]
aall[F4L..S127.S127.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S127.1999q4:"]
aall[F4L..S128.S128.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S128.1999q4:"]
aall[F4L..S129.S129.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S129.1999q4:"]
aall[F4L..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S11.1999q4:"]
aall[F4L..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S13.1999q4:"]
aall[F4L..S14.S14.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S14.1999q4:"]
aall[F4L..S15.S15.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S15.1999q4:"]
aall[F4L..S2.S2.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S2.1999q4:"]
aall[F4L..S21.S21.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S21.1999q4:"]
aall[F4L..S22.S22.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S22.1999q4:"]
aall[F4L..S2I.S2I.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S2I.1999q4:"]

# Fill combined sectors
aall[F4L..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S122_S123.1999q4:"]
aall[F4L..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S121_S122_S123.1999q4:"]
aall[F4L..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S125_S126_S127.1999q4:"]
aall[F4L..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S128_S129.1999q4:"]
aall[F4L..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S14_S15.1999q4:"]

# Calculate and fill S12R
aall[F4L..S12R.S12R.LE._T.] = aall[F4L..S124.S124.LE._T.] + aall[F4L..S12O.S12O.LE._T.] + aall[F4L..S12Q.S12Q.LE._T.]

# F3 (Debt securities)
intra3 = la$aa3nc - lc$aa3c
names(dimnames(intra3))[[1]] = 'REF_AREA'
names(dimnames(intra3))[[2]] = 'REF_SECTOR'
ppIntra3=copy(intra3); frequency(ppIntra3)='Q'

# Fill all individual sectors
aall[F3..S1.S1.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S1.1999q4:"]
aall[F3..S12.S12.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S12.1999q4:"]
aall[F3..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S121.1999q4:"]
aall[F3..S122.S122.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S122.1999q4:"]
aall[F3..S123.S123.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S123.1999q4:"]
aall[F3..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S124.1999q4:"]
aall[F3..S125.S125.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S125.1999q4:"]
aall[F3..S126.S126.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S126.1999q4:"]
aall[F3..S127.S127.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S127.1999q4:"]
aall[F3..S128.S128.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S128.1999q4:"]
aall[F3..S129.S129.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S129.1999q4:"]
aall[F3..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S11.1999q4:"]
aall[F3..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S13.1999q4:"]
aall[F3..S14.S14.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S14.1999q4:"]
aall[F3..S15.S15.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S15.1999q4:"]
aall[F3..S2.S2.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S2.1999q4:"]
aall[F3..S21.S21.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S21.1999q4:"]
aall[F3..S22.S22.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S22.1999q4:"]
aall[F3..S2I.S2I.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S2I.1999q4:"]

# Fill combined sectors
aall[F3..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S122_S123.1999q4:"]
aall[F3..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S121_S122_S123.1999q4:"]
aall[F3..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S125_S126_S127.1999q4:"]
aall[F3..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S128_S129.1999q4:"]
aall[F3..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S14_S15.1999q4:"]

# Calculate and fill S12R
aall[F3..S12R.S12R.LE._T.] = aall[F3..S124.S124.LE._T.] + aall[F3..S12O.S12O.LE._T.] + aall[F3..S12Q.S12Q.LE._T.]

# F3S (Short-term debt securities)
intra31 = la$aa31nc - lc$aa31c
names(dimnames(intra31))[[1]] = 'REF_AREA'
names(dimnames(intra31))[[2]] = 'REF_SECTOR'
ppIntra31=copy(intra31); frequency(ppIntra31)='Q'

# Fill all individual sectors
aall[F3S..S1.S1.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S1.1999q4:"]
aall[F3S..S12.S12.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S12.1999q4:"]
aall[F3S..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S121.1999q4:"]
aall[F3S..S122.S122.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S122.1999q4:"]
aall[F3S..S123.S123.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S123.1999q4:"]
aall[F3S..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S124.1999q4:"]
aall[F3S..S125.S125.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S125.1999q4:"]
aall[F3S..S126.S126.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S126.1999q4:"]
aall[F3S..S127.S127.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S127.1999q4:"]
aall[F3S..S128.S128.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S128.1999q4:"]
aall[F3S..S129.S129.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S129.1999q4:"]
aall[F3S..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S11.1999q4:"]
aall[F3S..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S13.1999q4:"]
aall[F3S..S14.S14.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S14.1999q4:"]
aall[F3S..S15.S15.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S15.1999q4:"]
aall[F3S..S2.S2.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S2.1999q4:"]
aall[F3S..S21.S21.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S21.1999q4:"]
aall[F3S..S22.S22.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S22.1999q4:"]
aall[F3S..S2I.S2I.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S2I.1999q4:"]

# Fill combined sectors
aall[F3S..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S122_S123.1999q4:"]
aall[F3S..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S121_S122_S123.1999q4:"]
aall[F3S..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S125_S126_S127.1999q4:"]
aall[F3S..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S128_S129.1999q4:"]
aall[F3S..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S14_S15.1999q4:"]

# Calculate and fill S12R
aall[F3S..S12R.S12R.LE._T.] = aall[F3S..S124.S124.LE._T.] + aall[F3S..S12O.S12O.LE._T.] + aall[F3S..S12Q.S12Q.LE._T.]

# F3L (Long-term debt securities)
intra32 = la$aa32nc - lc$aa32c
names(dimnames(intra32))[[1]] = 'REF_AREA'
names(dimnames(intra32))[[2]] = 'REF_SECTOR'
ppIntra32=copy(intra32); frequency(ppIntra32)='Q'

# Fill all individual sectors
aall[F3L..S1.S1.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S1.1999q4:"]
aall[F3L..S12.S12.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S12.1999q4:"]
aall[F3L..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S121.1999q4:"]
aall[F3L..S122.S122.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S122.1999q4:"]
aall[F3L..S123.S123.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S123.1999q4:"]
aall[F3L..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S124.1999q4:"]
aall[F3L..S125.S125.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S125.1999q4:"]
aall[F3L..S126.S126.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S126.1999q4:"]
aall[F3L..S127.S127.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S127.1999q4:"]
aall[F3L..S128.S128.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S128.1999q4:"]
aall[F3L..S129.S129.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S129.1999q4:"]
aall[F3L..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S11.1999q4:"]
aall[F3L..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S13.1999q4:"]
aall[F3L..S14.S14.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S14.1999q4:"]
aall[F3L..S15.S15.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S15.1999q4:"]
aall[F3L..S2.S2.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S2.1999q4:"]
aall[F3L..S21.S21.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S21.1999q4:"]
aall[F3L..S22.S22.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S22.1999q4:"]
aall[F3L..S2I.S2I.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S2I.1999q4:"]

# Fill combined sectors
aall[F3L..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S122_S123.1999q4:"]
aall[F3L..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S121_S122_S123.1999q4:"]
aall[F3L..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S125_S126_S127.1999q4:"]
aall[F3L..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S128_S129.1999q4:"]
aall[F3L..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S14_S15.1999q4:"]

# Calculate and fill S12R
aall[F3L..S12R.S12R.LE._T.] = aall[F3L..S124.S124.LE._T.] + aall[F3L..S12O.S12O.LE._T.] + aall[F3L..S12Q.S12Q.LE._T.]

# F21 (Currency)
intra21 = la$aa21nc - lc$aa21c
names(dimnames(intra21))[[1]] = 'REF_AREA'
names(dimnames(intra21))[[2]] = 'REF_SECTOR'
ppIntra21=copy(intra21); frequency(ppIntra21)='Q'

# Fill all individual sectors
aall[F21..S1.S1.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S1.1999q4:"]
aall[F21..S12.S12.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S12.1999q4:"]
aall[F21..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S121.1999q4:"]
aall[F21..S122.S122.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S122.1999q4:"]
aall[F21..S123.S123.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S123.1999q4:"]
aall[F21..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S124.1999q4:"]
aall[F21..S125.S125.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S125.1999q4:"]
aall[F21..S126.S126.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S126.1999q4:"]
aall[F21..S127.S127.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S127.1999q4:"]
aall[F21..S128.S128.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S128.1999q4:"]
aall[F21..S129.S129.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S129.1999q4:"]
aall[F21..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S11.1999q4:"]
aall[F21..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S13.1999q4:"]
aall[F21..S14.S14.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S14.1999q4:"]
aall[F21..S15.S15.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S15.1999q4:"]
aall[F21..S2.S2.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S2.1999q4:"]
aall[F21..S21.S21.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S21.1999q4:"]
aall[F21..S22.S22.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S22.1999q4:"]
aall[F21..S2I.S2I.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S2I.1999q4:"]

# Fill combined sectors
aall[F21..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S122_S123.1999q4:"]
aall[F21..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S121_S122_S123.1999q4:"]
aall[F21..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S125_S126_S127.1999q4:"]
aall[F21..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S128_S129.1999q4:"]
aall[F21..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S14_S15.1999q4:"]

# Calculate and fill S12R
aall[F21..S12R.S12R.LE._T.] = aall[F21..S124.S124.LE._T.] + aall[F21..S12O.S12O.LE._T.] + aall[F21..S12Q.S12Q.LE._T.]

# F (Total financial assets/liabilities)
intraf = la$aafnc - lc$aafc
names(dimnames(intraf))[[1]] = 'REF_AREA'
names(dimnames(intraf))[[2]] = 'REF_SECTOR'
ppIntraf=copy(intraf); frequency(ppIntraf)='Q'

# Fill all individual sectors
aall[F..S1.S1.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S1.1999q4:"]
aall[F..S12.S12.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S12.1999q4:"]
aall[F..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S121.1999q4:"]
aall[F..S122.S122.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S122.1999q4:"]
aall[F..S123.S123.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S123.1999q4:"]
aall[F..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S124.1999q4:"]
aall[F..S125.S125.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S125.1999q4:"]
aall[F..S126.S126.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S126.1999q4:"]
aall[F..S127.S127.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S127.1999q4:"]
aall[F..S128.S128.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S128.1999q4:"]
aall[F..S129.S129.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S129.1999q4:"]
aall[F..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S11.1999q4:"]
aall[F..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S13.1999q4:"]
aall[F..S14.S14.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S14.1999q4:"]
aall[F..S15.S15.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S15.1999q4:"]
aall[F..S2.S2.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S2.1999q4:"]
aall[F..S21.S21.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S21.1999q4:"]
aall[F..S22.S22.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S22.1999q4:"]
aall[F..S2I.S2I.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S2I.1999q4:"]

# Fill combined sectors
aall[F..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S122_S123.1999q4:"]
aall[F..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S121_S122_S123.1999q4:"]
aall[F..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S125_S126_S127.1999q4:"]
aall[F..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S128_S129.1999q4:"]
aall[F..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S14_S15.1999q4:"]

# Calculate and fill S12R
aall[F..S12R.S12R.LE._T.] = aall[F..S124.S124.LE._T.] + aall[F..S12O.S12O.LE._T.] + aall[F..S12Q.S12Q.LE._T.]

# F51 (Equity)
intra51 = la$aa51nc - lc$aa51c
names(dimnames(intra51))[[1]] = 'REF_AREA'
names(dimnames(intra51))[[2]] = 'REF_SECTOR'
ppIntra51=copy(intra51); frequency(ppIntra51)='Q'

# Fill all individual sectors
aall[F51..S1.S1.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S1.1999q4:"]
aall[F51..S12.S12.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S12.1999q4:"]
aall[F51..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S121.1999q4:"]
aall[F51..S122.S122.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S122.1999q4:"]
aall[F51..S123.S123.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S123.1999q4:"]
aall[F51..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S124.1999q4:"]
aall[F51..S125.S125.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S125.1999q4:"]
aall[F51..S126.S126.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S126.1999q4:"]
aall[F51..S127.S127.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S127.1999q4:"]
aall[F51..S128.S128.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S128.1999q4:"]
aall[F51..S129.S129.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S129.1999q4:"]
aall[F51..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S11.1999q4:"]
aall[F51..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S13.1999q4:"]
aall[F51..S14.S14.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S14.1999q4:"]
aall[F51..S15.S15.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S15.1999q4:"]
aall[F51..S2.S2.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S2.1999q4:"]
aall[F51..S21.S21.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S21.1999q4:"]
aall[F51..S22.S22.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S22.1999q4:"]
aall[F51..S2I.S2I.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S2I.1999q4:"]

# Fill combined sectors
aall[F51..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S122_S123.1999q4:"]
aall[F51..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S121_S122_S123.1999q4:"]
aall[F51..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S125_S126_S127.1999q4:"]
aall[F51..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S128_S129.1999q4:"]
aall[F51..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S14_S15.1999q4:"]

# Calculate and fill S12R
aall[F51..S12R.S12R.LE._T.] = aall[F51..S124.S124.LE._T.] + aall[F51..S12O.S12O.LE._T.] + aall[F51..S12Q.S12Q.LE._T.]

# F6 (Insurance, pension and standardized guarantee schemes)
intra6 = la$aa6nc - lc$aa6c
names(dimnames(intra6))[[1]] = 'REF_AREA'
names(dimnames(intra6))[[2]] = 'REF_SECTOR'
ppIntra6=copy(intra6); frequency(ppIntra6)='Q'

# Fill all individual sectors
aall[F6..S1.S1.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S1.1999q4:"]
aall[F6..S12.S12.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S12.1999q4:"]
aall[F6..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S121.1999q4:"]
aall[F6..S122.S122.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S122.1999q4:"]
aall[F6..S123.S123.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S123.1999q4:"]
aall[F6..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S124.1999q4:"]
aall[F6..S125.S125.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S125.1999q4:"]
aall[F6..S126.S126.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S126.1999q4:"]
aall[F6..S127.S127.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S127.1999q4:"]
aall[F6..S128.S128.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S128.1999q4:"]
aall[F6..S129.S129.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S129.1999q4:"]
aall[F6..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S11.1999q4:"]
aall[F6..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S13.1999q4:"]
aall[F6..S14.S14.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S14.1999q4:"]
aall[F6..S15.S15.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S15.1999q4:"]
aall[F6..S2.S2.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S2.1999q4:"]
aall[F6..S21.S21.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S21.1999q4:"]
aall[F6..S22.S22.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S22.1999q4:"]
aall[F6..S2I.S2I.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S2I.1999q4:"]

# Fill combined sectors
aall[F6..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S122_S123.1999q4:"]
aall[F6..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S121_S122_S123.1999q4:"]
aall[F6..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S125_S126_S127.1999q4:"]
aall[F6..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S128_S129.1999q4:"]
aall[F6..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S14_S15.1999q4:"]

# Calculate and fill S12R
aall[F6..S12R.S12R.LE._T.] = aall[F6..S124.S124.LE._T.] + aall[F6..S12O.S12O.LE._T.] + aall[F6..S12Q.S12Q.LE._T.]

# F6N (sum of F62 and F63_F64_F65)
intra62 = la$aa62nc - lc$aa62c
intra6n = la$aa6nnc - lc$aa6Nc
intra6N = intra62 + intra6n
names(dimnames(intra6N))[[1]] = 'REF_AREA'
names(dimnames(intra6N))[[2]] = 'REF_SECTOR'
ppIntra6N=copy(intra6N); frequency(ppIntra6N)='Q'

# Fill all individual sectors
aall[F6N..S1.S1.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6N[".S1.1999q4:"]
aall[F6N..S12.S12.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6N[".S12.1999q4:"]
aall[F6N..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6N[".S121.1999q4:"]
aall[F6N..S122.S122.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6N[".S122.1999q4:"]
aall[F6N..S123.S123.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6N[".S123.1999q4:"]
aall[F6N..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6N[".S124.1999q4:"]
aall[F6N..S125.S125.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6N[".S125.1999q4:"]
aall[F6N..S126.S126.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6N[".S126.1999q4:"]
aall[F6N..S127.S127.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6N[".S127.1999q4:"]
aall[F6N..S128.S128.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6N[".S128.1999q4:"]
aall[F6N..S129.S129.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6N[".S129.1999q4:"]
aall[F6N..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6N[".S11.1999q4:"]
aall[F6N..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6N[".S13.1999q4:"]
aall[F6N..S14.S14.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6N[".S14.1999q4:"]
aall[F6N..S15.S15.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6N[".S15.1999q4:"]
aall[F6N..S2.S2.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6N[".S2.1999q4:"]
aall[F6N..S21.S21.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6N[".S21.1999q4:"]
aall[F6N..S22.S22.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6N[".S22.1999q4:"]
aall[F6N..S2I.S2I.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6N[".S2I.1999q4:"]

# Fill combined sectors
aall[F6N..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6N[".S122_S123.1999q4:"]
aall[F6N..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6N[".S121_S122_S123.1999q4:"]
aall[F6N..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6N[".S125_S126_S127.1999q4:"]
aall[F6N..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6N[".S128_S129.1999q4:"]
aall[F6N..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6N[".S14_S15.1999q4:"]

# Calculate and fill S12R
aall[F6N..S12R.S12R.LE._T.] = aall[F6N..S124.S124.LE._T.] + aall[F6N..S12O.S12O.LE._T.] + aall[F6N..S12Q.S12Q.LE._T.]

# F7 (Financial derivatives)
intra7 = la$aa7nc - lc$aa7c
names(dimnames(intra7))[[1]] = 'REF_AREA'
names(dimnames(intra7))[[2]] = 'REF_SECTOR'
ppIntra7=copy(intra7); frequency(ppIntra7)='Q'

# Fill all individual sectors
aall[F7..S1.S1.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S1.1999q4:"]
aall[F7..S12.S12.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S12.1999q4:"]
aall[F7..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S121.1999q4:"]
aall[F7..S122.S122.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S122.1999q4:"]
aall[F7..S123.S123.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S123.1999q4:"]
aall[F7..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S124.1999q4:"]
aall[F7..S125.S125.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S125.1999q4:"]
aall[F7..S126.S126.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S126.1999q4:"]
aall[F7..S127.S127.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S127.1999q4:"]
aall[F7..S128.S128.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S128.1999q4:"]
aall[F7..S129.S129.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S129.1999q4:"]
aall[F7..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S11.1999q4:"]
aall[F7..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S13.1999q4:"]
aall[F7..S14.S14.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S14.1999q4:"]
aall[F7..S15.S15.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S15.1999q4:"]
aall[F7..S2.S2.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S2.1999q4:"]
aall[F7..S21.S21.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S21.1999q4:"]
aall[F7..S22.S22.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S22.1999q4:"]
aall[F7..S2I.S2I.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S2I.1999q4:"]

# Fill combined sectors
aall[F7..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S122_S123.1999q4:"]
aall[F7..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S121_S122_S123.1999q4:"]
aall[F7..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S125_S126_S127.1999q4:"]
aall[F7..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S128_S129.1999q4:"]
aall[F7..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S14_S15.1999q4:"]

# Calculate and fill S12R
aall[F7..S12R.S12R.LE._T.] = aall[F7..S124.S124.LE._T.] + aall[F7..S12O.S12O.LE._T.] + aall[F7..S12Q.S12Q.LE._T.]

# F81 (Trade credits and advances)
intra81 = la$aa81nc - lc$aa81c
names(dimnames(intra81))[[1]] = 'REF_AREA'
names(dimnames(intra81))[[2]] = 'REF_SECTOR'
ppIntra81=copy(intra81); frequency(ppIntra81)='Q'

# Fill all individual sectors
aall[F81..S1.S1.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S1.1999q4:"]
aall[F81..S12.S12.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S12.1999q4:"]
aall[F81..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S121.1999q4:"]
aall[F81..S122.S122.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S122.1999q4:"]
aall[F81..S123.S123.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S123.1999q4:"]
aall[F81..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S124.1999q4:"]
aall[F81..S125.S125.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S125.1999q4:"]
aall[F81..S126.S126.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S126.1999q4:"]
aall[F81..S127.S127.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S127.1999q4:"]
aall[F81..S128.S128.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S128.1999q4:"]
aall[F81..S129.S129.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S129.1999q4:"]
aall[F81..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S11.1999q4:"]
aall[F81..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S13.1999q4:"]
aall[F81..S14.S14.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S14.1999q4:"]
aall[F81..S15.S15.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S15.1999q4:"]
aall[F81..S2.S2.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S2.1999q4:"]
aall[F81..S21.S21.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S21.1999q4:"]
aall[F81..S22.S22.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S22.1999q4:"]
aall[F81..S2I.S2I.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S2I.1999q4:"]

# Fill combined sectors
aall[F81..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S122_S123.1999q4:"]
aall[F81..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S121_S122_S123.1999q4:"]
aall[F81..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S125_S126_S127.1999q4:"]
aall[F81..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S128_S129.1999q4:"]
aall[F81..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S14_S15.1999q4:"]

# Calculate and fill S12R
aall[F81..S12R.S12R.LE._T.] = aall[F81..S124.S124.LE._T.] + aall[F81..S12O.S12O.LE._T.] + aall[F81..S12Q.S12Q.LE._T.]

# F89 (Other accounts receivable/payable)
intra89 = la$aa89nc - lc$aa89c
names(dimnames(intra89))[[1]] = 'REF_AREA'
names(dimnames(intra89))[[2]] = 'REF_SECTOR'
ppIntra89=copy(intra89); frequency(ppIntra89)='Q'

# Fill all individual sectors
aall[F89..S1.S1.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S1.1999q4:"]
aall[F89..S12.S12.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S12.1999q4:"]
aall[F89..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S121.1999q4:"]
aall[F89..S122.S122.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S122.1999q4:"]
aall[F89..S123.S123.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S123.1999q4:"]
aall[F89..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S124.1999q4:"]
aall[F89..S125.S125.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S125.1999q4:"]
aall[F89..S126.S126.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S126.1999q4:"]
aall[F89..S127.S127.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S127.1999q4:"]
aall[F89..S128.S128.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S128.1999q4:"]
aall[F89..S129.S129.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S129.1999q4:"]
aall[F89..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S11.1999q4:"]
aall[F89..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S13.1999q4:"]
aall[F89..S14.S14.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S14.1999q4:"]
aall[F89..S15.S15.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S15.1999q4:"]
aall[F89..S2.S2.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S2.1999q4:"]
aall[F89..S21.S21.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S21.1999q4:"]
aall[F89..S22.S22.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S22.1999q4:"]
aall[F89..S2I.S2I.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S2I.1999q4:"]

# Fill combined sectors
aall[F89..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S122_S123.1999q4:"]
aall[F89..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S121_S122_S123.1999q4:"]
aall[F89..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S125_S126_S127.1999q4:"]
aall[F89..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S128_S129.1999q4:"]
aall[F89..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S14_S15.1999q4:"]

# Calculate and fill S12R
aall[F89..S12R.S12R.LE._T.] = aall[F89..S124.S124.LE._T.] + aall[F89..S12O.S12O.LE._T.] + aall[F89..S12Q.S12Q.LE._T.]

# Save final rounded data
saveRDS(aall, file.path(data_dir, 'intermediate_domestic_data_files/aall_nasa_intrasector.rds'))

gc()
