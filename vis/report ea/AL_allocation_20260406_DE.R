# ══════════════════════════════════════════════════════════════════════════════
# Whom-to-Whom Heatmap — Option A: Creditor allocation
# Each ROW sums to 100%: "how does each creditor allocate its holdings?"
# ══════════════════════════════════════════════════════════════════════════════

library(MDstats)
library(dplyr)
library(highcharter)

## ── 0. BOOTSTRAP ─────────────────────────────────────────────────────────────

if (!exists("data_dir")) data_dir <- '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/data'
source('\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/routines/utilities.R')
gc()

## ── 1. PARAMETERS ─────────────────────────────────────────────────────────────

TARGET_AREA  <- "DE"
TARGET_TIME  <- "2024q4"
BASE_TIME    <- "2023q4"
MIN_FLOW_PCT <- 0.5    # hide cells below this % within each creditor's row

## ── 2. LABELS & THEME ────────────────────────────────────────────────────────

sector_labels <- c(
  "S11"  = "NFCs",
  "S1M"  = "Households",
  "S13"  = "Government",
  "S12K" = "Banks",
  "S12Q" = "Ins. & Pension Funds",
  "S12O" = "Other Financial",
  "S124" = "Investment Funds",
  "S1"   = "Rest of World"
)

ren <- function(x, map) ifelse(x %in% names(map), map[x], x)

ec_theme <- hc_theme(
  chart    = list(backgroundColor = "#FFF",
                  style = list(fontFamily = "Arial, Helvetica, sans-serif")),
  title    = list(align = "left",
                  style = list(fontSize = "18px", fontWeight = "bold", color = "black")),
  subtitle = list(align = "left",
                  style = list(fontSize = "11px", color = "black")),
  caption  = list(align = "left",
                  style = list(fontSize = "10px", color = "black")),
  legend   = list(enabled = TRUE),
  tooltip  = list(backgroundColor = "#FFF", borderColor = "#CCC",
                  style = list(color = "black"))
)

## ── 3. LOAD & EXTRACT ────────────────────────────────────────────────────────

aa <- readRDS(file.path(data_dir, 'aa_iip_agg.rds')); gc()
ll <- readRDS(file.path(data_dir, 'll_iip_agg.rds')); gc()

# ⚠ Update instrument codes and time literals when changing parameters
wtw_aa <- aa[F2M+F3+F4+F511+F51M+F52+F6+F81+F89.DE.S11+S1M+S13+S12K+S12Q+S12O+S124.S11+S1M+S13+S12K+S12Q+S12O+S124+S1.LE._T.2024q4.W2+WRL_REST] -
  aa[F2M+F3+F4+F511+F51M+F52+F6+F81+F89.DE.S11+S1M+S13+S12K+S12Q+S12O+S124.S11+S1M+S13+S12K+S12Q+S12O+S124+S1.LE._T.2023q4.W2+WRL_REST]

wtw_ll <- ll[F2M+F3+F4+F511+F51M+F52+F6+F81+F89.WRL_REST.S1.S11+S1M+S13+S12K+S12Q+S12O+S124+S1.LE._T.2024q4.DE] -
  ll[F2M+F3+F4+F511+F51M+F52+F6+F81+F89.WRL_REST.S1.S11+S1M+S13+S12K+S12Q+S12O+S124+S1.LE._T.2023q4.DE]

## ── 4. TIDY ───────────────────────────────────────────────────────────────────

get_col <- function(cn, pat) cn[grep(pat, cn, ignore.case = TRUE)][1]

# Assets: REF_SECTOR = creditor, COUNTERPART_SECTOR = debtor
df_aa  <- as.data.frame(wtw_aa); cn_aa <- names(df_aa)
flows_aa <- df_aa %>%
  transmute(
    cred_sec = as.character(.data[[get_col(cn_aa, "ref_sector")]]),
    debt_sec = as.character(.data[[get_col(cn_aa, "counterpart_sector|cp_sector")]]),
    area     = as.character(.data[[get_col(cn_aa, "counterpart_area|cp_area")]]),
    value    = as.numeric(gsub(",", ".", .data[[get_col(cn_aa, "obs_value")]]))
  ) %>%
  filter(
    is.finite(value), value > 0,
    !(area == "W2"       & debt_sec == "S1"),
    !(area == "WRL_REST" & debt_sec != "S1")
  )

# Liabilities: REF_SECTOR = domestic debtor, creditor = RoW (S1)
df_ll  <- as.data.frame(wtw_ll); cn_ll <- names(df_ll)
flows_ll <- df_ll %>%
  transmute(
    cred_sec = "S1",
    debt_sec = as.character(.data[[get_col(cn_ll, "ref_sector")]]),
    area     = "W2",
    value    = as.numeric(gsub(",", ".", .data[[get_col(cn_ll, "obs_value")]]))
  ) %>%
  filter(is.finite(value), value > 0, debt_sec != "S1")

## ── 5. MERGE & COMPUTE ROW % ─────────────────────────────────────────────────

flows_raw <- bind_rows(flows_aa, flows_ll) %>%
  group_by(cred_sec, debt_sec, area) %>%
  summarise(value = sum(value), .groups = "drop")

stopifnot("No flows found — check bracket queries" = nrow(flows_raw) > 0)

# Row normalisation: each creditor's holdings sum to 100%
flows_pct <- flows_raw %>%
  mutate(
    cred_label = ren(cred_sec, sector_labels),
    debt_label = ifelse(area == "WRL_REST",
                        "Rest of World",
                        paste0(ren(debt_sec, sector_labels), " · Dom."))
  ) %>%
  group_by(cred_label) %>%
  mutate(pct = round(100 * value / sum(value), 1)) %>%
  ungroup() %>%
  filter(pct >= MIN_FLOW_PCT)

## ── 6. AXIS ORDERING ─────────────────────────────────────────────────────────

# Creditor rows — order by total assets descending
CRED_ORDER <- flows_raw %>%
  mutate(cred_label = ren(cred_sec, sector_labels)) %>%
  group_by(cred_label) %>%
  summarise(total = sum(value), .groups = "drop") %>%
  arrange(desc(total)) %>%
  pull(cred_label)

# Debtor columns — RoW first, then domestic fin. sectors, then real sectors
DEBT_ORDER <- c(
  "Rest of World",
  "Banks · Dom.",
  "Investment Funds · Dom.",
  "Ins. & Pension Funds · Dom.",
  "Other Financial · Dom.",
  "NFCs · Dom.",
  "Government · Dom.",
  "Households · Dom."
)

## ── 7. BUILD MATRIX FOR HIGHCHARTS ───────────────────────────────────────────

# Full grid so empty cells render as 0
full_grid <- expand.grid(
  cred_label = CRED_ORDER,
  debt_label = DEBT_ORDER,
  stringsAsFactors = FALSE
)

mat <- full_grid %>%
  left_join(flows_pct %>% select(cred_label, debt_label, pct),
            by = c("cred_label", "debt_label")) %>%
  mutate(
    pct = ifelse(is.na(pct), 0, pct),
    x   = match(debt_label, DEBT_ORDER) - 1L,
    y   = match(cred_label, CRED_ORDER) - 1L
  ) %>%
  filter(!is.na(x), !is.na(y)) %>%
  select(x, y, pct)

## ── 8. PLOT ──────────────────────────────────────────────────────────────────

p <- highchart() %>%
  hc_chart(type = "heatmap") %>%
  hc_add_series(
    data = highcharter::list_parse2(mat),
    keys = c("x", "y", "value"),
    name = "% of creditor holdings"
  ) %>%
  hc_colorAxis(
    min  = 0,
    max  = 100,
    stops = color_stops(
      n      = 7,
      colors = c("#FFFFFF", "#EBF5FB", "#AED6F1", "#2E86C1", "#1B4F72")
    )
  ) %>%
  hc_xAxis(
    categories = DEBT_ORDER,
    title      = list(text  = "Debtor sector",
                      style = list(fontWeight = "bold")),
    labels     = list(rotation = -35,
                      style    = list(fontSize = "11px")),
    opposite   = FALSE
  ) %>%
  hc_yAxis(
    categories = CRED_ORDER,
    title      = list(text  = "Creditor sector",
                      style = list(fontWeight = "bold")),
    reversed   = FALSE,
    labels     = list(style = list(fontSize = "11px"))
  ) %>%
  hc_plotOptions(heatmap = list(
    borderWidth = 2,
    borderColor = "#FFFFFF",
    dataLabels  = list(
      enabled   = TRUE,
      formatter = JS(
        "function(){
           return this.point.value > 0
             ? this.point.value.toFixed(1) + '%'
             : '';
         }"
      ),
      style = list(
        fontSize    = "11px",
        fontWeight  = "bold",
        color       = "black",
        textOutline = "none"
      )
    )
  )) %>%
  hc_tooltip(
    formatter = JS(
      "function(){
         return '<b>' + this.series.yAxis.categories[this.point.y] + '</b>' +
                ' → <b>' + this.series.xAxis.categories[this.point.x] + '</b>' +
                '<br/>Share of creditor holdings: <b>' +
                this.point.value.toFixed(1) + '%</b>' +
                '<br/><i>(each row sums to 100%)</i>';
       }"
    )
  ) %>%
  hc_title(text = sprintf(
    "Who-to-Whom: %s — %s | All instruments", TARGET_AREA, TARGET_TIME
  )) %>%
  hc_subtitle(text = paste0(
    "Each row = 100% of that creditor's total holdings  |  ",
    "Cells show % allocated to each debtor sector"
  )) %>%
  hc_caption(text = paste0(
    "Source: Finflows 3.0 (", TARGET_TIME, " vs ", BASE_TIME, " changes).  ",
    "Non-aggregate sectors only."
  )) %>%
  hc_size(width = 1050, height = 650) %>%
  hc_add_theme(ec_theme) %>%
  hc_exporting(
    enabled  = TRUE,
    filename = paste0("wtw_heatmap_rowpct_", TARGET_AREA, "_", TARGET_TIME)
  )

p