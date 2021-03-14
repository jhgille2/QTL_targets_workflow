##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title
##' @param CrossData
##' @param Pheno
##' @param nPerm
Map_SimpleInterval_Perms <- function(CrossData = QTLData, Pheno = PhenoNames,
                                     nPerm = 100) {

  scanone(cross     = CrossData, 
          pheno.col = Pheno,
          method    = "em",
          n.perm    = nPerm)

}
