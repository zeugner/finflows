library(MDstats); library(MD3)

# Set data directory
setwd("V:/FinFlows/githubrepo/finflows")
data_dir= file.path(getwd(),'data')
if (!exists("data_dir")) data_dir = '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/data/'

aa=readRDS(file.path(data_dir,'aa_iip_cpis.rds')); gc()
ll=readRDS(file.path(data_dir,'ll_iip_cpis.rds')); gc()

#######################################################
# Check for negative stocks in _T and _X
#######################################################

###### assets - test with time= 2022q4

check_negative_stocks_aa <- function(md3obj, time = "2022q4",
                                  description = "Negative stock check") {
  cat(sprintf("\n\n=== %s (%s) ===\n", description, time))
  
  # Restrict to given TIME
  stocks_T <- md3obj[ , , , , "LE", "_T", , time]
  stocks_X <- md3obj[ , , , , "LE", "_X", , time]
  
  # Find negatives
  neg_T <- which(stocks_T < 0, arr.ind = TRUE)
  neg_X <- which(stocks_X < 0, arr.ind = TRUE)
  
  if (length(neg_T) == 0 && length(neg_X) == 0) {
    cat("no negative stock values found in _T or _X\n")
  } else {
    if (length(neg_T) > 0) {
      cat(sprintf("\nFound %d negative values in _T\n", nrow(neg_T)))
      for (i in seq_len(min(10, nrow(neg_T)))) {
        idx <- neg_T[i,]
        cat("INSTR:", dimnames(stocks_T)$INSTR[idx["INSTR"]],
            "| REF_AREA:", dimnames(stocks_T)$REF_AREA[idx["REF_AREA"]],
            "| REF_SECTOR:", dimnames(stocks_T)$REF_SECTOR[idx["REF_SECTOR"]],
            "| Value:", stocks_T[idx], "\n")
      }
    }
    if (length(neg_X) > 0) {
      cat(sprintf("\nFound %d negative values in _X\n", nrow(neg_X)))
      for (i in seq_len(min(10, nrow(neg_X)))) {
        idx <- neg_X[i,]
        cat("INSTR:", dimnames(stocks_X)$INSTR[idx["INSTR"]],
            "| REF_AREA:", dimnames(stocks_X)$REF_AREA[idx["REF_AREA"]],
            "| REF_SECTOR:", dimnames(stocks_X)$REF_SECTOR[idx["REF_SECTOR"]],
            "| Value:", stocks_X[idx], "\n")
      }
    }
    cat("\n(Showing only first 10 cases per block — extend loop to see more)\n")
  }
  
  invisible(list(stocks_T = stocks_T, stocks_X = stocks_X))
}

check_negative_stocks_aa(aa, time = "2022q4")


###### liabilities - test with time= 2022q4


check_negative_stocks_ll <- function(md3obj, time = "2022q4",
                                     description = "Negative stock check (ll)") {
  cat(sprintf("\n\n=== %s (%s) ===\n", description, time))
  
  # Restrict to given TIME
  stocks_T <- md3obj[ , , , , "LE", "_T", , time]
  stocks_X <- md3obj[ , , , , "LE", "_X", , time]
  
  # Find negatives
  neg_T <- which(stocks_T < 0, arr.ind = TRUE)
  neg_X <- which(stocks_X < 0, arr.ind = TRUE)
  
  if (length(neg_T) == 0 && length(neg_X) == 0) {
    cat("no negative stock values found in _T or _X\n")
  } else {
    if (length(neg_T) > 0) {
      cat(sprintf("\nFound %d negative values in _T\n", nrow(neg_T)))
      for (i in seq_len(min(10, nrow(neg_T)))) {
        idx <- neg_T[i,]
        cat("INSTR:", dimnames(stocks_T)$INSTR[idx["INSTR"]],
            "| REF_AREA:", dimnames(stocks_T)$REF_AREA[idx["REF_AREA"]],
            "| REF_SECTOR:", dimnames(stocks_T)$REF_SECTOR[idx["REF_SECTOR"]],
            "| Value:", stocks_T[idx], "\n")
      }
    }
    if (length(neg_X) > 0) {
      cat(sprintf("\nFound %d negative values in _X\n", nrow(neg_X)))
      for (i in seq_len(min(10, nrow(neg_X)))) {
        idx <- neg_X[i,]
        cat("INSTR:", dimnames(stocks_X)$INSTR[idx["INSTR"]],
            "| REF_AREA:", dimnames(stocks_X)$REF_AREA[idx["REF_AREA"]],
            "| REF_SECTOR:", dimnames(stocks_X)$REF_SECTOR[idx["REF_SECTOR"]],
            "| Value:", stocks_X[idx], "\n")
      }
    }
    cat("\n(Showing only first 10 cases per block — extend loop to see more)\n")
  }
  
  invisible(list(stocks_T = stocks_T, stocks_X = stocks_X))
}

check_negative_stocks_ll(ll, time = "2022q4")

#######################################################
#################### time is not limited here!!!
#######################################################
# check_negative_stocks <- function(md3obj, description = "Negative stock check") {
#   cat(sprintf("\n\n=== %s ===\n", description))
#   
#   # Slice out _T and _X counterpart totals
#   stocks_T <- md3obj[ , , , , "LE", "_T", , ]
#   stocks_X <- md3obj[ , , , , "LE", "_X", , ]
#   
#   # Find negatives
#   neg_T <- which(stocks_T < 0, arr.ind = TRUE)
#   neg_X <- which(stocks_X < 0, arr.ind = TRUE)
#   
#   if (length(neg_T) == 0 && length(neg_X) == 0) {
#     cat("no negative stock values found in _T or _X\n")
#   } else {
#     if (length(neg_T) > 0) {
#       cat(sprintf("\nFound %d negative values in _T\n", nrow(neg_T)))
#       for (i in seq_len(min(10, nrow(neg_T)))) {  # limit to 10 prints
#         idx <- neg_T[i,]
#         cat("INSTR:", dimnames(stocks_T)$INSTR[idx["INSTR"]],
#             "| REF_AREA:", dimnames(stocks_T)$REF_AREA[idx["REF_AREA"]],
#             "| REF_SECTOR:", dimnames(stocks_T)$REF_SECTOR[idx["REF_SECTOR"]],
#             "| TIME:", dimnames(stocks_T)$TIME[idx["TIME"]],
#             "| Value:", stocks_T[idx], "\n")
#       }
#     }
#     if (length(neg_X) > 0) {
#       cat(sprintf("\nFound %d negative values in _X\n", nrow(neg_X)))
#       for (i in seq_len(min(10, nrow(neg_X)))) {
#         idx <- neg_X[i,]
#         cat("INSTR:", dimnames(stocks_X)$INSTR[idx["INSTR"]],
#             "| REF_AREA:", dimnames(stocks_X)$REF_AREA[idx["REF_AREA"]],
#             "| REF_SECTOR:", dimnames(stocks_X)$REF_SECTOR[idx["REF_SECTOR"]],
#             "| TIME:", dimnames(stocks_X)$TIME[idx["TIME"]],
#             "| Value:", stocks_X[idx], "\n")
#       }
#     }
#     cat("\n(Showing only first 10 cases per block — extend loop to see more)\n")
#   }
#   
#   invisible(list(stocks_T = stocks_T, stocks_X = stocks_X))
# }

check_negative_stocks(aa, "Check for negative stocks in _T and _X")


#######################################################
# --- consistency check between stocks _T - _X 
#######################################################

# # Define the consistency check function
# check_nonnegative <- function(diff_values, description, components = NULL) {
#   cat(sprintf("\n\n=== %s - Nonnegative check ===\n", description))
#   
#   # Find negatives
#   negatives <- which(diff_values < 0)
#   
#   if (length(negatives) > 0) {
#     cat(sprintf("\nFound %d negative discrepancies\n", length(negatives)))
#     
#     countries <- dimnames(diff_values)$REF_AREA
#     
#     for (i in seq_along(negatives)) {
#       country <- countries[negatives[i]]
#       cat("\nCountry:", country, "\n")
#       cat("Negative difference:", format(diff_values[negatives[i]], digits=2), "\n")
#       
#       if (!is.null(components)) {
#         for (comp_name in names(components)) {
#           comp_value <- components[[comp_name]][negatives[i]]
#           cat(comp_name, ":", format(comp_value, digits=2), "\n")
#         }
#       }
#       cat("--------------------\n")
#     }
#   } else {
#     cat("\nNo negative discrepancies found\n")
#   }
#   
#   invisible(diff_values)
# }
# 
# time <- "2023q4"
# 
# for (instr in dimnames(aa)$INSTR) {
#   for (sector in dimnames(aa)$REF_SECTOR) {
#     totals   <- aa[instr, , sector, "S1", "LE", "_T", time, "WRL_REST"]
#     explicit <- aa[instr, , sector, "S1", "LE", "_X", time, "WRL_REST"]
#     diff     <- totals - explicit
#     
#     check_nonnegative(
#       diff,
#       sprintf("Instr %s / Sector %s (%s)", instr, sector, time),
#       components = list(
#         "Total (_T)" = totals,
#         "Explicit (_X)" = explicit
#       )
#     )
#   }
# }

