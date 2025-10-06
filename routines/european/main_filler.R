################################################################################
# Setup and Configuration
################################################################################

library(MDstats); library(MD3)

# Set data directory
#data_dir= file.path(getwd(),'data')
if (!exists("data_dir")) data_dir = '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/data/'
#if (!exists("script_dir")) data_dir = '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/routines/'

script_dir <- "V:/Finflows/githubrepo/finflows/routines"

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



################################################################################
# Main Execution
################################################################################

# Initialize log file
cat("", file = file.path(data_dir, "logs", "execution_log.txt"))


# Define script dependencies and execution paths
execution_plan <- list(
  # Data loading pipeline
  data_loading = list(
    # preperation of aall_domestic to split into assets and liabilities
    prep = list(
      script = file.path(script_dir, "european/prep_aalldomestic.R"),
      output = file.path(data_dir, "ll_prep.rds"),
      name = "prep all"
    ),
    # IIP filler - first load aall_domestic and then fill with bop iip information from ESTAT
    iip = list(
      script = file.path(script_dir, "european/filler_iip.R"),
      output = file.path(data_dir, "ll_iip_cps.rds"),
      name = "IIP filler"
    ),
    # BSI filler - for F2 and F4
    bsi_ext = list(
      script = file.path(script_dir, "european/filler_bsi.R"),
      output = file.path(data_dir, "ll_iip_bsi.rds"),
      name = "BSI filler"
    ),
    # SHSS filler
    shss= list(
      script = file.path(script_dir, "european/filler_shss.R"),
      output = file.path(data_dir, "ll_iip_shss.rds"),
      name = "SHSS filler"
    ),
    # cpis filler
    cpis= list(
      script = file.path(script_dir, "european/cpis_shss.R"),
      output = file.path(data_dir, "ll_iip_cpis.rds"),
      name = "SHSS filler"
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


# Final execution summary
log_execution("MAIN", "COMPLETED", "All scripts executed successfully")

################################################################################
# End of Script
################################################################################