context('other endpoints')


testthat::test_that('annotation endpoint',{
    defaultCall = annotationInfo('http://purl.obolibrary.org/obo/OBI_0000105')
    testthat::expect_is(defaultCall,'list')
    expCall = annotationInfo('http://purl.obolibrary.org/obo/OBI_0000105', request = 'experiments')
    testthat::expect_is(expCall,'list')
    
    # memoise test. memoised function should be faster
    time = microbenchmark::microbenchmark(annotationInfo('http://purl.obolibrary.org/obo/OBI_0000105'),unit = 'ms') %>% summary
    timeMemo = microbenchmark::microbenchmark(annotationInfo('http://purl.obolibrary.org/obo/OBI_0000105',memoised = TRUE),unit = 'ms') %>% summary
    testthat::expect_lt(timeMemo$mean,time$mean)
})