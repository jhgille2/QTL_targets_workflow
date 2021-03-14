##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title
##' @param CrossData
##' @param Pheno
Map_Regression <- function(CrossData = QTLData, Pheno = PhenoNames) {

  scanone(cross     = CrossData, 
          pheno.col = Pheno,
          method    = "mr")

}
