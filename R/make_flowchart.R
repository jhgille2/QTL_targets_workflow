##' .. content for \description{} (no empty lines) ..
##'
##' .. content for \details{} ..
##'
##' @title

make_flowchart <- function() {

DiagrammeR::grViz("digraph {

graph [layout = dot]

# define the global styles of the nodes. We can override these in box if we wish
node [shape = rectangle, style = filled, fillcolor = Cyan]

CrossData [label = 'Read cross data', shape = cylinder]
InspectData [label = 'Inspect phenotype and genotype data']

ModelChoice [label = 'Choose model', shape = 'diamond']
SingleQTL [label = 'Single QTL model(s)']
MultiQTL [label = 'Multi-QTL model(s)']
ParamChoice [label = 'Choose model parameters', shape = 'diamond']

FitSingle [label = 'Fit single QTL model(s)']
FitMulti [label = 'Fit multi-QTL model(s)']
Perms [label = 'Determine significance thresholds']

SigSingle [label = 'Identify significant QTL \n and calculate QTL paramaters \n (Single)']
SigMulti [label = 'Identify significant QTL \n and calculate QTL paramaters \n for each parameter choice']

CompareMulti [label = 'Compare results between parameter choices']

CompareModels [label = 'Compare results between models']

FinalModel [label = 'Choose final model']


# edge definitions with the node IDs
CrossData -> InspectData -> ModelChoice -> {SingleQTL, MultiQTL}
SingleQTL -> FitSingle -> Perms -> SigSingle -> CompareModels
MultiQTL -> FitMulti -> Perms -> SigMulti -> CompareMulti -> CompareModels -> FinalModel
ParamChoice -> MultiQTL
}")
  

}
