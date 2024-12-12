################################################################################
# Setup and Configuration
################################################################################

# Load required packages
if (!require("MDecfin")) {
  stop("MDecfin package is required but not installed")
}

# Set the project directories
#please update for brussels
#setwd('U:/Topics/Spillovers_and_EA/flowoffunds/finflows2024/gitcodedata')
#setwd('C:/Users/aruqaer/R/finflow/gitclone/finflows')

#ispra
script_dir <- "X:/Finflows/zeugner/routines"
data_dir <- "X:/Finflows/zeugner/data"

# Check directories exist
if (!dir.exists(script_dir)) {
  stop("Scripts directory not found: ", script_dir)
}
if (!dir.exists(data_dir)) {
  stop("Data directory not found: ", data_dir)
}

# Set working directory to script location
setwd(script_dir)

# Create logs directory if it doesn't exist
if (!dir.exists(file.path(data_dir, "logs"))) {
  dir.create(file.path(data_dir, "logs"))
}

cat("\nStarting execution of financial flows analysis...\n")
cat("Scripts directory:", script_dir, "\n")
cat("Data directory:", data_dir, "\n")

################################################################################
# Utility Functions
################################################################################

# Logging function
log_execution <- function(script_name, status, message = "") {
  timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  log_entry <- sprintf("[%s] %s: %s %s\n", timestamp, script_name, status, message)
  cat(log_entry, file = file.path(data_dir, "logs", "execution_log.txt"), append = TRUE)
  cat(log_entry) # Also print to console
}

# Script execution function
run_script <- function(script_path) {
  script_name <- basename(script_path)
  
  tryCatch({
    log_execution(script_name, "STARTING")
    start_time <- Sys.time()
    
    # Create environment with correct data path
    script_env <- new.env()
    script_env$data_dir <- data_dir
    
    # Source the script in the new environment
    sys.source(script_path, script_env)
    
    end_time <- Sys.time()
    duration <- round(as.numeric(difftime(end_time, start_time, units = "mins")), 2)
    
    log_execution(script_name, "COMPLETED", sprintf("(Duration: %s minutes)", duration))
    return(TRUE)
    
  }, error = function(e) {
    log_execution(script_name, "ERROR", sprintf("Error: %s", e$message))
    return(FALSE)
  })
}

# Interactive control function
confirm_data_load <- function(data_name) {
  if (!interactive()) {
    cat("Non-interactive session detected, proceeding with data load\n")
    return(TRUE)
  }
  
  cat("\n========================================\n")
  cat(sprintf("Do you want to load %s data?\n", data_name))
  cat("Type 'y' to load, or press Enter to skip: ")
  
  choice <- tolower(trimws(readline()))
  cat(sprintf("You chose to %s this data load\n", ifelse(choice == "y", "proceed with", "skip")))
  cat("========================================\n")
  return(choice == "y")
}

# Dependency checking functions
check_rds_exists <- function(file_path) {
  exists <- file.exists(file_path)
  if (exists) {
    log_execution("DEPENDENCY CHECK", "INFO", sprintf("Found existing file: %s", file_path))
  } else {
    log_execution("DEPENDENCY CHECK", "INFO", sprintf("File not found: %s", file_path))
  }
  return(exists)
}

get_file_modification_time <- function(file_path) {
  if (file.exists(file_path)) {
    return(file.info(file_path)$mtime)
  }
  return(NULL)
}

################################################################################
# Main Execution
################################################################################

# Initialize log file
cat("", file = file.path(data_dir, "logs", "execution_log.txt"))

# Define script dependencies and execution paths
execution_plan <- list(
  # Data loading pipeline
  data_loading = list(
    # ECB QSA data
    ecb = list(
      script = file.path(script_dir, "001_finflowers_loadQSAfromECB.R"),
      output = file.path(data_dir, "fflist.rds"),
      name = "ECB QSA"
    ),
    # Eurostat annual data
    eurostat_annual = list(
      script = file.path(script_dir, "006_finflowers_load_nasa10fbs.R"),
      output = file.path(data_dir, "eurostat_annual.rds"),
      name = "Eurostat annual"
    ),
    # Eurostat quarterly data
    eurostat_quarterly = list(
      script = file.path(script_dir, "007_finflowers_load_nasq10fbs.R"),
      output = file.path(data_dir, "eurostat_quarterly.rds"),
      name = "Eurostat quarterly"
    )
  ),
  
  # Processing pipeline
  processing = list(
    combine = list(
      script = file.path(script_dir, "002_finflowers_combineQSA.R"),
      output = file.path(data_dir, "aall1.rds"),
      depends_on = file.path(data_dir, "fflist.rds")
    ),
    fill_gaps = list(
      script = file.path(script_dir, "003_finflowers_EAtest.R"),
      output = file.path(data_dir, "aall.rds"),
      depends_on = file.path(data_dir, "aall1.rds")
    ),
    exchange_rates = list(
      script = file.path(script_dir, "004_exchange_rates.R"),
      output = file.path(data_dir, "aall_bis.rds"),
      depends_on = file.path(data_dir, "aall.rds")
    )
  ),
  
  # Analysis paths
  analysis = list(
    plausibility = list(
      script = file.path(script_dir, "005_finflowers_EA_plausichecks.R"),
      depends_on = file.path(data_dir, "aall_bis.rds")
    ),
    visualization = list(
      script = file.path(script_dir, "006_finflowers_EAtest - visualisation.R"),
      depends_on = file.path(data_dir, "aall_bis.rds")
    )
  )
)

# Execute data loading pipeline
log_execution("MAIN", "INFO", "Starting data loading phase")
for (data_source in execution_plan$data_loading) {
  if (confirm_data_load(data_source$name)) {
    if (!file.exists(data_source$script)) {
      stop(sprintf("Script file not found: %s", data_source$script))
    }
    
    success <- run_script(data_source$script)
    if (!success) {
      stop(sprintf("Execution failed at script: %s", data_source$script))
    }
  } else {
    log_execution(data_source$name, "SKIPPED", "User chose to skip loading")
  }
}

# Execute processing pipeline
log_execution("MAIN", "INFO", "Starting data processing phase")
for (step in execution_plan$processing) {
  if (!file.exists(step$script)) {
    stop(sprintf("Script file not found: %s", step$script))
  }
  
  need_to_run <- FALSE
  
  if (!check_rds_exists(step$output)) {
    need_to_run <- TRUE
  } else if (!is.null(step$depends_on)) {
    input_time <- get_file_modification_time(step$depends_on)
    output_time <- get_file_modification_time(step$output)
    if (!is.null(input_time) && !is.null(output_time) && input_time > output_time) {
      need_to_run <- TRUE
      log_execution("DEPENDENCY CHECK", "INFO", 
                    sprintf("Input %s is newer than output %s", step$depends_on, step$output))
    }
  }
  
  if (need_to_run) {
    success <- run_script(step$script)
    if (!success) {
      stop(sprintf("Execution failed at script: %s", step$script))
    }
  } else {
    log_execution(step$script, "SKIPPED", "Output file exists and is up to date")
  }
}

# Execute parallel analysis paths
log_execution("MAIN", "INFO", "Starting analysis phase")
if (check_rds_exists(execution_plan$analysis$plausibility$depends_on)) {
  # Run plausibility checks and visualization in parallel
  for (analysis in execution_plan$analysis) {
    run_script(analysis$script)
  }
} else {
  stop("Required input file for analysis not found")
}

# Final execution summary
log_execution("MAIN", "COMPLETED", "All scripts executed successfully")

################################################################################
# End of Script
################################################################################