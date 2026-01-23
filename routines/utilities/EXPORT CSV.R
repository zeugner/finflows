# FAST EXPORT OF FILTERED aall DATA TO CSV FILES WITH PRECISE ROUNDING
# This code processes the data in small batches by time period
# and applies customized rounding: maximum of 2 decimal places

library(MDecfin)
library(data.table)

# Output file paths
stocks_csv <- "CSVs/Finflows_stocks.csv"
flows_csv <- "CSVs/Finflows_flows.csv"

cat("Starting optimized data export process with precise rounding...\n")

# Get all time periods - fixed to handle the structure correctly
all_dims <- dimcodes(aall)
time_dim <- all_dims$TIME

# Check what structure we actually have and extract time periods accordingly
cat("Examining TIME dimension structure...\n")
print(str(time_dim))

# Handle different possible structures
if (is.character(time_dim)) {
  time_periods <- time_dim  # Direct character vector
  cat("TIME dimension is a character vector with", length(time_periods), "periods\n")
} else if (is.data.frame(time_dim)) {
  # If it's a data frame, extract the code column
  time_periods <- time_dim$code
  cat("TIME dimension is a data frame, extracted 'code' column with", length(time_periods), "periods\n")
} else if (is.list(time_dim)) {
  # If it's a list, check what's in it and extract accordingly
  if ("code" %in% names(time_dim)) {
    time_periods <- time_dim$code
    cat("TIME dimension is a list with 'code' element, extracted", length(time_periods), "periods\n")
  } else {
    # Try to convert to character if it's a list without code element
    time_periods <- as.character(unlist(time_dim))
    cat("TIME dimension is a list without 'code' element, converted to", length(time_periods), "periods\n")
  }
} else {
  # Last resort - try to convert whatever we have to character
  time_periods <- as.character(time_dim)
  cat("TIME dimension is of unknown type, converted to character with", length(time_periods), "periods\n")
}

# Print first few periods to verify
cat("First few time periods:", paste(head(time_periods), collapse=", "), "\n")

# Get counterpart areas we want to keep (de-duplicated)
counterpart_areas_to_keep <- unique(c(
  # Initially specified areas
  "W0", "W1", "W2", "B6", "D6", 
  
  # European Areas
  "EA19", "EA20", "EXT_EA19", "EXT_EA20", "WRL_REST", 
  "EU27_2020", "EU28", "EUI", "EXT_EU27_2020", "EXT_EU28", 
  "G20_X_EU27_2020",
  
  # EU Countries
  "AT", "BE", "BG", "CY", "CZ", "DE", "DK", "EE", 
  "EL", "ES", "FI", "FR", "HR", "HU", "IE", "IT", 
  "LT", "LU", "LV", "MT", "NL", "PL", "PT", "RO", 
  "SE", "SI", "SK", "UK",
  
  # Other Major Countries
  "US", "JP", "CN", "BR", "RU", "IN", "CA", "AU", 
  "CH", "NO", "TR", "SA", "KR", "ID", "MX", "AR", 
  "ZA", "HK", 
  
  # Other Notable Entities
  "IMF", "OFFSHO"
))

# Custom rounding function:
# - If number has no decimal places, keep as is
# - If number has 1 decimal place, keep as is
# - If number has 2+ decimal places, round to 2 decimal places
custom_round <- function(x) {
  # Handle NA values
  if (is.na(x)) return(NA)
  
  # Convert to character to examine decimal places
  x_char <- as.character(x)
  
  # Check if it's an integer (no decimal part)
  if (grepl("^-?\\d+$", x_char) || !grepl("\\.", x_char)) {
    return(x)
  }
  
  # Extract decimal part
  decimal_part <- sub("^-?\\d+\\.(\\d*)$", "\\1", x_char)
  decimal_places <- nchar(decimal_part)
  
  # Apply rounding rules
  if (decimal_places <= 1) {
    return(x)  # Keep as is if 0 or 1 decimal place
  } else {
    return(round(x, 2))  # Round to 2 places if more
  }
}

# Function to process a single time period and append to CSV
process_time_period <- function(time_period, sto_value, output_file, append = FALSE) {
  tryCatch({
    cat("Processing", sto_value, "data for period", time_period, "...\n")
    
    # Extract data for just this time period with all our filters applied
    filtered_data <- aall[TRUE, TRUE, TRUE, TRUE, sto_value, "_T", time_period, counterpart_areas_to_keep]
    
    # Convert to data.table
    dt <- as.data.table(filtered_data)
    
    # Check if we have data
    if (nrow(dt) > 0 && "obs_value" %in% colnames(dt)) {
      # Apply custom rounding to each value
      dt$obs_value <- sapply(dt$obs_value, custom_round)
      
      # Filter out NA and 0 values
      dt <- dt[!is.na(obs_value) & obs_value != 0]
      
      # Write to CSV (append if not the first period)
      if (nrow(dt) > 0) {
        # Determine if we need to write headers
        write_headers <- !append || !file.exists(output_file)
        
        # Write to CSV
        fwrite(dt, output_file, append = append, col.names = write_headers)
        cat("Added", nrow(dt), "rows for period", time_period, "\n")
        return(nrow(dt))
      } else {
        cat("No valid data for period", time_period, "\n")
        return(0)
      }
    } else {
      cat("No data found for period", time_period, "\n")
      return(0)
    }
  }, error = function(e) {
    cat("Error processing period", time_period, ":", conditionMessage(e), "\n")
    return(0)
  })
}

# First, delete any existing output files
if (file.exists(stocks_csv)) file.remove(stocks_csv)
if (file.exists(flows_csv)) file.remove(flows_csv)

# Process stocks data (LE) period by period
cat("\nProcessing STOCKS data period by period...\n")
total_stocks_rows <- 0
for (i in seq_along(time_periods)) {
  period <- time_periods[i]
  # First period is not appended, all others are
  append_mode <- i > 1
  rows_added <- process_time_period(period, "LE", stocks_csv, append = append_mode)
  total_stocks_rows <- total_stocks_rows + rows_added
  
  # Free memory after each period
  gc()
  
  # Show progress
  cat(sprintf("Progress: %d/%d periods processed (%.1f%%)\n", 
              i, length(time_periods), 100 * i / length(time_periods)))
}

# Process flows data (F) period by period
cat("\nProcessing FLOWS data period by period...\n")
total_flows_rows <- 0
for (i in seq_along(time_periods)) {
  period <- time_periods[i]
  # First period is not appended, all others are
  append_mode <- i > 1
  rows_added <- process_time_period(period, "F", flows_csv, append = append_mode)
  total_flows_rows <- total_flows_rows + rows_added
  
  # Free memory after each period
  gc()
  
  # Show progress
  cat(sprintf("Progress: %d/%d periods processed (%.1f%%)\n", 
              i, length(time_periods), 100 * i / length(time_periods)))
}

cat("\nExport completed successfully!\n")
cat("Total stocks rows:", total_stocks_rows, "\n")
cat("Total flows rows:", total_flows_rows, "\n")
