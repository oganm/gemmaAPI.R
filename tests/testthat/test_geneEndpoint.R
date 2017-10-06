context("gene endpoints")


testthat::test_that('geneInfo',{
    testthat::expect_is(geneInfo('1859'),'list')
    testthat::expect_length(geneInfo('1859'),1)
    testthat::expect_true(length(geneInfo('Eno2'))>1)
    
    testthat::expect_is(geneInfo('1859','evidence'),'list')
    testthat::expect_is(geneInfo('1859','locations'),'list')
    testthat::expect_is(geneInfo('1859','probes'),'list')
    testthat::expect_is(geneInfo('1859','probes',limit= 0),'list') # fix this test after gemma fixes
    
    geneInfo('1859','goTerms')
    testthat::expect_is(geneInfo('1859','goTerms'),'list')
    
    testthat::expect_is(geneInfo('1859','coexpression',with= '1859'),'list')
    
    
})
