##loading of ESTAT IIP quarterly and annual data / [bop_iip6_q] 
# https://db.nomics.world/Eurostat/bop_iip6_q

library(MDecfin)

#### EXTRA EA #### 

##quartlery assets 
#aa=mds("Estat/bop_iip6_q/A.MIO_NAC...S1.A_LE.EXT_EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
print('loading of cross border assets')
exeaaa1=mds("Estat/bop_iip6_q/Q.MIO_EUR..S1M+S11.S1.A_LE.EXT_EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeaaa2=mds("Estat/bop_iip6_q/Q.MIO_EUR..S121+S12T+S12K.S1.A_LE.EXT_EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeaaa3=mds("Estat/bop_iip6_q/Q.MIO_EUR..S13.S1.A_LE.EXT_EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeaaa4=mds("Estat/bop_iip6_q/Q.MIO_EUR..S124.S1.A_LE.EXT_EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeaaa5=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12O.S1.A_LE.EXT_EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeaaa6=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12Q.S1.A_LE.EXT_EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeaaa7=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12M.S1.A_LE.EXT_EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeaaa8=mds("Estat/bop_iip6_q/Q.MIO_EUR..S1.S1.A_LE.EXT_EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeatempaa=merge(exeaaa1,exeaaa2)
##technical bug in merge, therefore 'x' used - no impact on the data or sectors (13/01/25)
exealaiip=merge(exeatempaa, exeaaa3, exeaaa4, exeaaa5, exeaaa6, exeaaa7,exeaaa8, along='sector10',newcodes=c('S13','x','S124','S12O','S12Q','S12M','S1'))

##quarterly liabilities 
print('loading of cross borderliabilities')
exeall1=mds("Estat/bop_iip6_q/Q.MIO_EUR..S121+S12T.S1.L_LE.EXT_EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeall2=mds("Estat/bop_iip6_q/Q.MIO_EUR..S11.S1.L_LE.EXT_EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeall3=mds("Estat/bop_iip6_q/Q.MIO_EUR..S1M.S1.L_LE.EXT_EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeall4=mds("Estat/bop_iip6_q/Q.MIO_EUR..S13.S1.L_LE.EXT_EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeall5=mds("Estat/bop_iip6_q/Q.MIO_EUR..S124.S1.L_LE.EXT_EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeall6=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12O.S1.L_LE.EXT_EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeall7=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12Q.S1.L_LE.EXT_EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeall8=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12M.S1.L_LE.EXT_EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
#exeall9=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12K.S1.L_LE.EXT_EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeall10=mds("Estat/bop_iip6_q/Q.MIO_EUR..S1.S1.L_LE.EXT_EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
##technical bug in merge, therefore 'x' used - no impact on the data or sectors (13/01/25)
exeatempll=merge(exeall1,exeall2,exeall3,exeall4, along='sector10',newcodes=c('S11','x','S1M','S13'))
exealliip=merge(exeatempll,exeall5,exeall6,exeall7,exeall8,exeall10, along='sector10',newcodes=c('S124','x','S12O','S12Q','S12M','S1'))


# Save all data
saveRDS(exealaiip,file='data/iip6_assets_exea.rds')
saveRDS(exealliip,file='data/iip6_liabilities_exea.rds')


##loading of ESTAT bop quarterly data / [bop_iip6_q] 
# https://db.nomics.world/Eurostat/bop_c6_q

##quartlery assets 
#aa=mds("Estat/bop_c6_q/Q.MIO_EUR...S1.ASS.EXT_EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
print('loading of cross border assets transaction')
exeataa1=mds("Estat/bop_c6_q/Q.MIO_EUR..S121+S122.S1.ASS.EXT_EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeataa2=mds("Estat/bop_c6_q/Q.MIO_EUR..S123+S12M.S1.ASS.EXT_EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeataa3=mds("Estat/bop_c6_q/Q.MIO_EUR..S12T+S1P.S1.ASS.EXT_EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeataa4=mds("Estat/bop_c6_q/Q.MIO_EUR..S1V+S13+S1.S1.ASS.EXT_EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

exeatemptaa=merge(exeataa1,exeataa2) 
##technical bug in merge, therefore 'x' used - no impact on the data or sectors (13/01/25)
exealabop=merge(exeatemptaa, exeataa3, exeataa4, along='sector10',newcodes=c('S12T','x','S1P','S1V','S13','S1'))

##quarterly liabilities 
print('loading of cross border liabilities transactions')
exeatll1=mds("Estat/bop_c6_q/Q.MIO_EUR..S121+S122.S1.LIAB.EXT_EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeatll2=mds("Estat/bop_c6_q/Q.MIO_EUR..S123+S12M.S1.LIAB.EXT_EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeatll3=mds("Estat/bop_c6_q/Q.MIO_EUR..S12T+S1P.S1.LIAB.EXT_EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
exeatll4=mds("Estat/bop_c6_q/Q.MIO_EUR..S1V+S13+S1.S1.LIAB.EXT_EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

exeatemptll=merge(exeatll1,exeatll2)
exeallbop=merge(exeatemptll,exeatll3,exeatll4, along='sector10',newcodes=c('S12T','x','S1P','S1V','S13','S1'))

# Save all data
saveRDS(exealabop,file='data/bop6_assets_exea.rds')
saveRDS(exeallbop,file='data/bop6_liabilities_exea.rds')
