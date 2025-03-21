#################### LOADING QUARTERLY SECTOR ACCOUNTS FROM EUROSTAT ####################

# Create list to store all unconsolidated data
aa5=list()

# - Estat/nasq_10_f_bs: Eurostat's quarterly financial balance sheets

# Load quarterly 511 (listed shares) data:
aa5$aa511=mds("Estat/nasq_10_f_bs/Q.MIO_EUR...F511.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# F51M components in quarterly accounts:
aa5$aa51M=mds("Estat/nasq_10_f_bs/Q.MIO_EUR...F512_F519.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
gc()
gc()
aa5$aa511t=mds("Estat/nasq_10_f_tr/Q.MIO_EUR...F511.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")
aa5$aa51Mt=mds("Estat/nasq_10_f_tr/Q.MIO_EUR...F512_F519.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

dimcodes(aa5$aa511)
dimcodes(aa5$aa511t)

saveRDS(aa5,file='data/aa5.rds')
