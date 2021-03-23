

TestCross <- read.cross(format     = "csv",
                        file       = paste0(here(),"/Data/ExampleCross.csv"),
                        na.strings = "-1",
                        genotypes  = c("2", "1", "0", "12", "10"),
                        crosstype  = "riself")


TestCross <- jittermap(TestCross) %>%
  calc.genoprob()

TestFill01 <- fill.geno(TestCross, 
                        method = "maxmarginal",
                        min.prob = 0.95)

TestFill02 <- fill.geno(TestCross, 
                        method = "maxmarginal",
                        min.prob = 0.90)

TestFill03 <- fill.geno(TestCross, 
                        method = "maxmarginal",
                        min.prob = 0.85)


TestScanOne <-   scanone(cross     = TestCross, 
                         pheno.col = "LeafWidth",
                         method    = "em")

TestPerms <- scanone(TestCross, pheno.col = "LeafWidth", method = "em", n.perm = 1000, n.cluster = 5)

TestSummary <- summary(TestScanOne, 
                       perms = TestPerms, 
                       alpha = 0.05,
                       format = "tabByCol",
                       pvalues = TRUE)




# A function to make QTL names from a QTL summary table
Name_QTLs <- function(ScanSummary = TestSummary, TraitName = "LeafWidth"){
  as_tibble(TestSummary) %>%
    mutate(QTL_name = paste(TraitName, chr, round(pos, 1), sep = "_"))
}

# Funciton to make a qtl object from a summary table
MakeQTL_scanone <- function(ScanoneSummary = TestSummary, cross = TestCross, trait = "LeafWidth"){
  
  Summary_Named <- Name_QTLs(ScanSummary = ScanoneSummary, TraitName = trait)
  
  makeqtl(cross    = cross,
          chr      = Summary_Named$chr,
          pos      = Summary_Named$pos,
          qtl.name = Summary_Named$QTL_name,
          what     = "prob")
  
}


Fit_Scanone <- function()
