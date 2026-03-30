library(MDstats); library(MD3)

# Set data directory
setwd("V:/FinFlows/githubrepo/finflows")
data_dir= file.path(getwd(),'data')
if (!exists("data_dir")) data_dir = '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/data/'

aa=readRDS(file.path(data_dir,'aa_iip_cpis.rds')); gc()
ll=readRDS(file.path(data_dir,'ll_iip_cpis.rds')); gc()


ea20_members <- c("AT","BE","CY","DE","EE","ES","FI","FR","GR","HR",
                  "IE","IT","LT","LU","LV","MT","NL","PT","SI","SK")
eu27_members <- c(ea20_members, "BG","CZ","DK","HU","PL","RO","SE")

# ASSETS: for each member country keep only its extra-EA positions,
# then sum across member countries
aa_ea20 <- aggregate(
  aa[, ea20_members, , , , , , "EXT_EA20"],
  FUN=sum, na.rm=TRUE, dim = "REF_AREA"
)
dimnames(aa_ea20)$REF_AREA <- "EA20"
# COUNTERPART_AREA is still "EXT_EA20" — relabel to W0 if desired
# (the EA20 aggregate's "world" is defined as EXT_EA20)

# LIABILITIES: same logic — only liabilities held by non-EA counterparts
ll_ea20 <- aggregate(
  ll[, "EXT_EA20", , , , , , ea20_members],
  dim = "REF_AREA"
)
dimnames(ll_ea20)$REF_AREA <- "EA20"

# Merge back
aa <- merge(aa, aa_ea20)
ll <- merge(ll, ll_ea20)

# EU27 — identical, use EXT_EU27
aa_eu27 <- aggregate(aa[, eu27_members, , , , , , "EXT_EU27"], dim = "REF_AREA")
dimnames(aa_eu27)$REF_AREA <- "EU27"

dimnames(aa_eu27)$REF_AREA <- "EU27"
# ... same for ll_eu27
ll_eu27 <- aggregate(ll[, "EXT_EU27", , , , , , eu27_members], dim = "REF_AREA")
dimnames(ll_eu27)$REF_AREA <- "EU27"

# Merge back
aa <- merge(aa, aa_eu27)
ll <- merge(ll, ll_eu27)
