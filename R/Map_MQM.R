##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title
##' @param CrossData
##' @param Pheno
##' @param WindowSize
##' @param nCofact
##' @param CofactorSignificance
Map_MQM <- function(CrossData = QTLData, Pheno = PhenoNames, WindowSize =
                    Window.size, nCofact = Cofact.number, CofactorSignificance = Cofact.sig) {

  # Fill in missing data (Explore other methods for this)
  CrossData <- fill.geno(CrossData, 
                         # method = "maxmarginal", 
                         map.function = "kosambi")
  
  # Select cofactors
  Cofacts <- mqmautocofactors(CrossData, num = nCofact)
  
  mqmscan(CrossData, 
          cofactors             = Cofacts, 
          pheno.col             = Pheno, 
          cofactor.significance = CofactorSignificance,
          window.size           = WindowSize)

}
