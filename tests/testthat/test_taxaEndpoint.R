context('taxa endpoint')

testthat::test_that('allDatasets',{
    defaultCall = allTaxa() 
    testthat::expect_is(defaultCall,'list')
    
    # memoise test. memoised function should be faster
    time = microbenchmark::microbenchmark(allTaxa(),unit = 'ms') %>% summary
    timeMemo = microbenchmark::microbenchmark(allTaxa(memoised = TRUE),unit = 'ms') %>% summary
    testthat::expect_lt(timeMemo$mean,time$mean)
})


testthat::test_that('taxonInfo',{
    testthat::expect_is(taxonInfo('human'),'list')
    testthat::expect_true(length(taxonInfo('human'))>0)
    testthat::expect_error(taxonInfo('o zaman dans'),'404')
    testthat::expect_null(taxonInfo('human',return = FALSE))
    
    testthat::expect_warning(taxonInfo('human',request = 'datasets',dsad=3),'request only accepts')
    
    testthat::expect_true(length(taxonInfo('human',request = 'datasets',limit=0))>20)
    
    phenoRequest = taxonInfo('human',request = 'phenotypes')
    testthat::expect_is(phenoRequest,'list')
    testthat::expect_true(length(phenoRequest)>0)
    
    phenoCandRequest = taxonInfo('human',request = 'phenoCandidateGenes',
                                 phenotypes = c('http://purl.obolibrary.org/obo/DOID_11934',
                                                'http://purl.obolibrary.org/obo/DOID_3119'))
    testthat::expect_is(phenoCandRequest,'list')
    testthat::expect_true(length(phenoCandRequest)>0)
    
   
    testthat::expect_is(taxonInfo('human', request= 'gene',gene='1859'),'list')
    testthat::expect_is(taxonInfo('human', request= 'gene',gene='DYRK1A'),'list')
    testthat::expect_is(taxonInfo('human', request= 'geneEvidence',gene='DYRK1A'),'list')
    testthat::expect_is(taxonInfo('human', request= 'geneLocation',gene='DYRK1A'),'list')
    
    testthat::expect_is(taxonInfo('human', request= 'genesAtLocation',chromosome=21,start = 37365790,size = 1),'list')
    testthat::expect_error(taxonInfo('human', request= 'genesAtLocation',chromosome=21,start = 37365790),'request requires')
    
    # memoise test. memoised function should be faster
    time = microbenchmark::microbenchmark(taxonInfo('human','datasets'),unit = 'ms') %>% summary
    timeMemo = microbenchmark::microbenchmark(taxonInfo('human','datasets',memoised = TRUE),unit = 'ms') %>% summary
    testthat::expect_lt(timeMemo$mean,time$mean)
})
