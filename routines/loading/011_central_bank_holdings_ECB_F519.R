<<<<<<< HEAD
# Load required packages
library(data.table)
library(openxlsx)
library(MD3)

# Set data directory
if (!exists("data_dir")) data_dir = getwd()

# ECB Capital Processing Script
# 1. Import the Excel file
ecb_file_path <- file.path(data_dir, "static/ecb_capital.xlsx")

# Read capital time series (annual ECB total capital)
capital_ts <- as.data.table(read.xlsx(ecb_file_path, sheet = "capital time series", startRow = 2))
# The structure is: first column is description, rest are years 1999-2024
colnames(capital_ts)[1] <- "description"
years <- 1999:2024
colnames(capital_ts)[2:ncol(capital_ts)] <- as.character(years)

# Read capital keys
capital_keys <- as.data.table(read.xlsx(ecb_file_path, sheet = "capital keys", startRow = 2))
colnames(capital_keys) <- c("REF_AREA", "ECB2013", "ECB", "2023", "2024")

# 2. Extract total ECB capital values for each year
ecb_total <- as.numeric(capital_ts[1, 2:ncol(capital_ts)])
names(ecb_total) <- years

print("ECB Total Capital by Year:")
print(ecb_total)

print("Capital Keys Structure:")
print(capital_keys)

# 3. Create quarterly time series with country participation
# Define time period mappings for capital keys
time_periods <- list(
  "ECB2013" = c("1999q4", paste0(rep(2000:2013, each=4), "q", rep(1:4, 14)), "2014q1"),
  "ECB" = paste0(rep(2014:2022, each=4), "q", rep(1:4, 9)),
  "2023" = paste0("2023q", 1:4),
  "2024" = paste0("2024q", 1:4)
)

# Create complete quarterly sequence
all_quarters <- c()
for(year in 1999:2024) {
  if(year == 1999) {
    all_quarters <- c(all_quarters, "1999q4")
  } else {
    all_quarters <- c(all_quarters, paste0(year, "q", 1:4))
  }
}

# Initialize result data.table
result_dt <- data.table()

# Process each country
for(i in 1:nrow(capital_keys)) {
  country <- capital_keys[i, REF_AREA]
  
  # Create country-specific time series
  country_series <- data.table(
    REF_AREA = country,
    TIME = all_quarters,
    obs_value = numeric(length(all_quarters))
  )
  
  # Fill values based on time periods
  for(quarter in all_quarters) {
    year <- as.numeric(substr(quarter, 1, 4))
    
    # Determine which capital key to use
    if(quarter %in% time_periods$ECB2013) {
      key_col <- "ECB2013"
    } else if(quarter %in% time_periods$ECB) {
      key_col <- "ECB"
    } else if(quarter %in% time_periods$"2023") {
      key_col <- "2023"
    } else if(quarter %in% time_periods$"2024") {
      key_col <- "2024"
    }
    
    # Calculate participation: capital_key × total_ECB_capital
    capital_key <- capital_keys[i, get(key_col)]
    total_capital <- ecb_total[as.character(year)]
    
    country_series[TIME == quarter, obs_value := capital_key * total_capital * 1000]
  }
  
  result_dt <- rbind(result_dt, country_series)
}

print("Sample of result data:")
print(head(result_dt, 20))

print("Summary by country:")
print(result_dt[, .(min_value = min(obs_value), max_value = max(obs_value), 
                    mean_value = mean(obs_value)), by = REF_AREA])

# 4. Convert to MD3 object
# Ensure proper data types
result_dt[, REF_AREA := as.character(REF_AREA)]
result_dt[, TIME := as.character(TIME)]
result_dt[, obs_value := as.numeric(obs_value)]

# Convert to MD3
ecb_capital_md3 <- as.md3(result_dt)

print("MD3 Structure:")
print(str(ecb_capital_md3))

print("Sample MD3 values:")
print(ecb_capital_md3["AT", "2023q1:2023q4"])

# Save results
saveRDS(ecb_capital_md3, file.path(data_dir, "ecb_capital_md3.rds"))
write.csv(result_dt, file.path(data_dir, "ecb_capital_quarterly.csv"), row.names = FALSE)

print("Processing complete!")
print(paste("Quarters processed:", length(all_quarters)))
print(paste("Countries processed:", nrow(capital_keys)))
=======
# Load required packages
library(data.table)
library(openxlsx)
library(MD3)

# Set data directory
if (!exists("data_dir")) data_dir = getwd()

# ECB Capital Processing Script
# 1. Import the Excel file
ecb_file_path <- file.path(data_dir, "static/ecb_capital.xlsx")

# Read capital time series (annual ECB total capital)
capital_ts <- as.data.table(read.xlsx(ecb_file_path, sheet = "capital time series", startRow = 2))
# The structure is: first column is description, rest are years 1999-2024
colnames(capital_ts)[1] <- "description"
years <- 1999:2024
colnames(capital_ts)[2:ncol(capital_ts)] <- as.character(years)

# Read capital keys
capital_keys <- as.data.table(read.xlsx(ecb_file_path, sheet = "capital keys", startRow = 2))
colnames(capital_keys) <- c("REF_AREA", "ECB2013", "ECB", "2023", "2024")

# 2. Extract total ECB capital values for each year
ecb_total <- as.numeric(capital_ts[1, 2:ncol(capital_ts)])
names(ecb_total) <- years

print("ECB Total Capital by Year:")
print(ecb_total)

print("Capital Keys Structure:")
print(capital_keys)

# 3. Create quarterly time series with country participation
# Define time period mappings for capital keys
time_periods <- list(
  "ECB2013" = c("1999q4", paste0(rep(2000:2013, each=4), "q", rep(1:4, 14)), "2014q1"),
  "ECB" = paste0(rep(2014:2022, each=4), "q", rep(1:4, 9)),
  "2023" = paste0("2023q", 1:4),
  "2024" = paste0("2024q", 1:4)
)

# Create complete quarterly sequence
all_quarters <- c()
for(year in 1999:2024) {
  if(year == 1999) {
    all_quarters <- c(all_quarters, "1999q4")
  } else {
    all_quarters <- c(all_quarters, paste0(year, "q", 1:4))
  }
}

# Initialize result data.table
result_dt <- data.table()

# Process each country
for(i in 1:nrow(capital_keys)) {
  country <- capital_keys[i, REF_AREA]
  
  # Create country-specific time series
  country_series <- data.table(
    REF_AREA = country,
    TIME = all_quarters,
    obs_value = numeric(length(all_quarters))
  )
  
  # Fill values based on time periods
  for(quarter in all_quarters) {
    year <- as.numeric(substr(quarter, 1, 4))
    
    # Determine which capital key to use
    if(quarter %in% time_periods$ECB2013) {
      key_col <- "ECB2013"
    } else if(quarter %in% time_periods$ECB) {
      key_col <- "ECB"
    } else if(quarter %in% time_periods$"2023") {
      key_col <- "2023"
    } else if(quarter %in% time_periods$"2024") {
      key_col <- "2024"
    }
    
    # Calculate participation: capital_key × total_ECB_capital
    capital_key <- capital_keys[i, get(key_col)]
    total_capital <- ecb_total[as.character(year)]
    
    country_series[TIME == quarter, obs_value := capital_key * total_capital * 1000]
  }
  
  result_dt <- rbind(result_dt, country_series)
}

print("Sample of result data:")
print(head(result_dt, 20))

print("Summary by country:")
print(result_dt[, .(min_value = min(obs_value), max_value = max(obs_value), 
                    mean_value = mean(obs_value)), by = REF_AREA])

# 4. Convert to MD3 object
# Ensure proper data types
result_dt[, REF_AREA := as.character(REF_AREA)]
result_dt[, TIME := as.character(TIME)]
result_dt[, obs_value := as.numeric(obs_value)]

# Convert to MD3
ecb_capital_md3 <- as.md3(result_dt)

print("MD3 Structure:")
print(str(ecb_capital_md3))

print("Sample MD3 values:")
print(ecb_capital_md3["AT", "2023q1:2023q4"])

# Save results
saveRDS(ecb_capital_md3, file.path(data_dir, "ecb_capital_md3.rds"))
write.csv(result_dt, file.path(data_dir, "ecb_capital_quarterly.csv"), row.names = FALSE)

print("Processing complete!")
print(paste("Quarters processed:", length(all_quarters)))
print(paste("Countries processed:", nrow(capital_keys)))
>>>>>>> 55a5a789115f3c6e93936ceaded19180b9724739
print(paste("Total observations:", nrow(result_dt)))