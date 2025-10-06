##loading of ESTAT IIP quarterly and annual data / [bop_iip6_q] 
# https://db.nomics.world/Eurostat/bop_iip6_q

library(MDecfin)

#### Offshore financial centers ESTAT part1 #### 

##quartlery assets 
#aa=mds("Estat/bop_iip6_q/A.MIO_NAC...S1.A_LE.OFFSHO.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
print('loading of cross border assets')
OFFSHOaa1=mds("Estat/bop_iip6_q/Q.MIO_EUR..S1M+S11.S1.A_LE.OFFSHO.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
OFFSHOaa2=mds("Estat/bop_iip6_q/Q.MIO_EUR..S121+S12T+S12K.S1.A_LE.OFFSHO.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
OFFSHOaa3=mds("Estat/bop_iip6_q/Q.MIO_EUR..S13.S1.A_LE.OFFSHO.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
OFFSHOaa4=mds("Estat/bop_iip6_q/Q.MIO_EUR..S124.S1.A_LE.OFFSHO.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
OFFSHOaa5=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12O.S1.A_LE.OFFSHO.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
OFFSHOaa6=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12Q.S1.A_LE.OFFSHO.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
OFFSHOaa7=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12M.S1.A_LE.OFFSHO.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
OFFSHOaa8=mds("Estat/bop_iip6_q/Q.MIO_EUR..S1.S1.A_LE.OFFSHO.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
OFFSHOtempaa=merge(OFFSHOaa1,OFFSHOaa2)
##technical bug in merge, therefore 'x' used - no impact on the data or sectors (13/01/25)
OFFSHOlaiip=merge(OFFSHOtempaa, OFFSHOaa3, OFFSHOaa4, OFFSHOaa5, OFFSHOaa6, OFFSHOaa7,OFFSHOaa8, along='sector10',newcodes=c('S13','x','S124','S12O','S12Q','S12M','S1'))

##quarterly liabilities 
print('loading of cross borderliabilities')
OFFSHOll1=mds("Estat/bop_iip6_q/Q.MIO_EUR..S121+S12T.S1.L_LE.OFFSHO.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
OFFSHOll2=mds("Estat/bop_iip6_q/Q.MIO_EUR..S11.S1.L_LE.OFFSHO.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
OFFSHOll3=mds("Estat/bop_iip6_q/Q.MIO_EUR..S1M.S1.L_LE.OFFSHO.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
OFFSHOll4=mds("Estat/bop_iip6_q/Q.MIO_EUR..S13.S1.L_LE.OFFSHO.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
OFFSHOll5=mds("Estat/bop_iip6_q/Q.MIO_EUR..S124.S1.L_LE.OFFSHO.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
OFFSHOll6=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12O.S1.L_LE.OFFSHO.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
OFFSHOll7=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12Q.S1.L_LE.OFFSHO.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
OFFSHOll8=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12M.S1.L_LE.OFFSHO.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
#OFFSHOll9=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12K.S1.L_LE.OFFSHO.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
OFFSHOll10=mds("Estat/bop_iip6_q/Q.MIO_EUR..S1.S1.L_LE.OFFSHO.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
##technical bug in merge, therefore 'x' used - no impact on the data or sectors (13/01/25)
OFFSHOtempll=merge(OFFSHOll1,OFFSHOll2,OFFSHOll3,OFFSHOll4, along='sector10',newcodes=c('S11','x','S1M','S13'))
OFFSHOlliip=merge(OFFSHOtempll,OFFSHOll5,OFFSHOll6,OFFSHOll7,OFFSHOll8,OFFSHOll10, along='sector10',newcodes=c('S124','x','S12O','S12Q','S12M','S1'))


# Save all data
saveRDS(OFFSHOlaiip,file='data/iip6_assets_OFFSHOestat.rds')
saveRDS(OFFSHOlliip,file='data/iip6_liabilities_OFFSHOestat.rds')


##loading of ESTAT bop quarterly data / [bop_iip6_q] 
# https://db.nomics.world/Eurostat/bop_c6_q

##quartlery assets 
#aa=mds("Estat/bop_c6_q/Q.MIO_EUR...S1.ASS.OFFSHO.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
print('loading of cross border assets transaction')
OFFSHOtaa1=mds("Estat/bop_c6_q/Q.MIO_EUR..S121+S122.S1.ASS.OFFSHO.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
OFFSHOtaa2=mds("Estat/bop_c6_q/Q.MIO_EUR..S123+S12M.S1.ASS.OFFSHO.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
OFFSHOtaa3=mds("Estat/bop_c6_q/Q.MIO_EUR..S12T+S1P.S1.ASS.OFFSHO.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
OFFSHOtaa4=mds("Estat/bop_c6_q/Q.MIO_EUR..S1V+S13+S1.S1.ASS.OFFSHO.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

OFFSHOtemptaa=merge(OFFSHOtaa1,OFFSHOtaa2) 
##technical bug in merge, therefore 'x' used - no impact on the data or sectors (13/01/25)
OFFSHOlabop=merge(OFFSHOtemptaa, OFFSHOtaa3, OFFSHOtaa4, along='sector10',newcodes=c('S12T','x','S1P','S1V','S13','S1'))

##quarterly liabilities 
print('loading of cross border liabilities transactions')
OFFSHOtll1=mds("Estat/bop_c6_q/Q.MIO_EUR..S121+S122.S1.LIAB.OFFSHO.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
OFFSHOtll2=mds("Estat/bop_c6_q/Q.MIO_EUR..S123+S12M.S1.LIAB.OFFSHO.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
OFFSHOtll3=mds("Estat/bop_c6_q/Q.MIO_EUR..S12T+S1P.S1.LIAB.OFFSHO.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
OFFSHOtll4=mds("Estat/bop_c6_q/Q.MIO_EUR..S1V+S13+S1.S1.LIAB.OFFSHO.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

OFFSHOtemptll=merge(OFFSHOtll1,OFFSHOtll2)
OFFSHOllbop=merge(OFFSHOtemptll,OFFSHOtll3,OFFSHOtll4, along='sector10',newcodes=c('S12T','x','S1P','S1V','S13','S1'))

# Save all data
saveRDS(OFFSHOlabop,file='data/bop6_assets_OFFSHOestat.rds')
saveRDS(OFFSHOllbop,file='data/bop6_liabilities_OFFSHOestat.rds')