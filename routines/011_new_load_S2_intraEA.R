##loading of ESTAT IIP quarterly and annual data / [bop_iip6_q] 
# https://db.nomics.world/Eurostat/bop_iip6_q

library(MDecfin)

#### intra EA #### 

##quartlery assets 
#aa=mds("Estat/bop_iip6_q/A.MIO_NAC...S1.A_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
print('loading of cross border assets')
eaaa1=mds("Estat/bop_iip6_q/Q.MIO_EUR..S1M+S11.S1.A_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eaaa2=mds("Estat/bop_iip6_q/Q.MIO_EUR..S121+S12T+S12K.S1.A_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eaaa3=mds("Estat/bop_iip6_q/Q.MIO_EUR..S13.S1.A_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eaaa4=mds("Estat/bop_iip6_q/Q.MIO_EUR..S124.S1.A_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eaaa5=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12O.S1.A_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eaaa6=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12Q.S1.A_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eaaa7=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12M.S1.A_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eaaa8=mds("Estat/bop_iip6_q/Q.MIO_EUR..S1.S1.A_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eatempaa=merge(eaaa1,eaaa2)
##technical bug in merge, therefore 'x' used - no impact on the data or sectors (13/01/25)
ealaiip=merge(eatempaa, eaaa3, eaaa4, eaaa5, eaaa6, eaaa7,eaaa8, along='sector10',newcodes=c('S13','x','S124','S12O','S12Q','S12M','S1'))

##quarterly liabilities 
print('loading of cross borderliabilities')
eall1=mds("Estat/bop_iip6_q/Q.MIO_EUR..S121+S12T.S1.L_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eall2=mds("Estat/bop_iip6_q/Q.MIO_EUR..S11.S1.L_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eall3=mds("Estat/bop_iip6_q/Q.MIO_EUR..S1M.S1.L_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eall4=mds("Estat/bop_iip6_q/Q.MIO_EUR..S13.S1.L_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eall5=mds("Estat/bop_iip6_q/Q.MIO_EUR..S124.S1.L_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eall6=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12O.S1.L_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eall7=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12Q.S1.L_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eall8=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12M.S1.L_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
#eall9=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12K.S1.L_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eall10=mds("Estat/bop_iip6_q/Q.MIO_EUR..S1.S1.L_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
##technical bug in merge, therefore 'x' used - no impact on the data or sectors (13/01/25)
eatempll=merge(eall1,eall2,eall3,eall4, along='sector10',newcodes=c('S11','x','S1M','S13'))
ealliip=merge(eatempll,eall5,eall6,eall7,eall8,eall10, along='sector10',newcodes=c('S124','x','S12O','S12Q','S12M','S1'))


# Save all data
saveRDS(ealaiip,file='data/iip6_assets_ea.rds')
saveRDS(ealliip,file='data/iip6_liabilities_ea.rds')


##loading of ESTAT bop quarterly data / [bop_iip6_q] 
# https://db.nomics.world/Eurostat/bop_c6_q

##quartlery assets 
#aa=mds("Estat/bop_c6_q/Q.MIO_EUR...S1.ASS.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
print('loading of cross border assets transaction')
eataa1=mds("Estat/bop_c6_q/Q.MIO_EUR..S121+S122.S1.ASS.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eataa2=mds("Estat/bop_c6_q/Q.MIO_EUR..S123+S12M.S1.ASS.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eataa3=mds("Estat/bop_c6_q/Q.MIO_EUR..S12T+S1P.S1.ASS.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eataa4=mds("Estat/bop_c6_q/Q.MIO_EUR..S1V+S13+S1.S1.ASS.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

eatemptaa=merge(eataa1,eataa2) 
##technical bug in merge, therefore 'x' used - no impact on the data or sectors (13/01/25)
ealabop=merge(eatemptaa, eataa3, eataa4, along='sector10',newcodes=c('S12T','x','S1P','S1V','S13','S1'))

##quarterly liabilities 
print('loading of cross border liabilities transactions')
eatll1=mds("Estat/bop_c6_q/Q.MIO_EUR..S121+S122.S1.LIAB.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eatll2=mds("Estat/bop_c6_q/Q.MIO_EUR..S123+S12M.S1.LIAB.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eatll3=mds("Estat/bop_c6_q/Q.MIO_EUR..S12T+S1P.S1.LIAB.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eatll4=mds("Estat/bop_c6_q/Q.MIO_EUR..S1V+S13+S1.S1.LIAB.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

eatemptll=merge(eatll1,eatll2)
eallbop=merge(eatemptll,eatll3,eatll4, along='sector10',newcodes=c('S12T','x','S1P','S1V','S13','S1'))

# Save all data
saveRDS(ealabop,file='data/bop6_assets_ea.rds')
saveRDS(eallbop,file='data/bop6_liabilities_ea.rds')
