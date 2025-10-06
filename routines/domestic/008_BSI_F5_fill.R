<<<<<<< HEAD
# Load required packages
library(MDstats)
library(MD3)

# Set data directory
if (!exists("data_dir")) data_dir = getwd()

# Load assets data
asbsi= readRDS(file.path(data_dir, "bsi_assets.rds"))
# Load liabilities data
libsi = readRDS(file.path(data_dir, "bsi_liab.rds"))

# Load current aall version
aall=readRDS(file.path(data_dir, 'intermediate_domestic_data_files/aall_NASA_intrasector.rds'))
gc()
setkey(aall, NULL)

### data structure
gc()
names(dimnames(asbsi))[[2]] = 'INSTR'
names(dimnames(libsi))[[1]] = 'STO'
names(dimnames(libsi))[[2]] = 'REF_AREA'

dimnames(libsi)[['STO']] = c("1"='LE',"4"='F')

# Check current data
aall[F5.AT.S12T..LE._T.2022q4]
aall[F51..S12T.S12O.LE._T.2023q4]

#ASSETS FILLING
aall[..S12T..._T., usenames=TRUE, onlyna=TRUE] = asbsi["....1998q4:"]

# Check after filling
aall[F5.AT.S12T..LE._T.2022q4]
aall[F51.AT.S12T..LE._T.2022q4]
aall[F5.AT.S12T..F._T.2022q4]

#LIABILITIES FILLING
aall[F5..S1.S12T.._T., usenames=TRUE, onlyna=TRUE] = libsi["..1998q4:"]

##### FILL F51M NAS AS RESIDUAL BETWEEN THESE NEW F51 AND POSSIBLY PREEXISTING F511
gc()
aall[F51+F511+F51M.AT.S12T..LE._T.2022q4]
temp=aall["F51..S12T..._T."]-aall["F511..S12T..._T."]
aall[F51M..S12T..._T., usenames=TRUE, onlyna=TRUE] <- temp

=======
# Load required packages
library(MDstats)
library(MD3)

# Set data directory
if (!exists("data_dir")) data_dir = getwd()

# Load assets data
asbsi= readRDS(file.path(data_dir, "bsi_assets.rds"))
# Load liabilities data
libsi = readRDS(file.path(data_dir, "bsi_liab.rds"))

# Load current aall version
aall=readRDS(file.path(data_dir, 'intermediate_domestic_data_files/aall_NASA_intrasector.rds'))
gc()
setkey(aall, NULL)

### data structure
gc()
names(dimnames(asbsi))[[2]] = 'INSTR'
names(dimnames(libsi))[[1]] = 'STO'
names(dimnames(libsi))[[2]] = 'REF_AREA'

dimnames(libsi)[['STO']] = c("1"='LE',"4"='F')

# Check current data
aall[F5.AT.S12T..LE._T.2022q4]
aall[F51..S12T.S12O.LE._T.2023q4]

#ASSETS FILLING
aall[..S12T..._T., usenames=TRUE, onlyna=TRUE] = asbsi["....1998q4:"]

# Check after filling
aall[F5.AT.S12T..LE._T.2022q4]
aall[F51.AT.S12T..LE._T.2022q4]
aall[F5.AT.S12T..F._T.2022q4]

#LIABILITIES FILLING
aall[F5..S1.S12T.._T., usenames=TRUE, onlyna=TRUE] = libsi["..1998q4:"]

##### FILL F51M NAS AS RESIDUAL BETWEEN THESE NEW F51 AND POSSIBLY PREEXISTING F511
gc()
aall[F51+F511+F51M.AT.S12T..LE._T.2022q4]
temp=aall["F51..S12T..._T."]-aall["F511..S12T..._T."]
aall[F51M..S12T..._T., usenames=TRUE, onlyna=TRUE] <- temp

>>>>>>> 55a5a789115f3c6e93936ceaded19180b9724739
saveRDS(aall, file.path(data_dir, 'intermediate_domestic_data_files/aall_bsi_f5.rds'))