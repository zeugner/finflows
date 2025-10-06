# EU27 Household Financial Instruments Sankey Diagram
# Breaking down financial instruments by counterpart area (intra-EU vs extra-EU)

library(MD3)
library(highcharter)

# Using the existing labels
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
  "S2" = "Extra-EU",
  "S1" = "Intra-EU"
)

# Create data for Sankey diagram
sankey_data <- data.frame(
  from = character(),
  to = character(),
  weight = numeric(),
  stringsAsFactors = FALSE
)

# Get instruments list
instruments <- c("F3", "F511", "F89", "F4", "F51M", "F52", "F6", "F2M", "F7", "F81")

# First level: From each instrument to counterpart area
for (instr in instruments) {
  # Add flow from instrument to Intra-EU (S1)
  s1_value <- fisma_sankey["S1", instr]
  sankey_data <- rbind(sankey_data, data.frame(
    from = instrument_labels[instr],
    to = "Intra-EU",
    weight = s1_value
  ))
  
  # Add flow from instrument to Extra-EU (S2)
  s2_value <- fisma_sankey["S2", instr]
  sankey_data <- rbind(sankey_data, data.frame(
    from = instrument_labels[instr],
    to = "Extra-EU", 
    weight = s2_value
  ))
}

# Create Sankey diagram
sankey <- highchart() %>%
  hc_chart(type = "sankey") %>%
  hc_add_series(
    data = list_parse(sankey_data),
    keys = c("from", "to", "weight"),
    name = "Asset Value"
  ) %>%
  hc_title(text = "EU27 Household Financial Instruments by Counterpart Area")

# Display the Sankey diagram
sankey