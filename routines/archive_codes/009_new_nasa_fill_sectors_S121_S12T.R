library(MDecfin)

# Load unconsolidated data
la = readRDS("data/nasa_unconsolidated.rds")

###new
aall=readRDS(file.path(data_dir,'aall4.rds'))
setkey(aall, NULL)

# Process F2M (sum of F22 and F29)
aaF22A = la$aa22nc[..]
aaF29A = la$aa29nc[..]
aaF2MA = aaF22A + aaF29A
names(dimnames(aaF2MA))[[1]] = 'REF_AREA'
names(dimnames(aaF2MA))[[2]] = 'REF_SECTOR'
ppF2M=copy(aaF2MA); frequency(ppF2M)='Q'
aall[F2M..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF2M[".S121.1999q4:"]
aall[F2M..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF2M[".S12T.1999q4:"]

# Process F4 (Loans)
aaF4A = la$aa4nc[..]
names(dimnames(aaF4A))[[1]] = 'REF_AREA'
names(dimnames(aaF4A))[[2]] = 'REF_SECTOR'
ppF4=copy(aaF4A); frequency(ppF4)='Q'
aall[F4..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF4[".S121.1999q4:"]
aall[F4..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF4[".S12T.1999q4:"]

# Process F511 (Listed shares)
aaF511A = la$aa511nc[..]
names(dimnames(aaF511A))[[1]] = 'REF_AREA'
names(dimnames(aaF511A))[[2]] = 'REF_SECTOR'
ppF511=copy(aaF511A); frequency(ppF511)='Q'
aall[F511..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF511[".S121.1999q4:"]
aall[F511..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF511[".S12T.1999q4:"]

# Process F52 (Investment fund shares)
aaF52A = la$aa52nc[..]
names(dimnames(aaF52A))[[1]] = 'REF_AREA'
names(dimnames(aaF52A))[[2]] = 'REF_SECTOR'
ppF52=copy(aaF52A); frequency(ppF52)='Q'
aall[F52..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF52[".S121.1999q4:"]
aall[F52..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF52[".S12T.1999q4:"]

# Process F3 (Debt securities)
aaF3A = la$aa3nc[..]
names(dimnames(aaF3A))[[1]] = 'REF_AREA'
names(dimnames(aaF3A))[[2]] = 'REF_SECTOR'
ppF3=copy(aaF3A); frequency(ppF3)='Q'
aall[F3..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF3[".S121.1999q4:"]
aall[F3..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF3[".S12T.1999q4:"]

# Process F3S (Short-term debt securities)
aaF3SA = la$aa31nc[..]
names(dimnames(aaF3SA))[[1]] = 'REF_AREA'
names(dimnames(aaF3SA))[[2]] = 'REF_SECTOR'
ppF3S=copy(aaF3SA); frequency(ppF3S)='Q'
aall[F3S..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF3S[".S121.1999q4:"]
aall[F3S..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF3S[".S12T.1999q4:"]

# Process F3L (Long-term debt securities)
aaF3LA = la$aa32nc[..]
names(dimnames(aaF3LA))[[1]] = 'REF_AREA'
names(dimnames(aaF3LA))[[2]] = 'REF_SECTOR'
ppF3L=copy(aaF3LA); frequency(ppF3L)='Q'
aall[F3L..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF3L[".S121.1999q4:"]
aall[F3L..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF3L[".S12T.1999q4:"]

# Process F21 (Currency)
aaF21A = la$aa21nc[..]
names(dimnames(aaF21A))[[1]] = 'REF_AREA'
names(dimnames(aaF21A))[[2]] = 'REF_SECTOR'
ppF21=copy(aaF21A); frequency(ppF21)='Q'
aall[F21..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF21[".S121.1999q4:"]
aall[F21..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF21[".S12T.1999q4:"]

# Process F (Total financial assets/liabilities)
aaFA = la$aafnc[..]
names(dimnames(aaFA))[[1]] = 'REF_AREA'
names(dimnames(aaFA))[[2]] = 'REF_SECTOR'
ppF=copy(aaFA); frequency(ppF)='Q'
aall[F..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF[".S121.1999q4:"]
aall[F..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF[".S12T.1999q4:"]

# Process F51 (Equity)
aaF51A = la$aa51nc[..]
names(dimnames(aaF51A))[[1]] = 'REF_AREA'
names(dimnames(aaF51A))[[2]] = 'REF_SECTOR'
ppF51=copy(aaF51A); frequency(ppF51)='Q'
aall[F51..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF51[".S121.1999q4:"]
aall[F51..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF51[".S12T.1999q4:"]

# Process F51M (sum of F512 and F519)
aaF512A = la$aa512nc[..]
aaF519A = la$aa519nc[..]
aaF51MA = aaF512A + aaF519A
names(dimnames(aaF51MA))[[1]] = 'REF_AREA'
names(dimnames(aaF51MA))[[2]] = 'REF_SECTOR'
ppF51M=copy(aaF51MA); frequency(ppF51M)='Q'
aall[F51M..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF51M[".S121.1999q4:"]
aall[F51M..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF51M[".S12T.1999q4:"]

# Process F6 (Insurance, pension and standardized guarantee schemes)
aaF6A = la$aa6nc[..]
names(dimnames(aaF6A))[[1]] = 'REF_AREA'
names(dimnames(aaF6A))[[2]] = 'REF_SECTOR'
ppF6=copy(aaF6A); frequency(ppF6)='Q'
aall[F6..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF6[".S121.1999q4:"]
aall[F6..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF6[".S12T.1999q4:"]

# Process F6N (sum of F62 and F63_F64_F65)
aaF62A = la$aa62nc[..]
aaF6NA = la$aa6nnc[..]
aaF6NA = aaF62A + aaF6NA
names(dimnames(aaF6NA))[[1]] = 'REF_AREA'
names(dimnames(aaF6NA))[[2]] = 'REF_SECTOR'
ppF6N=copy(aaF6NA); frequency(ppF6N)='Q'
aall[F6N..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF6N[".S121.1999q4:"]
aall[F6N..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF6N[".S12T.1999q4:"]


# Process F7 (Financial derivatives)
aaF7A = la$aa7nc[..]
names(dimnames(aaF7A))[[1]] = 'REF_AREA'
names(dimnames(aaF7A))[[2]] = 'REF_SECTOR'
ppF7=copy(aaF7A); frequency(ppF7)='Q'
aall[F7..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF7[".S121.1999q4:"]
aall[F7..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF7[".S12T.1999q4:"]

# Process F81 (Trade credits and advances)
aaF81A = la$aa81nc[..]
names(dimnames(aaF81A))[[1]] = 'REF_AREA'
names(dimnames(aaF81A))[[2]] = 'REF_SECTOR'
ppF81=copy(aaF81A); frequency(ppF81)='Q'
aall[F81..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF81[".S121.1999q4:"]
aall[F81..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF81[".S12T.1999q4:"]

# Process F89 (Other accounts receivable/payable)
aaF89A = la$aa89nc[..]
names(dimnames(aaF89A))[[1]] = 'REF_AREA'
names(dimnames(aaF89A))[[2]] = 'REF_SECTOR'
ppF89=copy(aaF89A); frequency(ppF89)='Q'
aall[F89..S121.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF89[".S121.1999q4:"]
aall[F89..S12T.S0.LE._T., usenames=TRUE, onlyna=TRUE] = ppF89[".S12T.1999q4:"]

saveRDS(aall, file.path(data_dir, 'aall4.rds'))
