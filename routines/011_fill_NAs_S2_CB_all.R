##loading of ESTAT IIP quarterly and annual data / [bop_iip6_q] 
# https://db.nomics.world/Eurostat/bop_iip6_q


library(MDecfin)
setwd('H:/R/finflowbackup')

zerofiller=function(x, fillscalar=0){
  temp=copy(x)
  temp[onlyna=TRUE]=fillscalar
  temp
}

##annual assets 
#S12M in ESTAT = S12R in finflows
#aa=mds("Estat/bop_iip6_q/A.MIO_NAC...S1.A_LE.WRL_REST.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
print('loading of cross border assets')
aa1=mds("Estat/bop_iip6_q/Q.MIO_EUR..S1M+S11.S1.A_LE.WRL_REST.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa2=mds("Estat/bop_iip6_q/Q.MIO_EUR..S121+S12T+S12K.S1.A_LE.WRL_REST.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa3=mds("Estat/bop_iip6_q/Q.MIO_EUR..S13.S1.A_LE.WRL_REST.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa4=mds("Estat/bop_iip6_q/Q.MIO_EUR..S124.S1.A_LE.WRL_REST.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa5=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12O.S1.A_LE.WRL_REST.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa6=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12Q.S1.A_LE.WRL_REST.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa7=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12M.S1.A_LE.WRL_REST.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
tempaa=merge(aa1,aa2)
##technical bug in merge, therefore 'x' used - no impact on the data or sectors (13/01/25)
aa=merge(tempaa, aa3, aa4, aa5, aa6, aa7, along='sector10',newcodes=c('S13','x','S124','S12O','S12Q','S12M'))


##annual liabilities S121 + S122 + S12K
print('loading of cross borderliabilities')
ll1=mds("Estat/bop_iip6_q/Q.MIO_EUR..S121+S12T.S1.L_LE.WRL_REST.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
ll2=mds("Estat/bop_iip6_q/Q.MIO_EUR..S11.S1.L_LE.WRL_REST.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
ll3=mds("Estat/bop_iip6_q/Q.MIO_EUR..S1M.S1.L_LE.WRL_REST.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
ll4=mds("Estat/bop_iip6_q/Q.MIO_EUR..S13.S1.L_LE.WRL_REST.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
ll5=mds("Estat/bop_iip6_q/Q.MIO_EUR..S124.S1.L_LE.WRL_REST.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
ll6=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12O.S1.L_LE.WRL_REST.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
ll7=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12Q.S1.L_LE.WRL_REST.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
ll8=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12M.S1.L_LE.WRL_REST.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
ll9=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12K.S1.L_LE.WRL_REST.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
##technical bug in merge, therefore 'x' used - no impact on the data or sectors (13/01/25)
templl=merge(ll1,ll2,ll3,ll4, along='sector10',newcodes=c('S11','x','S1M','S13'))
ll=merge(templl,ll5,ll6,ll7,ll8,ll9, along='sector10',newcodes=c('S124','x','S12O','S12Q','S12M','S12K'))

#temporary
aall=readRDS('data/aall1.rds')

### data structure
names(dimnames(aa))[[1]] = 'REF_AREA'
names(dimnames(aa))[[2]] = 'REF_SECTOR'
names(dimnames(ll))[[1]] = 'REF_AREA'
names(dimnames(ll))[[2]] = 'REF_SECTOR'

## F total - Assets for Qdata
# Process F (sum of F per functional categories)
print('filling NAs of crossborder financial assets')
aaF = aa[..FA__D__F+FA__O__F+FA__P__F+FA__R__F+FA__F__F7.]
dtaaF = as.data.table(aaF, na.rm = TRUE)
ppFA = as.md3(dtaaF,id.vars=1:4,obsattr = "obs_status")
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
llF = ll[..FA__D__F+FA__O__F+FA__P__F+FA__R__F+FA__F__F7.]
dtllF = as.data.table(llF, na.rm = TRUE)
ppFL = as.md3(dtllF,id.vars=1:4,obsattr = "obs_status")
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
aaF2 = aa[..FA__O__F2+FA__R__F2.]
dtF2MA = as.data.table(aaF2, na.rm = TRUE)
ppF2M = as.md3(dtF2MA,id.vars=1:4,obsattr = "obs_status")
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
llF2 = ll[..FA__O__F2+FA__R__F2.]
dtF2ML = as.data.table(llF2, na.rm = TRUE)
ppF2M = as.md3(dtF2ML,id.vars=1:4,obsattr = "obs_status")
aall[F2M..S2.S121.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF2M[".S121.FA__O__F2.1999q4:"])+zerofiller(ppF2M[".S121.FA__R__F2.1999q4:"])
aall[F2M..S2.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF2M[".S12T.FA__O__F2.1999q4:"])
aall[F2M..S2.S13.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF2M[".S13.FA__O__F2.1999q4:"])

## F3 bonds total - Assets for Qdata
# Process F51M (sum of F512 and F519 from Direct Investment, Other Investment, Portfolio Investment)
print('filling NAs of crossborder F3 assets')
aaF3M = aa[..FA__D__F3+FA__P__F3+FA__R__F3.]
dtaaF3MA = as.data.table(aaF3M, na.rm = TRUE)
ppF3MA = as.md3(dtaaF3MA,id.vars=1:4,obsattr = "obs_status")
aall[F3..S121.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF3MA[".S121.FA__D__F3.1999q4:"])+zerofiller(ppF3MA[".S121.FA__P__F3.1999q4:"])+zerofiller(ppF3MA[".S121.FA__R__F3.1999q4:"])
aall[F3..S12T.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF3MA[".S12T.FA__D__F3.1999q4:"])+zerofiller(ppF3MA[".S12T.FA__P__F3.1999q4:"])
aall[F3..S13.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF3MA[".S13.FA__D__F3.1999q4:"])+zerofiller(ppF3MA[".S13.FA__P__F3.1999q4:"])
aall[F3..S11.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF3MA[".S11.FA__D__F3.1999q4:"])+zerofiller(ppF3MA[".S11.FA__P__F3.1999q4:"])
aall[F3..S1M.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF3MA[".S1M.FA__D__F3.1999q4:"])+zerofiller(ppF3MA[".S1M.FA__P__F3.1999q4:"])
aall[F3..S124.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF3MA[".S124.FA__D__F3.1999q4:"])+zerofiller(ppF3MA[".S124.FA__P__F3.1999q4:"])
aall[F3..S12O.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF3MA[".S12O.FA__D__F3.1999q4:"])+zerofiller(ppF3MA[".S12O.FA__P__F3.1999q4:"])
aall[F3..S12Q.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF3MA[".S12Q.FA__D__F3.1999q4:"])+zerofiller(ppF3MA[".S12Q.FA__P__F3.1999q4:"])
aall[F3..S12R.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF3MA[".S12M.FA__D__F3.1999q4:"])+zerofiller(ppF3MA[".S12M.FA__P__F3.1999q4:"])

## F3 bonds total - Assets for Qdata
# Process F51M (sum of F512 and F519 from Direct Investment, Other Investment, Portfolio Investment)
print('filling NAs of crossborder F3 liabilities')
llF3M = ll[..FA__D__F3+FA__P__F3.]
dtaaF3ML = as.data.table(llF3M, na.rm = TRUE)
ppF3ML = as.md3(dtaaF3ML,id.vars=1:4,obsattr = "obs_status")
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
aaF4 = aa[..FA__D__F4+FA__O__F4.]
dtaaF4A = as.data.table(aaF4, na.rm = TRUE)
ppF4A = as.md3(dtaaF4A,id.vars=1:4,obsattr = "obs_status")
aall[F4..S121.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4A[".S121.FA__D__F4.1999q4:"])+zerofiller(ppF4A[".S121.FA__P__F3.1999q4:"])
aall[F4..S12T.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4A[".S12T.FA__D__F4.1999q4:"])+zerofiller(ppF4A[".S12T.FA__P__F3.1999q4:"])
aall[F4..S13.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4A[".S13.FA__D__F4.1999q4:"])+zerofiller(ppF4A[".S13.FA__P__F3.1999q4:"])
aall[F4..S11.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4A[".S11.FA__D__F4.1999q4:"])+zerofiller(ppF4A[".S11.FA__P__F3.1999q4:"])
aall[F4..S1M.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4A[".S1M.FA__D__F4.1999q4:"])+zerofiller(ppF4A[".S1M.FA__P__F3.1999q4:"])
aall[F4..S124.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4A[".S124.FA__D__F4.1999q4:"])+zerofiller(ppF4A[".S124.FA__P__F3.1999q4:"])
aall[F4..S12O.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4A[".S12O.FA__D__F4.1999q4:"])+zerofiller(ppF4A[".S12O.FA__P__F3.1999q4:"])
aall[F4..S12Q.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4A[".S12Q.FA__D__F4.1999q4:"])+zerofiller(ppF4A[".S12Q.FA__P__F3.1999q4:"])
aall[F4..S12R.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4A[".S12M.FA__D__F4.1999q4:"])+zerofiller(ppF4A[".S12M.FA__P__F3.1999q4:"])

## F4 loans total - liabilities for Qdata
# Process F4 (sum of F4 from Direct Investment, Other Investment)
print('filling NAs of crossborder F4 liabilities')
llF4 = ll[..FA__D__F4+FA__O__F4.]
dtaaF4L = as.data.table(llF4, na.rm = TRUE)
ppF4L = as.md3(dtaaF4L,id.vars=1:4,obsattr = "obs_status")
aall[F4..S2.S121.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4L[".S121.FA__D__F4.1999q4:"])+zerofiller(ppF4L[".S121.FA__P__F3.1999q4:"])
aall[F4..S2.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4L[".S12T.FA__D__F4.1999q4:"])+zerofiller(ppF4L[".S12T.FA__P__F3.1999q4:"])
aall[F4..S2.S13.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4L[".S13.FA__D__F4.1999q4:"])+zerofiller(ppF4L[".S13.FA__P__F3.1999q4:"])
aall[F4..S2.S11.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4L[".S11.FA__D__F4.1999q4:"])+zerofiller(ppF4L[".S11.FA__P__F3.1999q4:"])
aall[F4..S2.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4L[".S1M.FA__D__F4.1999q4:"])+zerofiller(ppF4L[".S1M.FA__P__F3.1999q4:"])
aall[F4..S2.S124.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4L[".S124.FA__D__F4.1999q4:"])+zerofiller(ppF4L[".S124.FA__P__F3.1999q4:"])
aall[F4..S2.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4L[".S12O.FA__D__F4.1999q4:"])+zerofiller(ppF4L[".S12O.FA__P__F3.1999q4:"])
aall[F4..S2.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4L[".S12Q.FA__D__F4.1999q4:"])+zerofiller(ppF4L[".S12Q.FA__P__F3.1999q4:"])
aall[F4..S2.S12R.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF4L[".S12R.FA__D__F4.1999q4:"])+zerofiller(ppF4L[".S12R.FA__P__F3.1999q4:"])

## F52 investment fund shares - Assets for Qdata
# Process F52 ( Portfolio Investment)
print('filling NAs of crossborder F52 assets')
aaF52 = aa[..FA__P__F52., drop=FALSE]
dtaaF52A = as.data.table(aaF52, na.rm = TRUE)
ppF52A = as.md3(dtaaF52A,id.vars=1:4,obsattr = "obs_status")
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
llF52 = ll[..FA__P__F52., drop=FALSE]
dtllF52L = as.data.table(llF52, na.rm = TRUE)
ppF52L = as.md3(dtllF52L,id.vars=1:4,obsattr = "obs_status")
aall[F52..S2.S121.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF52L[".S121.FA__P__F52.1999q4:"])
aall[F52..S2.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF52L[".S12T.FA__P__F52.1999q4:"])
aall[F52..S2.S124.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF52L[".S124.FA__P__F52.1999q4:"])
aall[F52..S2.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF52L[".S12O.FA__P__F52.1999q4:"])
aall[F52..S2.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF52L[".S12Q.FA__P__F52.1999q4:"])
aall[F52..S2.S12R.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF52L[".S12M.FA__P__F52.1999q4:"])

## F511 listed shares - Assets for Qdata
# Process F511 (sum of F511 from Direct Investment and Portfolio Investment)
print('filling NAs of crossborder F511 assets')
aaF511 = aa[..FA__D__F511+FA__P__F511.]
dtaaF511A = as.data.table(aaF511, na.rm = TRUE)
ppF511A = as.md3(dtaaF511A,id.vars=1:4,obsattr = "obs_status")
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
llF511 = ll[..FA__D__F511+FA__P__F511.]
dtllF511L = as.data.table(llF511, na.rm = TRUE)
ppF511L = as.md3(dtllF511L,id.vars=1:4,obsattr = "obs_status")
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
aaF51M = aa[..FA__D__F51M+FA__O__F519+FA__P__F512.]
dtaaF51MA = as.data.table(aaF51M, na.rm = TRUE)
ppF51MA = as.md3(dtaaF51MA,id.vars=1:4,obsattr = "obs_status")
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
llF51M = ll[..FA__D__F51M+FA__O__F519+FA__P__F512.]
dtaaF51ML = as.data.table(llF51M, na.rm = TRUE)
ppF51ML = as.md3(dtaaF51ML,id.vars=1:4,obsattr = "obs_status")
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
aaF6 = aa[..FA__O__F6., drop=FALSE]
dtaaF6A = as.data.table(aaF6, na.rm = TRUE)
ppF6A = as.md3(dtaaF6A,id.vars=1:4,obsattr = "obs_status")
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
llF6 = ll[..FA__O__F6., drop=FALSE]
dtllF6L = as.data.table(llF6, na.rm = TRUE)
ppF6L = as.md3(dtllF6L,id.vars=1:4,obsattr = "obs_status")
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
aaF81 = aa[..FA__D__F81+FA__O__F81.]
dtaaF81A = as.data.table(aaF81, na.rm = TRUE)
ppF81A = as.md3(dtaaF81A,id.vars=1:4,obsattr = "obs_status")
aall[F81..S121.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF81A[".S121.FA__D__F81.1999q4:"])+zerofiller(ppF81A[".S121.FA__O__F81.1999q4:"])
aall[F81..S12T.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF81A[".S12T.FA__D__F81.1999q4:"])+zerofiller(ppF81A[".S12T.FA__O__F81.1999q4:"])
aall[F81..S11.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF81A[".S11.FA__D__F81.1999q4:"])+zerofiller(ppF81A[".S11.FA__O__F81.1999q4:"])
aall[F81..S1M.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF81A[".S1M.FA__D__F81.1999q4:"])+zerofiller(ppF81A[".S1M.FA__O__F81.1999q4:"])
aall[F81..S13.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF81A[".S13.FA__D__F81.1999q4:"])+zerofiller(ppF81A[".S13.FA__O__F81.1999q4:"])
aall[F81..S124.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF81A[".S124.FA__D__F81.1999q4:"])+zerofiller(ppF81A[".S124.FA__O__F81.1999q4:"])
aall[F81..S12O.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF81A[".S12O.FA__D__F81.1999q4:"])+zerofiller(ppF81A[".S12O.FA__O__F81.1999q4:"])
aall[F81..S12Q.S2.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF81A[".S12M.FA__D__F81.1999q4:"])+zerofiller(ppF81A[".S12M.FA__O__F81.1999q4:"])


## F81  - Liabilities for Qdata
# Process F81 from Direct Investment and Other Investment
print('filling NAs of crossborder F81 liabilities')
llF81 = ll[..FA__D__F81+FA__O__F81.]
dtllF81L = as.data.table(llF81, na.rm = TRUE)
ppF81L = as.md3(dtllF81L,id.vars=1:4,obsattr = "obs_status")
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
aaF89 = aa[..FA__O__F89., drop=FALSE]
dtaaF89A = as.data.table(aaF89, na.rm = TRUE)
ppF89A = as.md3(dtaaF89A,id.vars=1:4,obsattr = "obs_status")
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
llF89 = ll[..FA__O__F89., drop=FALSE]
dtllF89L = as.data.table(llF89, na.rm = TRUE)
ppF89L = as.md3(dtllF89L,id.vars=1:4,obsattr = "obs_status")
aall[F89..S2.S121.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF89L[".S121.FA__O__F89.1999q4:"])
aall[F89..S2.S12T.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF89L[".S12T.FA__O__F89.1999q4:"])
aall[F89..S2.S11.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF89L[".S11.FA__O__F89.1999q4:"])
aall[F89..S2.S1M.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF89L[".S1M.FA__O__F89.1999q4:"])
aall[F89..S2.S13.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF89L[".S13.FA__O__F89.1999q4:"])
aall[F89..S2.S124.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF89L[".S124.FA__O__F89.1999q4:"])
aall[F89..S2.S12O.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF89L[".S12O.FA__O__F89.1999q4:"])
aall[F89..S2.S12Q.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF89L[".S12Q.FA__O__F89.1999q4:"])
aall[F89..S2.S12R.LE._T., usenames=TRUE, onlyna=TRUE] = zerofiller(ppF89L[".S12M.FA__O__F89.1999q4:"])

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
