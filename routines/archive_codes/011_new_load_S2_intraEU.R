##loading of ESTAT IIP quarterly and annual data / [bop_iip6_q] 
# https://db.nomics.world/Eurostat/bop_iip6_q

library(MDecfin)

#### intra EU #### 

##quartlery assets 
#aa=mds("Estat/bop_iip6_q/A.MIO_NAC...S1.A_LE.EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
print('loading of cross border assets')
euaa1=mds("Estat/bop_iip6_q/Q.MIO_EUR..S1M+S11.S1.A_LE.EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
euaa2=mds("Estat/bop_iip6_q/Q.MIO_EUR..S121+S12T+S12K.S1.A_LE.EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
euaa3=mds("Estat/bop_iip6_q/Q.MIO_EUR..S13.S1.A_LE.EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
euaa4=mds("Estat/bop_iip6_q/Q.MIO_EUR..S124.S1.A_LE.EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
euaa5=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12O.S1.A_LE.EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
euaa6=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12Q.S1.A_LE.EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
euaa7=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12M.S1.A_LE.EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
euaa8=mds("Estat/bop_iip6_q/Q.MIO_EUR..S1.S1.A_LE.EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eutempaa=merge(euaa1,euaa2)
##technical bug in merge, therefore 'x' used - no impact on the data or sectors (13/01/25)
eulaiip=merge(eutempaa, euaa3, euaa4, euaa5, euaa6, euaa7,euaa8, along='sector10',newcodes=c('S13','x','S124','S12O','S12Q','S12M','S1'))

##quarterly liabilities 
print('loading of cross borderliabilities')
eull1=mds("Estat/bop_iip6_q/Q.MIO_EUR..S121+S12T.S1.L_LE.EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eull2=mds("Estat/bop_iip6_q/Q.MIO_EUR..S11.S1.L_LE.EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eull3=mds("Estat/bop_iip6_q/Q.MIO_EUR..S1M.S1.L_LE.EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eull4=mds("Estat/bop_iip6_q/Q.MIO_EUR..S13.S1.L_LE.EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eull5=mds("Estat/bop_iip6_q/Q.MIO_EUR..S124.S1.L_LE.EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eull6=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12O.S1.L_LE.EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eull7=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12Q.S1.L_LE.EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eull8=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12M.S1.L_LE.EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
#eull9=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12K.S1.L_LE.EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eull10=mds("Estat/bop_iip6_q/Q.MIO_EUR..S1.S1.L_LE.EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
##technical bug in merge, therefore 'x' used - no impact on the data or sectors (13/01/25)
eutempll=merge(eull1,eull2,eull3,eull4, along='sector10',newcodes=c('S11','x','S1M','S13'))
eulliip=merge(eutempll,eull5,eull6,eull7,eull8,eull10, along='sector10',newcodes=c('S124','x','S12O','S12Q','S12M','S1'))


# Save all data
saveRDS(eulaiip,file='data/iip6_assets_eu.rds')
saveRDS(eulliip,file='data/iip6_liabilities_eu.rds')


##loading of ESTAT bop quarterly data / [bop_iip6_q] 
# https://db.nomics.world/Eurostat/bop_c6_q

##quartlery assets 
#aa=mds("Estat/bop_c6_q/Q.MIO_EUR...S1.ASS.EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
print('loading of cross border assets transaction')
eutaa1=mds("Estat/bop_c6_q/Q.MIO_EUR..S121+S122.S1.ASS.EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eutaa2=mds("Estat/bop_c6_q/Q.MIO_EUR..S123+S12M.S1.ASS.EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eutaa3=mds("Estat/bop_c6_q/Q.MIO_EUR..S12T+S1P.S1.ASS.EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eutaa4=mds("Estat/bop_c6_q/Q.MIO_EUR..S1V+S13+S1.S1.ASS.EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

eutemptaa=merge(eutaa1,eutaa2) 
##technical bug in merge, therefore 'x' used - no impact on the data or sectors (13/01/25)
eulabop=merge(eutemptaa, eutaa3, eutaa4, along='sector10',newcodes=c('S12T','x','S1P','S1V','S13','S1'))

##quarterly liabilities 
print('loading of cross border liabilities transactions')
eutll1=mds("Estat/bop_c6_q/Q.MIO_EUR..S121+S122.S1.LIAB.EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eutll2=mds("Estat/bop_c6_q/Q.MIO_EUR..S123+S12M.S1.LIAB.EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eutll3=mds("Estat/bop_c6_q/Q.MIO_EUR..S12T+S1P.S1.LIAB.EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
eutll4=mds("Estat/bop_c6_q/Q.MIO_EUR..S1V+S13+S1.S1.LIAB.EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

eutemptll=merge(eutll1,eutll2)
eullbop=merge(eutemptll,eutll3,eutll4, along='sector10',newcodes=c('S12T','x','S1P','S1V','S13','S1'))

# Save all data
saveRDS(eulabop,file='data/bop6_assets_eu.rds')
saveRDS(eullbop,file='data/bop6_liabilities_eu.rds')