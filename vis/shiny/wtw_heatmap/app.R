# ══════════════════════════════════════════════════════════════════════════════
# Shiny Dashboard — Who-to-Whom Heatmap (Creditor Allocation)
# Each ROW sums to 100 %: "how does each creditor allocate its holdings?"
# ══════════════════════════════════════════════════════════════════════════════

library(shiny)
library(bslib)
library(MDstats)
library(dplyr)
library(highcharter)

# ── 0. PATHS ──────────────────────────────────────────────────────────────────

APP_DIR  <- dirname(normalizePath(if (nchar(sys.frame(0)$ofile) > 0)
                                     sys.frame(0)$ofile else "app.R",
                                  mustWork = FALSE))

DATA_DIR <- Sys.getenv(
  "FINFLOWS_DATA_DIR",
  unset = "\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/data"
)

UTIL_PATH <- Sys.getenv(
  "FINFLOWS_UTIL_PATH",
  unset = file.path(APP_DIR, "..", "..", "..", "routines", "utilities.R")
)

if (file.exists(UTIL_PATH)) source(UTIL_PATH)

# ── 1. LOAD DATA (once at startup, shared across all sessions) ────────────────

message("[wtw_heatmap] Loading data from: ", DATA_DIR)

AA_PATH <- file.path(DATA_DIR, "aa_iip_agg.rds")
LL_PATH <- file.path(DATA_DIR, "ll_iip_agg.rds")

if (!file.exists(AA_PATH) || !file.exists(LL_PATH)) {
  stop("Data files not found. Set the FINFLOWS_DATA_DIR environment variable ",
       "to the directory containing aa_iip_agg.rds and ll_iip_agg.rds.")
}

aa_global <- readRDS(AA_PATH); gc()
ll_global <- readRDS(LL_PATH); gc()
message("[wtw_heatmap] Data loaded.")

# ── 2. CONSTANTS ──────────────────────────────────────────────────────────────

SECTOR_LABELS <- c(
  "S11"  = "NFCs",
  "S1M"  = "Households",
  "S13"  = "Government",
  "S12K" = "Banks",
  "S12Q" = "Ins. & Pension Funds",
  "S12O" = "Other Financial",
  "S124" = "Investment Funds",
  "S1"   = "Rest of World"
)

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

AREA_CHOICES <- c(
  "Austria (AT)"          = "AT", "Belgium (BE)"       = "BE",
  "Bulgaria (BG)"         = "BG", "Croatia (HR)"       = "HR",
  "Cyprus (CY)"           = "CY", "Czech Republic (CZ)"= "CZ",
  "Denmark (DK)"          = "DK", "Estonia (EE)"       = "EE",
  "Finland (FI)"          = "FI", "France (FR)"        = "FR",
  "Germany (DE)"          = "DE", "Greece (GR)"        = "GR",
  "Hungary (HU)"          = "HU", "Ireland (IE)"       = "IE",
  "Italy (IT)"            = "IT", "Latvia (LV)"        = "LV",
  "Lithuania (LT)"        = "LT", "Luxembourg (LU)"    = "LU",
  "Malta (MT)"            = "MT", "Netherlands (NL)"   = "NL",
  "Poland (PL)"           = "PL", "Portugal (PT)"      = "PT",
  "Romania (RO)"          = "RO", "Slovakia (SK)"      = "SK",
  "Slovenia (SI)"         = "SI", "Spain (ES)"         = "ES",
  "Sweden (SE)"           = "SE"
)

QUARTER_CHOICES <- rev(paste0(
  rep(2015:2025, each = 4), "q", 1:4
))

# ── 3. HELPERS ────────────────────────────────────────────────────────────────

ren <- function(x, map) ifelse(x %in% names(map), map[x], x)

get_col <- function(cn, pat) cn[grep(pat, cn, ignore.case = TRUE)][1]

ec_theme <- hc_theme(
  chart    = list(backgroundColor = "#FFF",
                  style = list(fontFamily = "Arial, Helvetica, sans-serif")),
  title    = list(align = "left",
                  style = list(fontSize = "18px", fontWeight = "bold",
                               color = "black")),
  subtitle = list(align = "left",
                  style = list(fontSize = "11px", color = "black")),
  caption  = list(align = "left",
                  style = list(fontSize = "10px", color = "black")),
  legend   = list(enabled = TRUE),
  tooltip  = list(backgroundColor = "#FFF", borderColor = "#CCC",
                  style = list(color = "black"))
)

# Build the MDstats bracket-query string and evaluate it against the dataset.
# Uses eval(parse()) so the key is constructed as a character string and then
# evaluated in the same way as a literal bracket expression.
extract_flows <- function(dataset, key_str) {
  eval(parse(text = sprintf("dataset[%s]", key_str)))
}

INSTRUMENTS  <- "F2M+F3+F4+F511+F51M+F52+F6+F81+F89"
DOM_SECTORS  <- "S11+S1M+S13+S12K+S12Q+S12O+S124"
ALL_SECTORS  <- paste0(DOM_SECTORS, "+S1")

# ── 4. UI ─────────────────────────────────────────────────────────────────────

ui <- page_sidebar(
  title  = "Who-to-Whom Heatmap — Creditor Allocation",
  theme  = bs_theme(bootswatch = "flatly", base_font = font_google("Inter")),
  window_title = "WtW Heatmap",

  # ---- Sidebar ---------------------------------------------------------------
  sidebar = sidebar(
    width = 270,

    h6("Parameters", class = "text-muted text-uppercase fw-bold mb-2"),

    selectInput("target_area", "Country",
                choices  = AREA_CHOICES,
                selected = "FR"),

    selectInput("target_time", "Reference quarter",
                choices  = QUARTER_CHOICES,
                selected = "2024q4"),

    selectInput("base_time", "Base quarter (change from)",
                choices  = QUARTER_CHOICES,
                selected = "2023q4"),

    sliderInput("min_flow_pct",
                "Min. cell display threshold (%)",
                min = 0, max = 10, value = 0.5, step = 0.1),

    hr(),

    actionButton("go", "Update chart",
                 icon  = icon("rotate"),
                 class = "btn-primary w-100"),

    hr(),

    p(class = "text-muted small",
      "Each ", strong("row"), " sums to 100 %.",
      "Cells show the share of a creditor's total holdings allocated to each debtor sector.",
      "Changes are computed as the difference between the reference and base quarters.")
  ),

  # ---- Main panel ------------------------------------------------------------
  layout_column_wrap(
    width = 1,

    card(
      full_screen = TRUE,
      card_header(
        textOutput("chart_title", inline = TRUE),
        class = "fw-bold"
      ),
      highchartOutput("heatmap", height = "640px"),
      uiOutput("error_msg")
    )
  )
)

# ── 5. SERVER ─────────────────────────────────────────────────────────────────

server <- function(input, output, session) {

  # Validate that target_time != base_time ─────────────────────────────────────
  observe({
    if (input$target_time == input$base_time) {
      showNotification(
        "Reference quarter and base quarter are the same — the chart will show zero flows.",
        type = "warning", duration = 6
      )
    }
  })

  # Compute flows on button click (or on first load) ───────────────────────────
  flows_data <- eventReactive(input$go, {

    TARGET_AREA  <- input$target_area
    TARGET_TIME  <- input$target_time
    BASE_TIME    <- input$base_time

    # Asset-side query (domestic creditors → all debtors)
    aa_key_t <- sprintf(
      "%s.%s.%s.%s.LE._T.%s.W2+WRL_REST",
      INSTRUMENTS, TARGET_AREA, DOM_SECTORS, ALL_SECTORS, TARGET_TIME
    )
    aa_key_b <- sprintf(
      "%s.%s.%s.%s.LE._T.%s.W2+WRL_REST",
      INSTRUMENTS, TARGET_AREA, DOM_SECTORS, ALL_SECTORS, BASE_TIME
    )

    # Liability-side query (RoW creditor → domestic debtors)
    ll_key_t <- sprintf(
      "%s.WRL_REST.S1.%s.LE._T.%s.%s",
      INSTRUMENTS, ALL_SECTORS, TARGET_TIME, TARGET_AREA
    )
    ll_key_b <- sprintf(
      "%s.WRL_REST.S1.%s.LE._T.%s.%s",
      INSTRUMENTS, ALL_SECTORS, BASE_TIME, TARGET_AREA
    )

    wtw_aa <- extract_flows(aa_global, aa_key_t) -
              extract_flows(aa_global, aa_key_b)
    wtw_ll <- extract_flows(ll_global, ll_key_t) -
              extract_flows(ll_global, ll_key_b)

    # ── Tidy: assets ──────────────────────────────────────────────────────────
    df_aa <- as.data.frame(wtw_aa); cn_aa <- names(df_aa)
    flows_aa <- df_aa %>%
      transmute(
        cred_sec = as.character(.data[[get_col(cn_aa, "ref_sector")]]),
        debt_sec = as.character(.data[[get_col(cn_aa,
                                       "counterpart_sector|cp_sector")]]),
        area     = as.character(.data[[get_col(cn_aa,
                                       "counterpart_area|cp_area")]]),
        value    = as.numeric(gsub(",", ".", .data[[get_col(cn_aa,
                                                   "obs_value")]]))
      ) %>%
      filter(
        is.finite(value), value > 0,
        !(area == "W2"       & debt_sec == "S1"),
        !(area == "WRL_REST" & debt_sec != "S1")
      )

    # ── Tidy: liabilities ─────────────────────────────────────────────────────
    df_ll <- as.data.frame(wtw_ll); cn_ll <- names(df_ll)
    flows_ll <- df_ll %>%
      transmute(
        cred_sec = "S1",
        debt_sec = as.character(.data[[get_col(cn_ll, "ref_sector")]]),
        area     = "W2",
        value    = as.numeric(gsub(",", ".", .data[[get_col(cn_ll,
                                                   "obs_value")]]))
      ) %>%
      filter(is.finite(value), value > 0, debt_sec != "S1")

    flows_raw <- bind_rows(flows_aa, flows_ll) %>%
      group_by(cred_sec, debt_sec, area) %>%
      summarise(value = sum(value), .groups = "drop")

    flows_raw

  }, ignoreNULL = FALSE)   # run once on startup with default inputs


  # Build percentage matrix ────────────────────────────────────────────────────
  flows_pct_data <- reactive({
    flows_raw    <- flows_data()
    MIN_FLOW_PCT <- input$min_flow_pct

    validate(need(
      nrow(flows_raw) > 0,
      "No flows found for the selected parameters. Try a different country or time period."
    ))

    flows_pct <- flows_raw %>%
      mutate(
        cred_label = ren(cred_sec, SECTOR_LABELS),
        debt_label = ifelse(
          area == "WRL_REST",
          "Rest of World",
          paste0(ren(debt_sec, SECTOR_LABELS), " · Dom.")
        )
      ) %>%
      group_by(cred_label) %>%
      mutate(pct = round(100 * value / sum(value), 1)) %>%
      ungroup() %>%
      filter(pct >= MIN_FLOW_PCT)

    # Creditor row order: descending total assets
    cred_order <- flows_raw %>%
      mutate(cred_label = ren(cred_sec, SECTOR_LABELS)) %>%
      group_by(cred_label) %>%
      summarise(total = sum(value), .groups = "drop") %>%
      arrange(desc(total)) %>%
      pull(cred_label)

    list(flows_pct = flows_pct, cred_order = cred_order)
  })


  # Render chart title ─────────────────────────────────────────────────────────
  output$chart_title <- renderText({
    sprintf("Who-to-Whom: %s — %s | All instruments",
            input$target_area, input$target_time)
  })


  # Render heatmap ─────────────────────────────────────────────────────────────
  output$heatmap <- renderHighchart({
    res        <- flows_pct_data()
    flows_pct  <- res$flows_pct
    CRED_ORDER <- res$cred_order

    TARGET_AREA <- input$target_area
    TARGET_TIME <- input$target_time
    BASE_TIME   <- input$base_time

    # Full grid: every creditor × every debtor slot
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

    highchart() %>%
      hc_chart(type = "heatmap") %>%
      hc_add_series(
        data = highcharter::list_parse2(mat),
        keys = c("x", "y", "value"),
        name = "% of creditor holdings"
      ) %>%
      hc_colorAxis(
        min   = 0,
        max   = 100,
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
                    ' \u2192 <b>' + this.series.xAxis.categories[this.point.x] +
                    '</b><br/>Share of creditor holdings: <b>' +
                    this.point.value.toFixed(1) + '%</b>' +
                    '<br/><i>(each row sums to 100%)</i>';
           }"
        )
      ) %>%
      hc_title(text = sprintf(
        "Who-to-Whom: %s \u2014 %s | All instruments",
        TARGET_AREA, TARGET_TIME
      )) %>%
      hc_subtitle(text = paste0(
        "Each row = 100% of that creditor's total holdings  |  ",
        "Cells show % allocated to each debtor sector"
      )) %>%
      hc_caption(text = paste0(
        "Source: Finflows 3.0 (", TARGET_TIME, " vs ", BASE_TIME, " changes).  ",
        "Non-aggregate sectors only."
      )) %>%
      hc_size(width = NULL, height = 620) %>%
      hc_add_theme(ec_theme) %>%
      hc_exporting(
        enabled  = TRUE,
        filename = paste0("wtw_heatmap_rowpct_", TARGET_AREA, "_", TARGET_TIME)
      )
  })


  # Inline error fallback ──────────────────────────────────────────────────────
  output$error_msg <- renderUI({
    tryCatch({
      flows_pct_data()
      NULL
    }, error = function(e) {
      div(class = "alert alert-danger mt-2",
          icon("triangle-exclamation"), " ", conditionMessage(e))
    })
  })
}

# ── 6. RUN ────────────────────────────────────────────────────────────────────

shinyApp(ui, server)
