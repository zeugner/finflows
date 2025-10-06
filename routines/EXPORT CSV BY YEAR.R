# OPTIMIZED EXPORT OF FILTERED aall DATA TO CSV FILES WITH PRECISE ROUNDING
# This code processes the data in optimized chunks with memory management
# Starting from 2024 and working backwards

library(MDecfin)
library(data.table)
library(bit64)  # For more efficient memory handling

# Base output directory for CSV files
csv_dir <- "CSVs"

cat("Starting optimized data export process with precise rounding...\n")

# Create directory if it doesn't exist
if (!dir.exists(csv_dir)) {
  dir.create(csv_dir, recursive = TRUE)
  cat("Created output directory:", csv_dir, "\n")
}

# Enable aggressive garbage collection to free memory faster
gc_aggressive <- function() {
  for (i in 1:3) gc(full = TRUE, verbose = FALSE)
}

# Get all time periods - fixed to handle the structure correctly
all_dims <- dimcodes(aall)
time_dim <- all_dims$TIME

# Handle different possible structures
if (is.character(time_dim)) {
  time_periods <- time_dim  # Direct character vector
} else if (is.data.frame(time_dim)) {
  time_periods <- time_dim$code  # Extract the code column
} else if (is.list(time_dim)) {
  if ("code" %in% names(time_dim)) {
    time_periods <- time_dim$code
  } else {
    time_periods <- as.character(unlist(time_dim))
  }
} else {
  time_periods <- as.character(time_dim)
}

# Group time periods by year for chunking
time_by_year <- split(time_periods, sub("q[1-4]$", "", time_periods))

# Sort years in reverse chronological order (newest first)
years <- sort(names(time_by_year), decreasing = TRUE)
cat("Found", length(years), "years in the data\n")
cat("Processing in reverse chronological order, starting with:", years[1], "\n")

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

# Custom rounding function with vectorized implementation
custom_round <- function(x) {
  # Handle NA values
  if (length(x) == 0 || all(is.na(x))) return(x)
  
  # Convert to character to examine decimal places
  x_out <- x
  
  # Process non-NA values
  valid_idx <- which(!is.na(x))
  
  if (length(valid_idx) > 0) {
    # Extract only non-NA values for processing
    x_valid <- x[valid_idx]
    
    # Convert to character
    x_char <- as.character(x_valid)
    
    # Find decimal points
    has_decimal <- grepl("\\.", x_char)
    
    # Extract decimal parts for those with decimals
    decimal_parts <- rep("", length(x_valid))
    decimal_parts[has_decimal] <- sub("^-?\\d+\\.(\\d*)$", "\\1", x_char[has_decimal])
    
    # Get decimal places count
    decimal_places <- nchar(decimal_parts)
    
    # Determine which need rounding (more than 2 decimal places)
    need_rounding <- decimal_places > 2
    
    # Apply rounding only to those that need it
    x_valid[need_rounding] <- round(x_valid[need_rounding], 2)
    
    # Update the output vector
    x_out[valid_idx] <- x_valid
  }
  
  return(x_out)
}

# Define STO values and functional categories to process
sto_values <- c("LE", "F")
func_cats <- c("_T", "_F", "_D", "_R", "_O", "_P")

# Process a full year at once with chunking by functional category
process_year <- function(year) {
  cat("\nStarting to process year:", year, "\n")
  output_file <- file.path(csv_dir, paste0("Finflows_", year, ".csv"))
  
  # Remove existing file if it exists
  if (file.exists(output_file)) {
    file.remove(output_file)
    cat("Removed existing file:", output_file, "\n")
  }
  
  # Get all quarters for this year
  quarters <- time_by_year[[year]]
  quarters <- sort(quarters, decreasing = TRUE)  # Process newest quarters first
  
  total_rows <- 0
  first_write <- TRUE
  
  # First-level chunking: Process by STO (stocks vs flows)
  for (sto in sto_values) {
    cat("Processing", sto, "data for year", year, "\n")
    
    # Second-level chunking: Process by functional category
    for (func_cat in func_cats) {
      cat(" - Processing functional category:", func_cat, "\n")
      
      # Create an empty data.table to hold all quarters for this STO and functional category
      combined_data <- data.table()
      
      # Process all quarters for this STO and functional category
      for (quarter in quarters) {
        cat("   - Extracting data for quarter:", quarter, "\n")
        
        # Extract data for this specific combination
        tryCatch({
          filtered_data <- aall[TRUE, TRUE, TRUE, TRUE, sto, func_cat, quarter, counterpart_areas_to_keep]
          
          # Convert to data.table and process only if we have data
          if (!is.null(filtered_data) && nrow(filtered_data) > 0) {
            dt <- as.data.table(filtered_data)
            
            if ("obs_value" %in% colnames(dt)) {
              # Apply custom rounding to each value
              dt$obs_value <- custom_round(dt$obs_value)
              
              # Filter out NA and 0 values
              dt <- dt[!is.na(obs_value) & obs_value != 0]
              
              if (nrow(dt) > 0) {
                # Add STO, functional category, and time period columns
                dt$STO <- sto
                dt$FUNCTIONAL_CAT <- func_cat
                dt$TIME <- quarter
                
                # Append to combined data
                combined_data <- rbindlist(list(combined_data, dt), use.names = TRUE, fill = TRUE)
              }
            }
          }
          
        }, error = function(e) {
          cat("Error processing", quarter, ":", conditionMessage(e), "\n")
        })
        
        # Intermediate memory cleanup
        rm(filtered_data)
        gc()
      }
      
      # Write the combined data for this STO and functional category
      if (nrow(combined_data) > 0) {
        # Write to CSV
        fwrite(combined_data, output_file, append = !first_write, col.names = first_write)
        
        rows_added <- nrow(combined_data)
        total_rows <- total_rows + rows_added
        first_write <- FALSE
        
        cat("   Added", rows_added, "rows for", func_cat, "\n")
      }
      
      # Free memory
      rm(combined_data)
      gc_aggressive()
    }
  }
  
  cat("Completed processing year", year, "with", total_rows, "total rows\n")
  return(total_rows)
}

# Initialize results counter
total_rows_by_year <- setNames(integer(length(years)), years)

# Process each year in reverse chronological order
for (year in years) {
  rows <- process_year(year)
  total_rows_by_year[year] <- rows
  
  # Force aggressive garbage collection between years
  gc_aggressive()
}

cat("\nExport completed successfully!\n")

# Display summary of rows exported by year
cat("\nSummary of rows exported by year:\n")
for (year in names(total_rows_by_year)) {
  cat(year, ":", total_rows_by_year[year], "rows\n")
}

# Calculate total rows across all years
total_rows <- sum(total_rows_by_year)
cat("\nTotal rows exported:", total_rows, "\n")