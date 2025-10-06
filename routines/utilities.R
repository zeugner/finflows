savevl = function(..., list = character(), file = stop("'file' must be specified"), 
                      ascii = FALSE, version = NULL, envir = parent.frame(), compress = isTRUE(!ascii), 
                      compression_level, eval.promises = TRUE, precheck = TRUE) {
  ttx=tempfile(fileext='.rda')
  save(..., file=ttx, list=list, ascii=ascii, version = version, envir=envir, compress=compress, compression_level = compression_level, eval.promises = eval.promises, precheck=precheck)
  file.copy(ttx,file,overwrite = TRUE)
  file.remove(ttx)
}
  
  
saveRDSvl = function(object, file = "", ascii = FALSE, version = NULL, compress = TRUE, 
                         refhook = NULL) {
  ttx=tempfile(fileext='.rda')
  saveRDS(object, file = ttx, ascii = ascii, version = version, compress = compress, refhook = refhook)
  file.copy(ttx,file,overwrite = TRUE)
  file.remove(ttx)
}


fwritevl = function(x,file="",...) {
  ttx=tempfile(fileext='.csv')
  fwrite(x,file=ttx,...)
  file.copy(ttx,file,overwrite = TRUE)
  file.remove(ttx)
}
