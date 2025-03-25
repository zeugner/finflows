library(MDecfin)
# Set data directory
data_dir <- if (exists("data_dir")) data_dir else "data"

# Load the processed array
aall = readRDS(file.path(data_dir, 'aall_bis.rds'))

# Define the consistency check function
check_consistency <- function(diff_values, description, check_type = "sector", 
                              thresholds = c(1, 1.5, 2), components = NULL) {
  for(threshold in thresholds) {
    cat(sprintf("\n\n=== %s - Analysis for threshold %g ===\n", description, threshold))
    
    # Find discrepancies
    significant_diff <- which(abs(diff_values) > threshold)
    
    if(length(significant_diff) > 0) {
      cat(sprintf("\nFound %d discrepancies larger than %g\n", 
                  length(significant_diff), threshold))
      
      # Get REF_AREA names - they should always be available
      countries <- dimnames(diff_values)$REF_AREA
      
      # Print the actual differences with country information
      if(!is.null(components)) {
        for(i in seq_along(significant_diff)) {
          # Get country name directly from REF_AREA dimension
          country <- countries[significant_diff[i]]
          
          cat("\nDetails for discrepancy", i, ":\n")
          cat("Country:", country, "\n")
          cat("Difference:", format(diff_values[significant_diff[i]], digits=2), "\n")
          
          # Print component values
          for(comp_name in names(components)) {
            comp_value <- components[[comp_name]][significant_diff[i]]
            cat(comp_name, ":", format(comp_value, digits=2), "\n")
          }
          cat("--------------------\n")
        }
      } else {
        for(i in seq_along(significant_diff)) {
          country <- countries[significant_diff[i]]
          
          cat("\nCountry:", country, "\n")
          cat("Difference:", format(diff_values[significant_diff[i]], digits=2), "\n")
          cat("--------------------\n")
        }
      }
    } else {
      cat("\nNo discrepancies found exceeding threshold", threshold, "\n")
    }
  }
  return(invisible(diff_values))
}

#################### SECTORAL CONSISTENCY CHECKS ####################

# CHECK 1: Total Economy Assets Composition
check1 = aall[F..S1.S0.LE._T.2023q4] - 
  apply(aall[F..S11+S1M+S12K+S12O+S12Q+S124+S13.S0.LE._T.2023q4], 1, sum)
check_consistency(check1, "Total Economy Assets Composition Check", 
                  components = list(
                    "Total S1" = aall[F..S1.S0.LE._T.2023q4],
                    "Sum of sectors" = apply(aall[F..S11+S1M+S12K+S12O+S12Q+S124+S13.S0.LE._T.2023q4], 1, sum)
                  ))

# CHECK 2: Total Economy Liabilities Composition
check2 = aall[F..S0.S1.LE._T.2023q4] - 
  apply(aall[F..S0.S11+S1M+S12K+S12O+S12Q+S124+S13.LE._T.2023q4], 1, sum)
check_consistency(check2, "Total Economy Liabilities Composition Check",
                  components = list(
                    "Total S1" = aall[F..S0.S1.LE._T.2023q4],
                    "Sum of sectors" = apply(aall[F..S0.S11+S1M+S12K+S12O+S12Q+S124+S13.LE._T.2023q4], 1, sum)
                  ))

# CHECK 3a: Currency Liabilities
check3a = aall[F21..S0.S1.LE._T.2023q4] - 
  apply(aall[F21..S0.S13+S12K.LE._T.2023q4], 1, sum)
check_consistency(check3a, "Currency Liabilities Check",
                  components = list(
                    "Total" = aall[F21..S0.S1.LE._T.2023q4],
                    "Sum of S13+S12K" = apply(aall[F21..S0.S13+S12K.LE._T.2023q4], 1, sum)
                  ))

# CHECK 3b: Deposit Liabilities
check3b = aall[F2M..S0.S1.LE._T.2023q4] - 
  apply(aall[F2M..S0.S13+S12K.LE._T.2023q4], 1, sum)
check_consistency(check3b, "Deposit Liabilities Check",
                  components = list(
                    "Total" = aall[F2M..S0.S1.LE._T.2023q4],
                    "Sum of S13+S12K" = apply(aall[F2M..S0.S13+S12K.LE._T.2023q4], 1, sum)
                  ))

# CHECK 4: S0 and S1 Comparison #####open
#check4a = aall[...S0.LE._T.2023q4]
#check4b = aall[...S1.LE._T.2023q4]
#check4 = check4a - check4b
#check_consistency(check4, "S0 vs S1 Comparison Check",
#                  components = list(
#                    "S0" = check4a,
#                    "S1" = check4b
#                  ))

#################### INSTRUMENT SUBCOMPONENT CHECKS ####################

# CHECK F3: Debt Securities
# Assets check
check_f3_assets = aall[F3..S1.S0.LE._T.2023q4] - 
  (aall[F3S..S1.S0.LE._T.2023q4] + aall[F3L..S1.S0.LE._T.2023q4])
check_consistency(check_f3_assets, "F3 (Debt Securities) Assets Composition",
                  components = list(
                    "F3 Total" = aall[F3..S1.S0.LE._T.2023q4],
                    "F3S" = aall[F3S..S1.S0.LE._T.2023q4],
                    "F3L" = aall[F3L..S1.S0.LE._T.2023q4]
                  ))

# Liabilities check
check_f3_liab = aall[F3..S0.S1.LE._T.2023q4] - 
  (aall[F3S..S0.S1.LE._T.2023q4] + aall[F3L..S0.S1.LE._T.2023q4])
check_consistency(check_f3_liab, "F3 (Debt Securities) Liabilities Composition",
                  components = list(
                    "F3 Total" = aall[F3..S0.S1.LE._T.2023q4],
                    "F3S" = aall[F3S..S0.S1.LE._T.2023q4],
                    "F3L" = aall[F3L..S0.S1.LE._T.2023q4]
                  ))

# CHECK F4: Loans
# Assets check
check_f4_assets = aall[F4..S1.S0.LE._T.2023q4] - 
  (aall[F4S..S1.S0.LE._T.2023q4] + aall[F4L..S1.S0.LE._T.2023q4])
check_consistency(check_f4_assets, "F4 (Loans) Assets Composition",
                  components = list(
                    "F4 Total" = aall[F4..S1.S0.LE._T.2023q4],
                    "F4S" = aall[F4S..S1.S0.LE._T.2023q4],
                    "F4L" = aall[F4L..S1.S0.LE._T.2023q4]
                  ))

# Liabilities check
check_f4_liab = aall[F4..S0.S1.LE._T.2023q4] - 
  (aall[F4S..S0.S1.LE._T.2023q4] + aall[F4L..S0.S1.LE._T.2023q4])
check_consistency(check_f4_liab, "F4 (Loans) Liabilities Composition",
                  components = list(
                    "F4 Total" = aall[F4..S0.S1.LE._T.2023q4],
                    "F4S" = aall[F4S..S0.S1.LE._T.2023q4],
                    "F4L" = aall[F4L..S0.S1.LE._T.2023q4]
                  ))

# CHECK F51: Equity
# Assets check
check_f51_assets = aall[F51..S1.S0.LE._T.2023q4] - 
  (aall[F511..S1.S0.LE._T.2023q4] + aall[F51M..S1.S0.LE._T.2023q4])
check_consistency(check_f51_assets, "F51 (Equity) Assets Composition",
                  components = list(
                    "F51 Total" = aall[F51..S1.S0.LE._T.2023q4],
                    "F511" = aall[F511..S1.S0.LE._T.2023q4],
                    "F51M" = aall[F51M..S1.S0.LE._T.2023q4]
                  ))

# Liabilities check
check_f51_liab = aall[F51..S0.S1.LE._T.2023q4] - 
  (aall[F511..S0.S1.LE._T.2023q4] + aall[F51M..S0.S1.LE._T.2023q4])
check_consistency(check_f51_liab, "F51 (Equity) Liabilities Composition",
                  components = list(
                    "F51 Total" = aall[F51..S0.S1.LE._T.2023q4],
                    "F511" = aall[F511..S0.S1.LE._T.2023q4],
                    "F51M" = aall[F51M..S0.S1.LE._T.2023q4]
                  ))

# CHECK F6: Insurance
# Assets check
check_f6_assets = aall[F6..S1.S0.LE._T.2023q4] - 
  (aall[F6N..S1.S0.LE._T.2023q4] + aall[F6O..S1.S0.LE._T.2023q4])
check_consistency(check_f6_assets, "F6 (Insurance) Assets Composition",
                  components = list(
                    "F6 Total" = aall[F6..S1.S0.LE._T.2023q4],
                    "F6N" = aall[F6N..S1.S0.LE._T.2023q4],
                    "F6O" = aall[F6O..S1.S0.LE._T.2023q4]
                  ))

# Liabilities check
check_f6_liab = aall[F6..S0.S1.LE._T.2023q4] - 
  (aall[F6N..S0.S1.LE._T.2023q4] + aall[F6O..S0.S1.LE._T.2023q4])
check_consistency(check_f6_liab, "F6 (Insurance) Liabilities Composition",
                  components = list(
                    "F6 Total" = aall[F6..S0.S1.LE._T.2023q4],
                    "F6N" = aall[F6N..S0.S1.LE._T.2023q4],
                    "F6O" = aall[F6O..S0.S1.LE._T.2023q4]
                  ))

#################### TOTAL INSTRUMENTS CHECK ####################

check_consistency <- function(diff_values, description, check_type = "sector", 
                              thresholds = c(1, 1.5, 2), components = NULL, 
                              individual_components = NULL) {
  for(threshold in thresholds) {
    cat(sprintf("\n\n=== %s - Analysis for threshold %g ===\n", description, threshold))
    
    significant_diff <- which(abs(diff_values) > threshold)
    
    if(length(significant_diff) > 0) {
      cat(sprintf("\nFound %d discrepancies larger than %g\n", 
                  length(significant_diff), threshold))
      
      countries <- dimnames(diff_values)$REF_AREA
      
      if(!is.null(components)) {
        for(i in seq_along(significant_diff)) {
          country <- countries[significant_diff[i]]
          diff_value <- diff_values[significant_diff[i]]
          
          cat("\nDetails for discrepancy", i, ":\n")
          cat("Country:", country, "\n")
          cat("Difference:", format(diff_value, digits=2), "\n")
          
          for(comp_name in names(components)) {
            comp_value <- components[[comp_name]][significant_diff[i]]
            cat(comp_name, ":", format(comp_value, digits=2), "\n")
          }
          
          # Analysis of individual components
          if(!is.null(individual_components)) {
            cat("\nPotential sources of discrepancy:\n")
            
            # Store all differences in a vector
            diffs <- numeric(length(individual_components))
            names(diffs) <- names(individual_components)
            
            # Calculate differences for each component
            for(comp_name in names(individual_components)) {
              comp_value <- individual_components[[comp_name]][significant_diff[i]]
              diffs[comp_name] <- abs(abs(comp_value) - abs(diff_value))
            }
            
            # Get two closest matches
            ordered_diffs <- sort(diffs)
            closest_two <- names(ordered_diffs)[1:2]
            
            # Print the results
            for(comp_name in closest_two) {
              comp_value <- individual_components[[comp_name]][significant_diff[i]]
              diff_from_discrepancy <- diffs[comp_name]
              cat(sprintf("%s: %.2f (value: %.2f)\n", 
                          comp_name,
                          diff_from_discrepancy,
                          comp_value))
            }
          }
          cat("--------------------\n")
        }
      } else {
        for(i in seq_along(significant_diff)) {
          country <- countries[significant_diff[i]]
          cat("\nCountry:", country, "\n")
          cat("Difference:", format(diff_values[significant_diff[i]], digits=2), "\n")
          cat("--------------------\n")
        }
      }
    } else {
      cat("\nNo discrepancies found exceeding threshold", threshold, "\n")
    }
  }
  return(invisible(diff_values))
}

#################### TOTAL INSTRUMENTS CHECK ####################
#### ADDING AN ADDITIONAL STEP TO DETERMINE THE POTENTIAL SOURCES OF ISSUES

check_consistency <- function(diff_values, description, check_type = "sector", 
                              thresholds = c(1, 1.5, 2), components = NULL, 
                              individual_components = NULL) {
  for(threshold in thresholds) {
    cat(sprintf("\n\n=== %s - Analysis for threshold %g ===\n", description, threshold))
    
    significant_diff <- which(abs(diff_values) > threshold)
    
    if(length(significant_diff) > 0) {
      cat(sprintf("\nFound %d discrepancies larger than %g\n", 
                  length(significant_diff), threshold))
      
      countries <- dimnames(diff_values)$REF_AREA
      
      if(!is.null(components)) {
        for(i in seq_along(significant_diff)) {
          country <- countries[significant_diff[i]]
          diff_value <- diff_values[significant_diff[i]]
          
          cat("\nDetails for discrepancy", i, ":\n")
          cat("Country:", country, "\n")
          cat("Difference:", format(diff_value, digits=2), "\n")
          
          for(comp_name in names(components)) {
            comp_value <- components[[comp_name]][significant_diff[i]]
            cat(comp_name, ":", format(comp_value, digits=2), "\n")
          }
          
          # Analysis of individual components
          if(!is.null(individual_components)) {
            cat("\nPotential sources of discrepancy:\n")
            
            # Store all differences in a vector
            diffs <- numeric(length(individual_components))
            names(diffs) <- names(individual_components)
            
            # Calculate differences for each component
            for(comp_name in names(individual_components)) {
              comp_value <- individual_components[[comp_name]][significant_diff[i]]
              diffs[comp_name] <- abs(abs(comp_value) - abs(diff_value))
            }
            
            # Get two closest matches
            ordered_diffs <- sort(diffs)
            closest_two <- names(ordered_diffs)[1:2]
            
            # Print the results
            for(comp_name in closest_two) {
              comp_value <- individual_components[[comp_name]][significant_diff[i]]
              diff_from_discrepancy <- diffs[comp_name]
              cat(sprintf("%s: %.2f (value: %.2f)\n", 
                          comp_name,
                          diff_from_discrepancy,
                          comp_value))
            }
          }
          cat("--------------------\n")
        }
      } else {
        for(i in seq_along(significant_diff)) {
          country <- countries[significant_diff[i]]
          cat("\nCountry:", country, "\n")
          cat("Difference:", format(diff_values[significant_diff[i]], digits=2), "\n")
          cat("--------------------\n")
        }
      }
    } else {
      cat("\nNo discrepancies found exceeding threshold", threshold, "\n")
    }
  }
  return(invisible(diff_values))
}



# Assets check
components_assets = aall[F21..S1.S0.LE._T.2023q4] +
  aall[F2M..S1.S0.LE._T.2023q4] +
  aall[F3..S1.S0.LE._T.2023q4] +
  aall[F4..S1.S0.LE._T.2023q4] +
  aall[F51..S1.S0.LE._T.2023q4] +
  aall[F52..S1.S0.LE._T.2023q4] +
  aall[F6..S1.S0.LE._T.2023q4] +
  aall[F7..S1.S0.LE._T.2023q4] +
  aall[F81..S1.S0.LE._T.2023q4] +
  aall[F89..S1.S0.LE._T.2023q4]

check_total_assets = aall[F..S1.S0.LE._T.2023q4] - components_assets

check_consistency(check_total_assets, "Total Financial Instruments Assets",
                  components = list(
                    "Total F" = aall[F..S1.S0.LE._T.2023q4],
                    "Sum of components" = components_assets
                  ),
                  individual_components = list(
                    "F21" = aall[F21..S1.S0.LE._T.2023q4],
                    "F2M" = aall[F2M..S1.S0.LE._T.2023q4],
                    "F3" = aall[F3..S1.S0.LE._T.2023q4],
                    "F4" = aall[F4..S1.S0.LE._T.2023q4],
                    "F51" = aall[F51..S1.S0.LE._T.2023q4],
                    "F52" = aall[F52..S1.S0.LE._T.2023q4],
                    "F6" = aall[F6..S1.S0.LE._T.2023q4],
                    "F7" = aall[F7..S1.S0.LE._T.2023q4],
                    "F81" = aall[F81..S1.S0.LE._T.2023q4],
                    "F89" = aall[F89..S1.S0.LE._T.2023q4]
                  ))

# Liabilities check
components_liab = aall[F21..S0.S1.LE._T.2023q4] +
  aall[F2M..S0.S1.LE._T.2023q4] +
  aall[F3..S0.S1.LE._T.2023q4] +
  aall[F4..S0.S1.LE._T.2023q4] +
  aall[F51..S0.S1.LE._T.2023q4] +
  aall[F52..S0.S1.LE._T.2023q4] +
  aall[F6..S0.S1.LE._T.2023q4] +
  aall[F7..S0.S1.LE._T.2023q4] +
  aall[F81..S0.S1.LE._T.2023q4] +
  aall[F89..S0.S1.LE._T.2023q4]

check_total_liab = aall[F..S0.S1.LE._T.2023q4] - components_liab

check_consistency(check_total_liab, "Total Financial Instruments Liabilities",
                  components = list(
                    "Total F" = aall[F..S0.S1.LE._T.2023q4],
                    "Sum of components" = components_liab
                  ),
                  individual_components = list(
                    "F21" = aall[F21..S0.S1.LE._T.2023q4],
                    "F2M" = aall[F2M..S0.S1.LE._T.2023q4],
                    "F3" = aall[F3..S0.S1.LE._T.2023q4],
                    "F4" = aall[F4..S0.S1.LE._T.2023q4],
                    "F51" = aall[F51..S0.S1.LE._T.2023q4],
                    "F52" = aall[F52..S0.S1.LE._T.2023q4],
                    "F6" = aall[F6..S0.S1.LE._T.2023q4],
                    "F7" = aall[F7..S0.S1.LE._T.2023q4],
                    "F81" = aall[F81..S0.S1.LE._T.2023q4],
                    "F89" = aall[F89..S0.S1.LE._T.2023q4]
                  ))
