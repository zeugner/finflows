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
as1m=aa[.EA20.S1M+S1.S12+S11+S13+S1M+S1.LE._T.2025q1.W2+WRL_REST]

#--- 1) Labels & theme --------------------------------------------------------
sector_labels <- c(
  S11 = "NFC", S12 = "Financial Corporations", S13 = "Government",
  S1M = "Households", S1 = "Total Economy"
)
area_labels <- c(W2 = "Domestic", WRL_REST = "Rest of World", US = "United States")

rename_code <- function(x, map) ifelse(x %in% names(map), map[x], x)

ec_theme <- hc_theme(
  chart = list(backgroundColor="#FFF", style=list(fontFamily="Arial, Helvetica, sans-serif")),
  title = list(align="left", style=list(fontSize="18px", fontWeight="bold", color="black")),
  subtitle = list(align="left", style=list(fontSize="11px", color="black")),
  caption = list(align="left", style=list(fontSize="10px", color="black")),
  legend = list(enabled = FALSE),
  tooltip = list(backgroundColor="#FFF", borderColor="#CCC", style=list(color="black")),
  plotOptions = list(
    sankey = list(dataLabels = list(style = list(color="black", textOutline="none", fontWeight="bold")))
  )
)


dfeat=as.data.frame(as1m)

## ---  Prep: keep only S1M as source, build target = sector · area ----------
df_s1m <- dfeat %>%
  filter(REF_SECTOR == "S1M") %>%
  transmute(
    from      = "S1M",
    to_sec    = as.character(COUNTERPART_SECTOR),
    to_area   = as.character(COUNTERPART_AREA),
    to_id     = paste0(to_sec, "_", to_area),
    to_label0 =  paste0(rename_code(to_sec, sector_labels), " · ",
                        rename_code(to_area, area_labels)),
    weight    = as.numeric(obs_value)
  ) %>%
  filter(!is.na(weight), weight > 0, 
         !(to_id == "S1_W2"))

# aggregate just in case there are multiple rows per pair
links_df <- df_s1m %>%
  group_by(from, to_id, to_label0, to_sec) %>%      # keep to_sec
  summarise(weight = sum(weight), .groups = "drop")

total_out <- sum(links_df$weight)



# compute shares for right node labels
to_shares <- links_df %>%
  group_by(to_id, to_label0, to_sec) %>%            # keep to_sec
  summarise(weight = sum(weight), .groups = "drop") %>%
  mutate(share = weight / total_out,
         is_s12 = grepl("^S12", to_sec))           

## --- Nodes: left = S1M, right = counterpart sector · area -----------------
nodes <- c(
  list(list(id = "S1M_src",
            name = "S1M · Households",
            column = 0,
            color = "#353B73")),  # EC deep blue
  lapply(seq_len(nrow(to_shares)), function(i) {
    list(
      id     = paste0(to_shares$to_id[i], "_dst"),
      # label like "S124 · W2 — 12.3%"
      name   = sprintf("%s — %.1f%%", to_shares$to_label0[i], 100 * to_shares$share[i]),
      column = 1,
      color  = if (to_shares$is_s12[i]) "#FFD724" else "#D9D9D9"  # muted grey for targets
    )
  })
)

## ---  Links ----------------------------------------------------------------
links <- links_df %>%
  mutate(is_s12 = grepl("^S12", to_sec)) %>%         
  transmute(
    from   = "S1M_src",
    to     = paste0(to_id, "_dst"),
    weight = weight,
    color  = ifelse(is_s12,
                    "rgba(31,111,235,0.80)",         # highlight S12* links
                    "rgba(150,150,150,0.25)"),       # de-emphasize others
    dataLabels = list(enabled = FALSE)               # keep labels on nodes only
  )



## --- Plot (fixed size for print; tweak width/height as needed) ------------
highchart() %>%
  hc_size(width = 700, height = 450) %>%           # good for A4 landscape when exported
  hc_add_series(
    type        = "sankey",
    data        = list_parse(links),
    nodes       = nodes,
    dataLabels  = list(enabled = TRUE, style = list(textOutline = "none", fontWeight = "bold")),
    nodeWidth   = 26,
    nodePadding = 14,
    borderColor = "#FFFFFF",
    borderWidth = 0,
    linkOpacity = 0.7,
    curveFactor = 0.35
  ) %>%
  hc_title(text = "Households (S1M) portfolios by counterpart sector and area — EA20, 2025 Q1") %>%
  hc_subtitle(text = sprintf("Shares refer to %% of S1M total (Fx7). Total = %s",
                             format(round(total_out), big.mark = ","))) %>%
  hc_caption(text = "Source: ECB/Eurostat; DG Ecfin calculations") %>%
  hc_add_theme(ec_theme) %>%
  hc_exporting(enabled = TRUE, filename = "s1m_sankey_ec")



#####################################################################
#####################################################################
#### HH look through via financial sector - ea
#####################################################################
#####################################################################

## select data
# S1M assets
#as1m=aa[.EA20.S1M+S1.S12+S12K+S12Q+S12O+S12R+S124+S11+S13+S1M+S1.LE._T.2025q1.W2+WRL_REST]
as1m=aa[.EA20.S1M+S1.S12+S11+S13+S1M+S1.LE._T.2025q1.W2+WRL_REST]

# S12 assets
#as12s=aa[.EA20.S1+S12+S12K+S12R+S12Q+S12O+S124.S12K+S12Q+S12O+S124S12R+S11+S13+S1M+S1.LE._T.2025q1.W2+WRL_REST]
as12s=aa[.EA20.S1+S12.S12K+S12Q+S12O+S124+S11+S13+S1M+S1.LE._T.2025q1.W2+WRL_REST]
# S12 liabilities
#li12s=ll[.W2+WRL_REST.S12+S12K+S12Q+S12O+S124+S12R+S11+S13+S1M+S1.S1+S12+S12K+S121+S12T+S12Q+S12O+S124+S12R.LE._T.2025q1.EA20]
li12s=ll[.W2+WRL_REST.S12K+S12Q+S12O+S124+S11+S13+S1M+S1.S1+S12.LE._T.2025q1.EA20]

##share of EA S1M assets in S12 liabilities
assets=as1m[Fx7.S1M.S12.W2]
#liab=ll[Fx7.W0.S1.S12+S12K+S121+S12T+S12Q+S12O+S124+S12R.LE._T.2025q1.EA20]
liab=ll[Fx7.W0.S1.S12.LE._T.2025q1.EA20]
share=round(((assets/liab)*100), digits=1)

library(dplyr)
library(tidyr)
library(highcharter)


# prep

sector_from_toid <- function(x) sub("_.*$", "", x)
ec_theme <- hc_theme(
  chart = list(backgroundColor = "#FFF", style = list(fontFamily = "Arial, Helvetica, sans-serif")),
  title = list(align = "left", style = list(fontSize = "18px", fontWeight = "bold", color = "black")),
  subtitle = list(align = "left", style = list(fontSize = "11px", color = "black")),
  caption = list(align = "left", style = list(fontSize = "10px", color = "black")),
  legend = list(enabled = FALSE),
  tooltip = list(
    backgroundColor = "#FFF",
    borderColor = "#CCC",
    style = list(color = "black")   # <— tooltip text
  ),
  plotOptions = list(
    sankey = list(
      dataLabels = list(
        style = list(color = "black", textOutline = "none", fontWeight = "bold")
      ))
    ))
make_bip_sankey <- function(links_df, left_label, highlight_flag = NULL,
                            title="", subtitle="", filename="chart",
                            width=700, height=450) {
  total_out <- sum(links_df$weight)
  to_shares <- links_df %>%
    group_by(to_id, to_label) %>%
    summarise(weight = sum(weight), .groups = "drop") %>%
    mutate(share = weight/total_out,
           is_hi = if (!is.null(highlight_flag)) highlight_flag[match(to_id, links_df$to_id)] else FALSE)
  nodes <- c(
    list(list(id="LEFT_src", name=left_label, column=0, color="#353B73")),
    lapply(seq_len(nrow(to_shares)), function(i) {
      list(
        id     = paste0(to_shares$to_id[i], "_dst"),
        name   = sprintf("%s — %.1f%%", to_shares$to_label[i], 100*to_shares$share[i]),
        column = 1,
        color  = if (isTRUE(to_shares$is_hi[i])) "#1F6FEB" else "#D9D9D9"
      )
    })
  )
  links <- links_df %>%
    mutate(is_hi = if (!is.null(highlight_flag)) highlight_flag else FALSE) %>%
    transmute(
      from="LEFT_src",
      to  = paste0(to_id, "_dst"),
      weight,
      color = ifelse(is_hi, "rgba(31,111,235,0.85)", "rgba(150,150,150,0.25)")
    )
  highchart() %>%
    hc_size(width, height) %>%
    hc_add_series(type="sankey", 
                  data=list_parse(links), 
                  nodes=nodes,
                  dataLabels=list(enabled=TRUE, style=list(colour="black",textOutline="none", fontWeight="bold")),
                  nodeWidth=26, nodePadding=14, borderWidth=0, curveFactor=0.35, linkOpacity=1) %>%
    hc_title(text=title) %>%
    hc_subtitle(text=subtitle) %>%
    hc_caption(text="Source: ECB/Eurostat; DG ECFIN calculations") %>%
    hc_add_theme(ec_theme) %>%
    hc_exporting(enabled=TRUE, filename=filename)
}

sector_labels <- c(
  "S1" = "Total",
  "S11" = "NFC",
  "S12" = "Financial Corporations",
  "S13" = "Government",
  "S124" = "Investment funds",
  "S12K" = "Banks",
  "S12Q" = "Insurances & Pension funds",
  "S12O" = "Other financial sector",
  "S1M" = "Households",
  "WRL_REST" = "Rest of World",
  "W2" = "EA20"
)

rename_code <- function(x) ifelse(x %in% names(sector_labels), sector_labels[x], x)

# ========================= 1) S1M assets (direct) =============================

dfeat <- as.data.frame(as1m)

df_s1m <- dfeat %>%
  filter(REF_SECTOR == "S1M") %>%
  transmute(
    to_sec   = as.character(COUNTERPART_SECTOR),
    to_area  = as.character(COUNTERPART_AREA),
    to_id    = paste0(to_sec, "_", to_area),
    to_label = paste(rename_code(to_sec), rename_code(to_area), sep = " · "),
    weight   = as.numeric(obs_value)
  ) %>%
  filter(!is.na(weight), weight > 0, !(to_id == "S1_W2")) %>%
  group_by(to_id, to_label) %>%
  summarise(weight = sum(weight), .groups = "drop")

# Direct holdings EXCLUDING S12 (those will be replaced by look-through)
df_direct <- df_s1m %>%
  filter(sector_from_toid(to_id) != "S12")

# ================= 2) S12 liabilities: S1M financing share by area ============

df_liab <- as.data.frame(li12s) %>%
  filter(REF_SECTOR == "S12") %>%
  transmute(holder = as.character(COUNTERPART_SECTOR),
            value  = as.numeric(obs_value)) %>%
  filter(!is.na(value), value > 0)

s12_tot_liab   <- sum(df_liab$value)
s12_s1m_liab   <- sum(df_liab$value[df_liab$holder == "S1M"])
s12_s1m_share  <- ifelse(s12_tot_liab > 0, s12_s1m_liab / s12_tot_liab, 0)  # scalar

# ================== 3) S12 assets & look-through via S12 ======================

dfa_s12 <- as.data.frame(as12s)

df_s12_assets <- dfa_s12 %>%
  filter(REF_SECTOR == "S12") %>%
  transmute(
    to_sec   = as.character(COUNTERPART_SECTOR),
    to_area  = as.character(COUNTERPART_AREA),
    to_id    = paste0(to_sec, "_", to_area),
    to_label = paste(rename_code(to_sec), rename_code(to_area), sep = " · "),
    weight   = as.numeric(obs_value)
  ) %>%
  filter(!is.na(weight), weight > 0) %>%
  group_by(to_id, to_label) %>%
  summarise(weight = sum(weight), .groups = "drop")

# look-through chunk financed by S1M
df_via_s12 <- df_s12_assets %>%
  mutate(weight = weight * s12_s1m_share) %>%
  filter(to_id != "S1_W2")

# ============ 4) Combine: final S1M allocation (direct + via S12) =============

df_final <- bind_rows(
  df_direct %>% mutate(via_s12 = FALSE),
  df_via_s12 %>% mutate(via_s12 = TRUE)
)

# Highlight portion that comes via S12
hi_flag <- df_final$via_s12

chart_s1m_lookthrough <- make_bip_sankey(
  links_df       = df_final %>% select(to_id, to_label, weight),
  left_label     = "Total assets",
    highlight_flag = hi_flag,
  title    = "Household financial assets — direct vs look-through via financial sector",
  subtitle = "EA20, 2025Q1 (Fx7): blue = via financial sector; grey = direct holding",
  filename = "s1m_lookthrough_via_s12"
)

chart_s1m_lookthrough

overall_share <- sum(liab_share$s1m_liab) / sum(liab_share$tot_liab)

#####
#####
#
# library(dplyr)
# library(highcharter)
#
# #  theme
# ec_theme <- hc_theme(
#   chart = list(backgroundColor = "#FFFFFF",
#                style = list(fontFamily = "Arial, Helvetica, sans-serif")),
#   title = list(align = "left", style = list(fontSize = "18px", fontWeight = "bold")),
#   subtitle = list(align = "left", style = list(fontSize = "11px", color = "#666")),
#   caption = list(align = "left", style = list(fontSize = "10px", color = "#666")),
#   legend = list(enabled = FALSE),
#   tooltip = list(backgroundColor = "#FFFFFF", borderColor = "#CCC")
# )

# # Generic bipartite sankey builder
# make_bip_sankey <- function(links_df, left_label = "Left",
#                             highlight_flag = NULL, width = 700, height = 450,
#                             title = "", subtitle = "", filename = "chart") {
#
#   total_out <- sum(links_df$weight)
#
#   # shares per target for labels
#   to_shares <- links_df %>%
#     group_by(to_id, to_label) %>%
#     summarise(weight = sum(weight), .groups = "drop") %>%
#     mutate(share = weight / total_out,
#            is_hi = if (!is.null(highlight_flag))
#              highlight_flag[match(to_id, links_df$to_id)] else FALSE)
#
#   nodes <- c(
#     list(list(id = "LEFT_src", name = left_label, column = 0, color = "#353B73")),
#     lapply(seq_len(nrow(to_shares)), function(i) {
#       list(
#         id     = paste0(to_shares$to_id[i], "_dst"),
#         name   = sprintf("%s — %.1f%%", to_shares$to_label[i], 100 * to_shares$share[i]),
#         column = 1,
#         color  = if (isTRUE(to_shares$is_hi[i])) "#1F6FEB" else "#D9D9D9"
#       )
#     })
#   )
#
#   links <- links_df %>%
#     mutate(is_hi = if (!is.null(highlight_flag)) highlight_flag else FALSE) %>%
#     transmute(
#       from   = "LEFT_src",
#       to     = paste0(to_id, "_dst"),
#       weight = weight,
#       color  = ifelse(is_hi, "rgba(31,111,235,0.85)", "rgba(150,150,150,0.25)")
#     )
#
#   highchart() %>%
#     hc_size(width = width, height = height) %>%
#     hc_add_series(
#       type        = "sankey",
#       data        = list_parse(links),
#       nodes       = nodes,
#       dataLabels  = list(enabled = TRUE, style = list(textOutline = "none", fontWeight = "bold")),
#       nodeWidth   = 26,
#       nodePadding = 14,
#       borderWidth = 0,
#       curveFactor = 0.35,
#       linkOpacity = 1
#     ) %>%
#     hc_title(text = title) %>%
#     hc_subtitle(text = subtitle) %>%
#     hc_caption(text = "Source: ECB/Eurostat; DG ECFIN calculations") %>%
#     hc_add_theme(ec_theme) %>%
#     hc_exporting(enabled = TRUE, filename = filename)
# }
#
# ###########
# ## S1M Assets
# ###########
#
# dfeat=as.data.frame(as1m)
#
# df_s1m <- dfeat %>%
#   filter(REF_SECTOR == "S1M") %>%
#   transmute(
#     to_sec    = as.character(COUNTERPART_SECTOR),
#     to_area   = as.character(COUNTERPART_AREA),
#     to_id     = paste0(to_sec, "_", to_area),
#     to_label  = paste(to_sec, to_area, sep = " · "),
#     weight    = as.numeric(obs_value)
#   ) %>%
#   filter(!is.na(weight), weight > 0, !(to_id == "S1_W2")) %>% # drop S1·W2 if needed
#   group_by(to_id, to_label) %>%
#   summarise(weight = sum(weight), .groups = "drop")
#
# hi_S12 <- grepl("^S12", sub("_.*$", "", df_s1m$to_id))  # S12* flag by target sector
#
# chart_s1m_assets <- make_bip_sankey(
#   links_df = df_s1m,
#   left_label = "S1M · Households",
#   highlight_flag = hi_S12,
#   title = "S1M assets by counterpart sector/area — highlight S12*",
#   subtitle = "EA20, 2022 Q4 (Fx7)",
#   filename = "s1m_assets_sankey"
# )
#
#
# ###########
# ## S12 Assets
# ###########
#
# dfa_s12 =as.data.frame(as12s)
#
# df_s12_assets <- dfa_s12 %>%
#   filter(REF_SECTOR == "S12") %>%
#   transmute(
#     to_sec    = as.character(COUNTERPART_SECTOR),
#     to_area   = as.character(COUNTERPART_AREA),
#     to_id     = paste0(to_sec, "_", to_area),
#     to_label  = paste(to_sec, to_area, sep = " · "),
#     weight    = as.numeric(obs_value)
#   ) %>%
#   filter(!is.na(weight), weight > 0) %>%
#   group_by(to_id, to_label) %>%
#   summarise(weight = sum(weight), .groups = "drop")
#
# #hi_focus <- grepl("^S11|^S13", sub("_.*$", "", df_s12_assets$to_id))  # example
#
# chart_s12_assets <- make_bip_sankey(
#   links_df = df_s12_assets,
#   left_label = "S12 · Financial corporations",
#   #highlight_flag = hi_focus,
#   title = "S12 asset allocation by counterpart sector/area",
#   subtitle = "EA20, 2022 Q4 (Fx7)",
#   filename = "s12_assets_sankey"
# )



