# DEPENDENCY WHEEL VISUALIZATION FOR FINANCIAL FLOWS
# This code creates an interactive visualization showing the relationships between
# different sectors in terms of listed shares (F511) holdings in Austria
# Set data directory
data_dir <- if (exists("data_dir")) data_dir else "data"
# Load required libraries
library(MDecfin)       # For handling financial data
library(highcharter)   # For creating interactive visualizations
library(data.table)    # For efficient data manipulation

# Create sector label mapping
# This converts technical sector codes to more readable labels while keeping them concise
sector_labels <- c(
  "S11" = "Non-Fin Corp",     # Non-financial corporations
  "S124" = "Inv Funds",       # Investment funds
  "S12K" = "Banks",           # Monetary financial institutions
  "S12O" = "Other Fin",       # Other financial institutions
  "S12Q" = "Ins & Pens",      # Insurance corporations and pension funds
  "S13" = "Government",       # General government
  "S1M" = "HH & NPISH",       # Households and non-profit institutions
  "S2" = "RoW"         # Rest of the world
)

# Extract who-to-whom data for listed shares (F511) in Austria
# Parameters:
# - F511: Listed shares
# - AT: Austria
# - S11+S124+...: All relevant sectors
# - LE: Stock positions (not flows)
# - _T: Total (no breakdown)
# - y2022q4: Time period
f511a = aall[F511.AT.S11+S124+S12K+S12O+S12Q+S13+S1M+S2.S11+S124+S12K+S12O+S12Q+S13+S2.LE._T.y2022q4]

# Convert to data.table format for more efficient processing
f511a_dt <- as.data.table(f511a)

# Reshape data from wide to long format
# This transforms the data to make it suitable for visualization
f511a_long <- melt(
  f511a_dt[, .(REF_SECTOR, COUNTERPART_SECTOR, obs_value)], # Select relevant columns
  id.vars = c("REF_SECTOR", "COUNTERPART_SECTOR"),          # Columns to keep as is
  measure.vars = "obs_value",                               # Column to reshape
  variable.name = "Measure",                                # Name for measure type
  value.name = "Value"                                      # Name for values
)

# Debug print to track data transformation
print("Before filtering:")
print(nrow(f511a_long))

# Prepare data for visualization
# Filter out invalid data points and ensure data quality
dependency_data <- f511a_long[!is.na(Value) &                 # Remove missing values
                                Value > 0 &                       # Keep only positive flows
                                !is.na(REF_SECTOR) &             # Ensure sector info exists
                                !is.na(COUNTERPART_SECTOR)]      # Ensure counterpart info exists

print("After filtering:")
print(nrow(dependency_data))

# Transform sector codes to labels and structure data for the dependency wheel
dependency_data <- dependency_data[, .(
  from = sector_labels[REF_SECTOR],          # Sector holding the asset
  to = sector_labels[COUNTERPART_SECTOR],    # Sector issuing the asset
  weight = Value                             # Value of the holding
)]

# Final data quality check
print("Final data:")
print(head(dependency_data))
print("Number of valid connections:")
print(nrow(dependency_data))

# Create the interactive dependency wheel visualization
hw <- highchart() %>%
  # Set basic chart properties
  hc_chart(type = "dependencywheel") %>%
  # Add the data series with proper formatting
  hc_add_series(
    data = list_parse(dependency_data),    # Convert data to highcharter format
    keys = c("from", "to", "weight"),      # Specify data structure
    name = "Flow Value",                   # Series name
    nodeWidth = 20                         # Width of nodes in the wheel
  ) %>%
  # Add title and subtitle
  hc_title(text = "Listed Shares (F511) Flows Between Sectors - Austria") %>%
  hc_subtitle(text = "2022 Q4 Stock Positions") %>%
  # Set visualization size
  hc_size(height = 700) %>%
  # Configure interactive tooltip
  hc_tooltip(
    useHTML = TRUE,
    formatter = JS("function() {
           if (this.point.from && this.point.to && this.point.weight) {
               return '<b>' + this.point.from + '</b> → <b>' + 
                      this.point.to + '</b>: ' + 
                      Highcharts.numberFormat(this.point.weight, 0) + ' million';
           }
           return false;  // Hide tooltip for invalid data points
       }")
  ) %>%
  # Apply a clean, simple theme
  hc_add_theme(hc_theme_smpl())

# Save the visualization as a self-contained HTML file
# This can be opened in any web browser without needing R
htmlwidgets::saveWidget(hw, "F511_AT_sectors_wheel.html", selfcontained = TRUE)