##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title
##' @param CIM_Results
Summarise_CIM <- function(CIM_Results = CompositeIntervalResults_Combined, ModelParams = CIM_ModelParams) {

  CIM_Tibbles <- CIM_Results
  
  # Make a single dataframe out of the SIM results.
  # Use the list names to add the model parameters
  for(i in seq_along(CIM_Tibbles)){
    ResultName <- names(CIM_Tibbles)[[i]]
    
    SplitName <- strsplit(ResultName, "_")[[1]]
    SplitName <- SplitName[2:length(SplitName)]
    
    names(SplitName) <- names(ModelParams)
    
    # Add new columns to the result to 
    for(j in seq_along(SplitName)){
      NewColName <- names(SplitName)[[j]]
      CIM_Tibbles[[i]][, NewColName] <- SplitName[[j]]
      
      CIM_Tibbles[[i]] <- as_tibble(CIM_Tibbles[[i]])
    }
    
  }
  
  CIM_Tibble <- reduce(CIM_Tibbles, bind_rows) %>%
    mutate(CIM_n.marcovar = as.numeric(CIM_n.marcovar),
           CIM_Window     = as.numeric(CIM_Window),
           PhenoNames     = as.factor(PhenoNames)) %>%
    rename(Pheno       = PhenoNames,
           nCofactors  = CIM_n.marcovar,
           Window_Size = CIM_Window)
  
  CIM_Tibble
}
