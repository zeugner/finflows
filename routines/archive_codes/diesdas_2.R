library(MDstats); 

# Set data directory
#data_dir= file.path(getwd(),'data')
if (!exists("data_dir")) data_dir = '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/data/'
source('\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/routines/utilities.R')
gc()


## load filled iip bop
aa=readRDS(file.path(data_dir,'aa_iip_agg.rds')); gc()

#############
eat=aa[.EA20.S1M+S1.S12K+S12Q+S12O+S124+S11+S13+S1M+S1.LE._T.2022q4.W2+WRL_REST]
dfeat=as.data.frame(eat)

library(dplyr)
library(highcharter)


## ---  Prep: keep only S1M as source, build target = sector · area ----------
df_s1m <- dfeat %>%
  filter(REF_SECTOR == "S1M") %>%
  transmute(
    from      = "S1M",
    to_sec    = as.character(COUNTERPART_SECTOR),
    to_area   = as.character(COUNTERPART_AREA),
    to_id     = paste0(to_sec, "_", to_area),
    to_label0 = paste(to_sec, to_area, sep = " · "),
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
  hc_title(text = "Households (S1M) portfolios by counterpart sector and area — EA20, 2022 Q4") %>%
  hc_subtitle(text = sprintf("Shares refer to %% of S1M total (Fx7). Total = %s",
                             format(round(total_out), big.mark = ","))) %>%
  hc_caption(text = "Source: ECB/Eurostat; DG Ecfin calculations") %>%
  hc_add_theme(ec_thm) %>%
  hc_exporting(enabled = TRUE, filename = "s1m_sankey_ec")

####################################
####################################
####################################


eat=aa[.EA20.S12+S1.S1+S11+S1M+S13+S12K+S12Q+S12O+S124.LE._T.2022q4.W2+WRL_REST]
dfeat=as.data.frame(eat)

library(dplyr)
library(highcharter)


## ---  Prep: keep only S12 as source, build target = sector · area ----------
df_s1m <- dfeat %>%
  filter(REF_SECTOR == "S12") %>%
  transmute(
    from      = "S12",
    to_id     = paste0(COUNTERPART_SECTOR, "_", COUNTERPART_AREA),        # id
    to_label0 = paste(COUNTERPART_SECTOR, COUNTERPART_AREA, sep = " · "), #  label
    weight    = as.numeric(obs_value)
  ) %>%
  filter(!is.na(weight), weight > 0) %>%
  # drop S1 · W2, keep S1 · WRL_REST
  filter(!(to_id == "S1_W2"))

# aggregate just in case there are multiple rows per pair
links_df <- df_s1m %>%
  group_by(from, to_id, to_label0) %>%
  summarise(weight = sum(weight), .groups = "drop")

total_out <- sum(links_df$weight)

# compute shares for right node labels
to_shares <- links_df %>%
  group_by(to_id, to_label0) %>%
  summarise(weight = sum(weight), .groups = "drop") %>%
  mutate(share = weight / total_out)

## --- Nodes: left = S12, right = counterpart sector · area -----------------
nodes <- c(
  list(list(id = "S12_src",
            name = "S12 · Financial Sector",
            column = 0,
            color = "#353B73")),  # EC deep blue
  lapply(seq_len(nrow(to_shares)), function(i) {
    list(
      id     = paste0(to_shares$to_id[i], "_dst"),
      # label like "S124 · W2 — 12.3%"
      name   = sprintf("%s — %.1f%%", to_shares$to_label0[i], 100 * to_shares$share[i]),
      column = 1,
      color  = "#D9D9D9"  # muted grey for targets
    )
  })
)

## ---  Links ----------------------------------------------------------------
links <- links_df %>%
  transmute(
    from   = "S12_src",
    to     = paste0(to_id, "_dst"),
    weight = weight,
    color  = "rgba(26,90,150,0.30)",   # translucent blue for flows
    custom = sprintf("%s", to_label0)
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
  hc_title(text = "Financial sector (S12) portfolios by counterpart sector and area — EA20, 2022 Q4") %>%
  hc_subtitle(text = sprintf("Shares refer to %% of S12 total (Fx7). Total = %s",
                             format(round(total_out), big.mark = ","))) %>%
  hc_caption(text = "Source: ECB/Eurostat; DG Ecfin calculations") %>%
  hc_add_theme(ec_thm) %>%
  hc_exporting(enabled = TRUE, filename = "s12_sankey_ec")