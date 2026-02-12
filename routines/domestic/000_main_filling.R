################################################################################
# MAIN FILLING SCRIPT - Finflows - Domestic
# 
################################################################################

# Load required packages
if (!require("MDecfin")) {
  stop("MDecfin package is required but not installed")
}

# Set the project directories
if (!exists("data_dir")) data_dir <- '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/data/'
script_dir <- '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/routines/'

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

cat("\nStarting execution of financial flows data processing and filling...\n")
cat("Scripts directory:", script_dir, "\n")
cat("Data directory:", data_dir, "\n")

################################################################################
# Utility Functions
################################################################################

# Logging function
log_execution <- function(script_name, status, message = "") {
  timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  log_entry <- sprintf("[%s] %s: %s %s\n", timestamp, script_name, status, message)
  cat(log_entry, file = file.path(data_dir, "logs", "filling_log.txt"), append = TRUE)
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
cat("", file = file.path(data_dir, "logs", "filling_log.txt"))

# Define processing pipeline with dependencies
filling_plan <- list(
  # Phase 1: Initial QSA Processing
  combine_qsa = list(
    script = file.path(script_dir, "001_finflowers_combineQSA.R"),
    input = file.path(data_dir, "fflist.rds"),
    output = file.path(data_dir, "intermediate_domestic_data_files/aall_qsa.rds"),
    phase = "Initial Processing"
  ),
  
  assumptions = list(
    script = file.path(script_dir, "002_finflowers_EAtest.R"),
    input = file.path(data_dir, "intermediate_domestic_data_files/aall_qsa.rds"),
    output = file.path(data_dir, "intermediate_domestic_data_files/aall_qsa_assumptions.rds"),
    phase = "Initial Processing"
  ),
  
  # Phase 2: Exchange Rate Conversion
  exchange_conversion = list(
    script = file.path(script_dir, "003_exchange_rates_rounding.R"),
    input = file.path(data_dir, "intermediate_domestic_data_files/aall_qsa_assumptions.rds"),
    output = file.path(data_dir, "intermediate_domestic_data_files/aall_rounded.rds"),
    phase = "Currency Conversion"
  ),
  
  # Phase 3: NASQ Processing
  nasq_processing = list(
    script = file.path(script_dir, "004_nasq_treatment.R"),
    input = file.path(data_dir, "domestic_loading_data_files/nasq_S.rds"),
    output = file.path(data_dir, "intermediate_domestic_data_files/nasq_processed_assets_stocks.rds"),
    phase = "NASQ Processing"
  ),
  
  fill_nasq_s0 = list(
    script = file.path(script_dir, "005_fill_nasq_s0_totals.R"),
    input = file.path(data_dir, "intermediate_domestic_data_files/aall_rounded.rds"),
    output = file.path(data_dir, "intermediate_domestic_data_files/aall_NASQ.rds"),
    phase = "NASQ Processing"
  ),
  
  # Phase 4: NASA Processing
  fill_nasa_s0 = list(
    script = file.path(script_dir, "006_fill_nasa_s0_totals.R"),
    input = file.path(data_dir, "intermediate_domestic_data_files/aall_NASQ.rds"),
    output = file.path(data_dir, "intermediate_domestic_data_files/aall_NASA_S0.rds"),
    phase = "NASA Processing"
  ),
  
  nasa_intrasector = list(
    script = file.path(script_dir, "007_NASA_fill_intrasector.R"),
    input = file.path(data_dir, "intermediate_domestic_data_files/aall_NASA_S0.rds"),
    output = file.path(data_dir, "intermediate_domestic_data_files/aall_NASA_intrasector.rds"),
    phase = "NASA Processing"
  ),
  
  # Phase 5: BSI Processing
  bsi_f5 = list(
    script = file.path(script_dir, "008_BSI_F5_fill.R"),
    input = file.path(data_dir, "intermediate_domestic_data_files/aall_NASA_intrasector.rds"),
    output = file.path(data_dir, "intermediate_domestic_data_files/aall_bsi_f5.rds"),
    phase = "BSI Processing"
  ),
  
  bsi_loans_deposits = list(
    script = file.path(script_dir, "009_BSI_F4_F2M_FILL.R"),
    input = file.path(data_dir, "intermediate_domestic_data_files/aall_bsi_f5.rds"),
    output = file.path(data_dir, "intermediate_domestic_data_files/aall_bsi_loans_deposits.rds"),
    phase = "BSI Processing"
  ),
  
  # Phase 6: Securities Holdings
  shss_fill = list(
    script = file.path(script_dir, "010_SHSS_FILL_F3_F5.R"),
    input = file.path(data_dir, "intermediate_domestic_data_files/aall_bsi_loans_deposits.rds"),
    output = file.path(data_dir, "intermediate_domestic_data_files/aall_shss.rds"),
    phase = "Securities Processing"
  ),
  
  # Phase 7: Counterpart Processing
  fill_cp = list(
    script = file.path(script_dir, "011_fill_CP.R"),
    input = file.path(data_dir, "intermediate_domestic_data_files/aall_shss.rds"),
    output = file.path(data_dir, "intermediate_domestic_data_files/aall_cp.rds"),
    phase = "Counterpart Processing"
  ),
  
  # Phase 8: International Equity
  international_equity = list(
    script = file.path(script_dir, "012_fill_international_equity_positions.R"),
    input = file.path(data_dir, "intermediate_domestic_data_files/aall_cp.rds"),
    output = file.path(data_dir, "intermediate_domestic_data_files/aall_equity_bilateral_imf_gov.rds"),
    phase = "International Equity"
  ),
  
  # Phase 9: Domestic Unlisted Equity
  domestic_unlisted_equity = list(
    script = file.path(script_dir, "013_fill_unlisted_equity_domestic.R"),
    input = file.path(data_dir, "intermediate_domestic_data_files/aall_equity_bilateral_imf_gov.rds"),
    output = file.path(data_dir, "intermediate_domestic_data_files/aall_f51m.rds"),
    phase = "Domestic Equity"
  ),
  
  # Phase 10: Final Instruments
  f81_fill = list(
    script = file.path(script_dir, "014_F81.R"),
    input = file.path(data_dir, "intermediate_domestic_data_files/aall_f51m.rds"),
    output = file.path(data_dir, "aall_f81.rds"),
    phase = "Final Instruments"
  ),
  
  f89_fill = list(
    script = file.path(script_dir, "015_F89.R"),
    input = file.path(data_dir, "aall_f81.rds"),
    output = file.path(data_dir, "aall_f89.rds"),
    phase = "Final Instruments"
  ),
  
  f6_fill = list(
    script = file.path(script_dir, "016_F6.R"),
    input = file.path(data_dir, "aall_f89.rds"),
    output = file.path(data_dir, "intermediate_domestic_data_files/aall_domestic_T_FND.rds"),
    phase = "Final Instruments"
  )
)

# Execute processing pipeline
log_execution("MAIN", "INFO", "Starting data processing and filling phase")

current_phase <- ""
for (step_name in names(filling_plan)) {
  step <- filling_plan[[step_name]]
  
  # Log phase changes
  if (step$phase != current_phase) {
    current_phase <- step$phase
    log_execution("PHASE", "INFO", sprintf("Starting %s", current_phase))
    cat("\n", paste(rep("-", 60), collapse=""), "\n")
    cat("PHASE:", current_phase, "\n")
    cat(paste(rep("-", 60), collapse=""), "\n")
  }
  
  if (!file.exists(step$script)) {
    stop(sprintf("Script file not found: %s", step$script))
  }
  
  need_to_run <- FALSE
  
  # Check if output exists
  if (!check_rds_exists(step$output)) {
    need_to_run <- TRUE
    log_execution(step_name, "INFO", "Output file does not exist, running script")
  } else if (!is.null(step$input)) {
    # Check if input is newer than output
    input_time <- get_file_modification_time(step$input)
    output_time <- get_file_modification_time(step$output)
    if (!is.null(input_time) && !is.null(output_time) && input_time > output_time) {
      need_to_run <- TRUE
      log_execution(step_name, "INFO", 
                    sprintf("Input %s is newer than output %s", step$input, step$output))
    }
  } else {
    # No input specified, check if we should run anyway
    need_to_run <- TRUE
  }
  
  if (need_to_run) {
    # Check input dependencies
    if (!is.null(step$input) && !file.exists(step$input)) {
      stop(sprintf("Required input file not found: %s for step: %s", step$input, step_name))
    }
    
    success <- run_script(step$script)
    if (!success) {
      stop(sprintf("Execution failed at script: %s", step$script))
    }
    
    # Verify output was created
    if (!file.exists(step$output)) {
      log_execution(step_name, "ERROR", sprintf("Expected output not created: %s", step$output))
      stop(sprintf("Script completed but output file not found: %s", step$output))
    }
    
  } else {
    log_execution(step_name, "SKIPPED", "Output file exists and is up to date")
  }
}

# Final processing summary
log_execution("MAIN", "COMPLETED", "All data processing operations completed successfully")

cat("\n", paste(rep("=", 80), collapse=""), "\n")
cat("DATA PROCESSING SUMMARY\n")
cat(paste(rep("=", 80), collapse=""), "\n")
cat("Processing and filling phase completed successfully!\n")
cat("\nFinal datasets created:\n")
cat("- Main dataset: ", file.path(data_dir, "intermediate_domestic_data_files/aall_domestic_T_FND.rds"), "\n")
cat("- Insurance data: ", file.path(data_dir, "aall_F6.rds"), "\n")
cat("- Trade credits: ", file.path(data_dir, "aall_f81.rds"), "\n")
cat("- Other accounts: ", file.path(data_dir, "aall_f89.rds"), "\n")
cat("\nCheck the logs directory for detailed execution logs.\n")
cat("Total processing phases completed: 10\n")
cat(paste(rep("=", 80), collapse=""), "\n")

################################################################################
# End of Filling Script
