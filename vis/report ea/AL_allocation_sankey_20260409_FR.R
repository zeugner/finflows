# ══════════════════════════════════════════════════════════════════════════════
# Whom-to-Whom Sankey — Creditor (left) → Debtor × area (right)
# % = share of total assets (domestic + Rest of World), each row sums to 100%
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
BASE_TIME    <- "2023q4"
ROW_AREA     <- "WRL_REST"   # "WRL_REST" for countries, "EXT_EA20" for EA20
MIN_FLOW_PCT <- 0.5

## ── 2. LABELS, COLOURS & THEME ───────────────────────────────────────────────

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
  "S11"  = "#353B73",  
  "S1M"  = "#E75118",  
  "S13"  = "#FFD724",  
  "S12K" = "#2F9AFB",  
  "S12Q" = "#5BAFD4", 
  "S12O" = "#8EC4E8",  
  "S124" = "#1A6FAF",  
  "S1"   = "#C9C9C9"   
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
                  style = list(fontSize = "10px", color = "black",borderColor = "#FFF")),
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

# ⚠ Update instrument codes and time literals when changing parameters
wtw_aa <- aa[F2M+F3+F4+F511+F51M+F52+F6+F81+F89.FR.S11+S1M+S13+S12K+S12Q+S12O+S124.S11+S1M+S13+S12K+S12Q+S12O+S124+S1.LE._T.2024q4.W2+WRL_REST] -
  aa[F2M+F3+F4+F511+F51M+F52+F6+F81+F89.FR.S11+S1M+S13+S12K+S12Q+S12O+S124.S11+S1M+S13+S12K+S12Q+S12O+S124+S1.LE._T.2023q4.W2+WRL_REST]

wtw_ll <- ll[F2M+F3+F4+F511+F51M+F52+F6+F81+F89.WRL_REST.S1.S11+S1M+S13+S12K+S12Q+S12O+S124+S1.LE._T.2024q4.FR] -
  ll[F2M+F3+F4+F511+F51M+F52+F6+F81+F89.WRL_REST.S1.S11+S1M+S13+S12K+S12Q+S12O+S124+S1.LE._T.2023q4.FR]

## ── 4. TIDY ───────────────────────────────────────────────────────────────────

get_col <- function(cn, pat) cn[grep(pat, cn, ignore.case = TRUE)][1]

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
    !(area == "W2"    & debt_sec == "S1"),
    !(area == ROW_AREA & debt_sec != "S1")
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

## ── 5. MERGE & COMPUTE ROW % ─────────────────────────────────────────────────

flows_raw <- bind_rows(flows_aa, flows_ll) %>%
  group_by(cred_sec, debt_sec, area) %>%
  summarise(value = sum(value), .groups = "drop")

total_value <- sum(flows_raw$value)
stopifnot("No flows found — check bracket queries" = total_value > 0)

flows <- flows_raw %>%
  mutate(
    cred_label = ren(cred_sec, sector_labels),
    debt_id    = paste0(debt_sec, "_", area),
    debt_label = ifelse(area == ROW_AREA,
                        "Rest of World",
                        paste0(ren(debt_sec, sector_labels), " · Dom."))
  ) %>%
  group_by(cred_label, cred_sec) %>%
  mutate(pct = round(100 * value / sum(value), 1)) %>%
  ungroup() %>%
  filter(pct >= MIN_FLOW_PCT)

## ── 6. COMPUTE SHARES & ORDER ────────────────────────────────────────────────

# Fixed sector order — same sequence left and right to minimise crossings
SECTOR_ORDER <- c("S1", "S12K", "S124", "S12Q", "S12O", "S11", "S1M", "S13")

cred_shares <- flows %>%
  group_by(cred_sec, cred_label) %>%
  summarise(w = sum(value), .groups = "drop") %>%
  mutate(
    row_pct  = round(100 * w / sum(w), 1),
    sec_rank = match(cred_sec, SECTOR_ORDER),
    sec_rank = ifelse(is.na(sec_rank), 99, sec_rank)
  ) %>%
  arrange(sec_rank)

debt_shares <- flows %>%
  group_by(debt_id, debt_label, debt_sec, area) %>%
  summarise(w = sum(value), .groups = "drop") %>%
  mutate(
    row_pct   = round(100 * w / sum(w), 1),
    area_rank = match(area, c(ROW_AREA, "W2")),   # RoW first on right
    sec_rank  = match(debt_sec, SECTOR_ORDER),
    area_rank = ifelse(is.na(area_rank), 99, area_rank),
    sec_rank  = ifelse(is.na(sec_rank),  99, sec_rank)
  ) %>%
  arrange(area_rank, sec_rank)

## ── 7. NODES & LINKS ─────────────────────────────────────────────────────────

left_nodes <- lapply(seq_len(nrow(cred_shares)), function(i) {
  r <- cred_shares[i, ]
  list(id         = paste0(r$cred_sec, "_src"),
       name       = sprintf("%s — %.1f%%", r$cred_label, r$row_pct),
       column     = 0,
       color      = sec_col(r$cred_sec),
       dataLabels = list(style = list(
         color       = "black",
         textOutline = "3px white",   # <-- white outline around black text
         fontWeight  = "bold",
         fontSize    = "11px"
       )))
})

right_nodes <- lapply(seq_len(nrow(debt_shares)), function(i) {
  r <- debt_shares[i, ]
  list(id         = paste0(r$debt_id, "_dst"),
       name       = sprintf("%s — %.1f%%", r$debt_label, r$row_pct),
       column     = 1,
       color      = sec_col(r$debt_sec),
       dataLabels = list(style = list(
         color       = "black",
         textOutline = "3px white",   # <-- white outline around black text
         fontWeight  = "bold",
         fontSize    = "11px"
       )))
})

nodes_all <- c(left_nodes, right_nodes)
stopifnot("Duplicate node IDs" =
            length(unique(vapply(nodes_all, `[[`, "", "id"))) == length(nodes_all))

# Scale link opacity by flow size: large flows bold, small flows faint
max_val <- max(flows$value)

links_all <- flows %>%
  mutate(
    opacity = 0.08 + 0.25 * (value / max_val),   # was 0.15 + 0.65 — much lighter range
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

# links_all <- flows %>%
#   mutate(
#     opacity = 0.15 + 0.65 * (value / max_val),
#     op_hex  = toupper(as.hexmode(round(opacity * 255))),
#     op_hex  = ifelse(nchar(op_hex) == 1, paste0("0", op_hex), op_hex)
#   ) %>%
#   transmute(
#     from   = paste0(cred_sec, "_src"),
#     to     = paste0(debt_id,  "_dst"),
#     weight = value,
#     color  = paste0(sec_col(cred_sec), op_hex)
#   ) %>%
#   mutate(across(c(from, to, color), as.character),
#          weight = as.numeric(weight)) %>%
#   filter(is.finite(weight), weight > 0)

## ── 8. PLOT ──────────────────────────────────────────────────────────────────

p <- highchart() %>%
  hc_add_dependency("modules/sankey") %>%
  hc_size(width = 1000, height = 560) %>%
  hc_add_series(
    type        = "sankey",
    data        = highcharter::list_parse2(links_all),
    nodes       = nodes_all,
    keys        = c("from", "to", "weight"),
    dataLabels  = list(enabled = TRUE,
                       style   = list(color       = "grey",
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
                  '</b><br/>Value: ' + bn + ' EUR bn' +
                  '<br/>Share of total: ' + pct + '%';
         }"
      ))
    )
  ) %>%
  hc_title(text = sprintf("Who-to-Whom: %s — %s | All instruments",
                          TARGET_AREA, TARGET_TIME)) %>%
  hc_subtitle(text = paste0(
    "Node % = share of total assets (domestic + RoW)  |  ",
    "Link colour follows creditor sector  |  ",
    "Flows below ", MIN_FLOW_PCT, "% hidden"
  )) %>%
  hc_caption(text = paste0(
    "Source: Finflows 3.0 (", TARGET_TIME, " vs ", BASE_TIME, " changes). ",
    "Non-aggregate sectors only."
  )) %>%
  hc_add_theme(ec_theme) %>%
  hc_exporting(enabled  = TRUE,
               filename = paste0("wtw_sankey_", TARGET_AREA, "_", TARGET_TIME))

p

# htmlwidgets::saveWidget(p, "wtw_sankey.html", selfcontained = TRUE)
# browseURL("wtw_sankey.html")
