# Simplified Sankey Diagram for Household Financial Instruments

# Load required libraries
library(data.table)    # For efficient data manipulation
library(dplyr)         # For data manipulation
library(highcharter)   # For interactive visualizations
library(htmlwidgets)   # For saving HTML widgets

# Instrument labels
instrument_labels <- c(
  "F2" = "Deposits",
  "F3" = "Debt Securities",
  "F4" = "Loans",
  "F511" = "Listed Shares",
  "F51M" = "Unlisted Shares", 
  "F52" = "Investment Fund Shares",
  "F6" = "Insurance & Pension",
  "F81" = "Trade Credits",
  "F89" = "Other"
)

# Counterpart area labels
area_labels <- c(
  "W1" = "Extra-Euro Area",
  "W2" = "Intra-Euro Area"
)

# List of instruments to include
instruments <- c("F2", "F3", "F4", "F511", "F51M", "F52", "F6", "F81", "F89")

# Period to analyze
period <- "2023q4"

# Function to collect data for Sankey diagram
collect_sankey_data <- function(data_matrix) {
  # Create data tables to store results
  instrument_totals <- data.table()
  area_totals <- data.table()
  
  # Collect data for each instrument
  for (instrument in instruments) {
    # Extract values for W1 and W2
    extra_eu_value <- data_matrix["W1", instrument]
    intra_eu_value <- data_matrix["W2", instrument]
    total_value <- extra_eu_value + intra_eu_value
    
    # Add to instrument totals
    if (total_value > 0) {
      instrument_totals <- rbind(instrument_totals, 
                                 data.table(
                                   instrument = instrument,
                                   instrument_name = instrument_labels[instrument],
                                   total_value = total_value,
                                   extra_eu_value = extra_eu_value,
                                   intra_eu_value = intra_eu_value
                                 ))
      
      # Add area totals
      if (extra_eu_value > 0) {
        area_totals <- rbind(area_totals, 
                             data.table(
                               instrument = instrument,
                               instrument_name = instrument_labels[instrument],
                               area = "W1",
                               area_name = "Extra-Euro Area",
                               value = extra_eu_value
                             ))
      }
      
      if (intra_eu_value > 0) {
        area_totals <- rbind(area_totals, 
                             data.table(
                               instrument = instrument,
                               instrument_name = instrument_labels[instrument],
                               area = "W2",
                               area_name = "Intra-Euro Area",
                               value = intra_eu_value
                             ))
      }
    }
  }
  
  # Return collected data
  return(list(instrument_totals = instrument_totals, area_totals = area_totals))
}

# Function to create Sankey diagram
create_sankey <- function(data, title) {
  # Validate input
  if (!is.list(data) || 
      !all(c("instrument_totals", "area_totals") %in% names(data))) {
    stop("Invalid data structure for Sankey diagram")
  }
  
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
    from = "Households",
    to = instrument_name,
    weight = total_value
  )]
  
  # Second part: Financial Instruments → Region
  if (nrow(area_totals) > 0) {
    # Sort areas in desired order: Intra-Euro, Extra-Euro
    area_totals[, area_order := ifelse(area == "W2", 1, 2)]
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
  
  # Create node styling for better visualization
  nodes_list <- list(
    list(id = "Households", color = "#7cb5ec", column = 0)
  )
  
  # Add coloring for region-instrument nodes
  if (nrow(area_totals) > 0) {
    unique_regions <- area_totals[, .(region_instrument, area_name)]
    unique_regions <- unique(unique_regions)
    
    for (i in 1:nrow(unique_regions)) {
      region <- unique_regions[i, region_instrument]
      area <- unique_regions[i, area_name]
      
      # Choose color based on area
      if (area == "Intra-Euro Area") {
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
      name = "Financial Flows",
      nodes = nodes_list
    ) %>%
    hc_title(text = title) %>%
    hc_subtitle(text = paste(period, "- Total:", formatted_total, "thousand euro")) %>%
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

# Main execution function
create_sankey_visualization <- function(data, period = "2023q4") {
  tryCatch({
    # Extract data for the specific period
    period_matrix <- data[, , period]
    
    # Collect Sankey data
    sankey_data <- collect_sankey_data(period_matrix)
    
    # Create Sankey diagram
    sankey <- create_sankey(
      sankey_data, 
      "Euro Area Households Asset Holdings by Instrument and Geographical Counterpart"
    )
    
    # Save the visualization
    html_file <- paste0("Household_Financial_Instruments_Sankey_", period, ".html")
    saveWidget(sankey, html_file, selfcontained = TRUE)
    
    cat("Sankey diagram saved to", html_file, "\n")
    
    return(sankey)
  }, error = function(e) {
    cat("Error details:\n")
    cat("Error message:", conditionMessage(e), "\n")
    cat("Error call:", capture.output(conditionCall(e)), "\n")
    return(NULL)
  })
}

# Run the visualization creation
sankey_result <- create_sankey_visualization(exp_fisma)