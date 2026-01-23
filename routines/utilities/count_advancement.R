# Function to count NA values - overall and by financial instrument
count_na <- function(obj_name) {
  # Convert to array
  arr_data <- as.array(obj_name)
  
  # OVERALL STATISTICS
  n_total <- length(arr_data)
  n_na <- sum(is.na(arr_data))
  n_non_na <- n_total - n_na
  
  cat("\n========================================\n")
  cat("OVERALL RESULTS\n")
  cat("========================================\n")
  cat(sprintf("Total elements:     %s\n", format(n_total, big.mark = ",")))
  cat(sprintf("Non-NA values:      %s (%.4f%%)\n", 
              format(n_non_na, big.mark = ","),
              (n_non_na / n_total) * 100))
  cat(sprintf("NA values:          %s (%.4f%%)\n", 
              format(n_na, big.mark = ","),
              (n_na / n_total) * 100))
  
  # BY FINANCIAL INSTRUMENT (1st dimension)
  cat("\n========================================\n")
  cat("PROGRESS BY FINANCIAL INSTRUMENT\n")
  cat("========================================\n")
  
  # Get instrument names
  instruments <- dimnames(obj_name)[[1]]
  
  # Calculate for each instrument
  for (i in 1:length(instruments)) {
    # Extract data for this instrument - HERE CHANGE NUMBER OF DIMENSIONS IF NEEDED
    instrument_data <- arr_data[i,,,,,,,]
    
    # Count values
    inst_total <- length(instrument_data)
    inst_non_na <- sum(!is.na(instrument_data))
    inst_pct <- (inst_non_na / inst_total) * 100
    
    # Print with formatting based on completion
    if (inst_pct == 0) {
      cat(sprintf("%-6s: %9s / %9s (%6.2f%%) [EMPTY]\n", 
                  instruments[i],
                  format(inst_non_na, big.mark = ","),
                  format(inst_total, big.mark = ","),
                  inst_pct))
    } else if (inst_pct == 100) {
      cat(sprintf("%-6s: %9s / %9s (%6.2f%%) [COMPLETE]\n", 
                  instruments[i],
                  format(inst_non_na, big.mark = ","),
                  format(inst_total, big.mark = ","),
                  inst_pct))
    } else {
      cat(sprintf("%-6s: %9s / %9s (%6.2f%%)\n", 
                  instruments[i],
                  format(inst_non_na, big.mark = ","),
                  format(inst_total, big.mark = ","),
                  inst_pct))
    }
  }
  cat("========================================\n")
}

# Usage
count_na(aall)
