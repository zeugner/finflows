#################### LOADING FINANCIAL BALANCE SHEETS FROM EUROSTAT ####################
# Loading data for equity instruments (F51x series)
# F51 components:
# - F511: Listed shares (quoted shares traded on stock exchanges)
# - F51M: Sum of F512 (unlisted shares) and F519 (other equity)

data_dir <- if (exists("data_dir")) data_dir else "data"
#################### LISTED SHARES (F511) ####################
# Load consolidated assets for listed shares
aa511c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F511.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Load unconsolidated assets for listed shares
aa511nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F511.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

#################### UNLISTED SHARES AND OTHER EQUITY (F51M) ####################
# Loading both consolidated and unconsolidated data to calculate intra-sector exposures
# Consolidated (CO): Positions between units in the same sector are netted out
# Unconsolidated (NCO): All positions are included, even within the same sector
# Example: If Bank A owns shares in Bank B, in consolidated data this intra-banking sector
# position would be netted out, while in unconsolidated data it would be included

# Load consolidated assets for unlisted shares (F512)
aa512c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F512.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Load unconsolidated assets for unlisted shares (F512)
aa512nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F512.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Load consolidated assets for other equity (F519)
aa519c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F519.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

# Load unconsolidated assets for other equity (F519)
aa519nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F519.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

