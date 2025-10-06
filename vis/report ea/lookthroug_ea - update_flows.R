library(MDstats); 

# Set data directory
#data_dir= file.path(getwd(),'data')
if (!exists("data_dir")) data_dir = '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/data/'
source('\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/routines/utilities.R')
gc()


## load data
aa=readRDS(file.path(data_dir,'aa_iip_agg.rds')); gc()
ll=readRDS(file.path(data_dir,'ll_iip_agg.rds')); gc()





# S1M assets
#as1m=aa[.EA20.S1M+S1.S12+S12K+S12Q+S12O+S12R+S124+S11+S13+S1M+S1.LE._T.2025q1.W2+WRL_REST]
#as1m=aa[Fx7.EA20.S1M+S1.S12+S11+S13+S1M+S1.LE._T.2025q1.W2+WRL_REST]
as1m=aa[Fx7.EA20.S1M+S1.S12+S11+S13+S1M+S1.LE._T.2024q4.W2+WRL_REST]-aa[Fx7.EA20.S1M+S1.S12+S11+S13+S1M+S1.LE._T.2023q4.W2+WRL_REST]
# S12 assets
#as12s=aa[.EA20.S1+S12+S12K+S12R+S12Q+S12O+S124.S12K+S12Q+S12O+S124S12R+S11+S13+S1M+S1.LE._T.2025q1.W2+WRL_REST]
as12s=aa[Fx7.EA20.S1+S12.S12K+S12Q+S12O+S124+S11+S13+S1M+S1.LE._T.2024q4.W2+WRL_REST]-aa[Fx7.EA20.S1+S12.S12K+S12Q+S12O+S124+S11+S13+S1M+S1.LE._T.2023q4.W2+WRL_REST]
# S12 liabilities
#li12s=ll[.W2+WRL_REST.S12+S12K+S12Q+S12O+S124+S12R+S11+S13+S1M+S1.S1+S12+S12K+S121+S12T+S12Q+S12O+S124+S12R.LE._T.2025q1.EA20]
#li12s=ll[Fx7.W2+WRL_REST.S12K+S12Q+S12O+S124+S11+S13+S1M+S1.S1+S12.LE._T.2025q1.EA20]

# ##share of EA S1M assets in S12 liabilities
# assets=as1m[Fx7.S1M.S12.W2]
# #liab=ll[Fx7.W0.S1.S12+S12K+S121+S12T+S12Q+S12O+S124+S12R.LE._T.2025q1.EA20]
# liab=ll[Fx7.W2.S1M.S12.LE._T.2025q1.EA20]

library(dplyr)
library(tidyr)
library(highcharter)

## --- LABEL MAPS --------------------------------------------------------------
sector_labels <- c(
  "S1"   = "Total Economy",
  "S11"  = "NFC",                     # Non-financial corporations
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

## --- THEME (all fonts black) -------------------------------------------------
ec_theme <- hc_theme(
  chart = list(backgroundColor="#FFF", style=list(fontFamily="Arial, Helvetica, sans-serif")),
  title = list(align="left", style=list(fontSize="18px", fontWeight="bold", color="black")),
  subtitle = list(align="left", style=list(fontSize="11px", color="black")),
  caption = list(align="left", style=list(fontSize="10px", color="black")),
  legend = list(enabled = FALSE),
  tooltip = list(backgroundColor="#FFF", borderColor="#CCC", style=list(color="black")),
  plotOptions = list(sankey = list(dataLabels = list(style = list(color="black", textOutline="none", fontWeight="bold"))))
)

## --- 1) Households (S1M) immediate holdings ---------------------------------
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

# S1M → S12 aggregate (authoritative amount from S1M assets)
s1m_into_S12 <- df_s1m_all %>%
  filter(to_sec == "S12") %>%
  summarise(w = sum(weight, na.rm = TRUE)) %>% pull(w)
s1m_into_S12 <- ifelse(length(s1m_into_S12)==0 || is.na(s1m_into_S12), 0, s1m_into_S12)

# Direct non-S12 holdings (grey leg)
df_direct <- df_s1m_all %>%
  filter(to_sec != "S12") %>%
  group_by(to_id, to_label) %>%
  summarise(weight = sum(weight), .groups="drop")

## --- 2) S12 asset composition (aggregate S12) --------------------------------
# We IGNORE liabilities. We only use S12's asset mix to split the S1M→S12 amount.
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

# Apply via-path exclusions and RENORMALISE shares
exclude_ids <- c("S1_W2")   # add more ids if needed
comp_try <- df_s12_assets_all %>% filter(!to_id %in% exclude_ids)
Z_try    <- sum(comp_try$weight)

if (Z_try > 0) {
  comp <- comp_try %>% mutate(share = weight / Z_try)
} else {
  # if exclusions wipe out everything, fall back to using the full mix (conservative)
  comp <- df_s12_assets_all %>% mutate(share = weight / sum(weight))
}

# FLOW-CONSERVING look-through: allocate the ACTUAL S1M→S12 amount
df_via_s12 <- comp %>%
  transmute(to_id, to_label, weight = share * s1m_into_S12) %>%
  filter(weight > 0)

## --- 3) Nodes (3 columns) ----------------------------------------------------
left_node <- list(list(
  id="S1M_src", name="Households (S1M)", column=0, color="#4C70A7",
  dataLabels=list(style=list(color="black", textOutline="none"))
))

mid_nodes <- c(
  list(list(id="S12_mid", name=ren("S12", sector_labels), column=1, color="#FFD724",
            dataLabels=list(style=list(color="black", textOutline="none")))),
  # one mid for each direct non-S12 target
  lapply(seq_len(nrow(df_direct %>% distinct(to_id, to_label))), function(i) {
    dn <- df_direct %>% distinct(to_id, to_label) %>% slice(i)
    list(id=paste0(dn$to_id, "_mid"), name=dn$to_label, column=1, color="#D9D9D9",
         dataLabels=list(style=list(color="black", textOutline="none")))
  })
)

right_targets <- bind_rows(
  df_via_s12 %>% transmute(to_id, to_label),
  df_direct   %>% transmute(to_id, to_label)
) %>% distinct()

right_nodes <- lapply(seq_len(nrow(right_targets)), function(i) {
  rt <- right_targets[i,]
  list(id=paste0(rt$to_id, "_dst"), name=rt$to_label, column=2, color="#D9D9D9",
       dataLabels=list(style=list(color="black", textOutline="none")))
})

nodes_all <- c(left_node, mid_nodes, right_nodes)

## --- 4) Links (yellow out = blue in, by construction) ------------------------
# Left → S12 (blue inflow)
link_left_S12 <- tibble(
  from="S1M_src", to="S12_mid", weight=s1m_into_S12,
  color="rgba(31,111,235,0.80)"
) %>% filter(weight > 0)

# S12 → right (yellow outflow; totals == s1m_into_S12)
link_S12_to_right <- df_via_s12 %>%
  transmute(from="S12_mid", to=paste0(to_id, "_dst"),
            weight=weight, color="rgba(31,111,235,0.80)")

# Left → direct mids (grey)
link_left_direct <- df_direct %>%
  transmute(from="S1M_src", to=paste0(to_id, "_mid"),
            weight, color="rgba(150,150,150,0.35)")

# Direct mids → right (grey passthrough)
link_direct_to_right <- df_direct %>%
  transmute(from=paste0(to_id, "_mid"), to=paste0(to_id, "_dst"),
            weight, color="rgba(150,150,150,0.35)")

links_all <- bind_rows(link_left_S12, link_left_direct, link_S12_to_right, link_direct_to_right) %>%
  mutate(
    from   = as.character(from),
    to     = as.character(to),
    weight = as.numeric(weight),
    color  = as.character(color)
  ) %>%
  filter(is.finite(weight), weight > 0)

## --- Invariant check ---------------------------------------------------------
stopifnot(abs(sum(link_S12_to_right$weight) - s1m_into_S12) < 1e-6)


# # === Shares for right-hand (final) nodes ======================================
# 1) Build a lookup of right-node labels once
right_labels_df <- bind_rows(
  df_via_s12  %>% transmute(to_id, to_label),
  df_direct   %>% transmute(to_id, to_label)
) %>% distinct()

# 2) Compute shares from the final flows that reach the right side
right_shares <- links_all %>%
  dplyr::filter(grepl("_dst$", to)) %>%
  mutate(to_id = sub("_dst$", "", to)) %>%
  group_by(to_id) %>%
  summarise(weight = sum(weight), .groups = "drop") %>%
  mutate(share = weight / sum(weight)) %>%
  left_join(right_labels_df, by = "to_id")

# 3) Rebuild right-hand nodes using the share labels
right_nodes <- lapply(seq_len(nrow(right_shares)), function(i) {
  rw <- right_shares[i, ]
  list(
    id     = paste0(rw$to_id, "_dst"),
    name   = sprintf("%s — %.1f%% of HH assets", rw$to_label, 100 * rw$share),
    column = 2,
    color  = "#D9D9D9",
    dataLabels = list(style = list(color = "black", textOutline = "none"))
  )
})

# 4) Reassemble nodes_all exactly once (so we don't keep an old version)
left_node <- list(list(
  id="S1M_src", name="Households (S1M)", column=0, color="#4C70A7",
  dataLabels=list(style=list(color="black", textOutline="none"))
))

mid_nodes <- c(
  list(list(id="S12_mid", name=ren("S12", sector_labels), column=1, color="#FFD724",
            dataLabels=list(style=list(color="black", textOutline="none")))),
  lapply(seq_len(nrow(df_direct %>% distinct(to_id, to_label))), function(i) {
    dn <- df_direct %>% distinct(to_id, to_label) %>% slice(i)
    list(id=paste0(dn$to_id, "_mid"), name=dn$to_label, column=1, color="#D9D9D9",
         dataLabels=list(style=list(color="black", textOutline="none")))
  })
)

nodes_all <- c(left_node, mid_nodes, right_nodes)



## --- 5) Plot -----------------------------------------------------------------
highchart() %>%
  hc_add_dependency("modules/sankey") %>%
  hc_size(width = 900, height = 520) %>%
  hc_add_series(
    type  = "sankey",
    data  = highcharter::list_parse2(links_all),   # df → list of lists
    nodes = nodes_all,                             # list-of-lists as-is
    keys  = c("from","to","weight"),
    dataLabels = list(enabled=TRUE, style=list(color="black", textOutline="none", fontWeight="bold")),
    nodeWidth   = 26, nodePadding = 14, curveFactor = 0.35,
    borderWidth = 0, linkOpacity = 1
  ) %>%
  hc_title(text = "Households’ financial assets flows, direct vs via financial sector ") %>%
  hc_subtitle(text = "EA20, 2024 (Fx7). Flows=change in stocks, Yellow = holdings via fin. sector transformation; Grey = direct holdings") %>%
  hc_caption(text = "Source: ECB/Eurostat; DG ECFIN calculations") %>%
  hc_add_theme(ec_theme) %>%
  hc_exporting(enabled = TRUE, filename = "s1m_three_column_with_lookthrough")


##########################################
#### FLOWS ####
##########################################


# S1M assets
#as1m=aa[.EA20.S1M+S1.S12+S12K+S12Q+S12O+S12R+S124+S11+S13+S1M+S1.LE._T.2025q1.W2+WRL_REST]
as1m=aa[Fx7.EA20.S1M+S1.S12+S11+S13+S1M+S1.F._T.y2024q1:.W2+WRL_REST]
#as1m=aa[Fx7.EA20.S1M+S1.S12+S11+S13+S1M+S1.LE._T.2024q4.W2+WRL_REST]-aa[Fx7.EA20.S1M+S1.S12+S11+S13+S1M+S1.LE._T.2023q4.W2+WRL_REST]
# S12 assets
as12s=aa[.EA20.S1+S12+S12K+S12R+S12Q+S12O+S124.S12K+S12Q+S12O+S124S12R+S11+S13+S1M+S1.F._T.y2024q1:.W2+WRL_REST]
#as12s=aa[Fx7.EA20.S1+S12.S12K+S12Q+S12O+S124+S11+S13+S1M+S1.LE._T.2024q4.W2+WRL_REST]-aa[Fx7.EA20.S1+S12.S12K+S12Q+S12O+S124+S11+S13+S1M+S1.LE._T.2023q4.W2+WRL_REST]
# S12 liabilities
#li12s=ll[.W2+WRL_REST.S12+S12K+S12Q+S12O+S124+S12R+S11+S13+S1M+S1.S1+S12+S12K+S121+S12T+S12Q+S12O+S124+S12R.LE._T.2025q1.EA20]
#li12s=ll[Fx7.W2+WRL_REST.S12K+S12Q+S12O+S124+S11+S13+S1M+S1.S1+S12.LE._T.2025q1.EA20]

# ##share of EA S1M assets in S12 liabilities
# assets=as1m[Fx7.S1M.S12.W2]
# #liab=ll[Fx7.W0.S1.S12+S12K+S121+S12T+S12Q+S12O+S124+S12R.LE._T.2025q1.EA20]
# liab=ll[Fx7.W2.S1M.S12.LE._T.2025q1.EA20]

library(dplyr)
library(tidyr)
library(highcharter)

## --- LABEL MAPS --------------------------------------------------------------
sector_labels <- c(
  "S1"   = "Total Economy",
  "S11"  = "NFC",                     # Non-financial corporations
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

## --- THEME (all fonts black) -------------------------------------------------
ec_theme <- hc_theme(
  chart = list(backgroundColor="#FFF", style=list(fontFamily="Arial, Helvetica, sans-serif")),
  title = list(align="left", style=list(fontSize="18px", fontWeight="bold", color="black")),
  subtitle = list(align="left", style=list(fontSize="11px", color="black")),
  caption = list(align="left", style=list(fontSize="10px", color="black")),
  legend = list(enabled = FALSE),
  tooltip = list(backgroundColor="#FFF", borderColor="#CCC", style=list(color="black")),
  plotOptions = list(sankey = list(dataLabels = list(style = list(color="black", textOutline="none", fontWeight="bold"))))
)

## --- 1) Households (S1M) immediate holdings ---------------------------------
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

# S1M → S12 aggregate (authoritative amount from S1M assets)
s1m_into_S12 <- df_s1m_all %>%
  filter(to_sec == "S12") %>%
  summarise(w = sum(weight, na.rm = TRUE)) %>% pull(w)
s1m_into_S12 <- ifelse(length(s1m_into_S12)==0 || is.na(s1m_into_S12), 0, s1m_into_S12)

# Direct non-S12 holdings (grey leg)
df_direct <- df_s1m_all %>%
  filter(to_sec != "S12") %>%
  group_by(to_id, to_label) %>%
  summarise(weight = sum(weight), .groups="drop")

## --- 2) S12 asset composition (aggregate S12) --------------------------------
# We IGNORE liabilities. We only use S12's asset mix to split the S1M→S12 amount.
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

# Apply via-path exclusions and RENORMALISE shares
exclude_ids <- c("S1_W2")   # add more ids if needed
comp_try <- df_s12_assets_all %>% filter(!to_id %in% exclude_ids)
Z_try    <- sum(comp_try$weight)

if (Z_try > 0) {
  comp <- comp_try %>% mutate(share = weight / Z_try)
} else {
  # if exclusions wipe out everything, fall back to using the full mix (conservative)
  comp <- df_s12_assets_all %>% mutate(share = weight / sum(weight))
}

# FLOW-CONSERVING look-through: allocate the ACTUAL S1M→S12 amount
df_via_s12 <- comp %>%
  transmute(to_id, to_label, weight = share * s1m_into_S12) %>%
  filter(weight > 0)

## --- 3) Nodes (3 columns) ----------------------------------------------------
left_node <- list(list(
  id="S1M_src", name="Households (S1M)", column=0, color="#4C70A7",
  dataLabels=list(style=list(color="black", textOutline="none"))
))

mid_nodes <- c(
  list(list(id="S12_mid", name=ren("S12", sector_labels), column=1, color="#FFD724",
            dataLabels=list(style=list(color="black", textOutline="none")))),
  # one mid for each direct non-S12 target
  lapply(seq_len(nrow(df_direct %>% distinct(to_id, to_label))), function(i) {
    dn <- df_direct %>% distinct(to_id, to_label) %>% slice(i)
    list(id=paste0(dn$to_id, "_mid"), name=dn$to_label, column=1, color="#D9D9D9",
         dataLabels=list(style=list(color="black", textOutline="none")))
  })
)

right_targets <- bind_rows(
  df_via_s12 %>% transmute(to_id, to_label),
  df_direct   %>% transmute(to_id, to_label)
) %>% distinct()

right_nodes <- lapply(seq_len(nrow(right_targets)), function(i) {
  rt <- right_targets[i,]
  list(id=paste0(rt$to_id, "_dst"), name=rt$to_label, column=2, color="#D9D9D9",
       dataLabels=list(style=list(color="black", textOutline="none")))
})

nodes_all <- c(left_node, mid_nodes, right_nodes)

## --- 4) Links (yellow out = blue in, by construction) ------------------------
# Left → S12 (blue inflow)
link_left_S12 <- tibble(
  from="S1M_src", to="S12_mid", weight=s1m_into_S12,
  color="rgba(31,111,235,0.80)"
) %>% filter(weight > 0)

# S12 → right (yellow outflow; totals == s1m_into_S12)
link_S12_to_right <- df_via_s12 %>%
  transmute(from="S12_mid", to=paste0(to_id, "_dst"),
            weight=weight, color="rgba(31,111,235,0.80)")

# Left → direct mids (grey)
link_left_direct <- df_direct %>%
  transmute(from="S1M_src", to=paste0(to_id, "_mid"),
            weight, color="rgba(150,150,150,0.35)")

# Direct mids → right (grey passthrough)
link_direct_to_right <- df_direct %>%
  transmute(from=paste0(to_id, "_mid"), to=paste0(to_id, "_dst"),
            weight, color="rgba(150,150,150,0.35)")

links_all <- bind_rows(link_left_S12, link_left_direct, link_S12_to_right, link_direct_to_right) %>%
  mutate(
    from   = as.character(from),
    to     = as.character(to),
    weight = as.numeric(weight),
    color  = as.character(color)
  ) %>%
  filter(is.finite(weight), weight > 0)

## --- Invariant check ---------------------------------------------------------
stopifnot(abs(sum(link_S12_to_right$weight) - s1m_into_S12) < 1e-6)


# # === Shares for right-hand (final) nodes ======================================
# 1) Build a lookup of right-node labels once
right_labels_df <- bind_rows(
  df_via_s12  %>% transmute(to_id, to_label),
  df_direct   %>% transmute(to_id, to_label)
) %>% distinct()

# 2) Compute shares from the final flows that reach the right side
right_shares <- links_all %>%
  dplyr::filter(grepl("_dst$", to)) %>%
  mutate(to_id = sub("_dst$", "", to)) %>%
  group_by(to_id) %>%
  summarise(weight = sum(weight), .groups = "drop") %>%
  mutate(share = weight / sum(weight)) %>%
  left_join(right_labels_df, by = "to_id")

# 3) Rebuild right-hand nodes using the share labels
right_nodes <- lapply(seq_len(nrow(right_shares)), function(i) {
  rw <- right_shares[i, ]
  list(
    id     = paste0(rw$to_id, "_dst"),
    name   = sprintf("%s — %.1f%% of HH assets", rw$to_label, 100 * rw$share),
    column = 2,
    color  = "#D9D9D9",
    dataLabels = list(style = list(color = "black", textOutline = "none"))
  )
})

# 4) Reassemble nodes_all exactly once (so we don't keep an old version)
left_node <- list(list(
  id="S1M_src", name="Households (S1M)", column=0, color="#4C70A7",
  dataLabels=list(style=list(color="black", textOutline="none"))
))

mid_nodes <- c(
  list(list(id="S12_mid", name=ren("S12", sector_labels), column=1, color="#FFD724",
            dataLabels=list(style=list(color="black", textOutline="none")))),
  lapply(seq_len(nrow(df_direct %>% distinct(to_id, to_label))), function(i) {
    dn <- df_direct %>% distinct(to_id, to_label) %>% slice(i)
    list(id=paste0(dn$to_id, "_mid"), name=dn$to_label, column=1, color="#D9D9D9",
         dataLabels=list(style=list(color="black", textOutline="none")))
  })
)

nodes_all <- c(left_node, mid_nodes, right_nodes)



## --- 5) Plot -----------------------------------------------------------------
highchart() %>%
  hc_add_dependency("modules/sankey") %>%
  hc_size(width = 900, height = 520) %>%
  hc_add_series(
    type  = "sankey",
    data  = highcharter::list_parse2(links_all),   # df → list of lists
    nodes = nodes_all,                             # list-of-lists as-is
    keys  = c("from","to","weight"),
    dataLabels = list(enabled=TRUE, style=list(color="black", textOutline="none", fontWeight="bold")),
    nodeWidth   = 26, nodePadding = 14, curveFactor = 0.35,
    borderWidth = 0, linkOpacity = 1
  ) %>%
  hc_title(text = "Households’ financial assets flows, direct vs via financial sector ") %>%
  hc_subtitle(text = "EA20, 2024 (Fx7). Flows=change in stocks, Yellow = holdings via fin. sector transformation; Grey = direct holdings") %>%
  hc_caption(text = "Source: ECB/Eurostat; DG ECFIN calculations") %>%
  hc_add_theme(ec_theme) %>%
  hc_exporting(enabled = TRUE, filename = "s1m_three_column_with_lookthrough")