# Function to count non-NA values by selected financial instruments
count_nonna_instruments <- function(dt_obj) {
  # Define the instruments we want to track
  selected_instruments <- c("F21", "F2M", "F3", "F3S", "F3L", "F4", "F4S", "F4L", 
                            "F5", "F51", "F511", "F51M", "F52", "F6", "F7", "F81", "F89")
  
  cat("\n========================================\n")
  cat("NON-NA VALUES BY FINANCIAL INSTRUMENT\n")
  cat("========================================\n")
  
  # Overall count
  total_non_na <- nrow(dt_obj)
  cat(sprintf("Total non-NA values: %s\n", format(total_non_na, big.mark = ",")))
  cat("----------------------------------------\n")
  
  # Count by instrument (INSTR column)
  inst_counts <- table(dt_obj$INSTR)
  
  # Show selected instruments
  total_selected <- 0
  for (inst in selected_instruments) {
    if (inst %in% names(inst_counts)) {
      count <- inst_counts[inst]
      total_selected <- total_selected + count
      cat(sprintf("%-6s: %9s\n", 
                  inst,
                  format(count, big.mark = ",")))
    } else {
      cat(sprintf("%-6s: %9s\n", inst, "0"))
    }
  }
  
  cat("----------------------------------------\n")
  cat(sprintf("Total in selected instruments: %s\n", 
              format(total_selected, big.mark = ",")))
  cat("========================================\n")
}

# Function to count by counterpart area
count_nonna_counterpart <- function(dt_obj) {
  cat("\n========================================\n")
  cat("NON-NA VALUES BY COUNTERPART AREA\n")
  cat("========================================\n")
  
  total_non_na <- nrow(dt_obj)
  cat(sprintf("Total non-NA values: %s\n", format(total_non_na, big.mark = ",")))
  cat("----------------------------------------\n")
  
  # Count by counterpart area
  area_counts <- sort(table(dt_obj$COUNTERPART_AREA), decreasing = TRUE)
  
  # Show top 30
  cat("Top 30 Counterpart Areas:\n")
  n_show <- min(30, length(area_counts))
  for (i in 1:n_show) {
    cat(sprintf("%-15s: %9s\n", 
                names(area_counts)[i],
                format(area_counts[i], big.mark = ",")))
  }
  
  cat("----------------------------------------\n")
  cat(sprintf("Areas with data: %d\n", length(area_counts)))
  cat("========================================\n")
}

# Quick summary function
quick_summary <- function(dt_obj) {
  cat("\n========================================\n")
  cat("QUICK DATA SUMMARY\n")
  cat("========================================\n")
  
  cat(sprintf("Total non-NA values: %s\n", format(nrow(dt_obj), big.mark = ",")))
  cat(sprintf("Unique instruments: %d\n", length(unique(dt_obj$INSTR))))
  cat(sprintf("Unique countries: %d\n", length(unique(dt_obj$REF_AREA))))
  cat(sprintf("Unique counterpart areas: %d\n", length(unique(dt_obj$COUNTERPART_AREA))))
  cat(sprintf("Time periods: %d\n", length(unique(dt_obj$TIME))))
  
  cat("\nValue column: _.obs_value\n")
  cat(sprintf("Min value: %g\n", min(dt_obj$`_.obs_value`, na.rm = TRUE)))
  cat(sprintf("Max value: %g\n", max(dt_obj$`_.obs_value`, na.rm = TRUE)))
  cat("========================================\n")
}

# Usage
count_nonna_instruments(aa_prep)
count_nonna_counterpart(aa_prep)
count_nonna_instruments(ll_prep)
count_nonna_counterpart(ll_prep)

count_nonna_instruments(aa_iip_cps)
count_nonna_counterpart(aa_iip_cps)
count_nonna_instruments(ll_iip_cps)
count_nonna_counterpart(ll_iip_cps)

count_nonna_instruments(aa_iip_bsi)
count_nonna_counterpart(aa_iip_bsi)
count_nonna_instruments(ll_iip_bsi)
count_nonna_counterpart(ll_iip_bsi)

count_nonna_instruments(aa_iip_bsi)
count_nonna_counterpart(aa_iip_bsi)
count_nonna_instruments(ll_iip_bsi)
count_nonna_counterpart(ll_iip_bsi)

count_nonna_instruments(aa_iip_shss)
count_nonna_counterpart(aa_iip_shss)
count_nonna_instruments(ll_iip_shss)
count_nonna_counterpart(ll_iip_shss)

count_nonna_instruments(aa_iip_cpis)
count_nonna_counterpart(aa_iip_cpis)
count_nonna_instruments(ll_iip_cpis)
count_nonna_counterpart(ll_iip_cpis)


# Function to count non-NA values by FUNCTIONAL_CAT
count_nonna_functional <- function(dt_obj) {
  cat("\n========================================\n")
  cat("NON-NA VALUES BY FUNCTIONAL CATEGORY\n")
  cat("========================================\n")
  
  # Overall count
  total_non_na <- nrow(dt_obj)
  cat(sprintf("Total non-NA values: %s\n", format(total_non_na, big.mark = ",")))
  cat("----------------------------------------\n")
  
  # Count by FUNCTIONAL_CAT
  func_counts <- sort(table(dt_obj$FUNCTIONAL_CAT), decreasing = TRUE)
  
  # Show all functional categories
  cat("Functional Categories:\n")
  for (i in 1:length(func_counts)) {
    cat(sprintf("%-6s: %9s\n", 
                names(func_counts)[i],
                format(func_counts[i], big.mark = ",")))
  }
  
  cat("----------------------------------------\n")
  cat(sprintf("Categories with data: %d\n", length(func_counts)))
  cat("========================================\n")
}

# Usage
count_nonna_functional(aa_prep)
count_nonna_functional(ll_prep)

count_nonna_functional(aa_iip_cps)
count_nonna_functional(ll_iip_cps)

count_nonna_functional(aa_iip_bsi)
count_nonna_functional(ll_iip_bsi)

count_nonna_functional(aa_iip_bsi)
count_nonna_functional(ll_iip_bsi)

count_nonna_functional(aa_iip_shss)
count_nonna_functional(ll_iip_shss)

count_nonna_functional(aa_iip_cpis)
count_nonna_functional(ll_iip_cpis)

