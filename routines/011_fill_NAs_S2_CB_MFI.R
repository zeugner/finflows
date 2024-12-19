##loading of ESTAT IIP quarterly and annual data / [bop_iip6_q] 
# https://db.nomics.world/Eurostat/bop_iip6_q


library(MDecfin)

zerofiller=function(x, fillscalar=0){
  temp=copy(x)
  temp[onlyna=TRUE]=fillscalar
  temp
}

##annual assets S121 + S122 + S12K
#aa=mds("Estat/bop_iip6_q/A.MIO_NAC...S1.A_LE.WRL_REST.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

aa=mds("Estat/bop_iip6_q/Q.MIO_EUR..S121+S122+S12T+S12K.S1.A_LE.WRL_REST.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

##annual liabilities S121 + S122 + S12K
ll=mds("Estat/bop_iip6_q/Q.MIO_EUR..S121+S122+S12T+S12K.S1.L_LE.WRL_REST.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

#temporary
aall=readRDS('data/aall1.rds')

### data structure
names(dimnames(aa))[[1]] = 'REF_AREA'
names(dimnames(aa))[[2]] = 'REF_SECTOR'
names(dimnames(ll))[[1]] = 'REF_AREA'
names(dimnames(ll))[[2]] = 'REF_SECTOR'

## F total - Assets for Qdata
# Process F (sum of F per functional categories)
aaF = aa[..FA__D__F+FA__O__F+FA__P__F+FA__R__F+FA__F__F7.]
dtaaF = as.data.table(aaF, na.rm = TRUE)
ppFA = as.md3(dtaaF,id.vars=1:4,obsattr = "obs_status")
aall[F..S121.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppFA[".S121.FA__D__F.1999q4:"])+zerofiller(ppFA[".S121.FA__O__F.1999q4:"])+zerofiller(ppFA[".S121.FA__P__F.1999q4:"])+zerofiller(ppFA[".S121.FA__F__F7.1999q4:"])+zerofiller(ppFA[".S121.FA__R__F.1999q4:"])
aall[F..S12T.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppFA[".S12T.FA__D__F.1999q4:"])+zerofiller(ppFA[".S12T.FA__O__F.1999q4:"])+zerofiller(ppFA[".S12T.FA__P__F.1999q4:"])+zerofiller(ppFA[".S12T.FA__F__F7.1999q4:"])

## F total - liabilities for Qdata
# Process F (sum of F per functional categories)
llF = ll[..FA__D__F+FA__O__F+FA__P__F+FA__R__F+FA__F__F7.]
dtllF = as.data.table(llF, na.rm = TRUE)
ppFL = as.md3(dtllF,id.vars=1:4,obsattr = "obs_status")
aall[F..S2.S121.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppFL[".S121.FA__D__F.1999q4:"])+zerofiller(ppFL[".S121.FA__O__F.1999q4:"])+zerofiller(ppFL[".S121.FA__P__F.1999q4:"])+zerofiller(ppFL[".S121.FA__F__F7.1999q4:"])
aall[F..S2.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppFL[".S12T.FA__D__F.1999q4:"])+zerofiller(ppFL[".S12T.FA__O__F.1999q4:"])+zerofiller(ppFL[".S12T.FA__P__F.1999q4:"])+zerofiller(ppFL[".S121.FA__F__F7.1999q4:"])

## F2 deposits and currency - Assets for Qdata
# Process F2M (sum of F22 and F29)
aaF2 = aa[..FA__O__F2+FA__R__F2.]
dtF2MA = as.data.table(aaF2, na.rm = TRUE)
#dtF2MA$TIME = frequency(dtF2MA$TIME, "Q", refersto = "end")
#attr(dtF2MA, "dcsimp") = NULL
#attr(dtF2MA, "dcstruct") = NULL
#dtF2MA$TIME = as.character(dtF2MA$TIME)
ppF2M = as.md3(dtF2MA,id.vars=1:4,obsattr = "obs_status")
aall[F2M..S121.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF2M[".S121.FA__O__F2.1999q4:"])+zerofiller(ppF2M[".S121.FA__R__F2.1999q4:"])
aall[F2M..S121.S2.LE.FNR., usenames=TRUE] = zerofiller(ppF2M[".S121.FA__R__F2.1999q4:"])
aall[F2M..S12T.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF2M[".S12T.FA__O__F2.1999q4:"])

## F2 deposits and currency - Liabilities for Qdata
# Process F2M (sum of F22 and F29)
llF2 = ll[..FA__O__F2+FA__R__F2.]
dtF2ML = as.data.table(llF2, na.rm = TRUE)
ppF2M = as.md3(dtF2ML,id.vars=1:4,obsattr = "obs_status")
aall[F2M..S2.S121.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF2M[".S121.FA__O__F2.1999q4:"])+zerofiller(ppF2M[".S121.FA__R__F2.1999q4:"])
aall[F2M..S2.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF2M[".S12T.FA__O__F2.1999q4:"])

## F3 bonds total - Assets for Qdata
# Process F51M (sum of F512 and F519 from Direct Investment, Other Investment, Portfolio Investment)
aaF3M = aa[..FA__D__F3+FA__P__F3+FA__R__F3.]
dtaaF3MA = as.data.table(aaF3M, na.rm = TRUE)
ppF3MA = as.md3(dtaaF3MA,id.vars=1:4,obsattr = "obs_status")
aall[F3..S121.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF3MA[".S121.FA__D__F3.1999q4:"])+zerofiller(ppF3MA[".S121.FA__P__F3.1999q4:"])+zerofiller(ppF3MA[".S121.FA__R__F3.1999q4:"])
aall[F3..S12T.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF3MA[".S12T.FA__D__F3.1999q4:"])+zerofiller(ppF3MA[".S12T.FA__P__F3.1999q4:"])

## F3 bonds total - Assets for Qdata
# Process F51M (sum of F512 and F519 from Direct Investment, Other Investment, Portfolio Investment)
llF3M = ll[..FA__D__F3+FA__P__F3.]
dtaaF3ML = as.data.table(llF3M, na.rm = TRUE)
ppF3ML = as.md3(dtaaF3ML,id.vars=1:4,obsattr = "obs_status")
aall[F3..S2.S121.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF3ML[".S121.FA__D__F3.1999q4:"])+zerofiller(ppF3ML[".S121.FA__P__F3.1999q4:"])
aall[F3..S2.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF3ML[".S12T.FA__D__F3.1999q4:"])+zerofiller(ppF3ML[".S12T.FA__P__F3.1999q4:"])

## F4 loans total - Assets for Qdata
# Process F4 (sum of F4 from Direct Investment, Other Investment)
aaF4 = aa[..FA__D__F4+FA__O__F4.]
dtaaF4A = as.data.table(aaF4, na.rm = TRUE)
ppF4A = as.md3(dtaaF4A,id.vars=1:4,obsattr = "obs_status")
aall[F4..S121.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4A[".S121.FA__D__F4.1999q4:"])+zerofiller(ppF4A[".S121.FA__P__F3.1999q4:"])
aall[F4..S12T.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4A[".S12T.FA__D__F4.1999q4:"])+zerofiller(ppF4A[".S12T.FA__P__F3.1999q4:"])

## F4 loans total - liabilities for Qdata
# Process F4 (sum of F4 from Direct Investment, Other Investment)
llF4 = ll[..FA__D__F4+FA__O__F4.]
dtaaF4L = as.data.table(llF4, na.rm = TRUE)
ppF4L = as.md3(dtaaF4L,id.vars=1:4,obsattr = "obs_status")
aall[F4..S2.S121.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4L[".S121.FA__D__F4.1999q4:"])+zerofiller(ppF4L[".S121.FA__P__F3.1999q4:"])
aall[F4..S2.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4L[".S12T.FA__D__F4.1999q4:"])+zerofiller(ppF4L[".S12T.FA__P__F3.1999q4:"])

## F511 listed shares - Assets for Qdata
# Process F511 (sum of F511 from Direct Investment and Portfolio Investment)
aaF511 = aa[..FA__D__F511+FA__P__F511.]
dtaaF511A = as.data.table(aaF511, na.rm = TRUE)
ppF511A = as.md3(dtaaF511A,id.vars=1:4,obsattr = "obs_status")
aall[F511..S121.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF511A[".S121.FA__D__F511.1999q4:"])+zerofiller(ppF511A[".S121.FA__P__F511.1999q4:"])
aall[F511..S12T.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF511A[".S12T.FA__D__F511.1999q4:"])+zerofiller(ppF511A[".S12T.FA__P__F511.1999q4:"])

## F511 listed shares - Liabilities for Qdata
# Process F511 (sum of F511 from Direct Investment and Portfolio Investment)
llF511 = ll[..FA__D__F511+FA__P__F511.]
dtllF511L = as.data.table(llF511, na.rm = TRUE)
ppF511L = as.md3(dtllF511L,id.vars=1:4,obsattr = "obs_status")
aall[F511..S2.S121.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF511L[".S121.FA__D__F511.1999q4:"])+zerofiller(ppF511L[".S121.FA__P__F511.1999q4:"])
aall[F511..S2.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF511L[".S12T.FA__D__F511.1999q4:"])+zerofiller(ppF511L[".S12T.FA__P__F511.1999q4:"])

## F51M other equity - Assets for Qdata
# Process F51M (sum of F512 and F519 from Direct Investment, Other Investment, Portfolio Investment)
# checkFDI to see if F51M or F512+F519 are filled for Q data 
#check = aa[..FA__D__F51M.2022q4]- aa[..FA__D__F512+FA__D__F519.2022q4] 
aaF51M = aa[..FA__D__F51M+FA__O__F519+FA__P__F512.]
dtaaF51MA = as.data.table(aaF51M, na.rm = TRUE)
ppF51MA = as.md3(dtaaF51MA,id.vars=1:4,obsattr = "obs_status")
aall[F51M..S121.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF51MA[".S121.FA__D__F51M.1999q4:"])+zerofiller(ppF51MA[".S121.FA__O__F519.1999q4:"])+zerofiller(ppF51MA[".S121.FA__P__F512.1999q4:"])
aall[F51M..S12T.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF51MA[".S12T.FA__D__F51M.1999q4:"])+zerofiller(ppF51MA[".S12T.FA__O__F519.1999q4:"])+zerofiller(ppF51MA[".S12T.FA__P__F512.1999q4:"])

## F51M other equity - Liabilities for Qdata
# Process F51M (sum of F512 and F519 from Direct Investment, Other Investment, Portfolio Investment)
# checkFDI to see if F51M or F512+F519 are filled for Q data 
#check = aa[..FA__D__F51M.2022q4]- aa[..FA__D__F512+FA__D__F519.2022q4] 
llF51M = ll[..FA__D__F51M+FA__O__F519+FA__P__F512.]
dtaaF51ML = as.data.table(llF51M, na.rm = TRUE)
ppF51ML = as.md3(dtaaF51ML,id.vars=1:4,obsattr = "obs_status")
aall[F51M..S2.S121.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF51ML[".S121.FA__D__F51M.1999q4:"])+zerofiller(ppF51ML[".S121.FA__O__F519.1999q4:"])+zerofiller(ppF51ML[".S121.FA__P__F512.1999q4:"])
aall[F51M..S2.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF51ML[".S12T.FA__D__F51M.1999q4:"])+zerofiller(ppF51ML[".S12T.FA__O__F519.1999q4:"])+zerofiller(ppF51ML[".S12T.FA__P__F512.1999q4:"])

## F6  - Assets for Qdata
# Process F6 Other Investment
aaF6 = aa[..FA__O__F6.]
dtaaF6A = as.data.table(aaF6, na.rm = TRUE)
ppF6A = as.md3(dtaaF6A,id.vars=1:4,obsattr = "obs_status")
aall[F6..S121.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF6A[".S121.FA__O__F6.1999q4:"])
aall[F6..S12T.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF6A[".S12T.FA__O__F6.1999q4:"])

## F6  - liabilities for Qdata
# Process F6 Other Investment
llF6 = ll[..FA__O__F6.]
dtllF6L = as.data.table(llF6, na.rm = TRUE)
ppF6L = as.md3(dtllF6L,id.vars=1:4,obsattr = "obs_status")
aall[F6..S2.S121.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF6L[".S121.FA__O__F6.1999q4:"])
aall[F6..S2.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF6L[".S12T.FA__O__F6.1999q4:"])

## F81  - Assets for Qdata
# Process F81 from Direct Investment and Other Investment
aaF81 = aa[..FA__D__F81+FA__O__F81.]
dtaaF81A = as.data.table(aaF81, na.rm = TRUE)
ppF81A = as.md3(dtaaF81A,id.vars=1:4,obsattr = "obs_status")
aall[F81..S121.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF81A[".S121.FA__D__F81.1999q4:"])+zerofiller(ppF81A[".S121.FA__O__F81.1999q4:"])
aall[F81..S12T.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF81A[".S12T.FA__D__F81.1999q4:"])+zerofiller(ppF81A[".S12T.FA__O__F81.1999q4:"])

## F81  - Liabilities for Qdata
# Process F81 from Direct Investment and Other Investment
llF81 = ll[..FA__D__F81+FA__O__F81.]
dtllF81L = as.data.table(llF81, na.rm = TRUE)
ppF81L = as.md3(dtllF81L,id.vars=1:4,obsattr = "obs_status")
aall[F81..S2.S121.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF81L[".S121.FA__D__F81.1999q4:"])+zerofiller(ppF81L[".S121.FA__O__F81.1999q4:"])
aall[F81..S2.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF81L[".S12T.FA__D__F81.1999q4:"])+zerofiller(ppF81L[".S12T.FA__O__F81.1999q4:"])

## F89  - Assets for Qdata
# Process F89 from Other Investment
aaF89 = aa[..FA__O__F89.]
dtaaF89A = as.data.table(aaF89, na.rm = TRUE)
ppF89A = as.md3(dtaaF89A,id.vars=1:4,obsattr = "obs_status")
aall[F89..S121.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF89A[".S121.FA__O__F89.1999q4:"])
aall[F89..S12T.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF89A[".S12T.FA__O__F89.1999q4:"])

## F89  - Liabilities for Qdata
# Process F89 from Other Investment
llF89 = ll[..FA__O__F89.]
dtllF89L = as.data.table(llF89, na.rm = TRUE)
ppF89L = as.md3(dtllF89L,id.vars=1:4,obsattr = "obs_status")
aall[F89..S2.S121.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF89L[".S121.FA__O__F89.1999q4:"])
aall[F89..S2.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF89L[".S12T.FA__O__F89.1999q4:"])

#################### CONSISTENCY CHECKS ####################
#### CHECK IF S121+S12T vis-a-vis S2 = S12K vis-a-vis S2
# Verify if central bank + financial sector (S12K) from ECB equals sum of S121+S12T
check1=aall[F51M..S12K.S2.LE._T.2023q4]-rowSums(aall[F51M..S121+S12T.S2.LE._T.2023q4])
result_check1 <- check1[abs(check1) > 1.5]
check2=aall[F51M..S2.S12K.LE._T.2023q4]-rowSums(aall[F51M..S2.S12K.LE._T.2023q4])
result_check2 <- check2[abs(check2) > 1.5]
# Extract actual values for problematic cases
result_check1
result_check2
