library(MD3)
library(MDstats)

library(readxl)
library(dplyr)
library(lubridate)
library(stringr)

if (!exists("data_dir")) data_dir = getwd()

#temp load current aall version
#aall=readRDS(file.path(data_dir,'aall_iip_cps_new.rds')); gc()


file_path <- file.path(data_dir, "static/bdi_S12V.xlsx")

raw_data <- read_excel(file_path, skip = 1)
column_names <- colnames(raw_data)
target_col_index <- 9  # "Altre istituzioni finanziarie, totale attivo verso banche"

convert_date_format <- function(date_val) {
  # Skip the header row
  if (date_val == "Data dell'osservazione") {
    return(NA)
  }
  
  if (grepl("^\\d{2}/\\d{2}/\\d{4}$", date_val)) {
    parts <- strsplit(date_val, "/")[[1]]
    day <- as.numeric(parts[1])
    month_val <- as.numeric(parts[2])
    year_val <- as.numeric(parts[3])
    
    quarter <- ceiling(month_val / 3)
    
    # Format as YYYYqQ
    return(paste0(year_val, "q", quarter))
  }
  
  return(NA)
}

IT_S12V_S122 <- raw_data %>%
  select(1, all_of(target_col_index)) %>%
  rename(
    date = 1,
    value = 2
  ) %>%
  filter(date != "Data dell'osservazione") %>%  # Remove the header row
  mutate(
    date_formatted = sapply(date, convert_date_format),
    value = as.numeric(value)  # Convert values to numeric
  ) %>%
  select(date_formatted, value)

print(head(IT_S12V_S122))


# Convert to an MD3 object
BDI_S12V_S122 <- as.md3(
  IT_S12V_S122,
  id.vars = "date_formatted",  
  name_for_cols = "time"       
)

BDI_S12V_S122
dimnames(aall)
# Check the dimension names and codes
dimnames(BDI_S12V_S122)

aall[F.IT.S12V.S122.LE._T.]
aall[F.IT.S12V.S122.LE._T.] <- BDI_S12V_S122
aall[F.IT.S12V.S122.LE._S.] <- BDI_S12V_S122

aall[F.IT.S12V.S122.LE._T.]


aall[.IT.S12O.S12K.LE._T.2023q4]
zerofiller=function(x, fillscalar=0){
  temp=copy(x)
  temp[onlyna=TRUE]=fillscalar
  temp
}

###

all_av_instr=aall[F511.IT.S12O.S12K.LE._S.]+zerofiller(aall[F52.IT.S12O.S12K.LE._S.])+zerofiller(aall[F2M.IT.S12O.S12K.LE._S.])+zerofiller(aall[F4.IT.S12O.S12K.LE._S.])+zerofiller(aall[F3.IT.S12O.S12K.LE._S.])+zerofiller(aall[F6.IT.S12O.S12K.LE._S.])+zerofiller(aall[F7.IT.S12O.S12K.LE._S.])+zerofiller(aall[F81.IT.S12O.S12K.LE._S.])+zerofiller(aall[F89.IT.S12O.S12K.LE._S.])

all_av_instr

aall[F51M.IT.S12O.S12T.LE._S.]
aall[F51M.IT.S12O.S12T.LE._S.]<-aall[F.IT.S12V.S122.LE._S.]-all_av_instr

aall[F51M.IT.S12O.S12T.LE._S.]


aall[F.IT.S12V.S122.LE._S.]
