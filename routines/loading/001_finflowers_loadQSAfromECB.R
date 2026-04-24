#
# Load ECB QSA data for Finflows #
#   - mds(..., drop=FALSE) preserves all 18 SDMX dimensions, many of which are
#     singleton (ADJUSTMENT=N, CONSOLIDATION=N, INSTR_ASSET, MATURITY, ...).
#   - drop=FALSE is REQUIRED during partial loading so merge() can stitch W0+W2
#     and LE+F without the split dimensions collapsing into singletons.
#   - merge() preserves the full 18-dim structure (tested on F2M and F511).
#

library(MDstats)
library(MD3)

`%&%` = function (..., collapse = NULL, recycle0 = FALSE)  .Internal(paste0(list(...), collapse, recycle0))

if (!exists("data_dir")) data_dir = getwd()

if (!dir.exists('C:/Users/Public/finflowsbuffer')) { 
  dir.create('C:/Users/Public/finflowsbuffer')
}

xss = 'S1+S11+S1M+S13+S12K+S12T+S121+S124+S12O+S12Q'
xii = 'F+F21+F2M+F3+F4+F51+F511+F51M+F52+F6+F6N+F6O+F7+F81+F89'

lll = list(A = list(), L = list())

cat('___ ' %&% Sys.Date() %&% ' ___\n', file = file.path(data_dir, 'finflows.log'), append = FALSE)

# Sector split used by both L and A loops
xss1 = 'S1+S11'
xss2 = 'S1M+S13'
xss3 = 'S12K+S12T'
xss4 = 'S121+S124'
xss5 = 'S12O+S12Q'
xss_groups = c(xss1, xss2, xss3, xss4, xss5)

ctp_areas = c('W0', 'W2')
sto_types = c('LE', 'F')

##############################################################################
# Helper: drop singleton dimensions from an md3 object.
# Used ONLY for Liabilities, because downstream selectors on L assume the
# flattened (singletons-removed) shape. Tested to produce the same 5-dim
# shape originally returned by mds(..., drop=TRUE) on the monolithic query.
##############################################################################

drop_md3_singletons = function(x) {
  if (!is(x, 'md3')) return(x)
  
  # Try base drop() first
  r = tryCatch(drop(x), error = function(e) NULL, warning = function(w) NULL)
  if (!is.null(r) && is(r, 'md3')) {
    dn = dimnames(r)
    if (all(sapply(dn, length) > 1)) return(r)
  }
  
  # Try x[drop = TRUE]
  r = tryCatch(x[drop = TRUE], error = function(e) NULL, warning = function(w) NULL)
  if (!is.null(r) && is(r, 'md3')) {
    dn = dimnames(r)
    if (all(sapply(dn, length) > 1)) return(r)
  }
  
  # Iterative fallback: subset one singleton at a time using dot syntax
  repeat {
    dn = dimnames(x)
    sizes = sapply(dn, length)
    sing_idx = which(sizes == 1)
    if (length(sing_idx) == 0) break
    
    i = sing_idx[1]
    ndims = length(dn)
    val = dn[[i]][1]
    parts = rep('', ndims)
    parts[i] = val
    selector = paste0('.', paste(parts, collapse = '.'), '.')
    
    expr = parse(text = 'x[' %&% selector %&% ']')
    r = tryCatch(eval(expr), error = function(e) NULL)
    if (is.null(r) || !is(r, 'md3')) break
    x = r
  }
  
  return(x)
}

##############################################################################
# SECTION 1: Load Liabilities (L)
# Split along:
#   COUNTERPART_AREA (W0 / W2)       : 2
#   REF_SECTOR (5 groups of 2)       : 5
#   STO (LE / F)                     : 2
# Total: 20 partial loads per instrument.
# COUNTERPART_SECTOR is always S1, so no sector x sector split needed.
# After merge(), drop singletons to match downstream L shape expectation.
##############################################################################

for (ii in strsplit(xii, split = '\\+')[[1]]) {
  message('L: Instrument ', ii)
  cat(format(Sys.time(), '%H:%M:%S') %&% ': L ' %&% ii %&% '\n', 
      file = file.path(data_dir, 'finflows.log'), append = TRUE)
  
  partial_loads = list()
  k = 0
  
  for (wa in ctp_areas) {
    for (sg in xss_groups) {
      for (st in sto_types) {
        k = k + 1
        message('  [', k, '/20] ', wa, ' / ref=', sg, ' / ', st)
        cat('    ' %&% format(Sys.time(), '%H:%M:%S') %&% ': ' %&% wa %&% ' / ref=' %&% sg %&% ' / ' %&% st %&% '\n',
            file = file.path(data_dir, 'finflows.log'), append = TRUE)
        
        query = 'ECB/QSA/Q.N..' %&% wa %&% '.' %&% sg %&% '.S1.N.L.' %&% st %&% '.' %&% ii %&% '.._Z.XDC._T.S.V.N.'
        partial_loads[[k]] = try(mds(query, drop = FALSE), silent = TRUE)
      }
    }
  }
  
  merged = NULL
  for (x in partial_loads) {
    if (is(x, 'md3')) {
      if (is.null(merged)) merged = x else merged = merge(merged, x)
    }
  }
  
  if (!is.null(merged)) {
    # Drop singletons so downstream [.W0...] / [...T..] selectors work
    lll[['L']][[ii]] = drop_md3_singletons(merged)
  } else {
    lll[['L']][[ii]] = partial_loads[[1]]
  }
  
  saveRDS(lll, file.path('C:/Users/Public/finflowsbuffer', 'fflist.rds'))
}

gc()

##############################################################################
# SECTION 2: Load Assets (A)
# Split along:
#   COUNTERPART_AREA (W0 / W2)          : 2
#   REF_SECTOR x COUNTERPART_SECTOR     : 25 (5 groups x 5 groups)
#   STO (LE / F)                        : 2
# Total: 100 partial loads per instrument (many return 404 for non-existent
# combinations, which is normal - merge() ignores them).
# After merge(), do NOT drop singletons: downstream uses positional selectors
# like [N..W2...N.A..F511._Z._Z.XDC._T.S.V.N..] that address all 18 dims.
##############################################################################

sector_combinations = list()
for (r in xss_groups) {
  for (c in xss_groups) {
    sector_combinations[[length(sector_combinations) + 1]] = list(ref = r, ctp = c)
  }
}

for (ii in strsplit(xii, split = '\\+')[[1]]) {
  message('A: Instrument ', ii)
  cat(format(Sys.time(), '%H:%M:%S') %&% ': A ' %&% ii %&% '\n', 
      file = file.path(data_dir, 'finflows.log'), append = TRUE)
  
  partial_loads = list()
  k = 0
  
  for (wa in ctp_areas) {
    for (sc in sector_combinations) {
      for (st in sto_types) {
        k = k + 1
        if (k %% 20 == 0) message('  [', k, '/100]')
        cat('    ' %&% format(Sys.time(), '%H:%M:%S') %&% ': ' %&% wa %&% ' / ref=' %&% sc$ref %&% ' ctp=' %&% sc$ctp %&% ' / ' %&% st %&% '\n',
            file = file.path(data_dir, 'finflows.log'), append = TRUE)
        
        query = 'ECB/QSA/Q.N..' %&% wa %&% '.' %&% sc$ref %&% '.' %&% sc$ctp %&% '.N.A.' %&% st %&% '.' %&% ii %&% '.._Z.XDC._T.S.V.N.'
        partial_loads[[k]] = try(mds(query, drop = FALSE), silent = TRUE)
      }
    }
  }
  
  merged = NULL
  for (x in partial_loads) {
    if (is(x, 'md3')) {
      if (is.null(merged)) merged = x else merged = merge(merged, x)
    }
  }
  
  if (!is.null(merged)) {
    # Preserve full 18-dim structure (do NOT drop singletons)
    lll[['A']][[ii]] = merged
  } else {
    lll[['A']][[ii]] = partial_loads[[1]]
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