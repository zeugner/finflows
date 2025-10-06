# STACKED BAR CHARTS OF EU HOUSEHOLD EXPOSURES BY QUARTER - FIXED VERSION WITH INVERTED STACKING
library(MDecfin)       
library(data.table)    
library(dplyr)         
library(highcharter)   
library(htmlwidgets)  

# Area labels for better readability
area_labels <- c(
  "W2" = "Domestic",
  "D6" = "Extra-EU",
  "B6" = "Intra-EU",
  "UN" = "Unallocated"
)

# List of instruments to include (same as original code)
instruments <- c("F2M", "F3", "F4", "F511", "F51M", "F52", "F6", "F7", "F81", "F89")

# List of all EU countries (same as original code)
eu_countries <- c(
  "AT", "BE", "BG", "CY", "CZ", "DE", "DK", "EE", "ES", "FI", 
  "FR", "EL", "HR", "HU", "IE", "IT", "LT", "LU", "LV", 
  "MT", "NL", "PL", "PT", "RO", "SE", "SI", "SK"
)

# Function to extract value with all dimensions (reused from original code)
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

# New function to collect data by quarter for all EU countries combined
collect_quarterly_exposure_data <- function(quarters) {
  # Create data table to store results
  quarterly_data <- data.table()
  
  # Process each quarter
  for (quarter in quarters) {
    cat("Processing quarter:", quarter, "\n")
    
    # Initialize aggregates for this quarter
    domestic_total <- 0
    intra_eu_total <- 0
    extra_eu_total <- 0
    
    # Process each country
    for (country in eu_countries) {
      # Process each instrument
      for (instrument in instruments) {
        # For assets: households (S1M) as reference sector
        
        # Get domestic assets - try with explicit W2 area
        domestic_value <- extract_value(
          instrument, country, "S1M", "S1", "LE", "_T", quarter, "W2"
        )
        
        # If domestic is 0, try without explicit W2
        if (domestic_value == 0) {
          domestic_value <- extract_value(
            instrument, country, "S1M", "S1", "LE", "_T", quarter, "W0"
          )
        }
        
        # Get total foreign assets (S2, all areas)
        foreign_total_value <- extract_value(
          instrument, country, "S1M", "S2", "LE", "_T", quarter, "W0"
        )
        
        # Get extra-EU assets (S2, extra-EU area)
        extra_eu_value <- extract_value(
          instrument, country, "S1M", "S2", "LE", "_T", quarter, "D6"
        )
        
        # Calculate intra-EU as foreign total minus extra-EU
        intra_eu_value <- max(0, foreign_total_value - extra_eu_value)
        
        # Add to quarterly totals
        domestic_total <- domestic_total + domestic_value
        intra_eu_total <- intra_eu_total + intra_eu_value
        extra_eu_total <- extra_eu_total + extra_eu_value
      }
    }
    
    # Debug output to check values
    cat("  Domestic:", domestic_total, "\n")
    cat("  Intra-EU:", intra_eu_total, "\n")
    cat("  Extra-EU:", extra_eu_total, "\n")
    
    # Add to quarterly data table
    quarterly_data <- rbind(quarterly_data, 
                            data.table(
                              quarter = quarter,
                              area = "Domestic",
                              value = domestic_total
                            ))
    
    quarterly_data <- rbind(quarterly_data, 
                            data.table(
                              quarter = quarter,
                              area = "Intra-EU",
                              value = intra_eu_total
                            ))
    
    quarterly_data <- rbind(quarterly_data, 
                            data.table(
                              quarter = quarter,
                              area = "Extra-EU",
                              value = extra_eu_total
                            ))
  }
  
  # Return collected data
  return(quarterly_data)
}

# Function to create stacked bar chart for quarterly exposure data with inverted stacking
create_quarterly_exposure_chart <- function(data, title) {
  # Check if we have data
  if (nrow(data) == 0) {
    stop("No data available")
  }
  
  # Ensure data is properly formatted as numeric
  data[, value := as.numeric(value)]
  
  # Calculate total for each quarter for percentage calculation
  quarterly_totals <- data[, .(total = sum(value)), by = quarter]
  data <- merge(data, quarterly_totals, by = "quarter")
  data[, percentage := value / total * 100]
  
  # Print summary of data for debugging
  cat("\nData summary for charting:\n")
  print(data[, .(quarter, area, value, total, percentage)])
  
  # Extract extra-EU percentages for data labels
  extra_eu_percentages <- data[area == "Extra-EU", .(quarter, percentage)]
  
  # Define the quarters (x-axis categories)
  quarters <- unique(data$quarter)
  
  # Set colors for each area
  domestic_color <- "#90caf9"  # Light blue
  intra_eu_color <- "#a5d6a7"  # Light green
  extra_eu_color <- "#ffcc80"  # Light orange
  
  # Create separate data arrays for each series
  # We need to ensure data is in the same order as quarters
  domestic_data <- numeric(length(quarters))
  intra_eu_data <- numeric(length(quarters))
  extra_eu_data <- numeric(length(quarters))
  
  # Fill the data arrays
  for (i in 1:length(quarters)) {
    q <- quarters[i]
    
    # Get data for this quarter
    q_domestic <- data[quarter == q & area == "Domestic", value]
    q_intra_eu <- data[quarter == q & area == "Intra-EU", value]
    q_extra_eu <- data[quarter == q & area == "Extra-EU", value]
    
    # Add to arrays (default to 0 if missing)
    domestic_data[i] <- ifelse(length(q_domestic) > 0, q_domestic, 0)
    intra_eu_data[i] <- ifelse(length(q_intra_eu) > 0, q_intra_eu, 0)
    extra_eu_data[i] <- ifelse(length(q_extra_eu) > 0, q_extra_eu, 0)
  }
  
  # Create the chart with proper data arrays for each series
  chart <- highchart() %>%
    hc_chart(type = "column") %>%
    hc_title(text = title) %>%
    hc_xAxis(
      categories = quarters,
      title = list(text = "Quarter"),
      labels = list(
        rotation = -45,
        style = list(fontSize = "10px")
      )
    ) %>%
    hc_yAxis(
      title = list(text = "Value (millions)"),
      stackLabels = list(enabled = TRUE, format = "{total:,.0f}")
    ) %>%
    hc_plotOptions(
      column = list(
        stacking = "normal"
      )
    ) %>%
    hc_tooltip(
      formatter = JS("function() {
        return '<b>' + this.series.name + '</b><br/>' +
               'Quarter: ' + this.x + '<br/>' +
               'Value: ' + Highcharts.numberFormat(this.y, 0) + ' million (' + 
               Highcharts.numberFormat(this.y / this.point.stackTotal * 100, 1) + '%)<br/>' +
               'Total: ' + Highcharts.numberFormat(this.point.stackTotal, 0) + ' million';
      }")
    ) %>%
    hc_legend(enabled = TRUE)
  
  # ADD THE SERIES IN STACKING ORDER - DOMESTIC AT BOTTOM, EXTRA-EU AT TOP
  # 1. Domestic (bottom layer)
  chart <- chart %>%
    hc_add_series(
      name = "Domestic",
      data = domestic_data,
      color = domestic_color
    )
  
  # 2. Intra-EU (middle layer)
  chart <- chart %>%
    hc_add_series(
      name = "Intra-EU",
      data = intra_eu_data,
      color = intra_eu_color
    )
  
  # 3. Extra-EU (top layer) with data labels for percentages
  chart <- chart %>%
    hc_add_series(
      name = "Extra-EU",
      data = extra_eu_data,
      color = extra_eu_color,
      dataLabels = list(
        enabled = TRUE,  # Changed from 'true' to TRUE (uppercase)
        inside = TRUE,   # Changed from 'true' to TRUE (uppercase)
        formatter = JS("function() {
        var pct = this.y / this.point.stackTotal * 100;
        // Show percentage for all data points
        return Math.round(pct) + '%';
      }"),
        style = list(
          color = "black",
          fontSize = "9px",
          fontWeight = "bold",
          textOutline = "1px white"
        ),
        rotation = 0,
        align = 'center',
        verticalAlign = 'middle'
      )
    )  
  return(chart)
}

# Define the quarters to analyze
start_year <- 2013
end_year <- 2023
quarters_to_analyze <- c()

for (year in start_year:end_year) {
  for (q in c("q1", "q2", "q3", "q4")) {
    quarters_to_analyze <- c(quarters_to_analyze, paste0(year, q))
  }
}

# Collect quarterly exposure data for assets
cat("\nCollecting quarterly exposure data for assets...\n")
quarterly_asset_data <- collect_quarterly_exposure_data(quarters_to_analyze)
cat("Data collection complete. Total records:", nrow(quarterly_asset_data), "\n")

# Debug: Print the collected data
print(quarterly_asset_data)

# Create and save assets chart
assets_chart <- create_quarterly_exposure_chart(
  quarterly_asset_data,
  "EU Household Financial Assets - Geographical Exposure by Quarter"
)
assets_html_file <- "EU_Household_Assets_Quarterly_Exposure.html"
saveWidget(assets_chart, assets_html_file, selfcontained = TRUE)
cat("Assets chart saved to", assets_html_file, "\n")

print("Quarterly exposure chart created successfully!")