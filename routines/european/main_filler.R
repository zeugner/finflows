################################################################################
# Setup and Configuration
################################################################################

library(MDstats); library(MD3)

# Set data directory
#data_dir= file.path(getwd(),'data')
if (!exists("data_dir")) data_dir <- '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/data/'
script_dir <- '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/routines'

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

cat("\nStarting execution: external sector filler...\n")
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
  cat(sprintf("Do you want to run %s?\n", data_name))
  cat("Type 'y' to run, or press Enter to skip: ")
  
  choice <- tolower(trimws(readline()))
  cat(sprintf("You chose to %s this step\n", ifelse(choice == "y", "proceed with", "skip")))
  cat("========================================\n")
  return(choice == "y")
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
    # Step 1: preparation of aall_domestic - split into assets and liabilities
    prep = list(
      script = file.path(script_dir, "european/001_prep_aalldomestic.R"),
      output = file.path(data_dir, "ll_prep.rds"),
      name = "Prep aall_domestic (split aa/ll)"
    ),
    # Step 2: IIP filler - fill aa/ll with BOP IIP information from Eurostat
    iip = list(
      script = file.path(script_dir, "european/002_filler_iip.R"),
      output = file.path(data_dir, "ll_iip_cps.rds"),
      name = "IIP filler"
    ),
    # Step 3: BSI filler - for F2 and F4
    bsi_ext = list(
      script = file.path(script_dir, "european/003_filler_bsi.R"),
      output = file.path(data_dir, "ll_iip_bsi.rds"),
      name = "BSI filler"
    ),
    # Step 4: SHSS filler
    shss = list(
      script = file.path(script_dir, "european/004_filler_shss.R"),
      output = file.path(data_dir, "ll_iip_shss.rds"),
      name = "SHSS filler"
    ),
    # Step 5: CPIS filler
    cpis = list(
      script = file.path(script_dir, "european/filler_cpis.R"),
      output = file.path(data_dir, "ll_iip_cpis.rds"),
      name = "CPIS filler"
    )
  )
)

# Execute data loading pipeline
log_execution("MAIN", "INFO", "Starting european external sector filling phase")
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
    log_execution(data_source$name, "SKIPPED", "User chose to skip")
  }
}


# Final execution summary
log_execution("MAIN", "COMPLETED", "All scripts executed successfully")

################################################################################
# End of Script
################################################################################
