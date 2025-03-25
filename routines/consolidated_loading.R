##############################################################################
# MERGED DATA LOADING SCRIPT
# This script combines multiple data loading scripts in sequence
##############################################################################

library(MDstats)
library(MD3)
`%&%` = function (..., collapse = NULL, recycle0 = FALSE)  .Internal(paste0(list(...), collapse, recycle0))

if (!dir.exists('C:/Users/Public/finflowsbuffer')) {
  dir.create('C:/Users/Public/finflowsbuffer')
}

# Set data directory
if (!exists("data_dir")) data_dir = '\\\\s-jrciprnacl01p-cifs-ipsc.jrc.it/ECOFIN/FinFlows/githubrepo/finflows/data/'
setwd(file.path(data_dir %&% ".." ))
script_dir = file.path(gsub('/data','/routines/loading',data_dir))

##############################################################################
source(script_dir %&% '/001_finflowers_loadQSAfromECB.R'); gc()
message('1 done. saving...'); save.image('C:/Users/Public/finflowsbuffer/loading_outcome.rda')

source(script_dir %&% '/007_new_load_nasa_unconsolidated.R'); gc()
message('7 done. saving...'); save.image('C:/Users/Public/finflowsbuffer/loading_outcome.rda')

source(script_dir %&% '/008_new_load_nasa_unconsolidated_TRANS.R'); gc()
message('8 done. saving...'); save.image('C:/Users/Public/finflowsbuffer/loading_outcome.rda')

source(script_dir %&% '/009_new_load_nasa_consolidated.R'); gc()
message('9 done. saving...'); save.image('C:/Users/Public/finflowsbuffer/loading_outcome.rda')

source(script_dir %&% '/010_new_load_nasa_consolidated_TRANS.R'); gc()
message('10 done. saving...'); save.image('C:/Users/Public/finflowsbuffer/loading_outcome.rda')

source(script_dir %&% '/011_finflowers_load_nasq10f.R'); gc()
message('11 done. saving...'); save.image('C:/Users/Public/finflowsbuffer/loading_outcome.rda')

source(script_dir %&% '/012_finflowers_load_BSI_MFI_new.R'); gc()
message('12 done. saving...'); save.image('C:/Users/Public/finflowsbuffer/loading_outcome.rda')

source(script_dir %&% '/013_loadiip.R'); gc()
message('13 done. saving...'); save.image('C:/Users/Public/finflowsbuffer/loading_outcome.rda')

