library(MDecfin)

# Create list to store all consolidated data
lc=list()

# Financial instruments (F511, F52)
lc$aa511c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F511.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lc$aa52c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F52.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Deposits (F22, F29)
lc$aa22c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F22.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lc$aa29c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F29.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Loans (F4, F41, F42)
lc$aa4c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F4.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lc$aa41c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F41.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lc$aa42c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F42.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Debt securities (F3, F31, F32)
lc$aa3c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F3.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lc$aa31c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F31.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lc$aa32c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F32.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Currency (F21)
lc$aa21c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F21.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Total financial assets (F)
lc$aafc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Equity (F51, F512, F519)
lc$aa51c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F51.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lc$aa512c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F512.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lc$aa519c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F519.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Insurance and pensions (F6, F62, F63_F64_F65, F61_F66)
lc$aa6c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F6.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lc$aa62c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F62.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lc$aa6Nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F63_F64_F65.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Others (F7, F81, F89)
lc$aa7c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F7.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lc$aa81c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F81.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
lc$aa89c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F89.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Save all data
saveRDS(lc,file='data/nasa_consolidated.rds')
