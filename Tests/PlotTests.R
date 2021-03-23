
test <- tar_read(CompositeIntervalResults_Summary)

LeafWidth <- test %>% dplyr::filter(Pheno == "LeafWidth") %>%
  group_by(Pheno, chr, nCofactors, Window_Size) %>%
  arrange(Pheno, pos) %>%
  ungroup()

MakeEchart <- function(TraitChrData = LeafWidth, facetVar = "nCofactors", groupVar = "Window_Size"){
  SplitData <- split(TraitChrData, TraitChrData[, facetVar])
  
  EchartList <- vector("list", length = length(SplitData))
  
  for(i in seq_along(SplitData)){
    FacetValue <- names(SplitData)[[i]]
    
    FacetTitle <- paste(facetVar, ": ", FacetValue)
    
    EchartList[[i]] <- SplitData[[i]] %>%
      group_by(!!sym(groupVar)) %>%
      e_charts(pos) %>%
      e_area(lod) %>%
      e_tooltip(trigger = "axis") %>%
      e_title(FacetTitle) %>%
      e_theme("dark-bold")
  }
  
  EchartList
}

LeafWidth %>%
  split(.$nCofactors) -> CofactorSplit

LeafWidth %>% 
  arrange(chr, nCofactors, pos) %>%
  dplyr::filter(chr == 1, Window_Size ==10) %>%
  e_charts(pos) %>%
  e_surface(nCofactors, lod, wireframe = list(show = TRUE)) %>%
  e_visual_map(lod)


e1 <- LeafWidth %>%
  dplyr::filter(nCofactors == 5, chr == 1) %>%
  e_charts(pos) %>%
  e_area(lod) %>%
  e_tooltip(trigger = "axis") %>%
  e_title("5 Cofactors") %>%
  e_group("grp")

e3 <- LeafWidth %>%
  dplyr::filter(nCofactors == 5, chr == 3) %>%
  group_by(Window_Size) %>%
  e_charts(pos) %>%
  e_area(lod) %>%
  e_tooltip(trigger = "axis") %>%
  e_title("5 Cofactors") %>%
  e_group("grp") %>%
  e_connect_group("grp")

e5 <- LeafWidth %>%
  dplyr::filter(nCofactors == 5, chr == 5) %>%
  group_by(Window_Size) %>%
  e_charts(pos) %>%
  e_area(lod) %>%
  e_tooltip(trigger = "axis") %>%
  e_title("5 Cofactors")

e_arrange(e1, e3, e5, cols = 3)


e2 <- LeafWidth %>%
  dplyr::filter(nCofactors == 6) %>%
  group_by(Window_Size) %>%
  e_charts(pos) %>%
  e_area(lod) %>%
  e_tooltip(trigger = "axis") %>%
  e_title("6 Cofactors")

e_arrange(testCharts[[1]], testCharts[[2]], testCharts[[3]], cols = 3)

LWidth_Chr1 <- LeafWidth %>% 
  dplyr::filter(chr == 1)

# Need to automate this chart
LWidth_Chr1 %>%
  pivot_wider(names_from = nCofactors, values_from = lod) %>%
  group_by(Window_Size) %>%
  e_charts(pos, timeline = TRUE) %>%
  e_legend(show = TRUE) %>%
  e_area(`5`, legend = TRUE, name = 'Window Size: 5') %>%
  e_area(`7`, legend = TRUE, name = 'Window Size: 7') %>%
  e_area(`10`, legend = TRUE, name = 'Window Size: 10') %>%
  e_tooltip(trigger = "axis") %>%
  e_timeline_serie(
    title = list(
      list(text = "10 cofactors"),
      list(text = "15 Cofactors"),
      list(text = "20 cofactors")
    )
  ) %>%
  e_theme("dark-bold")
