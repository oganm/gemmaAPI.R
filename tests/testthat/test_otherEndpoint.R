context('other endpoints')
httr::set_config(httr::config(ssl_verifypeer = 0L)) 


testthat::test_that('annotation endpoint',{
    defaultCall = annotationInfo('http://purl.obolibrary.org/obo/OBI_0000105')
    testthat::expect_is(defaultCall,'list')
    expCall = annotationInfo('http://purl.obolibrary.org/obo/OBI_0000105', request = 'datasets')
    testthat::expect_is(expCall,'list')
    
    # memoise test. memoised function should be faster
    time = microbenchmark::microbenchmark(annotationInfo('http://purl.obolibrary.org/obo/OBI_0000105'),times = 10,unit = 'ms') %>% summary
    timeMemo = microbenchmark::microbenchmark(annotationInfo('http://purl.obolibrary.org/obo/OBI_0000105',memoised = TRUE),times = 10,unit = 'ms') %>% summary
    testthat::expect_lt(timeMemo$median,time$median)
})