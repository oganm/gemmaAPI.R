context("misc tests")


testthat::test_that('forgetGemmaMemoised',{
    x = taxonInfo('human','datasets',memoised = TRUE)
    timeRemember = microbenchmark::microbenchmark(taxonInfo('human','datasets',memoised = TRUE),times = 1,unit = 'ms') %>% summary
    forgetGemmaMemoised()
    timeForgot = microbenchmark::microbenchmark(taxonInfo('human','datasets',memoised = TRUE),times = 1,unit = 'ms') %>% summary
    testthat::expect_lt(timeRemember$mean,timeForgot$mean)
    
})