# ══════════════════════════════════════════════════════════════════════════════
# Whom-to-Whom Heatmap — Option A with negative changes
# Each ROW: positive = increased allocation, negative = reduced allocation
# Normalised by sum of absolute changes per creditor row
# ══════════════════════════════════════════════════════════════════════════════

library(MDstats)
library(dplyr)
library(highcharter)

## ── 0. BOOTSTRAP ─────────────────────────────────────────────────────────────

if (!exists("data_dir")) data_dir <- '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/data'
source('\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/routines/utilities.R')
gc()

## ── 1. PARAMETERS ─────────────────────────────────────────────────────────────

TARGET_AREA  <- "EA20"
TARGET_TIME  <- "2024"      # label only — data uses 2024:y below
BASE_TIME    <- "2023"
ROW_AREA     <- "EXT_EA20"  # "WRL_REST" for single countries, "EXT_EA20" for EA20
MIN_VALUE    <- 1000

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
 wtw_aa <- aa[F2M+F3+F4+F511+F51M+F52+F6+F81+F89.EA20.S11+S1M+S13+S12K+S12Q+S12O+S124.S11+S1M+S13+S12K+S12Q+S12O+S124+S1.F._T.2024:y.W2+EXT_EA20]
 wtw_ll <- ll[F2M+F3+F4+F511+F51M+F52+F6+F81+F89.EXT_EA20.S1.S11+S1M+S13+S12K+S12Q+S12O+S124+S1.F._T.2024:y.EA20]

#check for ecb results
# wtw_aa <- aa[F2M+F3+F4+F511+F52.EA20.S11+S1M+S13+S12K+S12Q+S12O+S124.S11+S1M+S13+S12K+S12Q+S12O+S124+S1.F._T.2024:y.W2+EXT_EA20]
# wtw_ll <- ll[F2M+F3+F4+F511+F52.EXT_EA20.S1.S11+S1M+S13+S12K+S12Q+S12O+S124+S1.F._T.2024:y.EA20]


## ── 4. TIDY ───────────────────────────────────────────────────────────────────

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
    !(area == "W2"     & debt_sec == "S1"),   # drop domestic aggregate
    !(area == ROW_AREA & debt_sec != "S1")    # RoW: keep only S1 total
  )

df_ll  <- as.data.frame(wtw_ll); cn_ll <- names(df_ll)
flows_ll <- df_ll %>%
  transmute(
    cred_sec = "S1",
    debt_sec = as.character(.data[[get_col(cn_ll, "ref_sector")]]),
    area     = "W2",
    value    = as.numeric(gsub(",", ".", .data[[get_col(cn_ll, "obs_value")]]))
  ) %>%
  filter(is.finite(value), value > 0, debt_sec != "S1")

## ── 5. MERGE & BUILD VALUE TABLE ─────────────────────────────────────────────

flows_raw <- bind_rows(flows_aa, flows_ll) %>%
  group_by(cred_sec, debt_sec, area) %>%
  summarise(value = sum(value), .groups = "drop")   # sums across all 4 quarters

stopifnot("No flows found — check bracket queries" = nrow(flows_raw) > 0)

flows_val <- flows_raw %>%
  mutate(
    cred_label = ren(cred_sec, sector_labels),
    debt_label = ifelse(area == ROW_AREA,          # <-- use ROW_AREA not "WRL_REST"
                        "Rest of World",
                        paste0(ren(debt_sec, sector_labels), " · Dom.")),
    val_bn = round(value / 1000, 1)
  ) %>%
  filter(value >= MIN_VALUE)

## ── 6. AXIS ORDERING ─────────────────────────────────────────────────────────

CRED_ORDER <- flows_raw %>%
  mutate(cred_label = ren(cred_sec, sector_labels)) %>%
  group_by(cred_label) %>%
  summarise(total = sum(value), .groups = "drop") %>%
  arrange(desc(total)) %>%
  pull(cred_label)

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

full_grid <- expand.grid(
  cred_label = CRED_ORDER,
  debt_label = DEBT_ORDER,
  stringsAsFactors = FALSE
)

mat <- full_grid %>%
  left_join(flows_val %>% select(cred_label, debt_label, val_bn),
            by = c("cred_label", "debt_label")) %>%
  mutate(
    val_bn = ifelse(is.na(val_bn), 0, val_bn),
    x      = match(debt_label, DEBT_ORDER) - 1L,
    y      = match(cred_label, CRED_ORDER) - 1L
  ) %>%
  filter(!is.na(x), !is.na(y)) %>%
  select(x, y, val_bn)

axis_max <- ceiling(max(mat$val_bn, na.rm = TRUE) / 100) * 100

## ── 8. PLOT ──────────────────────────────────────────────────────────────────

p <- highchart() %>%
  hc_chart(type = "heatmap") %>%
  hc_add_series(
    data = highcharter::list_parse2(mat),
    keys = c("x", "y", "value"),
    name = "EUR bn"
  ) %>%
  hc_colorAxis(
    min   = 0,
    max   = axis_max,
    stops = color_stops(
      n      = 7,
      colors = c("#FFFFFF", "#EBF5FB", "#AED6F1", "#2E86C1", "#1B4F72")
    )
  ) %>%
  hc_xAxis(
    categories = DEBT_ORDER,
    title      = list(text  = "Debtor sector",
                      style = list(fontWeight = "bold")),
    labels     = list(rotation = -35, style = list(fontSize = "11px"))
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
             ? this.point.value.toFixed(1)
             : '';
         }"
      ),
      style = list(fontSize    = "11px",
                   fontWeight  = "bold",
                   color       = "black",
                   textOutline = "none")
    )
  )) %>%
  hc_tooltip(
    formatter = JS(
      "function(){
         return '<b>' + this.series.yAxis.categories[this.point.y] + '</b>' +
                ' → <b>' + this.series.xAxis.categories[this.point.x] + '</b>' +
                '<br/>Net flow: <b>' + this.point.value.toFixed(1) + ' EUR bn</b>';
       }"
    )
  ) %>%
  hc_title(text = sprintf(
    "Who-to-Whom: %s — %s | All instruments", TARGET_AREA, TARGET_TIME
  )) %>%
  hc_subtitle(text = paste0(
    "Sum of 4 quarterly flows, EUR bn  |  Full year ", TARGET_TIME
  )) %>%
  hc_caption(text = paste0(
    "Source: Finflows 3.0. Annual transactions (sum of 4 quarters, ", TARGET_TIME, ").  ",
    "Non-aggregate sectors only. Cells below ", MIN_VALUE, " mn not shown."
  )) %>%
  hc_caption(text = paste0(
    "Source: Finflows 3.0 (preliminary results).  ",
    "Non-aggregate sectors only. Cells below ", MIN_VALUE, " mn not shown."
  )) %>%
  hc_size(width = 1050, height = 650) %>%
  hc_add_theme(ec_theme) %>%
  hc_exporting(
    enabled  = TRUE,
    filename = paste0("wtw_heatmap_bn_", TARGET_AREA, "_", TARGET_TIME)
  )

p