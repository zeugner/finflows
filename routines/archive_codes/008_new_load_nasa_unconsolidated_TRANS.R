# Create list to store all unconsolidated data
lat=list()

# Financial instruments (F511, F52)
lat$aa511nc=mds("Estat/nasa_10_f_tr/A.MIO_EUR.NCO..ASS.F511.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lat$aa52nc=mds("Estat/nasa_10_f_tr/A.MIO_EUR.NCO..ASS.F52.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Deposits (F22, F29)
lat$aa22nc=mds("Estat/nasa_10_f_tr/A.MIO_EUR.NCO..ASS.F22.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lat$aa29nc=mds("Estat/nasa_10_f_tr/A.MIO_EUR.NCO..ASS.F29.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Loans (F4, F41, F42)
lat$aa4nc=mds("Estat/nasa_10_f_tr/A.MIO_EUR.NCO..ASS.F4.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lat$aa41nc=mds("Estat/nasa_10_f_tr/A.MIO_EUR.NCO..ASS.F41.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lat$aa42nc=mds("Estat/nasa_10_f_tr/A.MIO_EUR.NCO..ASS.F42.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Debt securities (F3, F31, F32)
lat$aa3nc=mds("Estat/nasa_10_f_tr/A.MIO_EUR.NCO..ASS.F3.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lat$aa31nc=mds("Estat/nasa_10_f_tr/A.MIO_EUR.NCO..ASS.F31.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lat$aa32nc=mds("Estat/nasa_10_f_tr/A.MIO_EUR.NCO..ASS.F32.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Currency (F21)
lat$aa21nc=mds("Estat/nasa_10_f_tr/A.MIO_EUR.NCO..ASS.F21.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Total financial assets (F)
lat$aafnc=mds("Estat/nasa_10_f_tr/A.MIO_EUR.NCO..ASS.F_TR.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Equity (F51, F512, F519)
lat$aa51nc=mds("Estat/nasa_10_f_tr/A.MIO_EUR.NCO..ASS.F51.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lat$aa512nc=mds("Estat/nasa_10_f_tr/A.MIO_EUR.NCO..ASS.F512.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lat$aa519nc=mds("Estat/nasa_10_f_tr/A.MIO_EUR.NCO..ASS.F519.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Insurance and pensions (F6, F62, F63_F64_F65, F61_F66)
lat$aa6nc=mds("Estat/nasa_10_f_tr/A.MIO_EUR.NCO..ASS.F6.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lat$aa62nc=mds("Estat/nasa_10_f_tr/A.MIO_EUR.NCO..ASS.F62.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lat$aa6nnc=mds("Estat/nasa_10_f_tr/A.MIO_EUR.NCO..ASS.F63_F64_F65.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Others (F7, F81, F89)
lat$aa7nc=mds("Estat/nasa_10_f_tr/A.MIO_EUR.NCO..ASS.F7.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lat$aa81nc=mds("Estat/nasa_10_f_tr/A.MIO_EUR.NCO..ASS.F81.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lat$aa89nc=mds("Estat/nasa_10_f_tr/A.MIO_EUR.NCO..ASS.F89.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Save all data
saveRDS(lat,file='data/domestic_loading_data_files/nasa_unconsolidated_TRANS.rds')

