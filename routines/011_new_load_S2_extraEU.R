##loading of ESTAT IIP quarterly and annual data / [bop_iip6_q] 
# https://db.nomics.world/Eurostat/bop_iip6_q

library(MDecfin)

#### EXTRA EU #### 

##quartlery assets 
#aa=mds("Estat/bop_iip6_q/A.MIO_NAC...S1.A_LE.EXT_EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
print('loading of cross border assets')
exeuaa1=mds("Estat/bop_iip6_q/Q.MIO_EUR..S1M+S11.S1.A_LE.EXT_EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeuaa2=mds("Estat/bop_iip6_q/Q.MIO_EUR..S121+S12T+S12K.S1.A_LE.EXT_EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeuaa3=mds("Estat/bop_iip6_q/Q.MIO_EUR..S13.S1.A_LE.EXT_EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeuaa4=mds("Estat/bop_iip6_q/Q.MIO_EUR..S124.S1.A_LE.EXT_EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeuaa5=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12O.S1.A_LE.EXT_EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeuaa6=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12Q.S1.A_LE.EXT_EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeuaa7=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12M.S1.A_LE.EXT_EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeuaa8=mds("Estat/bop_iip6_q/Q.MIO_EUR..S1.S1.A_LE.EXT_EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeutempaa=merge(exeuaa1,exeuaa2)
##technical bug in merge, therefore 'x' used - no impact on the data or sectors (13/01/25)
exeulaiip=merge(exeutempaa, exeuaa3, exeuaa4, exeuaa5, exeuaa6, exeuaa7,exeuaa8, along='sector10',newcodes=c('S13','x','S124','S12O','S12Q','S12M','S1'))

##quarterly liabilities 
print('loading of cross borderliabilities')
exeull1=mds("Estat/bop_iip6_q/Q.MIO_EUR..S121+S12T.S1.L_LE.EXT_EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeull2=mds("Estat/bop_iip6_q/Q.MIO_EUR..S11.S1.L_LE.EXT_EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeull3=mds("Estat/bop_iip6_q/Q.MIO_EUR..S1M.S1.L_LE.EXT_EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeull4=mds("Estat/bop_iip6_q/Q.MIO_EUR..S13.S1.L_LE.EXT_EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeull5=mds("Estat/bop_iip6_q/Q.MIO_EUR..S124.S1.L_LE.EXT_EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeull6=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12O.S1.L_LE.EXT_EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeull7=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12Q.S1.L_LE.EXT_EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeull8=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12M.S1.L_LE.EXT_EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
#exeull9=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12K.S1.L_LE.EXT_EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeull10=mds("Estat/bop_iip6_q/Q.MIO_EUR..S1.S1.L_LE.EXT_EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
##technical bug in merge, therefore 'x' used - no impact on the data or sectors (13/01/25)
exeutempll=merge(exeull1,exeull2,exeull3,exeull4, along='sector10',newcodes=c('S11','x','S1M','S13'))
exeulliip=merge(exeutempll,exeull5,exeull6,exeull7,exeull8,exeull10, along='sector10',newcodes=c('S124','x','S12O','S12Q','S12M','S1'))


# Save all data
saveRDS(exeulaiip,file='data/iip6_assets_exeu.rds')
saveRDS(exeulliip,file='data/iip6_liabilities_exeu.rds')


##loading of ESTAT bop quarterly data / [bop_iip6_q] 
# https://db.nomics.world/Eurostat/bop_c6_q

##quartlery assets 
#aa=mds("Estat/bop_c6_q/Q.MIO_EUR...S1.ASS.EXT_EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
print('loading of cross border assets transaction')
exeutaa1=mds("Estat/bop_c6_q/Q.MIO_EUR..S121+S122.S1.ASS.EXT_EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeutaa2=mds("Estat/bop_c6_q/Q.MIO_EUR..S123+S12M.S1.ASS.EXT_EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeutaa3=mds("Estat/bop_c6_q/Q.MIO_EUR..S12T+S1P.S1.ASS.EXT_EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeutaa4=mds("Estat/bop_c6_q/Q.MIO_EUR..S1V+S13+S1.S1.ASS.EXT_EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

exeutemptaa=merge(exeutaa1,exeutaa2) 
##technical bug in merge, therefore 'x' used - no impact on the data or sectors (13/01/25)
exeulabop=merge(exeutemptaa, exeutaa3, exeutaa4, along='sector10',newcodes=c('S12T','x','S1P','S1V','S13','S1'))

##quarterly liabilities 
print('loading of cross border liabilities transactions')
exeutll1=mds("Estat/bop_c6_q/Q.MIO_EUR..S121+S122.S1.LIAB.EXT_EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeutll2=mds("Estat/bop_c6_q/Q.MIO_EUR..S123+S12M.S1.LIAB.EXT_EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeutll3=mds("Estat/bop_c6_q/Q.MIO_EUR..S12T+S1P.S1.LIAB.EXT_EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeutll4=mds("Estat/bop_c6_q/Q.MIO_EUR..S1V+S13+S1.S1.LIAB.EXT_EU27_2020.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

exeutemptll=merge(exeutll1,exeutll2)
exeullbop=merge(exeutemptll,exeutll3,exeutll4, along='sector10',newcodes=c('S12T','x','S1P','S1V','S13','S1'))

# Save all data
saveRDS(exeulabop,file='data/bop6_assets_exeu.rds')
saveRDS(exeullbop,file='data/bop6_liabilities_exeu.rds')


#### EXTRA EA #### 

