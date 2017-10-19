context('platform endpoints')

testthat::test_that('allPlatforms',{
    defaultCall = allPlatforms()
    testthat::expect_is(defaultCall,'list')
    testthat::expect_length(defaultCall,20)
    limitCall = allPlatforms(limit = 10) 
    testthat::expect_length(limitCall,10)
    filterCall = allPlatforms(filter ='curationDetails.troubled = true')
    testthat::expect_is(filterCall,'list')
    noCall = allPlatforms(return=FALSE)
    testthat::expect_null(noCall)
    
    # memoise test. memoised function should be faster
    time = microbenchmark::microbenchmark(allPlatforms(),times = 10,unit = 'ms') %>% summary
    timeMemo = microbenchmark::microbenchmark(allPlatforms(memoised = TRUE),times = 10,unit = 'ms') %>% summary
    testthat::expect_lt(timeMemo$median,time$median)
})


testthat::test_that('platformInfo',{
    testthat::expect_is(platformInfo('GPL1355'),'list')
    # no longer is an error
    # testthat::expect_error(platformInfo('o zaman dans'),'404')
    testthat::expect_null(platformInfo('GPL1355',return = FALSE))
    testthat::expect_true(length(platformInfo('GPL1355'))>0)
    
    testthat::expect_is(platformInfo('GPL19485',request = 'annotations'),'data.frame')
    
    testthat::expect_true(length(platformInfo('GPL1355',request = 'datasets'))>0)
    testthat::expect_length(platformInfo('GPL1355',request = 'datasets',limit = 10,offset = 14),10)
    testthat::expect_length(platformInfo('GPL1355',request = 'elements',limit = 10,offset = 14),10)
    testthat::expect_is(platformInfo('GPL1355',request = 'specificElement',probe = 'AFFX_Rat_beta-actin_M_at'),'list')
    testthat::expect_is(platformInfo('GPL1355',request = 'genes',probe = 'AFFX_Rat_beta-actin_M_at'),'list')
    
    
    # memoise test. memoised function should be faster
    time = microbenchmark::microbenchmark(platformInfo('GPL1355'),times = 10, unit = 'ms') %>% summary
    timeMemo = microbenchmark::microbenchmark(platformInfo('GPL1355',memoised = TRUE),times = 10, unit = 'ms') %>% summary
    testthat::expect_lt(timeMemo$median,time$median)
})
    

