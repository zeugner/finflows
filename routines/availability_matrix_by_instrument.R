library(MDecfin)

# Define reference sectors (will become rows)
ref_sectors <- c("S121", "S12T", "S124", "S12O", "S12Q", "S13", 
                 "S1M", "S11", "S2", "S0", "S1", "S12K", "S12R")

# Define counterpart sectors (will become columns)
counterpart_sectors <- c("S121", "S12T", "S124", "S12O", "S12Q", "S13", 
                         "S1M", "S11", "S2", "S0", "S1", "S12K", "S12R")

# Define financial instruments (will determine which matrix)
instruments <- c("F", "F21", "F2M", "F3", "F4", "F511", "F51M", "F52", 
                 "F6", "F81", "F89")

# Function to create availability matrix for a given instrument
# Rows: reference sectors, Columns: counterpart sectors
create_availability_matrix_by_instrument <- function(instrument, time_period = "2022q4") {
  # Initialize matrix with reference sectors as rows, counterpart sectors as columns
  avail_matrix <- matrix(0, 
                         nrow = length(ref_sectors), 
                         ncol = length(counterpart_sectors),
                         dimnames = list(ref_sectors, counterpart_sectors))
  
  # For each combination of reference sector and counterpart sector
  for(rsector in ref_sectors) {
    for(csector in counterpart_sectors) {
      # Create indexing string for aall array
      # Format: [instrument..ref_sector.counterpart_sector.LE._T.time]
      idx <- sprintf("%s..%s.%s.LE._T.%s", instrument, rsector, csector, time_period)
      
      # Extract data and count non-NA values
      data_slice <- aall[idx]
      count <- sum(!is.na(data_slice))
      
      # Store count in matrix
      avail_matrix[rsector, csector] <- count
    }
  }
  
  return(avail_matrix)
}

# Create matrices for all instruments
availability_matrices_by_instrument <- lapply(instruments, 
                                              create_availability_matrix_by_instrument)
names(availability_matrices_by_instrument) <- instruments

# Print results
for(instr in instruments) {
  cat("\nAvailability Matrix for Financial Instrument:", instr, "\n")
  cat("Rows: Reference Sectors | Columns: Counterpart Sectors\n")
  print(availability_matrices_by_instrument[[instr]])
  cat("\n", paste(rep("-", 80), collapse=""), "\n")
}