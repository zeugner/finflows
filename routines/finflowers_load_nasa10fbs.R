## loading of ESTAT annual sector accounts for F51m (F512+F519) nasa_​10_​f_​bs
# https://db.nomics.world/Eurostat/nasa_10_f_bs?dimensions=%7B%22na_item%22%3A%5B%22F512%22%2C%22F519%22%5D%7D&tab=list


#aa=mds("Estat/nasq_10_f_cp/Q.MIO_EUR...STK.ASS.F511.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

#consolidated assets F512
aa512c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F512.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

#unconsolidated assets F512
aa512nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F512.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

#consolidated assets F519
aa519c=mds("Estat/nasa_10_f_bs/A.MIO_NAC.CO..ASS.F519.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")

#unconsolidated assets F519
aa519nc=mds("Estat/nasa_10_f_bs/A.MIO_NAC.NCO..ASS.F519.BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE")