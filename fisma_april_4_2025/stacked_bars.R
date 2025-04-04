library(highcharter)
library(data.table)
library(dplyr)
library(htmlwidgets)

# Define years and create q4 periods
years <- 2013:2023
quarters <- paste0(years, "q4")

# Create a data table to store our data
exposure_data <- data.table()

# Process each quarter
for (quarter in quarters) {
  # Get values directly from exp_fisma for this quarter
  w0_value <- as.numeric(exp_fisma["W0", "F", quarter])
  w1_value <- as.numeric(exp_fisma["W1", "F", quarter])
  w2_value <- as.numeric(exp_fisma["W2", "F", quarter])
  
  # Add to data table - one row per area type per quarter
  exposure_data <- rbind(
    exposure_data,
    data.table(
      quarter = quarter,
      year = as.numeric(sub("q4", "", quarter)),
      area = "Extra-EA",  # W1
      value = w1_value
    ),
    data.table(
      quarter = quarter,
      year = as.numeric(sub("q4", "", quarter)),
      area = "Intra-EA",  # W2
      value = w2_value
    )
  )
}

# Calculate total for each quarter for percentage calculation
quarterly_totals <- exposure_data[, .(total = sum(value)), by = quarter]
exposure_data <- merge(exposure_data, quarterly_totals, by = "quarter")
exposure_data[, percentage := round(value / total * 100, 1)]

# Print data to verify
print(exposure_data)

# Create the chart
create_quarterly_exposure_chart <- function(data, title) {
  # Check if we have data
  if (nrow(data) == 0) {
    stop("No data available")
  }
  
  # Define the quarters (x-axis categories)
  quarters <- unique(data$quarter)
  
  # Set colors
  intra_ea_color <- "#0a5e9c"  # Darker blue
  extra_ea_color <- "#7fcdff"  # Lighter blue
  
  # Create separate data arrays for each series
  intra_ea_data <- numeric(length(quarters))
  extra_ea_data <- numeric(length(quarters))
  
  # Extract and store the years and percentages
  years_labels <- c()
  extra_ea_pct <- c()
  
  # Fill the data arrays
  for (i in 1:length(quarters)) {
    q <- quarters[i]
    
    # Extract year for x-axis labels
    years_labels[i] <- as.numeric(substr(q, 1, 4))
    
    # Get data for this quarter
    q_intra_ea <- data[quarter == q & area == "Intra-EA", value]
    q_extra_ea <- data[quarter == q & area == "Extra-EA", value]
    
    # Get percentage for Extra-EA
    q_extra_ea_pct <- data[quarter == q & area == "Extra-EA", percentage]
    extra_ea_pct[i] <- q_extra_ea_pct
    
    # Add to arrays (default to 0 if missing)
    intra_ea_data[i] <- ifelse(length(q_intra_ea) > 0, q_intra_ea, 0)
    extra_ea_data[i] <- ifelse(length(q_extra_ea) > 0, q_extra_ea, 0)
  }
  
  # Convert percentages to formatted strings
  pct_strings <- paste0(extra_ea_pct, "%")
  pct_js_array <- paste0("[", paste(shQuote(pct_strings), collapse = ", "), "]")
  
  # Create the chart with proper data arrays for each series
  chart <- highchart() %>%
    hc_chart(type = "column") %>%
    hc_title(text = title) %>%
    hc_xAxis(
      categories = years_labels,  # Use full year numbers
      title = list(text = "Year (Q4)"),
      labels = list(style = list(fontSize = "12px"))
    ) %>%
    hc_yAxis(
      title = list(text = "Thousand euro"),
      labels = list(format = "{value:,.0f}"),
      stackLabels = list(
        enabled = TRUE, 
        format = "{total:,.0f}",
        allowOverlap = TRUE,  # Force labels to show even if they overlap
        style = list(
          textOutline = "1px contrast"  # Make them more readable
        )
      )
    ) %>%
    hc_plotOptions(
      column = list(
        stacking = "normal",
        pointPadding = 0.1,  # Adjust this value as needed
        groupPadding = 0.2   # Adjust this value as needed
      )
    ) %>%
    hc_tooltip(
      formatter = JS("function() {
        return '<b>' + this.series.name + '</b><br/>' +
               'Year (Q4): ' + this.x + '<br/>' +
               'Value: ' + Highcharts.numberFormat(this.y, 0) + ' million (' + 
               Highcharts.numberFormat(this.y / this.point.stackTotal * 100, 1) + '%)<br/>' +
               'Total: ' + Highcharts.numberFormat(this.point.stackTotal, 0) + ' million';
      }")
    ) %>%
    hc_legend(enabled = TRUE)
  

  
  # 2. Extra-EA (top layer) with data labels for percentages
  chart <- chart %>%
    hc_add_series(
      name = "Extra-EA",
      data = extra_ea_data,
      color = extra_ea_color,
      dataLabels = list(
        enabled = TRUE,
        formatter = JS(paste0("function() {
          var percentages = ", pct_js_array, ";
          return percentages[this.point.index];
        }")),
        style = list(
          color = "white",
          fontSize = "11px",
          fontWeight = "bold",
          textOutline = "1px contrast"
        ),
        rotation = 0,
        align = 'center',
        verticalAlign = 'middle'
      )
    )
  
  # 1. Intra-EA (bottom layer)
  chart <- chart %>%
    hc_add_series(
      name = "Intra-EA",
      data = intra_ea_data,
      color = intra_ea_color
    )
  return(chart)
}

# Create and save the chart
exposure_chart <- create_quarterly_exposure_chart(
  exposure_data,
  "EU Households Financial Assets - Geographical Exposure"
)

# Display the chart
exposure_chart

# Save the chart to HTML file (optional)
saveWidget(exposure_chart, "Euro_Area_households.html", selfcontained = TRUE)

# Export as PNG using Highcharts built-in export functionality
exposure_chart <- exposure_chart %>%
  hc_exporting(
    enabled = TRUE,
    filename = "Euro_Area_Exposure_Chart",
    formAttributes = list(target = "_blank"),
    buttons = list(
      contextButton = list(
        menuItems = list("downloadPNG", "downloadJPEG", "downloadPDF", "downloadSVG")
      )
    )
  )

# Display chart with export button
exposure_chart
