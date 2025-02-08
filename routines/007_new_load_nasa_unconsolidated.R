library(MDecfin)

# Create list to store all unconsolidated data
la=list()

# Financial instruments (F511, F52)
la$aa511nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F511.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
la$aa52nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F52.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Deposits (F22, F29)
la$aa22nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F22.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
la$aa29nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F29.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Loans (F4, F41, F42)
la$aa4nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F4.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
la$aa41nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F41.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
la$aa42nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F42.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Debt securities (F3, F31, F32)
la$aa3nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F3.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
la$aa31nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F31.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
la$aa32nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F32.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Currency (F21)
la$aa21nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F21.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Total financial assets (F)
la$aafnc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Equity (F51, F512, F519)
la$aa51nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F51.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
la$aa512nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F512.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
la$aa519nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F519.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Insurance and pensions (F6, F62, F63_F64_F65, F61_F66)
la$aa6nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F6.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
la$aa62nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F62.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
la$aa6nnc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F63_F64_F65.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
la$aa6onc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F61_F66.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Others (F7, F81, F89)
la$aa7nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F7.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
la$aa81nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F81.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
la$aa89nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F89.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Save all data
saveRDS(la,file='data/nasa_unconsolidated.rds')

