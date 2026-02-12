# Interpolate quarterly financial data for sectors S1 and S2
# Based on sector S0 (total) and S2 data, where S1 = S0 - S2
interpolate_f51m <- function(assets_obj, liab_obj) {
  
  library(data.table)
  
  # Function that processes either assets or liabilities
  # sector_to_calc determines which sector column to use for calculations
  process_direction <- function(md3_obj, sector_to_calc) {
    
    # Convert input object to data.table format
    dt <- as.data.table(md3_obj)
    # Standardize column name to "value" if it's called "obs_value"
    if ("obs_value" %in% names(dt)) setnames(dt, "obs_value", "value")
    
    # Extract year and quarter from TIME column (format: "YYYYqQ")
    dt[, year := as.integer(substr(TIME, 1, 4))]
    dt[, quarter := as.integer(substr(TIME, 6, 6))]
    
    # Determine which columns to group by based on calculation direction
    # If calculating counterpart sector, group by reference area and sector
    # Otherwise, group by reference area and counterpart sector
    if (sector_to_calc == "COUNTERPART_SECTOR") {
      group_cols <- c("REF_AREA", "REF_SECTOR")
    } else {
      group_cols <- c("REF_AREA", "COUNTERPART_SECTOR")
    }
    
    # Split data into S0 (total economy) and S2 (rest of world) observations
    dt_s0 <- dt[get(sector_to_calc) == "S0"]
    dt_s2 <- dt[get(sector_to_calc) == "S2"]
    
    # Initialize result list with S0 data (which doesn't need interpolation)
    result_list <- list()
    result_list[[1]] <- dt_s0[, .(REF_AREA, REF_SECTOR, COUNTERPART_SECTOR, TIME, value)]
    
    # Get all unique combinations of grouping columns
    unique_groups <- unique(dt_s0[, ..group_cols])
    
    # Process each unique group separately
    for (i in 1:nrow(unique_groups)) {
      grp <- unique_groups[i]
      
      # Extract S0 and S2 data for this specific group
      s0_grp <- dt_s0[grp, on = group_cols]
      s2_grp <- dt_s2[grp, on = group_cols]
      
      # Skip if no S0 data for this group
      if (nrow(s0_grp) == 0) next
      
      # Extract Q4 (annual) values for both S0 and S2
      s0_q4 <- s0_grp[quarter == 4 & !is.na(value), .(year, value_s0 = value)]
      s2_q4 <- s2_grp[quarter == 4 & !is.na(value), .(year, value_s2 = value)]
      
      # Skip if no annual S0 data
      if (nrow(s0_q4) == 0) next
      
      # Merge S0 and S2 annual data, filling missing S2 values with 0
      annual <- merge(s0_q4, s2_q4, by = "year", all.x = TRUE)
      annual[is.na(value_s2), value_s2 := 0]
      
      # Calculate S1 (domestic economy) as residual: S1 = S0 - S2
      annual[, value_s1_q4 := value_s0 - value_s2]
      
      # Determine which sector is smaller in absolute terms
      # This determines which one to interpolate (the smaller one)
      annual[, smaller_is_s1 := abs(value_s1_q4) <= abs(value_s2)]
      
      # Need at least 2 years for interpolation
      if (nrow(annual) < 2) next
      
      # Create skeleton with all quarters for all years in the range
      all_years <- seq(min(annual$year), max(annual$year))
      qtr_skel <- CJ(year = all_years, quarter = 1:4)
      
      # Merge in actual S0 quarterly values
      s0_all <- s0_grp[!is.na(value), .(year, quarter, value_s0 = value)]
      qtr_skel <- merge(qtr_skel, s0_all, by = c("year", "quarter"), all.x = TRUE)
      
      # Add annual information (which sector is smaller, annual values)
      qtr_skel <- merge(qtr_skel, annual[, .(year, smaller_is_s1, value_s1_q4, value_s2)], 
                        by = "year", all.x = TRUE)
      
      # Calculate fractional year for interpolation (Q1=0, Q2=0.25, Q3=0.5, Q4=0.75)
      qtr_skel[, year_frac := year + (quarter - 1) / 4]
      
      # Initialize columns for interpolated values
      qtr_skel[, s1_interpolated := NA_real_]
      qtr_skel[, s2_interpolated := NA_real_]
      
      # Interpolate S1 for years where S1 is the smaller sector
      s1_to_interp <- annual[smaller_is_s1 == TRUE]
      if (nrow(s1_to_interp) >= 2) {
        # Linear interpolation using Q4 values (0.75 of year)
        s1_interp_vals <- approx(
          x = s1_to_interp$year + 0.75,  # Q4 is at 0.75 of the year
          y = s1_to_interp$value_s1_q4,
          xout = qtr_skel[year %in% s1_to_interp$year]$year_frac,
          method = "linear",
          rule = 2  # Use endpoint values for extrapolation
        )
        qtr_skel[year %in% s1_to_interp$year, s1_interpolated := s1_interp_vals$y]
      }
      
      # Interpolate S2 for years where S2 is the smaller sector
      s2_to_interp <- annual[smaller_is_s1 == FALSE]
      if (nrow(s2_to_interp) >= 2) {
        s2_interp_vals <- approx(
          x = s2_to_interp$year + 0.75,
          y = s2_to_interp$value_s2,
          xout = qtr_skel[year %in% s2_to_interp$year]$year_frac,
          method = "linear",
          rule = 2
        )
        qtr_skel[year %in% s2_to_interp$year, s2_interpolated := s2_interp_vals$y]
      }
      
      # Initialize final value columns
      qtr_skel[, final_s1 := NA_real_]
      qtr_skel[, final_s2 := NA_real_]
      
      # For years where S1 was interpolated, calculate S2 as residual
      qtr_skel[smaller_is_s1 == TRUE & !is.na(s1_interpolated) & !is.na(value_s0),
               `:=`(final_s1 = s1_interpolated, final_s2 = value_s0 - s1_interpolated)]
      
      # For years where S2 was interpolated, calculate S1 as residual
      qtr_skel[smaller_is_s1 == FALSE & !is.na(s2_interpolated) & !is.na(value_s0),
               `:=`(final_s2 = s2_interpolated, final_s1 = value_s0 - s2_interpolated)]
      
      # Recreate TIME column in "YYYYqQ" format
      qtr_skel[, TIME := paste0(year, "q", quarter)]
      
      # Add back the grouping columns to the skeleton
      for (col in group_cols) qtr_skel[, (col) := grp[[col]]]
      
      # Create output for S1 sector with proper column structure
      # Column assignment depends on which sector is being calculated
      s1_out <- qtr_skel[!is.na(final_s1), .(REF_AREA = get(group_cols[1]), 
                                             REF_SECTOR = if(sector_to_calc == "COUNTERPART_SECTOR") get(group_cols[2]) else "S1",
                                             COUNTERPART_SECTOR = if(sector_to_calc == "COUNTERPART_SECTOR") "S1" else get(group_cols[2]),
                                             TIME, 
                                             value = final_s1)]
      
      # Create output for S2 sector with proper column structure
      s2_out <- qtr_skel[!is.na(final_s2), .(REF_AREA = get(group_cols[1]),
                                             REF_SECTOR = if(sector_to_calc == "COUNTERPART_SECTOR") get(group_cols[2]) else "S2",
                                             COUNTERPART_SECTOR = if(sector_to_calc == "COUNTERPART_SECTOR") "S2" else get(group_cols[2]),
                                             TIME,
                                             value = final_s2)]
      
      # Add S1 and S2 results to the result list
      result_list[[length(result_list) + 1]] <- s1_out
      result_list[[length(result_list) + 1]] <- s2_out
    }
    
    # Combine all results into a single data.table
    result_dt <- rbindlist(result_list, fill = TRUE)
    
    # Ensure proper column order and consistent structure
    result_dt <- result_dt[, .(REF_AREA, REF_SECTOR, COUNTERPART_SECTOR, TIME, value)]
    
    # Remove any duplicate rows based on key columns
    key_cols <- c("REF_AREA", "REF_SECTOR", "COUNTERPART_SECTOR", "TIME")
    result_dt <- unique(result_dt, by = key_cols)
    
    return(result_dt)
  }
  
  # Process assets data (interpolating counterpart sectors)
  assets_dt <- process_direction(assets_obj, "COUNTERPART_SECTOR")
  # Process liabilities data (interpolating reference sectors)
  liab_dt <- process_direction(liab_obj, "REF_SECTOR")
  
  # Convert results back to md3 format
  assets_result <- as.md3(assets_dt)
  liab_result <- as.md3(liab_dt)
  
  # Return both assets and liabilities results as a list
  return(list(assets = assets_result, liabilities = liab_result))
}

# Execute the function with the provided data objects
result <- interpolate_f51m(interpol_assets, interpol_liab)