library(MDstats); 

# Set data directory
#data_dir= file.path(getwd(),'data')
#if (!exists("data_dir")) data_dir = '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/data'
if (!exists("data_dir")) data_dir = '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/data'
source('\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/routines/utilities.R')
gc()

zerofiller=function(x, fillscalar=0){
  temp=copy(x)
  temp[onlyna=TRUE]=fillscalar
  temp
}


## load data
library(MDstats); 

# Set data directory
#data_dir= file.path(getwd(),'data')
#if (!exists("data_dir")) data_dir = '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/data'
if (!exists("data_dir")) data_dir = '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/data'
source('\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/routines/utilities.R')
gc()

zerofiller=function(x, fillscalar=0){
  temp=copy(x)
  temp[onlyna=TRUE]=fillscalar
  temp
}


## load data
aa=readRDS(file.path(data_dir,'aa_iip_agg.rds')); gc()
#ll=readRDS(file.path(data_dir,'ll_iip_agg.rds')); gc()

# S1M assets
as1t=aa[.EA20+DE+AT+FR+NL+IE+ES+BE+SI+PT+FI+IT+LT+CY+LU+LV+SK+EE+GR+HR+MT+CZ+HU+SE+DK+RO+BG+PL.S1M+S1.S12+S11+S13+S1M+S1.LE._T.2024q4.W2+WRL_REST]-aa[.EA20+DE+AT+FR+NL+IE+ES+BE+SI+PT+FI+IT+LT+CY+LU+LV+SK+EE+GR+HR+MT+CZ+HU+SE+DK+RO+BG+PL.S1M+S1.S12+S11+S13+S1M+S1.LE._T.2023q4.W2+WRL_REST]
as1t[F51M.EA20...W2, usenames=TRUE,onlyna=TRUE]=zerofiller(as1t[F51M.DE...W2])+
  zerofiller(as1t[F51M.AT...W2])+zerofiller(as1t[F51M.FR...W2])+zerofiller(as1t[F51M.NL...W2])+
  zerofiller(as1t[F51M.IE...W2])+zerofiller(as1t[F51M.ES...W2])+zerofiller(as1t[F51M.BE...W2])+
  zerofiller(as1t[F51M.SI...W2])+zerofiller(as1t[F51M.PT...W2])+zerofiller(as1t[F51M.FI...W2])+
  zerofiller(as1t[F51M.IT...W2])+zerofiller(as1t[F51M.LT...W2])+zerofiller(as1t[F51M.CY...W2])+
  zerofiller(as1t[F51M.LU...W2])+zerofiller(as1t[F51M.LV...W2])+zerofiller(as1t[F51M.SK...W2])+
  zerofiller(as1t[F51M.EE...W2])+zerofiller(as1t[F51M.GR...W2])+zerofiller(as1t[F51M.HR...W2])+
  zerofiller(as1t[F51M.MT...W2])



as1t[F6.EA20...W2, usenames=TRUE,onlyna=TRUE]=zerofiller(as1t[F6.DE...W2])+
  zerofiller(as1t[F6.AT...W2])+zerofiller(as1t[F6.FR...W2])+zerofiller(as1t[F6.NL...W2])+
  zerofiller(as1t[F6.IE...W2])+zerofiller(as1t[F6.ES...W2])+zerofiller(as1t[F6.BE...W2])+
  zerofiller(as1t[F6.SI...W2])+zerofiller(as1t[F6.PT...W2])+zerofiller(as1t[F6.FI...W2])+
  zerofiller(as1t[F6.IT...W2])+zerofiller(as1t[F6.LT...W2])+zerofiller(as1t[F6.CY...W2])+
  zerofiller(as1t[F6.LU...W2])+zerofiller(as1t[F6.LV...W2])+zerofiller(as1t[F6.SK...W2])+
  zerofiller(as1t[F6.EE...W2])+zerofiller(as1t[F6.GR...W2])+zerofiller(as1t[F6.HR...W2])+
  zerofiller(as1t[F6.MT...W2])

as1t[FT.EA20..., usenames=TRUE,onlyna=TRUE]=zerofiller(as1t[F2M.EA20...])+
  zerofiller(as1t[F3.EA20...])+zerofiller(as1t[F4.EA20...])+zerofiller(as1t[F511.EA20...])+
  zerofiller(as1t[F51M.EA20...])+zerofiller(as1t[F52.EA20...])+zerofiller(as1t[F6.EA20...])

as1t[FT.EA20..., usnemaes=TRUE,onlyna=TRUE]=zerofiller(as1t[F2M.EA20...])+
  zerofiller(as1t[F3.EA20...])+zerofiller(as1t[F4.EA20...])+zerofiller(as1t[F511.EA20...])+
  zerofiller(as1t[F51M.EA20...])+zerofiller(as1t[F52.EA20...])+zerofiller(as1t[F6.EA20...])

# as2t=aa[.CZ+HU+SE+DK+RO+BG.S1M+S1.S12+S11+S13+S1M+S1.LE._T.2024q4.W2+WRL_REST]
# 
as1t[.EU27_2020..., usnemaes=TRUE,onlyna=TRUE]=zerofiller(as1t[.EA20...])+zerofiller(as1t[.CZ...])+
  zerofiller(as1t[.HU...])+zerofiller(as1t[.SE...])+zerofiller(as1t[.DK...])+
  zerofiller(as1t[.RO...])+zerofiller(as1t[.BG...])++zerofiller(as1t[.PL...])

as1t[FT.EU27_2020..., usnemaes=TRUE,onlyna=TRUE]=zerofiller(as1t[F2M.EU27_2020...])+
  zerofiller(as1t[F3.EU27_2020...])+zerofiller(as1t[F4.EU27_2020...])+zerofiller(as1t[F511.EU27_2020...])+
  zerofiller(as1t[F51M.EU27_2020...])+zerofiller(as1t[F52.EU27_2020...])+zerofiller(as1t[F6.EU27_2020...])

#as1m=as1t[FT.EA20.S1M+S1.S12+S11+S13+S1M+S1.W2+WRL_REST]
as1m=as1t[FT.EU27_2020.S1M+S1.S12+S11+S13+S1M+S1.W2+WRL_REST]

# S12 assets
as12s=aa[.EA20+CZ+HU+SE+DK+RO+BG+PL.S12+S1.S12K+S12Q+S12O+S124+S11+S13+S1M+S1.LE..2024q4.W2+WRL_REST]-aa[.EA20+CZ+HU+SE+DK+RO+BG+PL.S12+S1.S12K+S12Q+S12O+S124+S11+S13+S1M+S1.LE..2023q4.W2+WRL_REST]
as12s[Fx7.EU27_2020...., usnemaes=TRUE ,onlyna=TRUE]=zerofiller(as12s[Fx7.EA20....])+zerofiller(as12s[Fx7.CZ....])+
  zerofiller(as12s[Fx7.HU....])+zerofiller(as12s[Fx7.SE....])+zerofiller(as12s[Fx7.DK....])+
  zerofiller(as12s[Fx7.RO....])+zerofiller(as12s[Fx7.BG....])+zerofiller(as12s[Fx7.PL....])


library(dplyr)
library(tidyr)
library(highcharter)

## --- LABEL MAPS --------------------------------------------------------------
sector_labels <- c(
  "S1"   = "Total",
  "S11"  = "NFC",
  "S12"  = "Financial Corporations",
  "S13"  = "Government",
  "S1M"  = "Households",
  "S12K" = "Banks",
  "S12Q" = "Insurers & Pension Funds",
  "S12O" = "Other Financial",
  "S124" = "Investment Funds"
)
area_labels <- c("W2" = "Domestic", "WRL_REST" = "Rest of World")
ren <- function(x, map) ifelse(x %in% names(map), map[x], x)

ec_theme <- hc_theme(
  chart = list(backgroundColor="#FFF", style=list(fontFamily="Arial, Helvetica, sans-serif")),
  title = list(align="left", style=list(fontSize="22px", fontWeight="bold", color="black")),
  subtitle = list(align="left", style=list(fontSize="13px", color="black")),
  caption = list(align="left", style=list(fontSize="11px", color="black")),
  legend = list(enabled = FALSE),
  tooltip = list(backgroundColor="#FFF", borderColor="#CCC", style=list(color="black")),
  plotOptions = list(sankey = list(dataLabels = list(style = list(color="black", textOutline="none", fontWeight="bold"))))
)

# ======================= 1) Households (S1M) immediate holdings ==============
dfeat <- as.data.frame(as1m)

df_s1m_all <- dfeat %>%
  filter(REF_SECTOR == "S1M") %>%
  transmute(
    to_sec   = as.character(COUNTERPART_SECTOR),
    to_area  = as.character(COUNTERPART_AREA),
    to_id    = paste0(to_sec, "_", to_area),
    to_label = paste(ren(to_sec, sector_labels), ren(to_area, area_labels), sep = " · "),
    weight   = as.numeric(obs_value)
  ) %>%
  filter(is.finite(weight), weight > 0, to_id != "S1_W2")   # drop S1 · W2 everywhere


# S1M → S12 (authoritative)
s1m_into_S12 <- df_s1m_all %>% filter(to_sec == "S12") %>% summarise(w = sum(weight)) %>% pull(w)
s1m_into_S12 <- ifelse(length(s1m_into_S12)==0 || is.na(s1m_into_S12), 0, s1m_into_S12)

# Direct non-S12 holdings (grey leg)
df_direct <- df_s1m_all %>%
  filter(to_sec != "S12") %>%
  group_by(to_id, to_label) %>%
  summarise(weight = sum(weight), .groups="drop")

# Total HH assets leaving the left node
total_hh_assets <- sum(df_direct$weight) + s1m_into_S12

# ======================= 2) S12 asset composition (for via leg) ==============
dfa_s12 <- as.data.frame(as12s)

df_s12_assets_all <- dfa_s12 %>%
  filter(REF_SECTOR == "S12") %>%
  transmute(
    to_sec   = as.character(COUNTERPART_SECTOR),
    to_area  = as.character(COUNTERPART_AREA),
    to_id    = paste0(to_sec, "_", to_area),
    to_label = paste(ren(to_sec, sector_labels), ren(to_area, area_labels), sep=" · "),
    weight   = as.numeric(obs_value)
  ) %>%
  filter(is.finite(weight), weight > 0) %>%
  group_by(to_id, to_label) %>% summarise(weight = sum(weight), .groups="drop")

# Exclude S1·W2 from via path and RENORMALISE; conservative fallback if empty
exclude_ids <- c("S1_W2")
comp_try <- df_s12_assets_all %>% filter(!to_id %in% exclude_ids)
Z_try    <- sum(comp_try$weight)
if (Z_try > 0) {
  comp <- comp_try %>% mutate(share = weight / Z_try)
} else {
  comp <- df_s12_assets_all %>% mutate(share = weight / sum(weight))
}

# Flow-conserving via-S12 outflows (sum = s1m_into_S12)
df_via_s12 <- comp %>%
  transmute(to_id, to_label, weight = share * s1m_into_S12) %>%
  filter(weight > 0)

# ======================= 3) Middle shares (S12 + direct mids) ================
mid_totals <- bind_rows(
  tibble(mid_id="S12_mid",
         mid_label = ren("S12", sector_labels),
         weight = s1m_into_S12,
         color  = "#FFD724"),                    # yellow
  df_direct %>%
    transmute(mid_id = paste0(to_id, "_mid"),
              mid_label = to_label,
              weight = weight,
              color  = "#A3BCE0")                # grey
) %>%
  mutate(share = ifelse(total_hh_assets > 0, weight / total_hh_assets, 0))

# ======================= 4) Right-hand ordering & shares ======================
# Build final flows to the right column
right_flows <- bind_rows(
  df_via_s12  %>% transmute(from="S12_mid", to_id, to_label, weight, via="via"),
  df_direct   %>% transmute(from=paste0(to_id, "_mid"), to_id, to_label, weight, via="direct")
)

# Desired order: Domestic first, then RoW; within area: financials first, then NFC, Gov, HH, Total
sec_order  <- c("S124","S12K","S12Q","S12O", "S11","S13","S1M","S1")
area_order <- c("W2","WRL_REST")

right_totals <- right_flows %>%
  group_by(to_id, to_label) %>%
  summarise(weight = sum(weight), .groups = "drop") %>%
  mutate(share = ifelse(total_hh_assets > 0, weight / total_hh_assets, 0),
         sec  = sub("_.*$", "", to_id),
         area = sub("^[^_]*_", "", to_id),
         area_rank = match(area, area_order),
         sec_rank  = match(sec,  sec_order),
         area_rank = ifelse(is.na(area_rank), 99, area_rank),
         sec_rank  = ifelse(is.na(sec_rank),  99, sec_rank)) %>%
  arrange(area_rank, sec_rank, desc(share))

# ======================= 5) Nodes ============================================
left_node <- list(list(
  id="S1M_src", name="Households", column=0, color="#A3BCE0",
  dataLabels=list(style=list(color="black", textOutline="none"))
))

mid_nodes <- lapply(seq_len(nrow(mid_totals)), function(i) {
  m <- mid_totals[i, ]
  list(
    id     = m$mid_id,
    name   = sprintf("%s — %.1f%% ", m$mid_label, 100 * m$share),
    column = 1,
    color  = m$color,
    dataLabels = list(style = list(color="black", textOutline="none"))
  )
})

right_nodes <- lapply(seq_len(nrow(right_totals)), function(i) {
  rw <- right_totals[i, ]
  list(
    id     = paste0(rw$to_id, "_dst"),
    name   = sprintf("%s — %.1f%% ", rw$to_label, 100 * rw$share),
    column = 2,
    color  = "#A3BCE0",
    dataLabels = list(style = list(color = "black", textOutline = "none"))
  )
})



nodes_all <- c(left_node, mid_nodes, right_nodes)

# ======================= 6) Links ============================================
link_left_S12 <- tibble(
  from="S1M_src", to="S12_mid", weight=s1m_into_S12,
  color="rgba(255,215,36,0.90)"
) %>% filter(weight > 0)

link_left_direct <- df_direct %>%
  transmute(from="S1M_src", to=paste0(to_id, "_mid"),
            weight, color="rgba(120,120,120,0.35)")

links_via <- right_flows %>%
  filter(via == "via") %>%
  transmute(from="S12_mid", to=paste0(to_id, "_dst"),
            weight, color="rgba(255,215,36,0.90)")

links_dir <- right_flows %>%
  filter(via == "direct") %>%
  transmute(from=paste0(to_id, "_mid"), to=paste0(to_id, "_dst"),
            weight, color="rgba(120,120,120,0.35)")

links_all <- bind_rows(link_left_S12, link_left_direct, links_via, links_dir) %>%
  mutate(
    from   = as.character(from),
    to     = as.character(to),
    weight = as.numeric(weight),
    color  = as.character(color)
  ) %>%
  filter(is.finite(weight), weight > 0)

# --- Compute % shares from the FINAL flows (links_all) ------------------------
# 1) Right labels lookup
right_labels_df <- bind_rows(
  df_via_s12  %>% transmute(to_id, to_label),
  df_direct   %>% transmute(to_id, to_label)
) %>% distinct()

# 2) Shares from final links that end on the right
right_shares <- links_all %>%
  dplyr::filter(grepl("_dst$", to)) %>%
  mutate(to_id = sub("_dst$", "", to)) %>%
  group_by(to_id) %>%
  summarise(weight = sum(weight), .groups = "drop") %>%
  mutate(share = weight / sum(weight)) %>%
  left_join(right_labels_df, by = "to_id")

# 3) Order: Domestic first, then RoW; within area: financials first
sec_order  <- c("S124","S12K","S12Q","S12O","S11","S13","S1M","S1")
area_order <- c("W2","WRL_REST")

right_shares <- right_shares %>%
  mutate(sec  = sub("_.*$", "", to_id),
         area = sub("^[^_]*_", "", to_id),
         area_rank = match(area, area_order),
         sec_rank  = match(sec,  sec_order),
         area_rank = ifelse(is.na(area_rank), 99, area_rank),
         sec_rank  = ifelse(is.na(sec_rank),  99, sec_rank)) %>%
  arrange(area_rank, sec_rank, desc(share))


# 4) Rebuild right-hand nodes WITH share in the label (and only once)
# right_nodes <- lapply(seq_len(nrow(right_shares)), function(i) {
#   rw <- right_shares[i, ]
#   list(
#     id     = paste0(rw$to_id, "_dst"),
#     name   = sprintf("%s — %.1f%% ", rw$to_label, 100 * rw$share),
#     column = 2,
#     color  = "#A3BCE0",
#     dataLabels = list(style = list(color = "black", textOutline = "none"))
#   )
# })

right_nodes <- lapply(seq_len(nrow(right_shares)), function(i) {
  rw <- right_shares[i, ]
  list(
    id     = paste0(rw$to_id, "_dst"),
    name   = sprintf("%s — %.1f%% ", rw$to_label, 100 * rw$share),
    column = 2,
    color  = "#A3BCE0",
    dataLabels = list(
      enabled = TRUE,
      align   = "left",   # <— push label to the right of node
      x       = 10,       # <— horizontal offset (pixels)
      crop    = FALSE,    # <— do not crop outside plot area
      overflow= "allow",  # <— allow drawing outside
      style   = list(color = "black", textOutline = "none")
    )
  )
})

# 5) Assemble nodes once (left + middle (with your mid_totals) + RIGHT just built)
left_node <- list(list(
  id="S1M_src", name="Households' financial savings", column=0, color="#A3BCE0",
  dataLabels=list(align = "left",
                  x = -10,
                  crop = FALSE,
                  overflow = "allow",
                  style=list(color="black", textOutline="none"))
))

mid_nodes <- lapply(seq_len(nrow(mid_totals)), function(i) {
  m <- mid_totals[i, ]
  list(
    id     = m$mid_id,
    name   = sprintf("%s — %.1f%% ", m$mid_label, 100 * m$share),
    column = 1,
    color  = m$color,
    dataLabels = list(style = list(color="black", textOutline="none"))
  )
})

# --- MIDDLE (left → mid) shares from FINAL links -----------------------------
# 1) Label lookup for mid nodes (S12 + each direct mid)
mid_labels_df <- bind_rows(
  tibble(mid_id = "S12_mid", mid_label = ren("S12", sector_labels)),
  df_direct %>%
    distinct(to_id, to_label) %>%
    transmute(mid_id = paste0(to_id, "_mid"),
              mid_label = to_label)
) %>% distinct()

# 2) Pull the flows that land on mid nodes from links_all
mid_shares <- links_all %>%
  dplyr::filter(to == "S12_mid" | grepl("_mid$", to)) %>%
  group_by(to) %>%
  summarise(weight = sum(weight), .groups = "drop") %>%
  mutate(share = weight / sum(weight),
         mid_id = to) %>%
  select(mid_id, weight, share) %>%
  left_join(mid_labels_df, by = "mid_id")

# 3) Rebuild mid_nodes with the % label
mid_nodes <- lapply(seq_len(nrow(mid_shares)), function(i) {
  m <- mid_shares[i, ]
  # color: S12 in yellow, direct mids in grey
  col <- if (m$mid_id == "S12_mid") "#FFD724" else "#A3BCE0"
  list(
    id     = m$mid_id,
    name   = sprintf("%s — %.1f%% ", m$mid_label, 100 * m$share),
    column = 1,
    color  = col,
    dataLabels = list(style = list(color="black", textOutline="none"))
  )
})

nodes_all <- c(left_node, mid_nodes, right_nodes)

# 6) Safety: ensure node IDs are unique (prevents Highcharts from using old labels)
stopifnot(length(unique(vapply(nodes_all, `[[`, "", "id"))) == length(nodes_all))

# ======================= 7) Column captions (annotations) =====================
col_captions <- list(
  list(labels = list(list(
    text = "Direct holdings",
    x = 360, y = 18, backgroundColor = "rgba(0,0,0,0)",
    style = list(color = "black", fontWeight = "bold")
  ))),
  list(labels = list(list(
    text = "After transformation",
    x = 780, y = 18, backgroundColor = "rgba(0,0,0,0)",
    style = list(color = "black", fontWeight = "bold")
  )))
)

# ======================= 8) Plot =============================================
highchart() %>%
  hc_add_dependency("modules/sankey") %>%
  hc_chart(spacingRight = 240) %>%
  hc_plotOptions(
    series = list(
      clip = FALSE,                   # <— don’t clip series to plot area
      dataLabels = list(
        crop = FALSE, overflow = "allow"  # global safety
      )
    ),
    sankey = list(
      dataLabels = list(
        style = list(color = "black", textOutline = "none")
      )
    )
  ) %>%
  hc_size(width = 1000, height = 560) %>%
  hc_add_series(
    type  = "sankey",
    data  = highcharter::list_parse2(links_all),
    nodes = nodes_all,
    keys  = c("from","to","weight"),
    dataLabels = list(enabled=TRUE, style=list(color="black", textOutline="none", fontWeight="bold")),
    nodeWidth   = 22,
    nodePadding = 12,
    curveFactor = 0.28,
    borderWidth = 0,
    linkOpacity = 1,
    tooltip = list(
      useHTML = TRUE,
      pointFormatter = JS(
        "function(){ 
           var w = this.weight;
           return '<b>' + this.from + '</b> → <b>' + this.to +
                  '</b><br/>Value: ' + (w/1000).toFixed(1) + ' bn';
         }")
    )
  ) %>%
  hc_title(text = " ") %>%
  hc_subtitle(text = "Blue = direct holdings; Yellow = holdings via financial sector ") %>%
  hc_caption(text = " ") %>%
  hc_add_theme(ec_theme) %>%
  hc_annotations(col_captions) %>%
  hc_exporting(enabled = TRUE, filename = "s1m_three_column_with_lookthrough")