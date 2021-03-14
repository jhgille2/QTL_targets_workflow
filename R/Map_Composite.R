##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title
##' @param CrossData
##' @param Pheno
##' @param nCovar
##' @param WindowSize
Map_Composite <- function(CrossData = QTLData, Pheno = PhenoNames, nCovar =
                          CIM_n.marcovar, WindowSize = CIM_Window) {

  cim(cross      = CrossData,
      pheno.col  = Pheno,
      n.marcovar = nCovar,
      window     = WindowSize,
      method     = "em")
 
}
