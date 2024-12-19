###
## This fills the ECB QSA NAs for cases in which:
# ref sector is S121 (central bank) and counterpart is s0
# ref sector is S12T (other MFIs) and counterpart is s0
# using Eurostat data

library(MDecfin)

# Load all unconsolidated data for each instrument
aa511nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F511.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa52nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F52.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa22nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F22.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa29nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F29.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa4nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F4.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa41nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F41.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa42nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F42.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa3nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F3.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa31nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F31.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa32nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F32.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa21nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F21.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aafnc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa51nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F51.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa512nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F512.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa519nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F519.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa6nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F6.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa62nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F62.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa6nnc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F63_F64_F65.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa6onc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F61_F66.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa7nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F7.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa81nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F81.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa89nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F89.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

## Try to consolidate the loading
## aa_nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F511+F52+F22+F29+F4+F41+F42+F3+F31+F32+F21+F51+F512+F519.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
## until here everything runs ok but if I try to add another financial instrument it does not work anymore:
## Error in .stackedsdmx(mycode, justxml = TRUE, verbose = verbose, startPeriod = startPeriod,  : 
## Could not fetch data for query code ESTAT/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F511+F52+F22+F29+F4+F41+F42+F3+F31+F32+F21+F51+F512+F519+F81.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE.


# Process F2M (sum of F22 and F29)
aaF22A = aa22nc[..]
aaF29A = aa29nc[..]
aaF2MA = aaF22A + aaF29A
names(dimnames(aaF2MA))[[1]] = 'REF_AREA'
names(dimnames(aaF2MA))[[2]] = 'REF_SECTOR'
dtF2MA = as.data.table(aaF2MA, na.rm = TRUE)
dtF2MA$TIME = frequency(dtF2MA$TIME, "Q", refersto = "end")
attr(dtF2MA, "dcsimp") = NULL
attr(dtF2MA, "dcstruct") = NULL
dtF2MA$TIME = as.character(dtF2MA$TIME)
ppF2M = as.md3(copy(dtF2MA), id.vars=1:3)
aall[F2M..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF2M[".S121.1999q4:"]
aall[F2M..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF2M[".S12T.1999q4:"]

# Process F51M (sum of F512 and F519)
aaF512A = aa512nc[..]
aaF519A = aa519nc[..]
aaF51MA = aaF512A + aaF519A
names(dimnames(aaF51MA))[[1]] = 'REF_AREA'
names(dimnames(aaF51MA))[[2]] = 'REF_SECTOR'
dtF51MA = as.data.table(aaF51MA, na.rm = TRUE)
dtF51MA$TIME = frequency(dtF51MA$TIME, "Q", refersto = "end")
attr(dtF51MA, "dcsimp") = NULL
attr(dtF51MA, "dcstruct") = NULL
dtF51MA$TIME = as.character(dtF51MA$TIME)
ppF51M = as.md3(copy(dtF51MA), id.vars=1:3)
aall[F51M..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF51M[".S121.1999q4:"]
aall[F51M..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF51M[".S12T.1999q4:"]

# Process F6N (sum of F62 and F63_F64_F65)
aaF62A = aa62nc[..]
aaF626364A = aa6nnc[..]
aaF6NA = aaF62A + aaF626364A
names(dimnames(aaF6NA))[[1]] = 'REF_AREA'
names(dimnames(aaF6NA))[[2]] = 'REF_SECTOR'
dtF6NA = as.data.table(aaF6NA, na.rm = TRUE)
dtF6NA$TIME = frequency(dtF6NA$TIME, "Q", refersto = "end")
attr(dtF6NA, "dcsimp") = NULL
attr(dtF6NA, "dcstruct") = NULL
dtF6NA$TIME = as.character(dtF6NA$TIME)
ppF6N = as.md3(copy(dtF6NA), id.vars=1:3)
aall[F6N..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF6N[".S121.1999q4:"]
aall[F6N..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF6N[".S12T.1999q4:"]

# Process F511 (Listed shares)
aaF511A = aa511nc[..]
names(dimnames(aaF511A))[[1]] = 'REF_AREA'
names(dimnames(aaF511A))[[2]] = 'REF_SECTOR'
dtF511A = as.data.table(aaF511A, na.rm = TRUE)
setnames(dtF511A, "obs_value", "value")
dtF511A = dtF511A[, .(REF_AREA, REF_SECTOR, TIME, value)]
dtF511A$TIME = frequency(dtF511A$TIME, "Q", refersto = "end")
attr(dtF511A, "dcsimp") = NULL
attr(dtF511A, "dcstruct") = NULL
dtF511A$TIME = as.character(dtF511A$TIME)
ppF511 = as.md3(copy(dtF511A), id.vars=1:3)
aall[F511..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF511[".S121.1999q4:"]
aall[F511..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF511[".S12T.1999q4:"]

# Process F52 (Investment fund shares)
aaF52A = aa52nc[..]
names(dimnames(aaF52A))[[1]] = 'REF_AREA'
names(dimnames(aaF52A))[[2]] = 'REF_SECTOR'
dtF52A = as.data.table(aaF52A, na.rm = TRUE)
setnames(dtF52A, "obs_value", "value")
dtF52A = dtF52A[, .(REF_AREA, REF_SECTOR, TIME, value)]
dtF52A$TIME = frequency(dtF52A$TIME, "Q", refersto = "end")
attr(dtF52A, "dcsimp") = NULL
attr(dtF52A, "dcstruct") = NULL
dtF52A$TIME = as.character(dtF52A$TIME)
ppF52 = as.md3(copy(dtF52A), id.vars=1:3)
aall[F52..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF52[".S121.1999q4:"]
aall[F52..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF52[".S12T.1999q4:"]

# Process F4 (Loans)
aaF4A = aa4nc[..]
names(dimnames(aaF4A))[[1]] = 'REF_AREA'
names(dimnames(aaF4A))[[2]] = 'REF_SECTOR'
dtF4A = as.data.table(aaF4A, na.rm = TRUE)
setnames(dtF4A, "obs_value", "value")
dtF4A = dtF4A[, .(REF_AREA, REF_SECTOR, TIME, value)]
dtF4A$TIME = frequency(dtF4A$TIME, "Q", refersto = "end")
attr(dtF4A, "dcsimp") = NULL
attr(dtF4A, "dcstruct") = NULL
dtF4A$TIME = as.character(dtF4A$TIME)
ppF4 = as.md3(copy(dtF4A), id.vars=1:3)
aall[F4..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF4[".S121.1999q4:"]
aall[F4..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF4[".S12T.1999q4:"]

# Process F4S (Short-term loans)
aaF4SA = aa41nc[..]
names(dimnames(aaF4SA))[[1]] = 'REF_AREA'
names(dimnames(aaF4SA))[[2]] = 'REF_SECTOR'
dtF4SA = as.data.table(aaF4SA, na.rm = TRUE)
setnames(dtF4SA, "obs_value", "value")
dtF4SA = dtF4SA[, .(REF_AREA, REF_SECTOR, TIME, value)]
dtF4SA$TIME = frequency(dtF4SA$TIME, "Q", refersto = "end")
attr(dtF4SA, "dcsimp") = NULL
attr(dtF4SA, "dcstruct") = NULL
dtF4SA$TIME = as.character(dtF4SA$TIME)
ppF4S = as.md3(copy(dtF4SA), id.vars=1:3)
aall[F4S..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF4S[".S121.1999q4:"]
aall[F4S..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF4S[".S12T.1999q4:"]

# Process F4L (Long-term loans)
aaF4LA = aa42nc[..]
names(dimnames(aaF4LA))[[1]] = 'REF_AREA'
names(dimnames(aaF4LA))[[2]] = 'REF_SECTOR'
dtF4LA = as.data.table(aaF4LA, na.rm = TRUE)
setnames(dtF4LA, "obs_value", "value")
dtF4LA = dtF4LA[, .(REF_AREA, REF_SECTOR, TIME, value)]
dtF4LA$TIME = frequency(dtF4LA$TIME, "Q", refersto = "end")
attr(dtF4LA, "dcsimp") = NULL
attr(dtF4LA, "dcstruct") = NULL
dtF4LA$TIME = as.character(dtF4LA$TIME)
ppF4L = as.md3(copy(dtF4LA), id.vars=1:3)
aall[F4L..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF4L[".S121.1999q4:"]
aall[F4L..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF4L[".S12T.1999q4:"]

# Process F3 (Debt securities)
aaF3A = aa3nc[..]
names(dimnames(aaF3A))[[1]] = 'REF_AREA'
names(dimnames(aaF3A))[[2]] = 'REF_SECTOR'
dtF3A = as.data.table(aaF3A, na.rm = TRUE)
setnames(dtF3A, "obs_value", "value")
dtF3A = dtF3A[, .(REF_AREA, REF_SECTOR, TIME, value)]
dtF3A$TIME = frequency(dtF3A$TIME, "Q", refersto = "end")
attr(dtF3A, "dcsimp") = NULL
attr(dtF3A, "dcstruct") = NULL
dtF3A$TIME = as.character(dtF3A$TIME)
ppF3 = as.md3(copy(dtF3A), id.vars=1:3)
aall[F3..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF3[".S121.1999q4:"]
aall[F3..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF3[".S12T.1999q4:"]

# Process F3S (Short-term debt securities)
aaF3SA = aa31nc[..]
names(dimnames(aaF3SA))[[1]] = 'REF_AREA'
names(dimnames(aaF3SA))[[2]] = 'REF_SECTOR'
dtF3SA = as.data.table(aaF3SA, na.rm = TRUE)
setnames(dtF3SA, "obs_value", "value")
dtF3SA = dtF3SA[, .(REF_AREA, REF_SECTOR, TIME, value)]
dtF3SA$TIME = frequency(dtF3SA$TIME, "Q", refersto = "end")
attr(dtF3SA, "dcsimp") = NULL
attr(dtF3SA, "dcstruct") = NULL
dtF3SA$TIME = as.character(dtF3SA$TIME)
ppF3S = as.md3(copy(dtF3SA), id.vars=1:3)
aall[F3S..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF3S[".S121.1999q4:"]
aall[F3S..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF3S[".S12T.1999q4:"]

# Process F3L (Long-term debt securities)
aaF3LA = aa32nc[..]
names(dimnames(aaF3LA))[[1]] = 'REF_AREA'
names(dimnames(aaF3LA))[[2]] = 'REF_SECTOR'
dtF3LA = as.data.table(aaF3LA, na.rm = TRUE)
setnames(dtF3LA, "obs_value", "value")
dtF3LA = dtF3LA[, .(REF_AREA, REF_SECTOR, TIME, value)]
dtF3LA$TIME = frequency(dtF3LA$TIME, "Q", refersto = "end")
attr(dtF3LA, "dcsimp") = NULL
attr(dtF3LA, "dcstruct") = NULL
dtF3LA$TIME = as.character(dtF3LA$TIME)
ppF3L = as.md3(copy(dtF3LA), id.vars=1:3)
aall[F3L..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF3L[".S121.1999q4:"]
aall[F3L..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF3L[".S12T.1999q4:"]

# Process F21 (Currency)
aaF21A = aa21nc[..]
names(dimnames(aaF21A))[[1]] = 'REF_AREA'
names(dimnames(aaF21A))[[2]] = 'REF_SECTOR'
dtF21A = as.data.table(aaF21A, na.rm = TRUE)
setnames(dtF21A, "obs_value", "value")
dtF21A = dtF21A[, .(REF_AREA, REF_SECTOR, TIME, value)]
dtF21A$TIME = frequency(dtF21A$TIME, "Q", refersto = "end")
attr(dtF21A, "dcsimp") = NULL
attr(dtF21A, "dcstruct") = NULL
dtF21A$TIME = as.character(dtF21A$TIME)
ppF21 = as.md3(copy(dtF21A), id.vars=1:3)
aall[F21..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF21[".S121.1999q4:"]
aall[F21..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF21[".S12T.1999q4:"]

# Process F (Total financial assets/liabilities)
aaFA = aafnc[..]
names(dimnames(aaFA))[[1]] = 'REF_AREA'
names(dimnames(aaFA))[[2]] = 'REF_SECTOR'
dtFA = as.data.table(aaFA, na.rm = TRUE)
setnames(dtFA, "obs_value", "value")
dtFA = dtFA[, .(REF_AREA, REF_SECTOR, TIME, value)]
dtFA$TIME = frequency(dtFA$TIME, "Q", refersto = "end")
attr(dtFA, "dcsimp") = NULL
attr(dtFA, "dcstruct") = NULL
dtFA$TIME = as.character(dtFA$TIME)
ppF = as.md3(copy(dtFA), id.vars=1:3)
aall[F..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF[".S121.1999q4:"]
aall[F..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF[".S12T.1999q4:"]

# Process F51 (Equity)
aaF51A = aa51nc[..]
names(dimnames(aaF51A))[[1]] = 'REF_AREA'
names(dimnames(aaF51A))[[2]] = 'REF_SECTOR'
dtF51A = as.data.table(aaF51A, na.rm = TRUE)
setnames(dtF51A, "obs_value", "value")
dtF51A = dtF51A[, .(REF_AREA, REF_SECTOR, TIME, value)]
dtF51A$TIME = frequency(dtF51A$TIME, "Q", refersto = "end")
attr(dtF51A, "dcsimp") = NULL
attr(dtF51A, "dcstruct") = NULL
dtF51A$TIME = as.character(dtF51A$TIME)
ppF51 = as.md3(copy(dtF51A), id.vars=1:3)
aall[F51..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF51[".S121.1999q4:"]
aall[F51..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF51[".S12T.1999q4:"]

# Process F6 (Insurance, pension and standardized guarantee schemes)
aaF6A = aa6nc[..]
names(dimnames(aaF6A))[[1]] = 'REF_AREA'
names(dimnames(aaF6A))[[2]] = 'REF_SECTOR'
dtF6A = as.data.table(aaF6A, na.rm = TRUE)
setnames(dtF6A, "obs_value", "value")
dtF6A = dtF6A[, .(REF_AREA, REF_SECTOR, TIME, value)]
dtF6A$TIME = frequency(dtF6A$TIME, "Q", refersto = "end")
attr(dtF6A, "dcsimp") = NULL
attr(dtF6A, "dcstruct") = NULL
dtF6A$TIME = as.character(dtF6A$TIME)
ppF6 = as.md3(copy(dtF6A), id.vars=1:3)
aall[F6..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF6[".S121.1999q4:"]
aall[F6..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF6[".S12T.1999q4:"]

# Process F6O (Non-life insurance provisions)
aaF6OA = aa6onc[..]
names(dimnames(aaF6OA))[[1]] = 'REF_AREA'
names(dimnames(aaF6OA))[[2]] = 'REF_SECTOR'
dtF6OA = as.data.table(aaF6OA, na.rm = TRUE)
setnames(dtF6OA, "obs_value", "value")
dtF6OA = dtF6OA[, .(REF_AREA, REF_SECTOR, TIME, value)]
dtF6OA$TIME = frequency(dtF6OA$TIME, "Q", refersto = "end")
attr(dtF6OA, "dcsimp") = NULL
attr(dtF6OA, "dcstruct") = NULL
dtF6OA$TIME = as.character(dtF6OA$TIME)
ppF6O = as.md3(copy(dtF6OA), id.vars=1:3)
aall[F6O..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF6O[".S121.1999q4:"]
aall[F6O..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF6O[".S12T.1999q4:"]

# Process F7 (Financial derivatives)
aaF7A = aa7nc[..]
names(dimnames(aaF7A))[[1]] = 'REF_AREA'
names(dimnames(aaF7A))[[2]] = 'REF_SECTOR'
dtF7A = as.data.table(aaF7A, na.rm = TRUE)
setnames(dtF7A, "obs_value", "value")
dtF7A = dtF7A[, .(REF_AREA, REF_SECTOR, TIME, value)]
dtF7A$TIME = frequency(dtF7A$TIME, "Q", refersto = "end")
attr(dtF7A, "dcsimp") = NULL
attr(dtF7A, "dcstruct") = NULL
dtF7A$TIME = as.character(dtF7A$TIME)
ppF7 = as.md3(copy(dtF7A), id.vars=1:3)
aall[F7..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF7[".S121.1999q4:"]
aall[F7..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF7[".S12T.1999q4:"]

# Process F81 (Trade credits and advances)
aaF81A = aa81nc[..]
names(dimnames(aaF81A))[[1]] = 'REF_AREA'
names(dimnames(aaF81A))[[2]] = 'REF_SECTOR'
dtF81A = as.data.table(aaF81A, na.rm = TRUE)
setnames(dtF81A, "obs_value", "value")
dtF81A = dtF81A[, .(REF_AREA, REF_SECTOR, TIME, value)]
dtF81A$TIME = frequency(dtF81A$TIME, "Q", refersto = "end")
attr(dtF81A, "dcsimp") = NULL
attr(dtF81A, "dcstruct") = NULL
dtF81A$TIME = as.character(dtF81A$TIME)
ppF81 = as.md3(copy(dtF81A), id.vars=1:3)
aall[F81..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF81[".S121.1999q4:"]
aall[F81..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF81[".S12T.1999q4:"]

# Process F89 (Other accounts receivable/payable)
aaF89A = aa89nc[..]
names(dimnames(aaF89A))[[1]] = 'REF_AREA'
names(dimnames(aaF89A))[[2]] = 'REF_SECTOR'
dtF89A = as.data.table(aaF89A, na.rm = TRUE)
setnames(dtF89A, "obs_value", "value")
dtF89A = dtF89A[, .(REF_AREA, REF_SECTOR, TIME, value)]
dtF89A$TIME = frequency(dtF89A$TIME, "Q", refersto = "end")
attr(dtF89A, "dcsimp") = NULL
attr(dtF89A, "dcstruct") = NULL
dtF89A$TIME = as.character(dtF89A$TIME)
ppF89 = as.md3(copy(dtF89A), id.vars=1:3)
aall[F89..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF89[".S121.1999q4:"]
aall[F89..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF89[".S12T.1999q4:"]



#################### CONSISTENCY CHECKS ####################

# SECTORAL CONSISTENCY CHECK 
# Verify if central bank + financial sector (S12K) from ECB equals sum of S121+S12T

# Check function with multiple thresholds
check_sectors = function(thresholds = c(1, 1.5, 2)) {
  # Get the data
  data_parts = aall[..S121+S12T.S0.LE._T.2023q4]
  data_whole = aall[..S12K.S0.LE._T.2023q4]
  
  # Convert to data.table for easier handling
  parts_dt = as.data.table(data_parts, na.rm=TRUE)
  whole_dt = as.data.table(data_whole, na.rm=TRUE)
  
  # Calculate difference
  diff = data_whole - apply(data_parts, c(1,2), sum, na.rm=TRUE)
  
  # For each threshold, analyze discrepancies
  for(threshold in thresholds) {
    cat("\n\n=== Analysis for threshold", threshold, "===\n")
    
    # Get indices where absolute difference exceeds threshold
    significant_indices = which(abs(diff) > threshold, arr.ind = TRUE)
    
    if(length(significant_indices) > 0) {
      cat("\nFound", nrow(significant_indices), "discrepancies larger than", threshold, "\n")
      
      # For each discrepancy, print detailed information
      for(i in 1:nrow(significant_indices)) {
        instr_idx = significant_indices[i, 1]
        country_idx = significant_indices[i, 2]
        
        # Get dimension names
        instr_name = dimnames(diff)[[1]][instr_idx]
        country_name = dimnames(diff)[[2]][country_idx]
        
        # Extract values using data.table
        s121_vals = parts_dt[INSTR == instr_name & REF_AREA == country_name & 
                               REF_SECTOR == "S121", obs_value]
        s12t_vals = parts_dt[INSTR == instr_name & REF_AREA == country_name & 
                               REF_SECTOR == "S12T", obs_value]
        s12k_vals = whole_dt[INSTR == instr_name & REF_AREA == country_name, obs_value]
        
        # Only print if we have all values
        if(length(s121_vals) > 0 && length(s12t_vals) > 0 && length(s12k_vals) > 0) {
          s121_val = s121_vals[1]
          s12t_val = s12t_vals[1]
          s12k_val = s12k_vals[1]
          
          cat("\nDiscrepancy found for:\n")
          cat("Instrument:", instr_name, "\n")
          cat("Country:", country_name, "\n")
          cat("S121 value:", format(s121_val, digits=2), "\n")
          cat("S12T value:", format(s12t_val, digits=2), "\n")
          cat("Sum of parts (S121+S12T):", format(s121_val + s12t_val, digits=2), "\n")
          cat("S12K value:", format(s12k_val, digits=2), "\n")
          cat("Difference:", format(s12k_val - (s121_val + s12t_val), digits=2), "\n")
          cat("--------------------\n")
        }
      }
    } else {
      cat("\nNo discrepancies found exceeding threshold", threshold, "\n")
    }
  }
  
  # Return the full difference matrix for further analysis if needed
  return(invisible(diff))
}

# Run the check with default thresholds
result = check_sectors()


