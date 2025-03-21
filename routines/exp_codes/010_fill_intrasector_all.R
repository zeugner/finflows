# F511
names(dimnames(intra511))[[1]] = 'REF_AREA'
names(dimnames(intra511))[[2]] = 'REF_SECTOR'
dtIntra511 = as.data.table(intra511, na.rm = TRUE)
setnames(dtIntra511, "obs_value", "value")
dtIntra511 = dtIntra511[, .(REF_AREA, REF_SECTOR, TIME, value)]
dtIntra511$TIME = frequency(dtIntra511$TIME, "Q", refersto = "end")
attr(dtIntra511, "dcsimp") = NULL
attr(dtIntra511, "dcstruct") = NULL
dtIntra511$TIME = as.character(dtIntra511$TIME)
ppIntra511 = as.md3(copy(dtIntra511), id.vars=1:3)
aall[F511..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S121.1999q4:"]
aall[F511..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S12T.1999q4:"]
aall[F511..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S11.1999q4:"]
aall[F511..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S13.1999q4:"]
aall[F511..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S1M.1999q4:"]
aall[F511..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S124.1999q4:"]
aall[F511..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S12O.1999q4:"]
aall[F511..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S12Q.1999q4:"]

# Process F512 
names(dimnames(intra512))[[1]] = 'REF_AREA'
names(dimnames(intra512))[[2]] = 'REF_SECTOR'
dtIntra512 = as.data.table(intra512, na.rm = TRUE)
setnames(dtIntra512, "obs_value", "value")
dtIntra512 = dtIntra512[, .(REF_AREA, REF_SECTOR, TIME, value)]
dtIntra512$TIME = frequency(dtIntra512$TIME, "Q", refersto = "end")
attr(dtIntra512, "dcsimp") = NULL
attr(dtIntra512, "dcstruct") = NULL
dtIntra512$TIME = as.character(dtIntra512$TIME)
ppIntra512 = as.md3(copy(dtIntra512), id.vars=1:3)
aall[F512..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra512[".S121.1999q4:"]
aall[F512..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra512[".S12T.1999q4:"]
aall[F512..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra512[".S11.1999q4:"]
aall[F512..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra512[".S13.1999q4:"]
aall[F512..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra512[".S1M.1999q4:"]
aall[F512..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra512[".S124.1999q4:"]
aall[F512..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra512[".S12O.1999q4:"]
aall[F512..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra512[".S12Q.1999q4:"]

# Process F519
names(dimnames(intra519))[[1]] = 'REF_AREA'
names(dimnames(intra519))[[2]] = 'REF_SECTOR'
dtIntra519 = as.data.table(intra519, na.rm = TRUE)
setnames(dtIntra519, "obs_value", "value")
dtIntra519 = dtIntra519[, .(REF_AREA, REF_SECTOR, TIME, value)]
dtIntra519$TIME = frequency(dtIntra519$TIME, "Q", refersto = "end")
attr(dtIntra519, "dcsimp") = NULL
attr(dtIntra519, "dcstruct") = NULL
dtIntra519$TIME = as.character(dtIntra519$TIME)
ppIntra519 = as.md3(copy(dtIntra519), id.vars=1:3)
aall[F519..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra519[".S121.1999q4:"]
aall[F519..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra519[".S12T.1999q4:"]
aall[F519..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra519[".S11.1999q4:"]
aall[F519..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra519[".S13.1999q4:"]
aall[F519..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra519[".S1M.1999q4:"]
aall[F519..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra519[".S124.1999q4:"]
aall[F519..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra519[".S12O.1999q4:"]
aall[F519..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra519[".S12Q.1999q4:"]


# F52
names(dimnames(intra52))[[1]] = 'REF_AREA'
names(dimnames(intra52))[[2]] = 'REF_SECTOR'
dtIntra52 = as.data.table(intra52, na.rm = TRUE)
setnames(dtIntra52, "obs_value", "value")
dtIntra52 = dtIntra52[, .(REF_AREA, REF_SECTOR, TIME, value)]
dtIntra52$TIME = frequency(dtIntra52$TIME, "Q", refersto = "end")
attr(dtIntra52, "dcsimp") = NULL
attr(dtIntra52, "dcstruct") = NULL
dtIntra52$TIME = as.character(dtIntra52$TIME)
ppIntra52 = as.md3(copy(dtIntra52), id.vars=1:3)
aall[F52..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S121.1999q4:"]
aall[F52..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S12T.1999q4:"]
aall[F52..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S11.1999q4:"]
aall[F52..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S13.1999q4:"]
aall[F52..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S1M.1999q4:"]
aall[F52..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S124.1999q4:"]
aall[F52..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S12O.1999q4:"]
aall[F52..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S12Q.1999q4:"]

# Process F4 (Loans)
names(dimnames(intra4))[[1]] = 'REF_AREA'
names(dimnames(intra4))[[2]] = 'REF_SECTOR'
dtIntra4 = as.data.table(intra4, na.rm = TRUE)
setnames(dtIntra4, "obs_value", "value")
dtIntra4 = dtIntra4[, .(REF_AREA, REF_SECTOR, TIME, value)]
dtIntra4$TIME = frequency(dtIntra4$TIME, "Q", refersto = "end")
attr(dtIntra4, "dcsimp") = NULL
attr(dtIntra4, "dcstruct") = NULL
dtIntra4$TIME = as.character(dtIntra4$TIME)
ppIntra4 = as.md3(copy(dtIntra4), id.vars=1:3)
aall[F4..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S121.1999q4:"]
aall[F4..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S12T.1999q4:"]
aall[F4..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S11.1999q4:"]
aall[F4..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S13.1999q4:"]
aall[F4..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S1M.1999q4:"]
aall[F4..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S124.1999q4:"]
aall[F4..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S12O.1999q4:"]
aall[F4..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S12Q.1999q4:"]

# Process F4S (Short-term loans)
names(dimnames(intra41))[[1]] = 'REF_AREA'
names(dimnames(intra41))[[2]] = 'REF_SECTOR'
dtIntra41 = as.data.table(intra41, na.rm = TRUE)
setnames(dtIntra41, "obs_value", "value")
dtIntra41 = dtIntra41[, .(REF_AREA, REF_SECTOR, TIME, value)]
dtIntra41$TIME = frequency(dtIntra41$TIME, "Q", refersto = "end")
attr(dtIntra41, "dcsimp") = NULL
attr(dtIntra41, "dcstruct") = NULL
dtIntra41$TIME = as.character(dtIntra41$TIME)
ppIntra41 = as.md3(copy(dtIntra41), id.vars=1:3)
aall[F4S..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S121.1999q4:"]
aall[F4S..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S12T.1999q4:"]
aall[F4S..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S11.1999q4:"]
aall[F4S..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S13.1999q4:"]
aall[F4S..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S1M.1999q4:"]
aall[F4S..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S124.1999q4:"]
aall[F4S..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S12O.1999q4:"]
aall[F4S..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S12Q.1999q4:"]

# Process F4L (Long-term loans)
names(dimnames(intra42))[[1]] = 'REF_AREA'
names(dimnames(intra42))[[2]] = 'REF_SECTOR'
dtIntra42 = as.data.table(intra42, na.rm = TRUE)
setnames(dtIntra42, "obs_value", "value")
dtIntra42 = dtIntra42[, .(REF_AREA, REF_SECTOR, TIME, value)]
dtIntra42$TIME = frequency(dtIntra42$TIME, "Q", refersto = "end")
attr(dtIntra42, "dcsimp") = NULL
attr(dtIntra42, "dcstruct") = NULL
dtIntra42$TIME = as.character(dtIntra42$TIME)
ppIntra42 = as.md3(copy(dtIntra42), id.vars=1:3)
aall[F4L..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S121.1999q4:"]
aall[F4L..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S12T.1999q4:"]
aall[F4L..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S11.1999q4:"]
aall[F4L..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S13.1999q4:"]
aall[F4L..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S1M.1999q4:"]
aall[F4L..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S124.1999q4:"]
aall[F4L..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S12O.1999q4:"]
aall[F4L..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S12Q.1999q4:"]

# Process F3 (Debt securities)
names(dimnames(intra3))[[1]] = 'REF_AREA'
names(dimnames(intra3))[[2]] = 'REF_SECTOR'
dtIntra3 = as.data.table(intra3, na.rm = TRUE)
setnames(dtIntra3, "obs_value", "value")
dtIntra3 = dtIntra3[, .(REF_AREA, REF_SECTOR, TIME, value)]
dtIntra3$TIME = frequency(dtIntra3$TIME, "Q", refersto = "end")
attr(dtIntra3, "dcsimp") = NULL
attr(dtIntra3, "dcstruct") = NULL
dtIntra3$TIME = as.character(dtIntra3$TIME)
ppIntra3 = as.md3(copy(dtIntra3), id.vars=1:3)
aall[F3..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S121.1999q4:"]
aall[F3..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S12T.1999q4:"]
aall[F3..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S11.1999q4:"]
aall[F3..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S13.1999q4:"]
aall[F3..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S1M.1999q4:"]
aall[F3..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S124.1999q4:"]
aall[F3..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S12O.1999q4:"]
aall[F3..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S12Q.1999q4:"]

# Process F3S (Short-term debt securities)
names(dimnames(intra31))[[1]] = 'REF_AREA'
names(dimnames(intra31))[[2]] = 'REF_SECTOR'
dtIntra31 = as.data.table(intra31, na.rm = TRUE)
setnames(dtIntra31, "obs_value", "value")
dtIntra31 = dtIntra31[, .(REF_AREA, REF_SECTOR, TIME, value)]
dtIntra31$TIME = frequency(dtIntra31$TIME, "Q", refersto = "end")
attr(dtIntra31, "dcsimp") = NULL
attr(dtIntra31, "dcstruct") = NULL
dtIntra31$TIME = as.character(dtIntra31$TIME)
ppIntra31 = as.md3(copy(dtIntra31), id.vars=1:3)
aall[F3S..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S121.1999q4:"]
aall[F3S..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S12T.1999q4:"]
aall[F3S..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S11.1999q4:"]
aall[F3S..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S13.1999q4:"]
aall[F3S..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S1M.1999q4:"]
aall[F3S..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S124.1999q4:"]
aall[F3S..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S12O.1999q4:"]
aall[F3S..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S12Q.1999q4:"]

# Process F3L (Long-term debt securities)
names(dimnames(intra32))[[1]] = 'REF_AREA'
names(dimnames(intra32))[[2]] = 'REF_SECTOR'
dtIntra32 = as.data.table(intra32, na.rm = TRUE)
setnames(dtIntra32, "obs_value", "value")
dtIntra32 = dtIntra32[, .(REF_AREA, REF_SECTOR, TIME, value)]
dtIntra32$TIME = frequency(dtIntra32$TIME, "Q", refersto = "end")
attr(dtIntra32, "dcsimp") = NULL
attr(dtIntra32, "dcstruct") = NULL
dtIntra32$TIME = as.character(dtIntra32$TIME)
ppIntra32 = as.md3(copy(dtIntra32), id.vars=1:3)
aall[F3L..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S121.1999q4:"]
aall[F3L..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S12T.1999q4:"]
aall[F3L..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S11.1999q4:"]
aall[F3L..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S13.1999q4:"]
aall[F3L..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S1M.1999q4:"]
aall[F3L..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S124.1999q4:"]
aall[F3L..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S12O.1999q4:"]
aall[F3L..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S12Q.1999q4:"]

# Process F21 (Currency)
names(dimnames(intra21))[[1]] = 'REF_AREA'
names(dimnames(intra21))[[2]] = 'REF_SECTOR'
dtIntra21 = as.data.table(intra21, na.rm = TRUE)
setnames(dtIntra21, "obs_value", "value")
dtIntra21 = dtIntra21[, .(REF_AREA, REF_SECTOR, TIME, value)]
dtIntra21$TIME = frequency(dtIntra21$TIME, "Q", refersto = "end")
attr(dtIntra21, "dcsimp") = NULL
attr(dtIntra21, "dcstruct") = NULL
dtIntra21$TIME = as.character(dtIntra21$TIME)
ppIntra21 = as.md3(copy(dtIntra21), id.vars=1:3)
aall[F21..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S121.1999q4:"]
aall[F21..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S12T.1999q4:"]
aall[F21..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S11.1999q4:"]
aall[F21..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S13.1999q4:"]
aall[F21..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S1M.1999q4:"]
aall[F21..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S124.1999q4:"]
aall[F21..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S12O.1999q4:"]
aall[F21..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S12Q.1999q4:"]

# Process F (Total financial assets/liabilities)
names(dimnames(intraf))[[1]] = 'REF_AREA'
names(dimnames(intraf))[[2]] = 'REF_SECTOR'
dtIntraf = as.data.table(intraf, na.rm = TRUE)
setnames(dtIntraf, "obs_value", "value")
dtIntraf = dtIntraf[, .(REF_AREA, REF_SECTOR, TIME, value)]
dtIntraf$TIME = frequency(dtIntraf$TIME, "Q", refersto = "end")
attr(dtIntraf, "dcsimp") = NULL
attr(dtIntraf, "dcstruct") = NULL
dtIntraf$TIME = as.character(dtIntraf$TIME)
ppIntraf = as.md3(copy(dtIntraf), id.vars=1:3)
aall[F..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S121.1999q4:"]
aall[F..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S12T.1999q4:"]
aall[F..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S11.1999q4:"]
aall[F..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S13.1999q4:"]
aall[F..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S1M.1999q4:"]
aall[F..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S124.1999q4:"]
aall[F..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S12O.1999q4:"]
aall[F..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S12Q.1999q4:"]

# Process F51 (Equity)
names(dimnames(intra51))[[1]] = 'REF_AREA'
names(dimnames(intra51))[[2]] = 'REF_SECTOR'
dtIntra51 = as.data.table(intra51, na.rm = TRUE)
setnames(dtIntra51, "obs_value", "value")
dtIntra51 = dtIntra51[, .(REF_AREA, REF_SECTOR, TIME, value)]
dtIntra51$TIME = frequency(dtIntra51$TIME, "Q", refersto = "end")
attr(dtIntra51, "dcsimp") = NULL
attr(dtIntra51, "dcstruct") = NULL
dtIntra51$TIME = as.character(dtIntra51$TIME)
ppIntra51 = as.md3(copy(dtIntra51), id.vars=1:3)
aall[F51..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S121.1999q4:"]
aall[F51..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S12T.1999q4:"]
aall[F51..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S11.1999q4:"]
aall[F51..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S13.1999q4:"]
aall[F51..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S1M.1999q4:"]
aall[F51..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S124.1999q4:"]
aall[F51..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S12O.1999q4:"]
aall[F51..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S12Q.1999q4:"]

# Process F6 (Insurance, pension and standardized guarantee schemes)
names(dimnames(intra6))[[1]] = 'REF_AREA'
names(dimnames(intra6))[[2]] = 'REF_SECTOR'
dtIntra6 = as.data.table(intra6, na.rm = TRUE)
setnames(dtIntra6, "obs_value", "value")
dtIntra6 = dtIntra6[, .(REF_AREA, REF_SECTOR, TIME, value)]
dtIntra6$TIME = frequency(dtIntra6$TIME, "Q", refersto = "end")
attr(dtIntra6, "dcsimp") = NULL
attr(dtIntra6, "dcstruct") = NULL
dtIntra6$TIME = as.character(dtIntra6$TIME)
ppIntra6 = as.md3(copy(dtIntra6), id.vars=1:3)
aall[F6..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S121.1999q4:"]
aall[F6..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S12T.1999q4:"]
aall[F6..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S11.1999q4:"]
aall[F6..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S13.1999q4:"]
aall[F6..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S1M.1999q4:"]
aall[F6..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S124.1999q4:"]
aall[F6..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S12O.1999q4:"]
aall[F6..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S12Q.1999q4:"]

# Process F7 (Financial derivatives)
names(dimnames(intra7))[[1]] = 'REF_AREA'
names(dimnames(intra7))[[2]] = 'REF_SECTOR'
dtIntra7 = as.data.table(intra7, na.rm = TRUE)
setnames(dtIntra7, "obs_value", "value")
dtIntra7 = dtIntra7[, .(REF_AREA, REF_SECTOR, TIME, value)]
dtIntra7$TIME = frequency(dtIntra7$TIME, "Q", refersto = "end")
attr(dtIntra7, "dcsimp") = NULL
attr(dtIntra7, "dcstruct") = NULL
dtIntra7$TIME = as.character(dtIntra7$TIME)
ppIntra7 = as.md3(copy(dtIntra7), id.vars=1:3)
aall[F7..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S121.1999q4:"]
aall[F7..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S12T.1999q4:"]
aall[F7..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S11.1999q4:"]
aall[F7..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S13.1999q4:"]
aall[F7..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S1M.1999q4:"]
aall[F7..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S124.1999q4:"]
aall[F7..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S12O.1999q4:"]
aall[F7..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S12Q.1999q4:"]

# Process F81 (Trade credits and advances)
names(dimnames(intra81))[[1]] = 'REF_AREA'
names(dimnames(intra81))[[2]] = 'REF_SECTOR'
dtIntra81 = as.data.table(intra81, na.rm = TRUE)
setnames(dtIntra81, "obs_value", "value")
dtIntra81 = dtIntra81[, .(REF_AREA, REF_SECTOR, TIME, value)]
dtIntra81$TIME = frequency(dtIntra81$TIME, "Q", refersto = "end")
attr(dtIntra81, "dcsimp") = NULL
attr(dtIntra81, "dcstruct") = NULL
dtIntra81$TIME = as.character(dtIntra81$TIME)
ppIntra81 = as.md3(copy(dtIntra81), id.vars=1:3)
aall[F81..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S121.1999q4:"]
aall[F81..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S12T.1999q4:"]
aall[F81..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S11.1999q4:"]
aall[F81..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S13.1999q4:"]
aall[F81..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S1M.1999q4:"]
aall[F81..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S124.1999q4:"]
aall[F81..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S12O.1999q4:"]
aall[F81..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S12Q.1999q4:"]

# Process F89 (Other accounts receivable/payable)
names(dimnames(intra89))[[1]] = 'REF_AREA'
names(dimnames(intra89))[[2]] = 'REF_SECTOR'
dtIntra89 = as.data.table(intra89, na.rm = TRUE)
setnames(dtIntra89, "obs_value", "value")
dtIntra89 = dtIntra89[, .(REF_AREA, REF_SECTOR, TIME, value)]
dtIntra89$TIME = frequency(dtIntra89$TIME, "Q", refersto = "end")
attr(dtIntra89, "dcsimp") = NULL
attr(dtIntra89, "dcstruct") = NULL
dtIntra89$TIME = as.character(dtIntra89$TIME)
ppIntra89 = as.md3(copy(dtIntra89), id.vars=1:3)
aall[F89..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S121.1999q4:"]
aall[F89..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S12T.1999q4:"]
aall[F89..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S11.1999q4:"]
aall[F89..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S13.1999q4:"]
aall[F89..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S1M.1999q4:"]
aall[F89..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S124.1999q4:"]
aall[F89..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S12O.1999q4:"]
aall[F89..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S12Q.1999q4:"]


# F51M
names(dimnames(intra51M))[[1]] = 'REF_AREA'
names(dimnames(intra51M))[[2]] = 'REF_SECTOR'
dtIntra51M = as.data.table(intra51M, na.rm = TRUE)
setnames(dtIntra51M, "obs_value", "value")
dtIntra51M = dtIntra51M[, .(REF_AREA, REF_SECTOR, TIME, value)]
dtIntra51M$TIME = frequency(dtIntra51M$TIME, "Q", refersto = "end")
attr(dtIntra51M, "dcsimp") = NULL
attr(dtIntra51M, "dcstruct") = NULL
dtIntra51M$TIME = as.character(dtIntra51M$TIME)
ppIntra51M = as.md3(copy(dtIntra51M), id.vars=1:3)
aall[F51M..S121.S121.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51M[".S121.1999q4:"]
aall[F51M..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51M[".S12T.1999q4:"]
aall[F51M..S11.S11.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51M[".S11.1999q4:"]
aall[F51M..S13.S13.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51M[".S13.1999q4:"]
aall[F51M..S1M.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51M[".S1M.1999q4:"]
aall[F51M..S124.S124.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51M[".S124.1999q4:"]
aall[F51M..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51M[".S12O.1999q4:"]
aall[F51M..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51M[".S12Q.1999q4:"]

# F511
aall[F511..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S122_S123.1999q4:"]
aall[F511..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S121_S122_S123.1999q4:"]
aall[F511..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S125_S126_S127.1999q4:"]
aall[F511..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra511[".S128_S129.1999q4:"]
aall[F511..S12R.S12R.LE._T.] = aall[F511..S124.S124.LE._T.] + aall[F511..S12O.S12O.LE._T.] + aall[F511..S12Q.S12Q.LE._T.]

# F52
aall[F52..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S122_S123.1999q4:"]
aall[F52..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S121_S122_S123.1999q4:"]
aall[F52..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S125_S126_S127.1999q4:"]
aall[F52..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra52[".S128_S129.1999q4:"]
aall[F52..S12R.S12R.LE._T.] = aall[F52..S124.S124.LE._T.] + aall[F52..S12O.S12O.LE._T.] + aall[F52..S12Q.S12Q.LE._T.]

# F2M
aall[F2M..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppF2M[".S122_S123.1999q4:"]
aall[F2M..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppF2M[".S121_S122_S123.1999q4:"]
aall[F2M..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppF2M[".S125_S126_S127.1999q4:"]
aall[F2M..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppF2M[".S128_S129.1999q4:"]
aall[F2M..S12R.S12R.LE._T.] = aall[F2M..S124.S124.LE._T.] + aall[F2M..S12O.S12O.LE._T.] + aall[F2M..S12Q.S12Q.LE._T.]

# F4
aall[F4..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S122_S123.1999q4:"]
aall[F4..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S121_S122_S123.1999q4:"]
aall[F4..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S125_S126_S127.1999q4:"]
aall[F4..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra4[".S128_S129.1999q4:"]
aall[F4..S12R.S12R.LE._T.] = aall[F4..S124.S124.LE._T.] + aall[F4..S12O.S12O.LE._T.] + aall[F4..S12Q.S12Q.LE._T.]

# F4S
aall[F4S..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S122_S123.1999q4:"]
aall[F4S..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S121_S122_S123.1999q4:"]
aall[F4S..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S125_S126_S127.1999q4:"]
aall[F4S..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra41[".S128_S129.1999q4:"]
aall[F4S..S12R.S12R.LE._T.] = aall[F4S..S124.S124.LE._T.] + aall[F4S..S12O.S12O.LE._T.] + aall[F4S..S12Q.S12Q.LE._T.]

# F4L
aall[F4L..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S122_S123.1999q4:"]
aall[F4L..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S121_S122_S123.1999q4:"]
aall[F4L..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S125_S126_S127.1999q4:"]
aall[F4L..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra42[".S128_S129.1999q4:"]
aall[F4L..S12R.S12R.LE._T.] = aall[F4L..S124.S124.LE._T.] + aall[F4L..S12O.S12O.LE._T.] + aall[F4L..S12Q.S12Q.LE._T.]

# F3
aall[F3..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S122_S123.1999q4:"]
aall[F3..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S121_S122_S123.1999q4:"]
aall[F3..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S125_S126_S127.1999q4:"]
aall[F3..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra3[".S128_S129.1999q4:"]
aall[F3..S12R.S12R.LE._T.] = aall[F3..S124.S124.LE._T.] + aall[F3..S12O.S12O.LE._T.] + aall[F3..S12Q.S12Q.LE._T.]

# F3S
aall[F3S..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S122_S123.1999q4:"]
aall[F3S..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S121_S122_S123.1999q4:"]
aall[F3S..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S125_S126_S127.1999q4:"]
aall[F3S..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra31[".S128_S129.1999q4:"]
aall[F3S..S12R.S12R.LE._T.] = aall[F3S..S124.S124.LE._T.] + aall[F3S..S12O.S12O.LE._T.] + aall[F3S..S12Q.S12Q.LE._T.]

# F3L
aall[F3L..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S122_S123.1999q4:"]
aall[F3L..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S121_S122_S123.1999q4:"]
aall[F3L..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S125_S126_S127.1999q4:"]
aall[F3L..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra32[".S128_S129.1999q4:"]
aall[F3L..S12R.S12R.LE._T.] = aall[F3L..S124.S124.LE._T.] + aall[F3L..S12O.S12O.LE._T.] + aall[F3L..S12Q.S12Q.LE._T.]

# F21
aall[F21..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S122_S123.1999q4:"]
aall[F21..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S121_S122_S123.1999q4:"]
aall[F21..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S125_S126_S127.1999q4:"]
aall[F21..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra21[".S128_S129.1999q4:"]
aall[F21..S12R.S12R.LE._T.] = aall[F21..S124.S124.LE._T.] + aall[F21..S12O.S12O.LE._T.] + aall[F21..S12Q.S12Q.LE._T.]

# F (Total financial assets/liabilities)
aall[F..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S122_S123.1999q4:"]
aall[F..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S121_S122_S123.1999q4:"]
aall[F..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S125_S126_S127.1999q4:"]
aall[F..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntraf[".S128_S129.1999q4:"]
aall[F..S12R.S12R.LE._T.] = aall[F..S124.S124.LE._T.] + aall[F..S12O.S12O.LE._T.] + aall[F..S12Q.S12Q.LE._T.]

# F51
aall[F51..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S122_S123.1999q4:"]
aall[F51..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S121_S122_S123.1999q4:"]
aall[F51..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S125_S126_S127.1999q4:"]
aall[F51..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra51[".S128_S129.1999q4:"]
aall[F51..S12R.S12R.LE._T.] = aall[F51..S124.S124.LE._T.] + aall[F51..S12O.S12O.LE._T.] + aall[F51..S12Q.S12Q.LE._T.]

# F51M
aall[F51M..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppF51M[".S122_S123.1999q4:"]
aall[F51M..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppF51M[".S121_S122_S123.1999q4:"]
aall[F51M..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppF51M[".S125_S126_S127.1999q4:"]
aall[F51M..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppF51M[".S128_S129.1999q4:"]
aall[F51M..S12R.S12R.LE._T.] = aall[F51M..S124.S124.LE._T.] + aall[F51M..S12O.S12O.LE._T.] + aall[F51M..S12Q.S12Q.LE._T.]

# F6
aall[F6..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S122_S123.1999q4:"]
aall[F6..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S121_S122_S123.1999q4:"]
aall[F6..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S125_S126_S127.1999q4:"]
aall[F6..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra6[".S128_S129.1999q4:"]
aall[F6..S12R.S12R.LE._T.] = aall[F6..S124.S124.LE._T.] + aall[F6..S12O.S12O.LE._T.] + aall[F6..S12Q.S12Q.LE._T.]

# F6N
aall[F6N..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppF6N[".S122_S123.1999q4:"]
aall[F6N..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppF6N[".S121_S122_S123.1999q4:"]
aall[F6N..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppF6N[".S125_S126_S127.1999q4:"]
aall[F6N..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppF6N[".S128_S129.1999q4:"]
aall[F6N..S12R.S12R.LE._T.] = aall[F6N..S124.S124.LE._T.] + aall[F6N..S12O.S12O.LE._T.] + aall[F6N..S12Q.S12Q.LE._T.]

# F6O
aall[F6O..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppF6O[".S122_S123.1999q4:"]
aall[F6O..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppF6O[".S121_S122_S123.1999q4:"]
aall[F6O..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppF6O[".S125_S126_S127.1999q4:"]
aall[F6O..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppF6O[".S128_S129.1999q4:"]
aall[F6O..S12R.S12R.LE._T.] = aall[F6O..S124.S124.LE._T.] + aall[F6O..S12O.S12O.LE._T.] + aall[F6O..S12Q.S12Q.LE._T.]

# F7
aall[F7..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S122_S123.1999q4:"]
aall[F7..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S121_S122_S123.1999q4:"]
aall[F7..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S125_S126_S127.1999q4:"]
aall[F7..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra7[".S128_S129.1999q4:"]
aall[F7..S12R.S12R.LE._T.] = aall[F7..S124.S124.LE._T.] + aall[F7..S12O.S12O.LE._T.] + aall[F7..S12Q.S12Q.LE._T.]

# F81
aall[F81..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S122_S123.1999q4:"]
aall[F81..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S121_S122_S123.1999q4:"]
aall[F81..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S125_S126_S127.1999q4:"]
aall[F81..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra81[".S128_S129.1999q4:"]
aall[F81..S12R.S12R.LE._T.] = aall[F81..S124.S124.LE._T.] + aall[F81..S12O.S12O.LE._T.] + aall[F81..S12Q.S12Q.LE._T.]

# F89
aall[F89..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S122_S123.1999q4:"]
aall[F89..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S121_S122_S123.1999q4:"]
aall[F89..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S125_S126_S127.1999q4:"]
aall[F89..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra89[".S128_S129.1999q4:"]
aall[F89..S12R.S12R.LE._T.] = aall[F89..S124.S124.LE._T.] + aall[F89..S12O.S12O.LE._T.] + aall[F89..S12Q.S12Q.LE._T.]

# F512
aall[F512..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra512[".S122_S123.1999q4:"]
aall[F512..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra512[".S121_S122_S123.1999q4:"]
aall[F512..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra512[".S125_S126_S127.1999q4:"]
aall[F512..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra512[".S128_S129.1999q4:"]
aall[F512..S12R.S12R.LE._T.] = aall[F512..S124.S124.LE._T.] + aall[F512..S12O.S12O.LE._T.] + aall[F512..S12Q.S12Q.LE._T.]

# F519
aall[F519..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra519[".S122_S123.1999q4:"]
aall[F519..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra519[".S121_S122_S123.1999q4:"]
aall[F519..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra519[".S125_S126_S127.1999q4:"]
aall[F519..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra519[".S128_S129.1999q4:"]
aall[F519..S12R.S12R.LE._T.] = aall[F519..S124.S124.LE._T.] + aall[F519..S12O.S12O.LE._T.] + aall[F519..S12Q.S12Q.LE._T.]

# F62
aall[F62..S12T.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra62[".S122_S123.1999q4:"]
aall[F62..S12K.S12K.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra62[".S121_S122_S123.1999q4:"]
aall[F62..S12O.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra62[".S125_S126_S127.1999q4:"]
aall[F62..S12Q.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = ppIntra62[".S128_S129.1999q4:"]
aall[F62..S12R.S12R.LE._T.] = aall[F62..S124.S124.LE._T.] + aall[F62..S12O.S12O.LE._T.] + aall[F62..S12Q.S12Q.LE._T.]
