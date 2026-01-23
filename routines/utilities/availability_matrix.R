library(MDecfin)

# Define reference sectors to analyze
ref_sectors <- c("S12K", "S121", "S12T", "S1M", "S2", "S11", "S13")

# Define counterpart sectors (columns)
counterpart_sectors <- c("S121", "S12T", "S124", "S12O", "S12Q", "S13", "S1M", "S11", "S2", "S0", "S1", "S12K", "S12R")

# Define financial instruments (rows)
instruments <- c("F", "F21", "F2M", "F3", "F4", "F511", "F51M", "F52", "F6", "F81", "F89")

# Function to create availability matrix for a given reference sector
create_availability_matrix <- function(ref_sector, time_period = "2022q4") {
  # Initialize matrix
  avail_matrix <- matrix(0, 
                         nrow = length(instruments), 
                         ncol = length(counterpart_sectors),
                         dimnames = list(instruments, counterpart_sectors))
  
  # For each combination of instrument and counterpart sector
  for(instr in instruments) {
    for(csector in counterpart_sectors) {
      # Create indexing string for aall array
      # Format: [instrument..ref_sector.counterpart_sector.LE._T.time]
      idx <- sprintf("%s..%s.%s.LE._T.%s", instr, ref_sector, csector, time_period)
      
      # Extract data and count non-NA values
      data_slice <- aall[idx]
      count <- sum(!is.na(data_slice))
      
      # Store count in matrix
      avail_matrix[instr, csector] <- count
    }
  }
  
  return(avail_matrix)
}

# Create matrices for all reference sectors
availability_matrices <- lapply(ref_sectors, create_availability_matrix)
names(availability_matrices) <- ref_sectors

# Print results
for(sector in ref_sectors) {
  cat("\nAvailability Matrix for Reference Sector:", sector, "\n")
  print(availability_matrices[[sector]])
  cat("\n", paste(rep("-", 80), collapse=""), "\n")
}

if (!exists("data_dir")) data_dir = getwd()
saveRDS(aall, file.path(data_dir, 'aall_filled.rds'))


