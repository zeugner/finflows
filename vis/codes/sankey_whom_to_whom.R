# Whom-to-Whom Financial Flows — Sankey Diagram
# Creditor sector (left) → Debtor sector × area (right)
# Follows the S1M Sankey patterns: MDstats RDS + Highcharter

library(MDstats)
library(dplyr)
library(highcharter)

## ── 0. BOOTSTRAP (same as existing scripts) ──────────────────────────────────

if (!exists("data_dir")) data_dir <- '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/data'
source('\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/routines/utilities.R')
gc()

## ── 1. PARAMETERS ─────────────────────────────────────────────────────────────

TARGET_AREA  <- "AT"       # country
TARGET_TIME  <- "2024q4"   # period
TARGET_INSTR <- "F3"       # instrument: "F3"=Debt Sec, "F52"=Inv Fund Shares,
                            #             "FT"=all, "F2M"=Deposits, etc.
MIN_FLOW_PCT <- 0.3        # % of total: hide flows smaller than this (reduces clutter)

## ── 2. LABELS & THEME (same as S1M script) ───────────────────────────────────

sector_labels <- c(
  "S11"  = "NFC",
  "S1M"  = "Households",
  "S13"  = "Government",
  "S12"  = "Financial Corporations",
  "S12K" = "Banks",
  "S12Q" = "Insurers & Pension Funds",
  "S12O" = "Other Financial",
  "S124" = "Investment Funds",
  "S2"   = "Rest of World"
)

area_labels <- c("W2" = "Domestic", "WRL_REST" = "Rest of World")

ren <- function(x, map) ifelse(x %in% names(map), map[x], x)

ec_theme <- hc_theme(
  chart    = list(backgroundColor = "#FFF",
                  style = list(fontFamily = "Arial, Helvetica, sans-serif")),
  title    = list(align = "left",
                  style = list(fontSize = "18px", fontWeight = "bold", color = "black")),
  subtitle = list(align = "left",
                  style = list(fontSize = "11px", color = "black")),
  caption  = list(align = "left",
                  style = list(fontSize = "10px",  color = "black")),
  legend   = list(enabled = FALSE),
  tooltip  = list(backgroundColor = "#FFF", borderColor = "#CCC",
                  style = list(color = "black")),
  plotOptions = list(sankey = list(
    dataLabels = list(style = list(color = "black", textOutline = "none",
                                   fontWeight = "bold"))))
)

## ── 3. LOAD DATA ──────────────────────────────────────────────────────────────

aa <- readRDS(file.path(data_dir, 'aa_iip_agg.rds')); gc()

## ── 4. EXTRACT WHOM-TO-WHOM FLOWS ────────────────────────────────────────────
#
# MDstats bracket DSL:
#   aa[INSTR.AREA.REF_SECTOR.CP_SECTOR.STO.FCAT.TIME.CP_AREA]
#   "+" = OR within a dimension; "." separates dimensions
#
# Non-aggregate creditor sectors: S11 NFC, S1M HH, S13 Gov,
#   S12K Banks, S12Q Ins&Pens, S12O OtherFin, S124 InvFunds
# --- Domestic creditors → domestic debtors (CP_AREA = W2) ---
wtw_dom <- aa[F3.AT.S11+S1M+S13+S12K+S12Q+S12O+S124.S11+S1M+S13+S12K+S12Q+S12O+S124.LE._T.2024q4.W2]

# --- Domestic creditors → Rest of World (CP_SECTOR = S1 = total economy of CP) ---
wtw_row <- aa[F3.AT.S11+S1M+S13+S12K+S12Q+S12O+S124.S1.LE._T.2024q4.WRL_REST]

# ── Adjust TARGET_INSTR / TARGET_TIME above and re-run; bracket literals must
#    match — replace F3 and 2024q4 in the two lines above when changing params.

## ── 5. TIDY INTO FLOWS DATA FRAME ────────────────────────────────────────────

tidy_flows <- function(md_obj, cp_area_label) {
  df <- as.data.frame(md_obj)
  if (nrow(df) == 0) return(tibble())
  df %>%
    transmute(
      cred_sec  = as.character(REF_SECTOR),
      debt_sec  = as.character(COUNTERPART_SECTOR),
      area      = cp_area_label,
      value     = as.numeric(obs_value)
    ) %>%
    filter(is.finite(value), value > 0)
}

flows_raw <- bind_rows(
  tidy_flows(wtw_dom, "W2"),
  tidy_flows(wtw_row, "WRL_REST")
) %>%
  group_by(cred_sec, debt_sec, area) %>%
  summarise(value = sum(value), .groups = "drop")

total_value <- sum(flows_raw$value)
stopifnot("No flows extracted — check bracket notation / parameters" = total_value > 0)

## ── 6. FILTER SMALL FLOWS & BUILD NODE LABELS ────────────────────────────────

flows <- flows_raw %>%
  filter(value / total_value * 100 >= MIN_FLOW_PCT) %>%
  mutate(
    # Right-hand node = debtor sector · area
    debt_id    = paste0(debt_sec, "_", area),
    debt_label = paste(ren(debt_sec, sector_labels),
                       ren(area, area_labels), sep = " · "),
    cred_label = ren(cred_sec, sector_labels)
  )

## ── 7. COMPUTE SHARES FOR NODE LABELS ────────────────────────────────────────

# Creditor shares (left column)
cred_shares <- flows %>%
  group_by(cred_sec, cred_label) %>%
  summarise(w = sum(value), .groups = "drop") %>%
  mutate(share = w / sum(w)) %>%
  arrange(desc(w))

# Debtor × area shares (right column)
# Ordered: Domestic first, then RoW; within area: fin. sector first
sec_order  <- c("S124", "S12K", "S12Q", "S12O", "S11", "S13", "S1M", "S1")
area_order <- c("W2", "WRL_REST")

debt_shares <- flows %>%
  group_by(debt_id, debt_label, debt_sec, area) %>%
  summarise(w = sum(value), .groups = "drop") %>%
  mutate(
    share     = w / sum(w),
    area_rank = match(area,     area_order),
    sec_rank  = match(debt_sec, sec_order),
    area_rank = ifelse(is.na(area_rank), 99, area_rank),
    sec_rank  = ifelse(is.na(sec_rank),  99, sec_rank)
  ) %>%
  arrange(area_rank, sec_rank, desc(share))

## ── 8. HIGHCHARTER NODES & LINKS ─────────────────────────────────────────────

# Colour palette: creditors in blue-grey family, debtors split domestic/RoW
CRED_COL    <- "#A8C4DC"   # blue-grey for all creditor nodes
DOM_COL     <- "#D9D9D9"   # grey for domestic debtor nodes
ROW_COL     <- "#C8E6C9"   # light green for Rest-of-World debtor nodes

left_nodes <- lapply(seq_len(nrow(cred_shares)), function(i) {
  r <- cred_shares[i, ]
  list(
    id     = paste0(r$cred_sec, "_src"),
    name   = sprintf("%s — %.1f%%", r$cred_label, 100 * r$share),
    column = 0,
    color  = CRED_COL,
    dataLabels = list(style = list(color = "black", textOutline = "none"))
  )
})

right_nodes <- lapply(seq_len(nrow(debt_shares)), function(i) {
  r <- debt_shares[i, ]
  col <- if (r$area == "W2") DOM_COL else ROW_COL
  list(
    id     = paste0(r$debt_id, "_dst"),
    name   = sprintf("%s — %.1f%%", r$debt_label, 100 * r$share),
    column = 1,
    color  = col,
    dataLabels = list(style = list(color = "black", textOutline = "none"))
  )
})

nodes_all <- c(left_nodes, right_nodes)

# Verify unique IDs
stopifnot(length(unique(vapply(nodes_all, `[[`, "", "id"))) == length(nodes_all))

# Links
links_all <- flows %>%
  transmute(
    from   = paste0(cred_sec, "_src"),
    to     = paste0(debt_id,  "_dst"),
    weight = value,
    # Domestic flows grey, RoW flows green-tinted
    color  = ifelse(area == "W2",
                    "rgba(150,150,150,0.40)",
                    "rgba(100,180,120,0.40)")
  ) %>%
  mutate(across(c(from, to, color), as.character),
         weight = as.numeric(weight)) %>%
  filter(is.finite(weight), weight > 0)

## ── 9. PLOT ──────────────────────────────────────────────────────────────────

chart_title <- sprintf(
  "Whom-to-Whom: %s — %s  |  %s",
  TARGET_AREA, TARGET_TIME, TARGET_INSTR
)

highchart() %>%
  hc_add_dependency("modules/sankey") %>%
  hc_size(width = 980, height = 580) %>%
  hc_add_series(
    type        = "sankey",
    data        = highcharter::list_parse2(links_all),
    nodes       = nodes_all,
    keys        = c("from", "to", "weight"),
    dataLabels  = list(enabled = TRUE,
                       style   = list(color        = "black",
                                      textOutline  = "none",
                                      fontWeight   = "bold")),
    nodeWidth   = 22,
    nodePadding = 14,
    curveFactor = 0.30,
    borderWidth = 0,
    linkOpacity = 1,
    tooltip = list(
      useHTML = TRUE,
      pointFormatter = JS(
        "function(){
           var bn = (this.weight / 1000).toFixed(1);
           var pct = (100 * this.weight / " , total_value, ").toFixed(1);
           return '<b>' + this.from + '</b> → <b>' + this.to +
                  '</b><br/>Value: ' + bn + ' bn  (' + pct + '% of total)';
         }")
    )
  ) %>%
  hc_title(text = chart_title) %>%
  hc_subtitle(text = paste0(
    "Blue-grey = creditor sectors  |  ",
    "Grey = domestic debtors  |  Green = Rest-of-World debtors  |  ",
    "Flows < ", MIN_FLOW_PCT, "% of total hidden"
  )) %>%
  hc_caption(text = "Source: IIP (aa_iip_agg.rds). Non-aggregate sectors only.") %>%
  hc_add_theme(ec_theme) %>%
  hc_annotations(list(
    list(labels = list(
      list(text = "Creditor sectors", x = 90,  y = 16,
           backgroundColor = "rgba(0,0,0,0)",
           style = list(color = "black", fontWeight = "bold")),
      list(text = "Debtor sector · area", x = 730, y = 16,
           backgroundColor = "rgba(0,0,0,0)",
           style = list(color = "black", fontWeight = "bold"))
    ))
  )) %>%
  hc_exporting(enabled = TRUE, filename = paste0("wtw_sankey_", TARGET_AREA, "_", TARGET_TIME))
