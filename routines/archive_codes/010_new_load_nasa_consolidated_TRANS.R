
# Create list to store all consolidated data
lct=list()

# Financial instruments (F511, F52)
lct$aa511c=mds("Estat/nasa_10_f_tr/A.MIO_EUR.CO..ASS.F511.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lct$aa52c=mds("Estat/nasa_10_f_tr/A.MIO_EUR.CO..ASS.F52.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Deposits (F22, F29)
lct$aa22c=mds("Estat/nasa_10_f_tr/A.MIO_EUR.CO..ASS.F22.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lct$aa29c=mds("Estat/nasa_10_f_tr/A.MIO_EUR.CO..ASS.F29.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Loans (F4, F41, F42)
lct$aa4c=mds("Estat/nasa_10_f_tr/A.MIO_EUR.CO..ASS.F4.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lct$aa41c=mds("Estat/nasa_10_f_tr/A.MIO_EUR.CO..ASS.F41.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lct$aa42c=mds("Estat/nasa_10_f_tr/A.MIO_EUR.CO..ASS.F42.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Debt securities (F3, F31, F32)
lct$aa3c=mds("Estat/nasa_10_f_tr/A.MIO_EUR.CO..ASS.F3.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lct$aa31c=mds("Estat/nasa_10_f_tr/A.MIO_EUR.CO..ASS.F31.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lct$aa32c=mds("Estat/nasa_10_f_tr/A.MIO_EUR.CO..ASS.F32.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Currency (F21)
lct$aa21c=mds("Estat/nasa_10_f_tr/A.MIO_EUR.CO..ASS.F21.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Total financial assets (F)
lct$aafc=mds("Estat/nasa_10_f_tr/A.MIO_EUR.CO..ASS.F_TR.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Equity (F51, F512, F519)
lct$aa51c=mds("Estat/nasa_10_f_tr/A.MIO_EUR.CO..ASS.F51.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lct$aa512c=mds("Estat/nasa_10_f_tr/A.MIO_EUR.CO..ASS.F512.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lct$aa519c=mds("Estat/nasa_10_f_tr/A.MIO_EUR.CO..ASS.F519.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Insurance and pensions (F6, F62, F63_F64_F65, F61_F66)
lct$aa6c=mds("Estat/nasa_10_f_tr/A.MIO_EUR.CO..ASS.F6.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lct$aa62c=mds("Estat/nasa_10_f_tr/A.MIO_EUR.CO..ASS.F62.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lct$aa6Nc=mds("Estat/nasa_10_f_tr/A.MIO_EUR.CO..ASS.F63_F64_F65.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Others (F7, F81, F89)
lct$aa7c=mds("Estat/nasa_10_f_tr/A.MIO_EUR.CO..ASS.F7.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lct$aa81c=mds("Estat/nasa_10_f_tr/A.MIO_EUR.CO..ASS.F81.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lct$aa89c=mds("Estat/nasa_10_f_tr/A.MIO_EUR.CO..ASS.F89.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Save all data
saveRDS(lct,file='data/nasa_consolidated_TRANS.rds')
