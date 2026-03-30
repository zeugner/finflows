library(MDstats); 


zerofiller=function(x, fillscalar=0){
  temp=copy(x)
  temp[onlyna=TRUE]=fillscalar
  temp
}


## load data
library(MDstats); library(MD3)

# Set data directory
setwd("V:/FinFlows/githubrepo/finflows")
data_dir= '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/data'

aa=readRDS(file.path(data_dir,'aa_iip_pip.rds')); gc()
ll=readRDS(file.path(data_dir,'ll_iip_pip.rds')); gc()

# # S1 assets 
# S1assetsdom=aa["F+F2M+F3+F4+F5+F51+F511+F51M+F6+F81+F89+Fx7.EA20+DE+AT+FR.S1+S11+S1M+S13+S12+S12T+S124+S12Q+S12O.S1+S11+S1M+S13+S12+S12T+S124+S12Q+S12O.LE._T.2024q4.W2"]
# S1assetsrow=aa["F+F2M+F3+F4+F5+F51+F511+F51M+F6+F81+F89+Fx7.EA20+DE+AT+FR.S1+S11+S1M+S13+S12+S12T+S124+S12Q+S12O.S1.LE._Tx7.2024q4.WRL_REST"]
# 
# # S1 liabilities 
# S1iabdom=ll["F+F2M+F3+F4+F5+F51+F511+F51M+F6+F81+F89+Fx7.W2.S1+S11+S1M+S13+S12+S12T+S124+S12Q+S12O.S1+S11+S1M+S13+S12+S12T+S124+S12Q+S12O.LE._T.2024q4.EA20+DE+AT+FR"]
# S1iabrow=ll["F+F2M+F3+F4+F5+F51+F511+F51M+F6+F81+F89+Fx7.WRL_Rest.S1.S1+S11+S1M+S13+S12+S12T+S124+S12Q+S12O.LE._Tx7.2024q4.EA20+DE+AT+FR"]

library(dplyr)
library(tidyr)
library(highcharter)

# Whom-to-Whom Financial Flows — Sankey Diagram
# Creditor sector (left) → Debtor sector × area (right)
# Follows the S1M Sankey patterns: MDstats RDS + Highcharter

## ── 1. PARAMETERS ─────────────────────────────────────────────────────────────

TARGET_AREA  <- "ES"       # country
TARGET_TIME  <- "2024q4"   # period
TARGET_INSTR <- "Fx7"       # instrument: "F3"=Debt Sec, "F52"=Inv Fund Shares,
#                           "F2M"=Deposits, etc.
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

# done above
wtw_all <- aa[F2M+F3+F4+F511+F51M+F6+F81+F89.ES.S11+S1M+S13+S12K+S12Q+S12O+S124.S11+S1M+S13+S12K+S12Q+S12O+S124+S1.LE._T.2024q4.W2+WRL_REST]-aa[F2M+F3+F4+F511+F51M+F6+F81+F89.ES.S11+S1M+S13+S12K+S12Q+S12O+S124.S11+S1M+S13+S12K+S12Q+S12O+S124+S1.LE._T.2023q4.W2+WRL_REST]


## ── 4. TIDY ───────────────────────────────────────────────────────────────────

df_raw <- as.data.frame(wtw_all)

# Auto-detect column names (MDstats can vary)
cn      <- names(df_raw)
col_ref <- cn[grep("ref_sector",                   cn, ignore.case = TRUE)][1]
col_cp  <- cn[grep("counterpart_sector|cp_sector", cn, ignore.case = TRUE)][1]
col_ca  <- cn[grep("counterpart_area|cp_area",     cn, ignore.case = TRUE)][1]
col_val <- cn[grep("obs_value",                    cn, ignore.case = TRUE)][1]

stopifnot("REF_SECTOR column not found"         = !is.na(col_ref),
          "COUNTERPART_SECTOR column not found" = !is.na(col_cp),
          "COUNTERPART_AREA column not found"   = !is.na(col_ca),
          "obs_value column not found"          = !is.na(col_val))

flows_raw <- df_raw %>%
  transmute(
    cred_sec = as.character(.data[[col_ref]]),
    debt_sec = as.character(.data[[col_cp]]),
    area     = as.character(.data[[col_ca]]),
    value    = as.numeric(gsub(",", ".", .data[[col_val]]))
  ) %>%
  filter(
    is.finite(value), value > 0,
    # domestic: specific sectors only — exclude S1 aggregate (avoids double-count)
    !(area == "W2"       & debt_sec == "S1"),
    # RoW: total economy only — exclude sub-sector breakdown
    !(area == "WRL_REST" & debt_sec != "S1")
  ) %>%
  group_by(cred_sec, debt_sec, area) %>%
  summarise(value = sum(value), .groups = "drop")

# ── Grand total = domestic + RoW (used as denominator for ALL percentages) ──
total_value <- sum(flows_raw$value)
stopifnot("No flows found — check bracket query in section 3" = total_value > 0)

## ── 5. FILTER & LABEL ────────────────────────────────────────────────────────

flows <- flows_raw %>%
  filter(value / total_value * 100 >= MIN_FLOW_PCT) %>%
  mutate(
    debt_id    = paste0(debt_sec, "_", area),
    cred_label = ren(cred_sec, sector_labels),
    debt_label = ifelse(area == "WRL_REST",
                        "Rest of World",
                        paste0(ren(debt_sec, sector_labels), " · Dom."))
  )

## ── 6. COMPUTE SHARES ────────────────────────────────────────────────────────
# All shares divided by total_value (domestic + RoW) → comparable across nodes

# Fixed order, same sequence left and right
SECTOR_ORDER <- c("S12K", "S12O", "S124", "S12Q", "S11", "S1M", "S13", "S1")

cred_shares <- flows %>%
  group_by(cred_sec, cred_label) %>%
  summarise(w = sum(value), .groups = "drop") %>%
  mutate(share    = w / total_value,
         sec_rank = match(cred_sec, SECTOR_ORDER),
         sec_rank = ifelse(is.na(sec_rank), 99, sec_rank)) %>%
  arrange(sec_rank)                    # same top-to-bottom order as right side

debt_shares <- flows %>%
  group_by(debt_id, debt_label, debt_sec, area) %>%
  summarise(w = sum(value), .groups = "drop") %>%
  mutate(share     = w / total_value,
         sec_rank  = match(debt_sec, SECTOR_ORDER),
         area_rank = match(area, c("WRL_REST", "W2")),  # RoW at top right
         sec_rank  = ifelse(is.na(sec_rank),  99, sec_rank),
         area_rank = ifelse(is.na(area_rank), 99, area_rank)) %>%
  arrange(area_rank, sec_rank)

## ── 7. BUILD NODES & LINKS ───────────────────────────────────────────────────

# SECTOR COLOUR MAP (consistent left & right) 

sector_colours <- c(
  "S11"  = "#4472C4",   # blue        — NFCs
  "S1M"  = "#ED7D31",   # orange      — Households
  "S13"  = "#A9D18E",   # green       — Government
  "S12K" = "#FFD700",   # yellow      — Banks
  "S12Q" = "#9DC3E6",   # light blue  — Insurers & Pension Funds
  "S12O" = "#C9C9C9",   # grey        — Other Financial
  "S124" = "#7030A0",   # purple      — Investment Funds
  "S1"   = "#C8E6C9"    # pale green  — Rest of World
)

# helper: get colour by sector code (fallback to grey)
sec_col <- function(sec) unname(ifelse(sec %in% names(sector_colours),
                                       sector_colours[sec], "#CCCCCC"))

left_nodes <- lapply(seq_len(nrow(cred_shares)), function(i) {
  r <- cred_shares[i, ]
  list(id         = paste0(r$cred_sec, "_src"),
       name       = sprintf("%s — %.1f%%", r$cred_label, 100 * r$share),
       column     = 0,
       color      = sec_col(r$cred_sec),   # sector colour
       dataLabels = list(style = list(color = "black", textOutline = "none")))
})

right_nodes <- lapply(seq_len(nrow(debt_shares)), function(i) {
  r <- debt_shares[i, ]
  list(id         = paste0(r$debt_id, "_dst"),
       name       = sprintf("%s — %.1f%%", r$debt_label, 100 * r$share),
       column     = 1,
       color      = sec_col(r$debt_sec),   # same sector colour as left
       dataLabels = list(style = list(color = "black", textOutline = "none")))
})

nodes_all <- c(left_nodes, right_nodes)
stopifnot("Duplicate node IDs detected" =
            length(unique(vapply(nodes_all, `[[`, "", "id"))) == length(nodes_all))

max_val <- max(flows$value)

links_all <- flows %>%
  mutate(
    sec_color = sec_col(cred_sec),
    opacity   = 0.15 + 0.65 * (value / max_val),   # 0.15 (small) → 0.80 (large)
    # convert opacity to 2-digit hex and append to colour
    op_hex    = toupper(as.hexmode(round(opacity * 255))),
    op_hex    = ifelse(nchar(op_hex) == 1, paste0("0", op_hex), op_hex)
  ) %>%
  transmute(
    from   = paste0(cred_sec, "_src"),
    to     = paste0(debt_id,  "_dst"),
    weight = value,
    color  = paste0(sec_color, op_hex)
  ) %>%
  mutate(across(c(from, to, color), as.character),
         weight = as.numeric(weight)) %>%
  filter(is.finite(weight), weight > 0)

## ── 8. PLOT ──────────────────────────────────────────────────────────────────

p <- highchart() %>%
  hc_add_dependency("modules/sankey") %>%
  hc_size(width = 1400, height = 800) %>%
  hc_add_series(
    type        = "sankey",
    data        = highcharter::list_parse2(links_all),
    nodes       = nodes_all,
    keys        = c("from", "to", "weight"),
    dataLabels  = list(enabled = TRUE,
                       style   = list(color       = "black",
                                      textOutline = "none",
                                      fontWeight  = "bold",
                                      fontSize    = "11px")),
    nodeWidth   = 28,
    nodePadding = 6,
    curveFactor = 0.50,
    borderWidth = 0,
    linkOpacity = 1,
    tooltip     = list(
      useHTML = TRUE,
      pointFormatter = JS(paste0(
        "function(){
           var bn  = (this.weight / 1000).toFixed(1);
           var pct = (100 * this.weight / ", total_value, ").toFixed(1);
           return '<b>' + this.from + '</b> → <b>' + this.to +
                  '</b><br/>Value: ' + bn + ' bn' +
                  '<br/>Share of total: ' + pct + '%';
         }"
      ))
    )
  ) %>%
  hc_title(text = sprintf("Who-to-Whom: %s — %s | %s",
                          TARGET_AREA, TARGET_TIME, TARGET_INSTR)) %>%
  hc_subtitle(text = paste0(
    "Node size = % of total assets (domestic + RoW)  |  ",
    "Link colour follows creditor sector")) %>%
  hc_caption(text = "Source: IIP (aa_iip_pip.rds). Non-aggregate sectors only.") %>%
  hc_add_theme(ec_theme) %>%
  hc_exporting(enabled  = TRUE,
               filename = paste0("wtw_sankey_", TARGET_AREA, "_", TARGET_TIME))

p

## ── optional: open in browser at full resolution ─────────────────────────────
# htmlwidgets::saveWidget(p, "wtw_sankey.html", selfcontained = TRUE)
# browseURL("wtw_sankey.html")