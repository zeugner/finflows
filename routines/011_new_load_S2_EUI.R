##loading of ESTAT IIP quarterly and annual data / [bop_iip6_q] 
# https://db.nomics.world/Eurostat/bop_iip6_q

library(MDecfin)

#### EUI - institutions and bodies of the EU #### 

##quartlery assets 
#aa=mds("Estat/bop_iip6_q/A.MIO_NAC...S1.A_LE.EUI.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
print('loading of cross border assets')
EUIeuaa1=mds("Estat/bop_iip6_q/Q.MIO_EUR..S1M+S11.S1.A_LE.EUI.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
EUIeuaa2=mds("Estat/bop_iip6_q/Q.MIO_EUR..S121+S12T+S12K.S1.A_LE.EUI.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
EUIeuaa3=mds("Estat/bop_iip6_q/Q.MIO_EUR..S13.S1.A_LE.EUI.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
EUIeuaa4=mds("Estat/bop_iip6_q/Q.MIO_EUR..S124.S1.A_LE.EUI.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
EUIeuaa5=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12O.S1.A_LE.EUI.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
EUIeuaa6=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12Q.S1.A_LE.EUI.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
EUIeuaa7=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12M.S1.A_LE.EUI.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
EUIeuaa8=mds("Estat/bop_iip6_q/Q.MIO_EUR..S1.S1.A_LE.EUI.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
EUIeutempaa=merge(EUIeuaa1,EUIeuaa2)
##technical bug in merge, therefore 'x' used - no impact on the data or sectors (13/01/25)
EUIeulaiip=merge(EUIeutempaa, EUIeuaa3, EUIeuaa4, EUIeuaa5, EUIeuaa6, EUIeuaa7,EUIeuaa8, along='sector10',newcodes=c('S13','x','S124','S12O','S12Q','S12M','S1'))

##quarterly liabilities 
print('loading of cross borderliabilities')
EUIeull1=mds("Estat/bop_iip6_q/Q.MIO_EUR..S121+S12T.S1.L_LE.EUI.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
EUIeull2=mds("Estat/bop_iip6_q/Q.MIO_EUR..S11.S1.L_LE.EUI.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
EUIeull3=mds("Estat/bop_iip6_q/Q.MIO_EUR..S1M.S1.L_LE.EUI.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
EUIeull4=mds("Estat/bop_iip6_q/Q.MIO_EUR..S13.S1.L_LE.EUI.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
EUIeull5=mds("Estat/bop_iip6_q/Q.MIO_EUR..S124.S1.L_LE.EUI.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
EUIeull6=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12O.S1.L_LE.EUI.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
EUIeull7=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12Q.S1.L_LE.EUI.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
EUIeull8=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12M.S1.L_LE.EUI.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
#EUIeull9=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12K.S1.L_LE.EUI.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
EUIeull10=mds("Estat/bop_iip6_q/Q.MIO_EUR..S1.S1.L_LE.EUI.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
##technical bug in merge, therefore 'x' used - no impact on the data or sectors (13/01/25)
EUIeutempll=merge(EUIeull1,EUIeull2,EUIeull3,EUIeull4, along='sector10',newcodes=c('S11','x','S1M','S13'))
EUIeulliip=merge(EUIeutempll,EUIeull5,EUIeull6,EUIeull7,EUIeull8,EUIeull10, along='sector10',newcodes=c('S124','x','S12O','S12Q','S12M','S1'))


# Save all data
saveRDS(EUIeulaiip,file='data/iip6_assets_EUIeu.rds')
saveRDS(EUIeulliip,file='data/iip6_liabilities_EUIeu.rds')


##loading of ESTAT bop quarterly data / [bop_iip6_q] 
# https://db.nomics.world/Eurostat/bop_c6_q

##quartlery assets 
#aa=mds("Estat/bop_c6_q/Q.MIO_EUR...S1.ASS.EUI.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
print('loading of cross border assets transaction')
EUIeutaa1=mds("Estat/bop_c6_q/Q.MIO_EUR..S121+S122.S1.ASS.EUI.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
EUIeutaa2=mds("Estat/bop_c6_q/Q.MIO_EUR..S123+S12M.S1.ASS.EUI.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
EUIeutaa3=mds("Estat/bop_c6_q/Q.MIO_EUR..S12T+S1P.S1.ASS.EUI.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
EUIeutaa4=mds("Estat/bop_c6_q/Q.MIO_EUR..S1V+S13+S1.S1.ASS.EUI.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

EUIeutemptaa=merge(EUIeutaa1,EUIeutaa2) 
##technical bug in merge, therefore 'x' used - no impact on the data or sectors (13/01/25)
EUIeulabop=merge(EUIeutemptaa, EUIeutaa3, EUIeutaa4, along='sector10',newcodes=c('S12T','x','S1P','S1V','S13','S1'))

##quarterly liabilities 
print('loading of cross border liabilities transactions')
EUIeutll1=mds("Estat/bop_c6_q/Q.MIO_EUR..S121+S122.S1.LIAB.EUI.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
EUIeutll2=mds("Estat/bop_c6_q/Q.MIO_EUR..S123+S12M.S1.LIAB.EUI.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
EUIeutll3=mds("Estat/bop_c6_q/Q.MIO_EUR..S12T+S1P.S1.LIAB.EUI.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
EUIeutll4=mds("Estat/bop_c6_q/Q.MIO_EUR..S1V+S13+S1.S1.LIAB.EUI.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

EUIeutemptll=merge(EUIeutll1,EUIeutll2)
EUIeullbop=merge(EUIeutemptll,EUIeutll3,EUIeutll4, along='sector10',newcodes=c('S12T','x','S1P','S1V','S13','S1'))

# Save all data
saveRDS(EUIeulabop,file='data/bop6_assets_EUIeu.rds')
saveRDS(EUIeullbop,file='data/bop6_liabilities_EUIeu.rds')