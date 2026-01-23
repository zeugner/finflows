# Load required packages
library(MDstats)
library(MD3)

# Define paste0 operator
`%&%` = function (..., collapse = NULL, recycle0 = FALSE)  .Internal(paste0(list(...), collapse, recycle0))

# Set data directory
if (!exists("data_dir")) data_dir = getwd()

# Create buffer directory if it doesn't exist
if (!dir.exists('C:/Users/Public/finflowsbuffer')) { 
  dir.create('C:/Users/Public/finflowsbuffer')
}

# Load and process data
xss = 'S1+S11+S1M+S13+S12K+S12T+S121+S124+S12O+S12Q'
xii = 'F+F21+F2M+F3+F4+F51+F511+F51M+F52+F6+F6N+F6O+F7+F81+F89'

# Initialize results list
lll = list(A = list(), L = list())

# Initialize log file
cat('___ ' %&% Sys.Date() %&% ' ___\n', file = file.path(data_dir, 'finflows.log'), append = FALSE)

##############################################################################
# SECTION 1: Load Liabilities (L)
##############################################################################

for (ii in strsplit(xii, split = '\\+')[[1]]) {
  message(ii)
  cat(format(Sys.time(), '%H:%M:%S') %&% ": " %&% ii %&% '\n', 
      file = file.path(data_dir, 'finflows.log'), append = TRUE)
  lll[['L']][[ii]] = try(mds('ECB/QSA/Q.N..W0+W2.' %&% xss %&% '.S1.N.L.LE+F.' %&% ii %&% '.._Z.XDC._T.S.V.N.'), silent = TRUE)
  saveRDS(lll, file.path('C:/Users/Public/finflowsbuffer', 'fflist.rds'))
}

gc()

##############################################################################
# SECTION 2: Load Assets (A) - REVISED WITH SPLIT QUERIES
# Original query: 'ECB/QSA/Q.N..W0+W2.' %&% xss %&% '.' %&% xss %&% '.N.A.LE+F.' %&% ii %&% '.._Z.XDC._T.S.V.N.'
# Split into smaller queries to avoid timeout:
# - W0/W2 (2 counterpart areas)
# - xss1/xss2 x xss1/xss2 (4 sector combinations)
# - LE/F (2 stock/flow types)
# Total: 16 partial loads per instrument
##############################################################################

# Split sectors into five groups of 2 sectors each
xss1 = 'S1+S11'
xss2 = 'S1M+S13'
xss3 = 'S12K+S12T'
xss4 = 'S121+S124'
xss5 = 'S12O+S12Q'

# Define all 25 sector combinations (5 x 5)
xss_groups = c(xss1, xss2, xss3, xss4, xss5)
sector_combinations = list()
for (r in xss_groups) {
  for (c in xss_groups) {
    sector_combinations[[length(sector_combinations) + 1]] = list(ref = r, ctp = c)
  }
}
ctp_areas = c('W0', 'W2')
sto_types = c('LE', 'F')

for (ii in strsplit(xii, split = '\\+')[[1]]) {
  message('A: Instrument ', ii)
  cat(format(Sys.time(), '%H:%M:%S') %&% ': A ' %&% ii %&% '\n', 
      file = file.path(data_dir, 'finflows.log'), append = TRUE)
  
  # List to collect partial loads for this instrument
  partial_loads = list()
  load_counter = 0
  
  for (wa in ctp_areas) {
    for (sc in sector_combinations) {
      for (st in sto_types) {
        load_counter = load_counter + 1
        message('  Loading: ' %&% wa %&% ' / ' %&% sc$ref %&% ' x ' %&% sc$ctp %&% ' / ' %&% st)
        cat('    ' %&% format(Sys.time(), '%H:%M:%S') %&% ': ' %&% wa %&% ' / ref=' %&% sc$ref %&% ' ctp=' %&% sc$ctp %&% ' / ' %&% st %&% '\n',
            file = file.path(data_dir, 'finflows.log'), append = TRUE)
        
        query = 'ECB/QSA/Q.N..' %&% wa %&% '.' %&% sc$ref %&% '.' %&% sc$ctp %&% '.N.A.' %&% st %&% '.' %&% ii %&% '.._Z.XDC._T.S.V.N.'
        
        partial_loads[[load_counter]] = try(mds(query, drop = FALSE), silent = TRUE)
      }
    }
  }
  
  # Merge partial loads into single object
  merged = NULL
  for (x in partial_loads) {
    if (is(x, 'md3')) {
      if (is.null(merged)) {
        merged = x
      } else {
        merged = merge(merged, x)
      }
    }
  }
  
  if (!is.null(merged)) {
    lll[['A']][[ii]] = merged
  } else {
    lll[['A']][[ii]] = partial_loads[[1]]  # Keep error object if all failed
  }
  
  saveRDS(lll, file.path('C:/Users/Public/finflowsbuffer', 'fflist.rds'))
}

gc()

##############################################################################
# SECTION 3: Save code descriptions and final results
##############################################################################

codedescriptions = list()
codedescriptions$INSTR = helpmds('ECB/QSA', dim = 'INSTR_ASSET', verbose = FALSE)
codedescriptions$REF_SECTOR = helpmds('ECB/QSA', dim = 'REF_SECTOR', verbose = FALSE)
codedescriptions$COUNTERPART_SECTOR = helpmds('ECB/QSA', dim = 'COUNTERPART_SECTOR', verbose = FALSE)
codedescriptions$STO = helpmds('ECB/QSA', dim = 'STO', verbose = FALSE)
codedescriptions$CUST_BREAKDOWN = helpmds('ECB/QSA', dim = 'CUST_BREAKDOWN', verbose = FALSE)

saveRDS(codedescriptions, file.path(data_dir, 'codedescriptions.rds'))
saveRDS(lll, file.path(data_dir, 'fflist.rds'))

gc()
