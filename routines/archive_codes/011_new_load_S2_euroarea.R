library(MDecfin)

#Create list to store all exposure EA20
##quartlery assets 
#aa=mds("Estat/bop_iip6_q/A.MIO_NAC...S1.A_LE.WRL_REST.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
print('loading of cross border assets')
aa1=mds("Estat/bop_iip6_q/Q.MIO_EUR..S1M+S11.S1.A_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa2=mds("Estat/bop_iip6_q/Q.MIO_EUR..S121+S12T+S12K.S1.A_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa3=mds("Estat/bop_iip6_q/Q.MIO_EUR..S13.S1.A_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa4=mds("Estat/bop_iip6_q/Q.MIO_EUR..S124.S1.A_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa5=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12O.S1.A_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa6=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12Q.S1.A_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa7=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12M.S1.A_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
tempaa=merge(aa1,aa2)
##technical bug in merge, therefore 'x' used - no impact on the data or sectors (13/01/25)
laeap=merge(tempaa, aa3, aa4, aa5, aa6, aa7, along='sector10',newcodes=c('S13','x','S124','S12O','S12Q','S12M'))

##quarterly liabilities 
print('loading of cross borderliabilities')
ll1=mds("Estat/bop_iip6_q/Q.MIO_EUR..S121+S12T.S1.L_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
ll2=mds("Estat/bop_iip6_q/Q.MIO_EUR..S11.S1.L_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
ll3=mds("Estat/bop_iip6_q/Q.MIO_EUR..S1M.S1.L_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
ll4=mds("Estat/bop_iip6_q/Q.MIO_EUR..S13.S1.L_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
ll5=mds("Estat/bop_iip6_q/Q.MIO_EUR..S124.S1.L_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
ll6=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12O.S1.L_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
ll7=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12Q.S1.L_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
ll8=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12M.S1.L_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
#ll9=mds("Estat/bop_iip6_q/Q.MIO_EUR..S12K.S1.L_LE.EA20.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
##technical bug in merge, therefore 'x' used - no impact on the data or sectors (13/01/25)
templl=merge(ll1,ll2,ll3,ll4, along='sector10',newcodes=c('S11','x','S1M','S13'))
lleap=merge(templl,ll5,ll6,ll7,ll8, along='sector10',newcodes=c('S124','x','S12O','S12Q','S12M'))

# Save all data
saveRDS(laeap,file='data/iip6_assets_ea.rds')
saveRDS(lleap,file='data/iip6_liabilities_ea.rds')

