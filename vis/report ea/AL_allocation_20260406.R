# ══════════════════════════════════════════════════════════════════════════════
# Whom-to-Whom Sankey — full picture: domestic + RoW as creditor
# aa  = domestic sectors' assets (domestic + RoW counterparts)
# ll  = RoW holdings of domestic liabilities  →  RoW as creditor node
# ══════════════════════════════════════════════════════════════════════════════

library(MDstats)
library(dplyr)
library(highcharter)

## ── 0. BOOTSTRAP ─────────────────────────────────────────────────────────────

if (!exists("data_dir")) data_dir <- '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/data'
source('\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/routines/utilities.R')
gc()

## ── 1. PARAMETERS ─────────────────────────────────────────────────────────────

TARGET_AREA  <- "FR"
TARGET_TIME  <- "2024q4"
BASE_TIME    <- "2023q4"   # for change (flows) calculation
INSTRS       <- "F2M+F3+F4+F511+F51M+F6+F81+F89"
MIN_FLOW_PCT <- 0.3

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

sector_colours <- c(
  "S11"  = "#4472C4",
  "S1M"  = "#ED7D31",
  "S13"  = "#A9D18E",
  "S12K" = "#FFD700",
  "S12Q" = "#9DC3E6",
  "S12O" = "#C9C9C9",
  "S124" = "#7030A0",
  "S1"   = "#70AD47"    # green — Rest of World
)

ren     <- function(x, map) ifelse(x %in% names(map), map[x], x)
sec_col <- function(s) unname(ifelse(s %in% names(sector_colours),
                                     sector_colours[s], "#CCCCCC"))

ec_theme <- hc_theme(
  chart    = list(backgroundColor = "#FFF",
                  style = list(fontFamily = "Arial, Helvetica, sans-serif")),
  title    = list(align = "left",
                  style = list(fontSize = "18px", fontWeight = "bold", color = "black")),
  subtitle = list(align = "left",
                  style = list(fontSize = "11px", color = "black")),
  caption  = list(align = "left",
                  style = list(fontSize = "10px", color = "black")),
  legend   = list(enabled = FALSE),
  tooltip  = list(backgroundColor = "#FFF", borderColor = "#CCC",
                  style = list(color = "black")),
  plotOptions = list(sankey = list(
    dataLabels = list(style = list(color       = "black",
                                   textOutline = "none",
                                   fontWeight  = "bold"))))
)

## ── 3. LOAD & EXTRACT ────────────────────────────────────────────────────────

aa <- readRDS(file.path(data_dir, 'aa_iip_agg.rds')); gc()
ll <- readRDS(file.path(data_dir, 'll_iip_agg.rds')); gc()

# ── Asset side: domestic creditors → domestic + RoW debtors ──────────────────
# ⚠ Update instrument codes and time periods here when changing parameters
wtw_aa <- aa[F2M+F3+F4+F511+F51M+F6+F81+F89.FR.S11+S1M+S13+S12K+S12Q+S12O+S124.S11+S1M+S13+S12K+S12Q+S12O+S124+S1.LE._T.2024q4.W2+WRL_REST]-aa[F2M+F3+F4+F511+F51M+F6+F81+F89.FR.S11+S1M+S13+S12K+S12Q+S12O+S124.S11+S1M+S13+S12K+S12Q+S12O+S124+S1.LE._T.2023q4.W2+WRL_REST]

# ── Liability side: RoW creditor → domestic debtors ──────────────────────────
# In ll: REF_SECTOR = domestic debtor | COUNTERPART_SECTOR = RoW creditor (S1)
wtw_ll <- ll[F2M+F3+F4+F511+F51M+F6+F81+F89.WRL_REST.S1.S11+S1M+S13+S12K+S12Q+S12O+S124+S1.LE._T.2024q4.FR]-ll[F2M+F3+F4+F511+F51M+F6+F81+F89.WRL_REST.S1.S11+S1M+S13+S12K+S12Q+S12O+S124+S1.LE._T.2023q4.FR]

## ── 4. TIDY ───────────────────────────────────────────────────────────────────

# helper: auto-detect obs_value column name
get_col <- function(cn, pattern) cn[grep(pattern, cn, ignore.case = TRUE)][1]

# ── 4a. Assets (aa): REF_SECTOR = creditor, COUNTERPART_SECTOR = debtor ──────
df_aa <- as.data.frame(wtw_aa)
cn_aa  <- names(df_aa)

flows_aa <- df_aa %>%
  transmute(
    cred_sec = as.character(.data[[get_col(cn_aa, "ref_sector")]]),
    debt_sec = as.character(.data[[get_col(cn_aa, "counterpart_sector|cp_sector")]]),
    area     = as.character(.data[[get_col(cn_aa, "counterpart_area|cp_area")]]),
    value    = as.numeric(gsub(",", ".", .data[[get_col(cn_aa, "obs_value")]]))
  ) %>%
  filter(
    is.finite(value), value > 0,
    !(area == "W2"       & debt_sec == "S1"),   # drop domestic S1 aggregate
    !(area == "WRL_REST" & debt_sec != "S1")    # RoW: keep only S1 total
  )

# ── 4b. Liabilities (ll): REF_SECTOR = domestic debtor, cred = RoW (S1) ──────
df_ll <- as.data.frame(wtw_ll)
cn_ll  <- names(df_ll)

flows_ll <- df_ll %>%
  transmute(
    cred_sec = "S1",    # RoW is always the creditor here
    debt_sec = as.character(.data[[get_col(cn_ll, "ref_sector")]]),
    area     = "W2",    # these are holdings of domestic liabilities
    value    = as.numeric(gsub(",", ".", .data[[get_col(cn_ll, "obs_value")]]))
  ) %>%
  filter(
    is.finite(value), value > 0,
    debt_sec != "S1"    # exclude aggregate
  )

## ── 5. MERGE & SUMMARISE ─────────────────────────────────────────────────────

flows_raw <- bind_rows(flows_aa, flows_ll) %>%
  group_by(cred_sec, debt_sec, area) %>%
  summarise(value = sum(value), .groups = "drop")

# Grand total = all flows (domestic creditors + RoW creditor)
total_value <- sum(flows_raw$value)
stopifnot("No flows found — check bracket queries" = total_value > 0)

## ── 6. FILTER & LABEL ────────────────────────────────────────────────────────

flows <- flows_raw %>%
  filter(value / total_value * 100 >= MIN_FLOW_PCT) %>%
  mutate(
    debt_id    = paste0(debt_sec, "_", area),
    cred_label = ren(cred_sec, sector_labels),
    debt_label = ifelse(area == "WRL_REST",
                        "Rest of World",
                        paste0(ren(debt_sec, sector_labels), " · Dom."))
  )

## ── 7. SHARES (all relative to total_value) ───────────────────────────────────

# Fixed sector order: same sequence left and right → minimises crossings
SECTOR_ORDER <- c("S1", "S12K", "S12O", "S124", "S12Q", "S11", "S1M", "S13")

cred_shares <- flows %>%
  group_by(cred_sec, cred_label) %>%
  summarise(w = sum(value), .groups = "drop") %>%
  mutate(share    = w / total_value,
         sec_rank = match(cred_sec, SECTOR_ORDER),
         sec_rank = ifelse(is.na(sec_rank), 99, sec_rank)) %>%
  arrange(sec_rank)

debt_shares <- flows %>%
  group_by(debt_id, debt_label, debt_sec, area) %>%
  summarise(w = sum(value), .groups = "drop") %>%
  mutate(
    share     = w / total_value,
    area_rank = match(area, c("WRL_REST", "W2")),  # RoW first on right
    sec_rank  = match(debt_sec, SECTOR_ORDER),
    area_rank = ifelse(is.na(area_rank), 99, area_rank),
    sec_rank  = ifelse(is.na(sec_rank),  99, sec_rank)
  ) %>%
  arrange(area_rank, sec_rank)

## ── 8. NODES & LINKS ─────────────────────────────────────────────────────────

left_nodes <- lapply(seq_len(nrow(cred_shares)), function(i) {
  r <- cred_shares[i, ]
  list(id         = paste0(r$cred_sec, "_src"),
       name       = sprintf("%s — %.1f%%", r$cred_label, 100 * r$share),
       column     = 0,
       color      = sec_col(r$cred_sec),
       dataLabels = list(style = list(color = "black", textOutline = "none")))
})

right_nodes <- lapply(seq_len(nrow(debt_shares)), function(i) {
  r <- debt_shares[i, ]
  list(id         = paste0(r$debt_id, "_dst"),
       name       = sprintf("%s — %.1f%%", r$debt_label, 100 * r$share),
       column     = 1,
       color      = sec_col(r$debt_sec),
       dataLabels = list(style = list(color = "black", textOutline = "none")))
})

nodes_all <- c(left_nodes, right_nodes)
stopifnot("Duplicate node IDs" =
            length(unique(vapply(nodes_all, `[[`, "", "id"))) == length(nodes_all))

# Scale link opacity by flow size: big flows bold, small flows faint
max_val <- max(flows$value)

links_all <- flows %>%
  mutate(
    opacity = 0.15 + 0.65 * (value / max_val),
    op_hex  = toupper(as.hexmode(round(opacity * 255))),
    op_hex  = ifelse(nchar(op_hex) == 1, paste0("0", op_hex), op_hex)
  ) %>%
  transmute(
    from   = paste0(cred_sec, "_src"),
    to     = paste0(debt_id,  "_dst"),
    weight = value,
    color  = paste0(sec_col(cred_sec), op_hex)
  ) %>%
  mutate(across(c(from, to, color), as.character),
         weight = as.numeric(weight)) %>%
  filter(is.finite(weight), weight > 0)

## ── 9. PLOT ──────────────────────────────────────────────────────────────────

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
  hc_title(text = sprintf("Whom-to-Whom: %s — %s | All instruments",
                          TARGET_AREA, TARGET_TIME)) %>%
  hc_subtitle(text = paste0(
    "Left = creditor sectors (incl. Rest of World via liabilities)  |  ",
    "Right = debtor sectors  |  ",
    "% of total (domestic + RoW)  |  Flows < ", MIN_FLOW_PCT, "% hidden"
  )) %>%
  hc_caption(text = paste0(
    "Source: IIP aa + ll (", TARGET_TIME, " vs ", BASE_TIME, " changes). ",
    "Non-aggregate sectors only."
  )) %>%
  hc_add_theme(ec_theme) %>%
  hc_exporting(enabled  = TRUE,
               filename = paste0("wtw_sankey_full_", TARGET_AREA, "_", TARGET_TIME))

p

# htmlwidgets::saveWidget(p, "wtw_sankey_full.html", selfcontained = TRUE)
# browseURL("wtw_sankey_full.html")
