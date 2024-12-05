#################### LOADING QUARTERLY SECTOR ACCOUNTS FROM EUROSTAT ####################
# Parameters:
# - Estat/nasq_10_f_bs: Eurostat's quarterly financial balance sheets
# - Q: Quarterly frequency
# - MIO_NAC: Millions of national currency
# - ...: Empty selectors (all available breakdowns for those dimensions)
# - F512_F519: Combined unlisted shares and other equity
# - Country list: All EU members
# Load quarterly 511 (listed shares) data:
aa511=mds("Estat/nasq_10_f_bs/Q.MIO_NAC...F511.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Loading data for unlisted shares and other equity (F51M)
# F51M components in quarterly accounts:
# - F512_F519: Combined unlisted shares and other equity
# Note: In quarterly accounts, F512 (unlisted shares) and F519 (other equity) 
# are reported as a combined item F512_F519, unlike in annual accounts 
# where they are reported separately

# Load quarterly data for unlisted shares and other equity combined (F512_F519)
aa512=mds("Estat/nasq_10_f_bs/Q.MIO_NAC...F512_F519.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

