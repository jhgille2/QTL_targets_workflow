## Load your packages, e.g. library(targets).
source("./packages.R")

## Load your R files
lapply(list.files("./R", full.names = TRUE), source)

AllPhenos <- c("EarHeight",
               "LeafLength",
               "LeafWidth",
               "CobWeight",
               "TotalKernelVolume")

# Parameters for the single 
SingleQTL_Params <- tibble(Method = c("mr", "em"))

# Combinations of parameters for composite interval mapping.
# Useful early on for checking the effects of different model parameters on the output
CIM_ModelParams <- expand_grid(
  CIM_n.marcovar = c(5, 7, 10),
  CIM_Window     = c(10, 15, 20),
  PhenoNames     = AllPhenos
)

MQM_ModelParams <- expand.grid(
  Cofact.number = c(50, 100, 150),
  Cofact.sig    = c(0.02, 0.05, 0.1),
  Window.size   = c(10, 15),
 # Step.size    = c(0, 0.5, 1, 5),
  PhenoNames    = AllPhenos
)

## tar_plan supports drake-style targets and also tar_target()
tar_plan(
  
  # The input cross data, already in the r/qtl "csv" format
  tar_target(InputFile, 
             "Data/ExampleCross.csv",
             format = "file"),
  
  # Read the QTL file in with r/qtls "read.cross" function. Also apply
  # a few basic operations to clean the initial cross
  QTLData = read_cross(QTL_File = InputFile),
  
  ### Look into tar_map for these?
  # Marker regression mapping and permutations
  tar_target(RegressionResults,
             Map_Regression(CrossData = QTLData,
                                Pheno = phenames(QTLData))),
  
  tar_target(RegressionPerms,
             Map_Regression_Perms(CrossData = QTLData,
                                  Pheno     = phenames(QTLData),
                                  nPerm     = 100)),
  

  # Simple interval mapping and permutations
  tar_target(SimpleIntervalResults,
             Map_SimpleInterval(CrossData   = QTLData,
                                      Pheno = phenames(QTLData))),
  
  tar_target(SimpleIntervalPerms,
             Map_SimpleInterval_Perms(CrossData = QTLData,
                                      Pheno     = phenames(QTLData),
                                      nPerm     = 100)),
  
  # Composite interval mapping
  # Perform composite interval mapping with each combination of phenotype,
  # number of marker covariates, and window size as specified above
  CIM_Mapped <- tar_map(
    
    values = CIM_ModelParams,
    
    tar_target(CompositeIntervalResults,
               Map_Composite(CrossData  = QTLData,
                             Pheno      = PhenoNames,
                             nCovar     = CIM_n.marcovar,
                             WindowSize = CIM_Window,
                             perm       = F))

    # tar_target(CompositeIntervalPerms,
    #            Map_Composite(CrossData  = QTLData,
    #                          Pheno      = PhenoNames,
    #                          nCovar     = CIM_n.marcovar,
    #                          WindowSize = CIM_Window,
    #                          perm       = 100))
    
  ),

  # Combine the results to lists
   tar_combine(CompositeIntervalResults_Combined,
               CIM_Mapped[[1]],
               command = list(!!!.x)),
  
  # tar_combine(CompositeIntervalPerms_Combined,
  #             CIM_Mapped[[2]],
  #             command = list(!!!.x)),
  
  # Summarise the CIM mapping results
  tar_target(CompositeIntervalResults_Summary,
             Summarise_CIM(CIM_Results = CompositeIntervalResults_Combined)),
  
  # MQM_Mapped <- tar_map(
  # 
  #   values = MQM_ModelParams,
  # 
  #   tar_target(MQMResults,
  #              Map_MQM(CrossData            = QTLData,
  #                      Pheno                = PhenoNames,
  #                      WindowSize           = Window.size,
  #                      nCofact              = Cofact.number,
  #                      CofactorSignificance = Cofact.sig))
  # ),
  # 
  # tar_combine(MQMResults_Combined,
  #             MQM_Mapped[[1]],
  #             command = list(!!!.x)),
  
  

# target = function_to_make(arg), ## drake style

# tar_target(target2, function_to_make2(arg)) ## targets style

# A simple flowchart for the general QTL mapping process (used in the writeup)
tar_target(QTL_Flowchart, 
           make_flowchart()),
  
tar_render(AnalysisWriteup, "docs/AnalysisWriteup.Rmd")


)
