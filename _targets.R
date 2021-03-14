## Load your packages, e.g. library(targets).
source("./packages.R")

## Load your R files
lapply(list.files("./R", full.names = TRUE), source)


## tar_plan supports drake-style targets and also tar_target()
tar_plan(
  
  tar_target(InputFile, 
             "Data/ExampleCross.csv",
             format = "file"),
  
  # Read the QTL file in with r/qtls "read.cross" function. Also apply
  # a few basic operations to clean the initial cross
  QTLData = read_cross(QTL_File = InputFile),
  
  # Get the phenotype names from the cross object
  tar_target(PhenoNames,
             phenames(QTLData)),
  
  # Marker regression mapping and permutations
  tar_target(RegressionResults,
             Map_Regression(CrossData = QTLData,
                                Pheno = PhenoNames),
             pattern = map(PhenoNames),
             iteration = "list"),
  
  tar_target(RegressionPerms,
             Map_Regression_Perms(CrossData = QTLData,
                                  Pheno     = PhenoNames,
                                  nPerm     = 100),
             pattern = map(PhenoNames),
             iteration = "list"),
  
  # Simple interval mapping and permutations
  tar_target(SimpleIntervalResults,
             Map_SimpleInterval(CrossData   = QTLData,
                                      Pheno = PhenoNames),
             pattern = map(PhenoNames),
             iteration = "list"),
  
  tar_target(SimpleIntervalPerms,
             Map_SimpleInterval_Perms(CrossData = QTLData,
                                      Pheno     = PhenoNames,
                                      nPerm     = 100),
             pattern = map(PhenoNames),
             iteration = "list"),
  
  # Composite interval mapping
  # First, define what values for model parameters you want to test
  
  # The number of marker covariates
  tar_target(CIM_n.marcovar,
             c(5, 6)),
  
  # The window size
  tar_target(CIM_Window,
             c(10, 15)),
  
  # Perform composite interval mapping with each combination of phenotype,
  # numebr of marker covariates, and window size as specified above
  tar_target(CompositeIntervalResults,
             Map_Composite(CrossData  = QTLData,
                           Pheno      = PhenoNames,
                           nCovar     = CIM_n.marcovar,
                           WindowSize = CIM_Window),
             pattern = cross(PhenoNames, CIM_n.marcovar, CIM_Window),
             iteration = "list"),
  

# target = function_to_make(arg), ## drake style

# tar_target(target2, function_to_make2(arg)) ## targets style
  
  tar_render(AnalysisWriteup, "doc/AnalysisWriteup.Rmd")

)
