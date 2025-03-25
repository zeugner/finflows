#################### LOADING COUNTERPART INFORMATION FROM EUROSTAT ####################

# Create list to store quarterly CP data
cpq=list()

# - Estat/nasq_10_f_cp: Eurostat's quarterly financial counterpart information

cpq$F3=mds("Estat/nasq_10_f_cp/Q.MIO_EUR...STK+TRN..F3.AT+BE+BG+CY+CZ+DE+DK+EE+EL+ES+FI+FR+HR+HU+IE+IT+LT+LU+MT+NL+PL+PT+RO+SE+SI+SK")
cpq$F2M=mds("Estat/nasq_10_f_cp/Q.MIO_EUR...STK+TRN..F22_F29.AT+BE+BG+CY+CZ+DE+DK+EE+EL+ES+FI+FR+HR+HU+IE+IT+LT+LU+MT+NL+PL+PT+RO+SE+SI+SK")
cpq$F3S=mds("Estat/nasq_10_f_cp/Q.MIO_EUR...STK+TRN..F31.AT+BE+BG+CY+CZ+DE+DK+EE+EL+ES+FI+FR+HR+HU+IE+IT+LT+LU+MT+NL+PL+PT+RO+SE+SI+SK")
cpq$F3L=mds("Estat/nasq_10_f_cp/Q.MIO_EUR...STK+TRN..F32.AT+BE+BG+CY+CZ+DE+DK+EE+EL+ES+FI+FR+HR+HU+IE+IT+LT+LU+MT+NL+PL+PT+RO+SE+SI+SK")
cpq$F4=mds("Estat/nasq_10_f_cp/Q.MIO_EUR...STK+TRN..F4.AT+BE+BG+CY+CZ+DE+DK+EE+EL+ES+FI+FR+HR+HU+IE+IT+LT+LU+MT+NL+PL+PT+RO+SE+SI+SK")
cpq$F4S=mds("Estat/nasq_10_f_cp/Q.MIO_EUR...STK+TRN..F41.AT+BE+BG+CY+CZ+DE+DK+EE+EL+ES+FI+FR+HR+HU+IE+IT+LT+LU+MT+NL+PL+PT+RO+SE+SI+SK")
cpq$F4L=mds("Estat/nasq_10_f_cp/Q.MIO_EUR...STK+TRN..F42.AT+BE+BG+CY+CZ+DE+DK+EE+EL+ES+FI+FR+HR+HU+IE+IT+LT+LU+MT+NL+PL+PT+RO+SE+SI+SK")
cpq$F511=mds("Estat/nasq_10_f_cp/Q.MIO_EUR...STK+TRN..F511.AT+BE+BG+CY+CZ+DE+DK+EE+EL+ES+FI+FR+HR+HU+IE+IT+LT+LU+MT+NL+PL+PT+RO+SE+SI+SK")
cpq$F52=mds("Estat/nasq_10_f_cp/Q.MIO_EUR...STK+TRN..F52.AT+BE+BG+CY+CZ+DE+DK+EE+EL+ES+FI+FR+HR+HU+IE+IT+LT+LU+MT+NL+PL+PT+RO+SE+SI+SK")

cpq$F3_FDI=mds("Estat/nasq_10_f_cp/Q.MIO_EUR...STK+TRN..F3_FDI.AT+BE+BG+CY+CZ+DE+DK+EE+EL+ES+FI+FR+HR+HU+IE+IT+LT+LU+MT+NL+PL+PT+RO+SE+SI+SK")
cpq$F4_FDI=mds("Estat/nasq_10_f_cp/Q.MIO_EUR...STK+TRN..F4_FDI.AT+BE+BG+CY+CZ+DE+DK+EE+EL+ES+FI+FR+HR+HU+IE+IT+LT+LU+MT+NL+PL+PT+RO+SE+SI+SK")
cpq$F511_FDI=mds("Estat/nasq_10_f_cp/Q.MIO_EUR...STK+TRN..F511_FDI.AT+BE+BG+CY+CZ+DE+DK+EE+EL+ES+FI+FR+HR+HU+IE+IT+LT+LU+MT+NL+PL+PT+RO+SE+SI+SK")

saveRDS(cpq,file='data/cpq.rds')


# Create list to store annual CP data

cpa=list()

cpa$F3=mds("Estat/nasa_10_f_cp/A.STK+TRN...F3..MIO_EUR.AT+BE+BG+EE+EL+ES+FI+FR+HU+LT+LU+LV+MT+PT")
cpa$F=mds("Estat/nasa_10_f_cp/A.STK+TRN...F..MIO_EUR.AT+BE+BG+EE+EL+ES+FI+FR+HU+LT+LU+LV+MT+PT")
cpa$F511=mds("Estat/nasa_10_f_cp/A.STK+TRN...F511..MIO_EUR.AT+BE+BG+EE+EL+ES+FI+FR+HU+LT+LU+LV+MT+PT")
cpa$F52=mds("Estat/nasa_10_f_cp/A.STK+TRN...F52..MIO_EUR.AT+BE+BG+EE+EL+ES+FI+FR+HU+LT+LU+LV+MT+PT")
cpa$F22=mds("Estat/nasa_10_f_cp/A.STK+TRN...F22..MIO_EUR.AT+BE+BG+EE+EL+ES+FI+FR+HU+LT+LU+LV+MT+PT")
cpa$F29=mds("Estat/nasa_10_f_cp/A.STK+TRN...F29..MIO_EUR.AT+BE+BG+EE+EL+ES+FI+FR+HU+LT+LU+LV+MT+PT")
cpa$F4=mds("Estat/nasa_10_f_cp/A.STK+TRN...F4..MIO_EUR.AT+BE+BG+EE+EL+ES+FI+FR+HU+LT+LU+LV+MT+PT")
cpa$F4S=mds("Estat/nasa_10_f_cp/A.STK+TRN...F41..MIO_EUR.AT+BE+BG+EE+EL+ES+FI+FR+HU+LT+LU+LV+MT+PT")
cpa$F4L=mds("Estat/nasa_10_f_cp/A.STK+TRN...F42..MIO_EUR.AT+BE+BG+EE+EL+ES+FI+FR+HU+LT+LU+LV+MT+PT")
cpa$F3S=mds("Estat/nasa_10_f_cp/A.STK+TRN...F31..MIO_EUR.AT+BE+BG+EE+EL+ES+FI+FR+HU+LT+LU+LV+MT+PT")
cpa$F3L=mds("Estat/nasa_10_f_cp/A.STK+TRN...F32..MIO_EUR.AT+BE+BG+EE+EL+ES+FI+FR+HU+LT+LU+LV+MT+PT")
cpa$F21=mds("Estat/nasa_10_f_cp/A.STK+TRN...F21..MIO_EUR.AT+BE+BG+EE+EL+ES+FI+FR+HU+LT+LU+LV+MT+PT")
cpa$F51=mds("Estat/nasa_10_f_cp/A.STK+TRN...F51..MIO_EUR.AT+BE+BG+EE+EL+ES+FI+FR+HU+LT+LU+LV+MT+PT")
cpa$F512=mds("Estat/nasa_10_f_cp/A.STK+TRN...F512..MIO_EUR.AT+BE+BG+EE+EL+ES+FI+FR+HU+LT+LU+LV+MT+PT")
cpa$F519=mds("Estat/nasa_10_f_cp/A.STK+TRN...F519..MIO_EUR.AT+BE+BG+EE+EL+ES+FI+FR+HU+LT+LU+LV+MT+PT")
cpa$F6=mds("Estat/nasa_10_f_cp/A.STK+TRN...F6..MIO_EUR.AT+BE+BG+EE+EL+ES+FI+FR+HU+LT+LU+LV+MT+PT")
cpa$F62=mds("Estat/nasa_10_f_cp/A.STK+TRN...F62..MIO_EUR.AT+BE+BG+EE+EL+ES+FI+FR+HU+LT+LU+LV+MT+PT")
cpa$F63_F64_F65=mds("Estat/nasa_10_f_cp/A.STK+TRN...F63_F64_F65..MIO_EUR.AT+BE+BG+EE+EL+ES+FI+FR+HU+LT+LU+LV+MT+PT")
cpa$F7=mds("Estat/nasa_10_f_cp/A.STK+TRN...F7..MIO_EUR.AT+BE+BG+EE+EL+ES+FI+FR+HU+LT+LU+LV+MT+PT")
cpa$F81=mds("Estat/nasa_10_f_cp/A.STK+TRN...F81..MIO_EUR.AT+BE+BG+EE+EL+ES+FI+FR+HU+LT+LU+LV+MT+PT")
cpa$F89=mds("Estat/nasa_10_f_cp/A.STK+TRN...F89..MIO_EUR.AT+BE+BG+EE+EL+ES+FI+FR+HU+LT+LU+LV+MT+PT")
cpa$F6O=mds("Estat/nasa_10_f_cp/A.STK+TRN...F61_F66..MIO_EUR.AT+BE+BG+EE+EL+ES+FI+FR+HU+LT+LU+LV+MT+PT")
cpa$F2M= cpa$F22+cpa$F29
cpa$F51M= cpa$F512+cpa$F519
cpa$F6N= cpa$F62+cpa$F63_F64_F65


saveRDS(cpa,file='data/cpa.rds')
