# Whom-to-Whom Sankey Diagram
# Creditor sector → Debtor sector financial flows
# Uses the output CSV from the finflows pipeline

library(dplyr)
library(networkD3)
library(htmlwidgets)

# ── 1. Sector labels ──────────────────────────────────────────────────────────

sector_labels <- c(
  "S11"  = "NFCs",
  "S1M"  = "Households",
  "S13"  = "Government",
  "S12"  = "Financial sector",
  "S121" = "Central bank",
  "S12K" = "MFIs",        # Banks incl. central bank
  "S12T" = "Banks",       # MFIs excl. central bank
  "S124" = "Investment funds",
  "S12Q" = "Other fin. inst.",
  "S12O" = "Ins. & Pension Funds",
  "S2"   = "Rest of the world"
)

# Top-level sectors to show (exclude aggregates like S1, S12 to avoid double-counting)
CREDITOR_SECTORS <- c("S11", "S1M", "S13", "S12T", "S121", "S124", "S12Q", "S12O", "S2")
DEBTOR_SECTORS   <- c("S11", "S1M", "S13", "S12T", "S121", "S124", "S12Q", "S12O")

# ── 2. Parameters (adjust as needed) ─────────────────────────────────────────

TARGET_INSTR   <- "F3"          # instrument filter, e.g. "F3" = debt securities; use NULL for all
TARGET_AREA    <- "W2"          # W2 = domestic; WRL_REST = rest of world; NULL for all
TARGET_TIME    <- NULL          # e.g. "2024q4"; NULL = latest available
MIN_FLOW       <- 100           # hide flows below this threshold (same unit as obs_value)

# ── 3. Load data ──────────────────────────────────────────────────────────────

# Adjust path to your actual CSV file
data_file <- here::here("output", "aa_stocks_2022q4_selected_cp.csv")

raw <- read.csv(data_file, stringsAsFactors = FALSE, check.names = FALSE)

# Normalise column name for obs_value (handles "_.obs_value" or "obs_value")
obs_col <- grep("obs_value", names(raw), value = TRUE)[1]
names(raw)[names(raw) == obs_col] <- "obs_value"

# Parse numeric values (handle European decimal comma if present)
raw$obs_value <- as.numeric(gsub(",", ".", raw$obs_value))

# ── 4. Filter ─────────────────────────────────────────────────────────────────

df <- raw %>%
  filter(
    STO           == "LE",
    FUNCTIONAL_CAT == "_T",
    POS           == "A",                           # asset side = creditor perspective
    REF_SECTOR    %in% CREDITOR_SECTORS,
    COUNTERPART_SECTOR %in% DEBTOR_SECTORS,
    !is.na(obs_value),
    obs_value     > 0
  )

if (!is.null(TARGET_INSTR)) df <- df %>% filter(INSTR == TARGET_INSTR)
if (!is.null(TARGET_AREA))  df <- df %>% filter(COUNTERPART_AREA == TARGET_AREA)

# If no time filter, keep the latest period
if (!is.null(TARGET_TIME)) {
  df <- df %>% filter(TIME == TARGET_TIME)
} else {
  latest <- max(df$TIME)
  df     <- df %>% filter(TIME == latest)
  message("Using latest period: ", latest)
}

# ── 5. Aggregate ──────────────────────────────────────────────────────────────

flows <- df %>%
  group_by(REF_SECTOR, COUNTERPART_SECTOR) %>%
  summarise(value = sum(obs_value, na.rm = TRUE), .groups = "drop") %>%
  filter(value >= MIN_FLOW) %>%
  mutate(
    creditor = paste0("Creditor: ", sector_labels[REF_SECTOR]),
    debtor   = paste0("Debtor: ",   sector_labels[COUNTERPART_SECTOR])
  )

if (nrow(flows) == 0) stop("No flows after filtering. Check your filter parameters.")

# ── 6. Build networkD3 node/link tables ───────────────────────────────────────

nodes <- data.frame(
  name = unique(c(flows$creditor, flows$debtor)),
  stringsAsFactors = FALSE
)

links <- flows %>%
  transmute(
    source = match(creditor, nodes$name) - 1L,
    target = match(debtor,   nodes$name) - 1L,
    value  = value
  )

# ── 7. Colour palette ─────────────────────────────────────────────────────────

n_nodes <- nrow(nodes)
# Creditor nodes (left) get blue shades, debtor nodes (right) get orange shades
n_creditors <- length(unique(flows$creditor))
n_debtors   <- length(unique(flows$debtor))

colours <- c(
  colorRampPalette(c("#1f77b4", "#aec7e8"))(n_creditors),
  colorRampPalette(c("#e6550d", "#fdae6b"))(n_debtors)
)
colour_str <- paste0('d3.scaleOrdinal().range([',
  paste0('"', colours, '"', collapse = ","), '])')

# ── 8. Draw Sankey ────────────────────────────────────────────────────────────

title_text <- paste0(
  "Whom-to-Whom: ",
  ifelse(!is.null(TARGET_INSTR), TARGET_INSTR, "All instruments"),
  " | ",
  ifelse(!is.null(TARGET_AREA), TARGET_AREA, "All areas"),
  " | ",
  ifelse(!is.null(TARGET_TIME), TARGET_TIME, latest)
)

p <- sankeyNetwork(
  Links       = links,
  Nodes       = nodes,
  Source      = "source",
  Target      = "target",
  Value       = "value",
  NodeID      = "name",
  colourScale = JS(colour_str),
  fontSize    = 13,
  nodeWidth   = 20,
  nodePadding = 12,
  sinksRight  = TRUE,
  height      = 600,
  width       = 900
)

# Add title via htmlwidgets
p <- htmlwidgets::prependContent(
  p,
  htmltools::tags$h3(title_text, style = "font-family:sans-serif; margin:8px 0 4px 20px;")
)

p   # display in RStudio Viewer / browser

# ── 9. Export ─────────────────────────────────────────────────────────────────

out_path <- here::here("output", paste0("sankey_whom_to_whom_",
  gsub("[^A-Za-z0-9]", "_", title_text), ".html"))
saveWidget(p, file = out_path, selfcontained = TRUE)
message("Saved: ", out_path)
