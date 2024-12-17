library(MDecfin)

# This requires having already loaded Non Consolidated data (see previous file)

# Load all consolidated data for each instrument
aa511c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F511.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa52c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F52.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa22c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F22.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa29c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F29.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa4c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F4.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa41c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F41.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa42c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F42.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa3c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F3.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa31c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F31.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa32c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F32.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa21c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F21.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aafc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa51c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F51.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa512c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F512.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa519c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F519.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa6c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F6.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa62c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F62.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa6Nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F63_F64_F65.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa7c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F7.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa81c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F81.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa89c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F89.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")


# Restrict the unconsolidated data to only assets to match dimensions with consolidated
aa511nc_ass = aa511nc[ASS...]
aa52nc_ass = aa52nc[ASS...]
aa22nc_ass = aa22nc[ASS...]
aa29nc_ass = aa29nc[ASS...]
aa4nc_ass = aa4nc[ASS...]
aa512nc_ass = aa512nc[ASS...] 
aa519nc_ass = aa519nc[ASS...]
aa41nc_ass = aa41nc[ASS...]
aa42nc_ass = aa42nc[ASS...]
aa3nc_ass = aa3nc[ASS...]
aa31nc_ass = aa31nc[ASS...]
aa32nc_ass = aa32nc[ASS...]
aa21nc_ass = aa21nc[ASS...]
aafnc_ass = aafnc[ASS...]
aa51nc_ass = aa51nc[ASS...]
aa6nc_ass = aa6nc[ASS...]
aa62nc_ass = aa62nc[ASS...]
aa6nnc_ass = aa6nnc[ASS...]
aa7nc_ass = aa7nc[ASS...]
aa81nc_ass = aa81nc[ASS...]
aa89nc_ass = aa89nc[ASS...]

# Calculate all intrasector exposures
intra511 = aa511nc_ass - aa511c
intra52 = aa52nc_ass - aa52c
intra22 = aa22nc_ass - aa22c
intra29 = aa29nc_ass - aa29c
intra4 = aa4nc_ass - aa4c
intra41 = aa41nc_ass - aa41c
intra42 = aa42nc_ass - aa42c
intra3 = aa3nc_ass - aa3c
intra31 = aa31nc_ass - aa31c
intra32 = aa32nc_ass - aa32c
intra21 = aa21nc_ass - aa21c
intraf = aafnc_ass - aafc
intra51 = aa51nc_ass - aa51c
intra6 = aa6nc_ass - aa6c
intra62 = aa62nc_ass - aa62c
intra6n = aa6nnc_ass - aa6Nc
intra7 = aa7nc_ass - aa7c
intra81 = aa81nc_ass - aa81c
intra89 = aa89nc_ass - aa89c
intra512 = aa512nc_ass - aa512c
intra519 = aa519nc_ass - aa519c

#NOW IN aall FOR THE INTRASECTORAL EXPOSURES OF THE TWO SECTORS S12T (MFI) AND S121 (CB) 
#WE CAN FILL THE NAs USING ALL THE intrasectoral exposures just calculated using eurostat.

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

# Process F89 (Other accounts receivable/payable)
names(dimnames(intra89))[[1]] = 'REF_AREA'
names(dimnames(intra89))[[2]] = 'REF_SECTOR'
dtIntra89 = as.data.table(intra89, na.rm = TRUE)
setnames(dtIntra89, "obs_value", "value")
dtIntra89 = dtIntra89[, .(REF_AREA, REF_SECTOR, TIME, value)]

