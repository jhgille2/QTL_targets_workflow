##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title
##' @param CrossData
##' @param Pheno
##' @param nPerm
Map_Regression_Perms <- function(CrossData = QTLData, Pheno = PhenoNames, nPerm = 100) {

  scanone(cross     = CrossData, 
          pheno.col = Pheno,
          method    = "mr",
          n.perm    = nPerm)

}
