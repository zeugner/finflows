# COUNTRY-LEVEL SANKEY DIAGRAMS FOR ALL EU COUNTRIES
# AND MODIFIED EU AGGREGATE SANKEY DIAGRAM

# Load required libraries
library(MDecfin)       # For handling financial data
library(data.table)    # For efficient data manipulation
library(dplyr)         # For data manipulation
library(highcharter)   # For interactive visualizations
library(htmlwidgets)   # For saving HTML widgets

# Create instrument and area label mappings for better readability
instrument_labels <- c(
  "F2M" = "Deposits",
  "F3" = "Debt Securities",
  "F4" = "Loans",
  "F511" = "Listed Shares",
  "F51M" = "Unlisted Shares",
  "F52" = "Investment Fund Shares",
  "F6" = "Insurance & Pension",
  "F7" = "Financial Derivatives",
  "F81" = "Trade Credits",
  "F89" = "Other"
)

# Area labels
area_labels <- c(
  "W2" = "Domestic",
  "D6" = "Extra-EU",
  "B6" = "Intra-EU"
)

# List of instruments to include
instruments <- c("F2M", "F3", "F4", "F511", "F51M", "F52", "F6", "F7", "F81", "F89")

# List of all EU countries
eu_countries <- c(
  "AT", "BE", "BG", "CY", "CZ", "DE", "DK", "EE", "ES", "FI", 
  "FR", "EL", "HR", "HU", "IE", "IT", "LT", "LU", "LV", 
  "MT", "NL", "PL", "PT", "RO", "SE", "SI", "SK"
)

# Country names for pretty labels
country_names <- c(
  "AT" = "Austria",
  "BE" = "Belgium",
  "BG" = "Bulgaria",
  "CY" = "Cyprus",
  "CZ" = "Czech Republic",
  "DE" = "Germany", 
  "DK" = "Denmark",
  "EE" = "Estonia",
  "ES" = "Spain",
  "FI" = "Finland",
  "FR" = "France",
  "EL" = "Greece",
  "HR" = "Croatia",
  "HU" = "Hungary",
  "IE" = "Ireland",
  "IT" = "Italy",
  "LT" = "Lithuania", 
  "LU" = "Luxembourg",
  "LV" = "Latvia",
  "MT" = "Malta",
  "NL" = "Netherlands",
  "PL" = "Poland",
  "PT" = "Portugal",
  "RO" = "Romania",
  "SE" = "Sweden",
  "SI" = "Slovenia",
  "SK" = "Slovakia"
)

# Period to analyze
period <- "2022q4"

# Function to extract value with all dimensions
extract_value <- function(instr, ref_area, ref_sector, counterpart_sector, sto, func_cat, time_period, counterpart_area) {
  # Build the query
  query <- paste0(
    instr, ".",
    ref_area, ".",
    ref_sector, ".",
    counterpart_sector, ".",
    sto, ".",
    func_cat, ".",
    time_period, ".",
    counterpart_area
  )
  
  # Try to get data
  tryCatch({
    data <- aall[query]
    
    # Extract value if successful
    if (length(data) > 0 && !is.na(data[1])) {
      return(data[1])
    } else {
      return(0)
    }
  }, error = function(e) {
    # Silent error handling
    return(0)
  })
}

# Function to collect data for a single country
collect_country_sankey_data <- function(country, asset_or_liability = "asset", period = "2022q4") {
  # Create data tables to store results
  instrument_totals <- data.table()
  area_totals <- data.table()
  
  # Collect data for each instrument
  for (instrument in instruments) {
    if (asset_or_liability == "asset") {
      # For assets: households (S1M) as reference sector
      
      # Get total assets (all areas)
      total_value <- extract_value(
        instrument, country, "S1M", "S0", "LE", "_T", period, "W0"
      )
      
      # Get domestic assets - try with explicit W2 area
      domestic_value <- extract_value(
        instrument, country, "S1M", "S1", "LE", "_T", period, "W2"
      )
      
      # If domestic is 0, try without explicit W2
      if (domestic_value == 0) {
        domestic_value <- extract_value(
          instrument, country, "S1M", "S1", "LE", "_T", period, "W0"
        )
      }
      
      # Get total foreign assets (S2, all areas)
      foreign_total_value <- extract_value(
        instrument, country, "S1M", "S2", "LE", "_T", period, "W0"
      )
      
      # Get extra-EU assets (S2, extra-EU area)
      extra_eu_value <- extract_value(
        instrument, country, "S1M", "S2", "LE", "_T", period, "D6"
      )
      
      # Calculate intra-EU as foreign total minus extra-EU
      intra_eu_value <- max(0, foreign_total_value - extra_eu_value)
      
    } else {
      # For liabilities: households (S1M) as counterpart sector
      
      # Get total liabilities (all areas)
      total_value <- extract_value(
        instrument, country, "S0", "S1M", "LE", "_T", period, "W0"
      )
      
      # Get domestic liabilities - try with explicit W2 area
      domestic_value <- extract_value(
        instrument, country, "S1", "S1M", "LE", "_T", period, "W2"
      )
      
      # If domestic is 0, try without explicit W2
      if (domestic_value == 0) {
        domestic_value <- extract_value(
          instrument, country, "S1", "S1M", "LE", "_T", period, "W0"
        )
      }
      
      # Get total foreign liabilities (S2, all areas)
      foreign_total_value <- extract_value(
        instrument, country, "S2", "S1M", "LE", "_T", period, "W0"
      )
      
      # Get extra-EU liabilities (S2, extra-EU area)
      extra_eu_value <- extract_value(
        instrument, country, "S2", "S1M", "LE", "_T", period, "D6"
      )
      
      # Calculate intra-EU as foreign total minus extra-EU
      intra_eu_value <- max(0, foreign_total_value - extra_eu_value)
    }
    
    # Add to instrument totals if there's any value
    if (total_value > 0) {
      # Calculate the sum of allocated values by area
      sum_allocated <- domestic_value + extra_eu_value + intra_eu_value
      
      # If there's a significant gap, allocate unallocated portion to domestic
      if (sum_allocated < total_value * 0.9) {  # Less than 90% allocated
        unallocated <- total_value - sum_allocated
        cat("Country:", country, "Instrument:", instrument, "has", unallocated, 
            "unallocated out of", total_value, "\n")
        cat("  - Allocating unallocated portion to domestic\n")
        domestic_value <- domestic_value + unallocated
      }
      
      instrument_totals <- rbind(instrument_totals, 
                                 data.table(
                                   instrument = instrument,
                                   instrument_name = instrument_labels[instrument],
                                   total_value = total_value,
                                   domestic_value = domestic_value,
                                   extra_eu_value = extra_eu_value,
                                   intra_eu_value = intra_eu_value
                                 ))
      
      # Add to area totals
      # Add domestic flow
      if (domestic_value > 0) {
        area_totals <- rbind(area_totals, 
                             data.table(
                               instrument = instrument,
                               instrument_name = instrument_labels[instrument],
                               area = "W2",
                               area_name = "Domestic",
                               value = domestic_value
                             ))
      }
      
      # Add intra-EU flow
      if (intra_eu_value > 0) {
        area_totals <- rbind(area_totals, 
                             data.table(
                               instrument = instrument,
                               instrument_name = instrument_labels[instrument],
                               area = "B6",
                               area_name = "Intra-EU",
                               value = intra_eu_value
                             ))
      }
      
      # Add extra-EU flow
      if (extra_eu_value > 0) {
        area_totals <- rbind(area_totals, 
                             data.table(
                               instrument = instrument,
                               instrument_name = instrument_labels[instrument],
                               area = "D6",
                               area_name = "Extra-EU",
                               value = extra_eu_value
                             ))
      }
    }
  }
  
  # Return collected data
  return(list(instrument_totals = instrument_totals, area_totals = area_totals))
}

# Function to create country-level Sankey diagram
create_country_sankey <- function(data, country, title, type = "asset") {
  # Extract the data components
  instrument_totals <- data$instrument_totals
  area_totals <- data$area_totals
  
  # Check if we have data
  if (nrow(instrument_totals) == 0) {
    stop("No instrument data available")
  }
  
  # Create Sankey data
  # First part: Households → Financial Instruments
  sankey_data1 <- instrument_totals[, .(
    from = ifelse(type == "asset", 
                  paste0(country_names[country], " Households"), 
                  paste0(country_names[country], " Households (Liabilities)")),
    to = instrument_name,
    weight = total_value
  )]
  
  # Second part: Financial Instruments → Region-Instrument
  if (nrow(area_totals) > 0) {
    # Sort areas in desired order: Domestic, Intra-EU, Extra-EU
    area_totals[, area_order := ifelse(area == "W2", 1, 
                                       ifelse(area == "B6", 2, 3))]
    area_totals <- area_totals[order(area_order)]
    
    # Create area-first naming for the nodes
    area_totals[, region_instrument := paste0(area_name, " - ", instrument_name)]
    
    sankey_data2 <- area_totals[, .(
      from = instrument_name,
      to = region_instrument,
      weight = value
    )]
    
    # Combine the data
    sankey_data <- rbind(sankey_data1, sankey_data2)
  } else {
    # If no area breakdown data, just use the first level
    sankey_data <- sankey_data1
  }
  
  # Calculate total value for the subtitle
  total_value <- sum(sankey_data1$weight)
  formatted_total <- format(round(total_value), big.mark = ",")
  
  # Node color
  node_color <- ifelse(type == "asset", "#7cb5ec", "#E57373")
  
  # Create node styling for better visualization
  nodes_list <- list(
    list(id = ifelse(type == "asset", 
                     paste0(country_names[country], " Households"), 
                     paste0(country_names[country], " Households (Liabilities)")), 
         color = node_color, 
         column = 0)
  )
  
  # Add coloring for region-instrument nodes
  if (nrow(area_totals) > 0) {
    unique_regions <- area_totals[, .(region_instrument, area_name)]
    unique_regions <- unique(unique_regions)
    
    for (i in 1:nrow(unique_regions)) {
      region <- unique_regions[i, region_instrument]
      area <- unique_regions[i, area_name]
      
      # Choose color based on area
      if (area == "Domestic") {
        color <- "#90caf9"  # Light blue
      } else if (area == "Intra-EU") {
        color <- "#a5d6a7"  # Light green
      } else {
        color <- "#ffcc80"  # Light orange
      }
      
      nodes_list <- c(nodes_list, list(list(id = region, color = color)))
    }
  }
  
  # Create the Sankey diagram
  sankey <- highchart() %>%
    hc_chart(type = "sankey") %>%
    hc_add_series(
      data = list_parse(sankey_data),
      keys = c("from", "to", "weight"),
      name = ifelse(type == "asset", "Asset Value", "Liability Value"),
      nodes = nodes_list
    ) %>%
    hc_title(text = title) %>%
    hc_subtitle(text = paste(period, "- Total:", formatted_total, "million")) %>%
    hc_tooltip(
      nodeFormat = '{point.name}: {point.sum:,.0f} million',
      formatter = JS("function() {
        return '<b>' + this.point.from + '</b> → <b>' + 
               this.point.to + '</b>: ' + 
               Highcharts.numberFormat(this.point.weight, 0) + ' million (' + 
               Highcharts.numberFormat(this.point.weight/this.point.from.sum*100, 1) + '%)';
      }")
    ) %>%
    hc_size(height = 800) %>%
    hc_add_theme(hc_theme_smpl())
  
  return(sankey)
}

# Function to collect data for EU aggregate with only intra-EU and extra-EU split
collect_eu_aggregate_sankey_data <- function(asset_or_liability = "asset", period = "2022q4") {
  # Create data tables to store results
  instrument_totals <- data.table()
  area_totals <- data.table()
  
  # Collect data for each instrument
  for (instrument in instruments) {
    # Initialize values for EU aggregation
    total_eu_value <- 0
    intra_eu_value <- 0 
    extra_eu_value <- 0
    
    # Collect data for each country and aggregate
    for (country in eu_countries) {
      if (asset_or_liability == "asset") {
        # For assets: households (S1M) as reference sector
        
        # Get total assets (all areas)
        total_value <- extract_value(
          instrument, country, "S1M", "S0", "LE", "_T", period, "W0"
        )
        
        # Get domestic assets - try with explicit W2 area
        domestic_value <- extract_value(
          instrument, country, "S1M", "S1", "LE", "_T", period, "W2"
        )
        
        # If domestic is 0, try without explicit W2
        if (domestic_value == 0) {
          domestic_value <- extract_value(
            instrument, country, "S1M", "S1", "LE", "_T", period, "W0"
          )
        }
        
        # Get total foreign assets (S2, all areas)
        foreign_total_value <- extract_value(
          instrument, country, "S1M", "S2", "LE", "_T", period, "W0"
        )
        
        # Get extra-EU assets (S2, extra-EU area)
        extra_eu_value_country <- extract_value(
          instrument, country, "S1M", "S2", "LE", "_T", period, "D6"
        )
        
        # Calculate intra-EU as foreign total minus extra-EU
        intra_eu_value_country <- max(0, foreign_total_value - extra_eu_value_country)
        
        # For EU aggregate, domestic holdings go to intra-EU
        intra_eu_value_country <- intra_eu_value_country + domestic_value
        
      } else {
        # For liabilities: households (S1M) as counterpart sector
        
        # Get total liabilities (all areas)
        total_value <- extract_value(
          instrument, country, "S0", "S1M", "LE", "_T", period, "W0"
        )
        
        # Get domestic liabilities - try with explicit W2 area
        domestic_value <- extract_value(
          instrument, country, "S1", "S1M", "LE", "_T", period, "W2"
        )
        
        # If domestic is 0, try without explicit W2
        if (domestic_value == 0) {
          domestic_value <- extract_value(
            instrument, country, "S1", "S1M", "LE", "_T", period, "W0"
          )
        }
        
        # Get total foreign liabilities (S2, all areas)
        foreign_total_value <- extract_value(
          instrument, country, "S2", "S1M", "LE", "_T", period, "W0"
        )
        
        # Get extra-EU liabilities (S2, extra-EU area)
        extra_eu_value_country <- extract_value(
          instrument, country, "S2", "S1M", "LE", "_T", period, "D6"
        )
        
        # Calculate intra-EU as foreign total minus extra-EU
        intra_eu_value_country <- max(0, foreign_total_value - extra_eu_value_country)
        
        # For EU aggregate, domestic holdings go to intra-EU
        intra_eu_value_country <- intra_eu_value_country + domestic_value
      }
      
      # Add to EU totals
      total_eu_value <- total_eu_value + total_value
      extra_eu_value <- extra_eu_value + extra_eu_value_country
      intra_eu_value <- intra_eu_value + intra_eu_value_country
    }
    
    # Add to instrument totals if there's any value
    if (total_eu_value > 0) {
      # Calculate the sum of allocated values by area
      sum_allocated <- intra_eu_value + extra_eu_value
      
      # If there's a significant gap, allocate unallocated portion proportionally
      if (sum_allocated < total_eu_value * 0.9) {  # Less than 90% allocated
        unallocated <- total_eu_value - sum_allocated
        cat("Instrument", instrument, "has", unallocated, "unallocated out of", total_eu_value, "\n")
        
        # Allocate unallocated portion to intra-EU (since domestic is now part of intra-EU)
        intra_eu_value <- intra_eu_value + unallocated
      }
      
      instrument_totals <- rbind(instrument_totals, 
                                 data.table(
                                   instrument = instrument,
                                   instrument_name = instrument_labels[instrument],
                                   total_value = total_eu_value,
                                   intra_eu_value = intra_eu_value,
                                   extra_eu_value = extra_eu_value
                                 ))
      
      # Add to area totals - now just intra-EU and extra-EU
      # Add intra-EU flow
      if (intra_eu_value > 0) {
        area_totals <- rbind(area_totals, 
                             data.table(
                               instrument = instrument,
                               instrument_name = instrument_labels[instrument],
                               area = "B6",
                               area_name = "Intra-EU",
                               value = intra_eu_value
                             ))
      }
      
      # Add extra-EU flow
      if (extra_eu_value > 0) {
        area_totals <- rbind(area_totals, 
                             data.table(
                               instrument = instrument,
                               instrument_name = instrument_labels[instrument],
                               area = "D6",
                               area_name = "Extra-EU",
                               value = extra_eu_value
                             ))
      }
    }
  }
  
  # Return collected data
  return(list(instrument_totals = instrument_totals, area_totals = area_totals))
}

# Function to create EU aggregate Sankey diagram
create_eu_aggregate_sankey <- function(data, title, type = "asset") {
  # Extract the data components
  instrument_totals <- data$instrument_totals
  area_totals <- data$area_totals
  
  # Check if we have data
  if (nrow(instrument_totals) == 0) {
    stop("No instrument data available")
  }
  
  # Create Sankey data
  # First part: Households → Financial Instruments
  sankey_data1 <- instrument_totals[, .(
    from = ifelse(type == "asset", "EU Households", "EU Households (Liabilities)"),
    to = instrument_name,
    weight = total_value
  )]
  
  # Second part: Financial Instruments → Region-Instrument
  if (nrow(area_totals) > 0) {
    # Sort areas in desired order: Intra-EU, Extra-EU
    area_totals[, area_order := ifelse(area == "B6", 1, 2)]
    area_totals <- area_totals[order(area_order)]
    
    # Create area-first naming for the nodes
    area_totals[, region_instrument := paste0(area_name, " - ", instrument_name)]
    
    sankey_data2 <- area_totals[, .(
      from = instrument_name,
      to = region_instrument,
      weight = value
    )]
    
    # Combine the data
    sankey_data <- rbind(sankey_data1, sankey_data2)
  } else {
    # If no area breakdown data, just use the first level
    sankey_data <- sankey_data1
  }
  
  # Calculate total value for the subtitle
  total_value <- sum(sankey_data1$weight)
  formatted_total <- format(round(total_value), big.mark = ",")
  
  # Node color
  node_color <- ifelse(type == "asset", "#7cb5ec", "#E57373")
  
  # Create node styling for better visualization
  nodes_list <- list(
    list(id = ifelse(type == "asset", "EU Households", "EU Households (Liabilities)"), 
         color = node_color, 
         column = 0)
  )
  
  # Add coloring for region-instrument nodes
  if (nrow(area_totals) > 0) {
    unique_regions <- area_totals[, .(region_instrument, area_name)]
    unique_regions <- unique(unique_regions)
    
    for (i in 1:nrow(unique_regions)) {
      region <- unique_regions[i, region_instrument]
      area <- unique_regions[i, area_name]
      
      # Choose color based on area
      if (area == "Intra-EU") {
        color <- "#a5d6a7"  # Light green
      } else {
        color <- "#ffcc80"  # Light orange
      }
      
      nodes_list <- c(nodes_list, list(list(id = region, color = color)))
    }
  }
  
  # Create the Sankey diagram
  sankey <- highchart() %>%
    hc_chart(type = "sankey") %>%
    hc_add_series(
      data = list_parse(sankey_data),
      keys = c("from", "to", "weight"),
      name = ifelse(type == "asset", "Asset Value", "Liability Value"),
      nodes = nodes_list
    ) %>%
    hc_title(text = title) %>%
    hc_subtitle(text = paste(period, "- Total:", formatted_total, "million")) %>%
    hc_tooltip(
      nodeFormat = '{point.name}: {point.sum:,.0f} million',
      formatter = JS("function() {
        return '<b>' + this.point.from + '</b> → <b>' + 
               this.point.to + '</b>: ' + 
               Highcharts.numberFormat(this.point.weight, 0) + ' million (' + 
               Highcharts.numberFormat(this.point.weight/this.point.from.sum*100, 1) + '%)';
      }")
    ) %>%
    hc_size(height = 800) %>%
    hc_add_theme(hc_theme_smpl())
  
  return(sankey)
}

# Process all EU countries
for (country in eu_countries) {
  # For Assets
  tryCatch({
    cat("\nCreating Sankey diagram for", country_names[country], "assets...\n")
    country_assets_data <- collect_country_sankey_data(country, "asset", period)
    
    # Print summary of the data collected
    cat("Collected data for", nrow(country_assets_data$instrument_totals), "instruments\n")
    cat("Collected", nrow(country_assets_data$area_totals), "area flows\n")
    
    country_assets_sankey <- create_country_sankey(
      country_assets_data, 
      country,
      paste(country_names[country], "Household Financial Assets - Geographical Breakdown"),
      "asset"
    )
    
    # Save the visualization
    assets_html_file <- paste0(country, "_Household_Assets_Sankey_", period, ".html")
    saveWidget(country_assets_sankey, assets_html_file, selfcontained = TRUE)
    
    cat("Asset Sankey diagram saved to", assets_html_file, "\n")
  }, error = function(e) {
    cat("Error creating asset Sankey for", country, ":", conditionMessage(e), "\n")
  })
  
  # For Liabilities
  tryCatch({
    cat("\nCreating Sankey diagram for", country_names[country], "liabilities...\n")
    country_liabilities_data <- collect_country_sankey_data(country, "liability", period)
    
    # Print summary of the data collected
    cat("Collected data for", nrow(country_liabilities_data$instrument_totals), "instruments\n")
    cat("Collected", nrow(country_liabilities_data$area_totals), "area flows\n")
    
    country_liabilities_sankey <- create_country_sankey(
      country_liabilities_data, 
      country,
      paste(country_names[country], "Household Financial Liabilities - Geographical Breakdown"),
      "liability"
    )
    
    # Save the visualization
    liabilities_html_file <- paste0(country, "_Household_Liabilities_Sankey_", period, ".html")
    saveWidget(country_liabilities_sankey, liabilities_html_file, selfcontained = TRUE)
    
    cat("Liabilities Sankey diagram saved to", liabilities_html_file, "\n")
  }, error = function(e) {
    cat("Error creating liabilities Sankey for", country, ":", conditionMessage(e), "\n")
  })
}

# Create EU aggregate Sankey diagrams
# For Assets
tryCatch({
  cat("\nCreating EU aggregate Sankey diagram for assets...\n")
  eu_assets_data <- collect_eu_aggregate_sankey_data("asset", period)
  
  # Print summary of the data collected
  cat("Collected data for", nrow(eu_assets_data$instrument_totals), "instruments\n")
  cat("Collected", nrow(eu_assets_data$area_totals), "area flows\n")
  
  eu_assets_sankey <- create_eu_aggregate_sankey(
    eu_assets_data, 
    "EU Household Financial Assets - Intra-EU vs. Extra-EU Breakdown",
    "asset"
  )
  
  # Save the visualization
  assets_html_file <- paste0("EU_Aggregate_Assets_Sankey_", period, ".html")
  saveWidget(eu_assets_sankey, assets_html_file, selfcontained = TRUE)
  
  cat("EU aggregate asset Sankey diagram saved to", assets_html_file, "\n")
}, error = function(e) {
  cat("Error creating EU aggregate asset Sankey:", conditionMessage(e), "\n")
})

# For Liabilities
tryCatch({
  cat("\nCreating EU aggregate Sankey diagram for liabilities...\n")
  eu_liabilities_data <- collect_eu_aggregate_sankey_data("liability", period)
  
  # Print summary of the data collected
  cat("Collected data for", nrow(eu_liabilities_data$instrument_totals), "instruments\n")
  cat("Collected", nrow(eu_liabilities_data$area_totals), "area flows\n")
  
  eu_liabilities_sankey <- create_eu_aggregate_sankey(
    eu_liabilities_data, 
    "EU Household Financial Liabilities - Intra-EU vs. Extra-EU Breakdown",
    "liability"
  )
  
  # Save the visualization
  liabilities_html_file <- paste0("EU_Aggregate_Liabilities_Sankey_", period, ".html")
  saveWidget(eu_liabilities_sankey, liabilities_html_file, selfcontained = TRUE)
  
  cat("EU aggregate liability Sankey diagram saved to", liabilities_html_file, "\n")
}, error = function(e) {
  cat("Error creating EU aggregate liability Sankey:", conditionMessage(e), "\n")
})

print("\nAll Sankey diagrams created successfully!")