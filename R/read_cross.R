##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title
##' @param QTL_File
read_cross <- function(QTL_File = !!file_in(QTLFile)) {

  InitialCross <- read.cross(format     = "csv",
                             file       = QTL_File,
                             na.strings = "-1",
                             genotypes  = c("2", "1", "0", "12", "10"),
                             crosstype  = "riself")
  
  
  # "Jitter" map such that no markers are in the same position
 InitialCross %<>%
   jittermap() %>%
   calc.genoprob()
 
 InitialCross
}
