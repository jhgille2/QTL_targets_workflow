##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title
##' @param CrossData
##' @param Pheno
##' @param nCovar
##' @param WindowSize
##' @param perm
Map_Composite <- function(CrossData = QTLData, Pheno = PhenoNames, nCovar =
                          CIM_n.marcovar, WindowSize = CIM_Window, perm = F) {

  if(perm){
    cim(cross      = CrossData,
        pheno.col  = Pheno,
        n.marcovar = nCovar,
        window     = WindowSize,
        method     = "em",
        n.perm     = perm)
  }else{
    cim(cross      = CrossData,
        pheno.col  = Pheno,
        n.marcovar = nCovar,
        window     = WindowSize,
        method     = "em")
  }
 
}
