context('annotations')


testthat::test_that('annotations',{
    gpl96 = getMicroannot(1)
    
    testthat::expect_equal(names(gpl96),
                           c("ProbeName", 
                             "GeneSymbols",
                             "GeneNames",
                             "GOTerms",
                             "GemmaIDs", 
                             "NCBIids"))
    
    file = tempfile()
    getMicroannot(1,file = file, return = FALSE)
    
    gpl96File = readDataFile(file)
    
    testthat::expect_identical(gpl96, gpl96File)
    
    testthat::expect_warning(getMicroannot(1,file = file, return = FALSE),
                             'already exists')
    
    probes = c("206746_at", "220141_at", "212531_at", "206510_at", "206511_s_at", 
               "204924_at",'LEBLEBI')
    
    geneMatchNA = annotationGeneMatch(probes,gpl96,removeNAs = FALSE)
    geneMatchNoNA = annotationGeneMatch(probes,gpl96,removeNAs = TRUE)
    geneMatchNoNAFromFile = annotationGeneMatch(probes,file,removeNAs = TRUE)
    testthat::expect_identical(geneMatchNoNA, geneMatchNoNAFromFile)
    testthat::expect_equal(length(geneMatchNA), length(geneMatchNoNA)+1)
    
    fromDF = annotationProbesetMatch(geneMatchNoNA,gpl96)
    fromFile = annotationProbesetMatch(geneMatchNoNA,file)
    testthat::expect_identical(fromDF, fromFile)
    
    
})