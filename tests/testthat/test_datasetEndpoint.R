context('dataset endpoints')

testthat::test_that('allDatasets',{
    defaultCall = allDatasets() 
    testthat::expect_is(defaultCall,'list')
    testthat::expect_length(defaultCall,20)
    limitCall = allDatasets(limit = 10) 
    testthat::expect_length(limitCall,10)
    filterCall = allDatasets(filter ='curationDetails.troubled = true')
    testthat::expect_is(filterCall,'list')
    listCall = allDatasets(datasets = c('GSE2871','GSE2869','GSE2868'))
    testthat::expect_equal(names(listCall),  c('GSE2871','GSE2869','GSE2868'))
    listCall = allDatasets(datasets = c('GSE2871','GSE2869','GSE2868'),return = FALSE)
    testthat::expect_null(listCall)
    
    # memoise test. memoised function should be faster
    time = microbenchmark::microbenchmark(allDatasets(limit = 100),times = 10,unit = 'ms') %>% summary
    timeMemo = microbenchmark::microbenchmark(allDatasets(limit = 100,memoised = TRUE),times =10, unit = 'ms') %>% summary
    testthat::expect_lt(timeMemo$median,time$median)
})


testthat::test_that('datasetInfo',{
    testthat::expect_is(datasetInfo('GSE81454'),'list')
    # testthat::expect_error(datasetInfo('o zaman dans'),'404')
    
    testthat::expect_null(datasetInfo('GSE81454',return = FALSE))
    
    testthat::expect_length(datasetInfo('GSE81454'),1)
    
    testthat::expect_is(datasetInfo('GSE81454',request = 'samples'),'list')
    testthat::expect_error(datasetInfo(c('GSE81454',3888),request = 'samples'),regexp = 'not a string')
    
    testthat::expect_true(length(datasetInfo('GSE81454',request = 'samples'))>0)
    
    testthat::expect_warning(datasetInfo('GSE81454',request = 'samples',loyloy= 'sadds'),'does not accept parameters')
    
    testthat::expect_is(datasetInfo('GSE81454',request = 'annotations'),'list')
    testthat::expect_true(length(datasetInfo('GSE81454',request = 'annotations'))>0)
    
    testthat::expect_is(datasetInfo('GSE81454',request = 'platforms'),'list')
    testthat::expect_true(length(datasetInfo('GSE81454',request = 'platforms'))>0)
    
    testthat::expect_is(datasetInfo('GSE81454',request = 'design'),'data.frame')
    
    testthat::expect_is(datasetInfo('GSE81454',request = 'design'),'data.frame')

    expressions = datasetInfo(3888,request='geneExpression',genes = c(1859, 5728))
    testthat::expect_is(expressions,'list')
    testthat::expect_length(expressions, 1)
    testthat::expect_true(all(names(expressions[[1]]) %in% c('geneExpressionLevels', 'datasetId')))
    expressionsMultiple = datasetInfo(c(3888,'GSE2871'),request='geneExpression',genes = c(1859, 5728))
    testthat::expect_length(expressionsMultiple, 2)
    
    
    
    nonFiltered  = datasetInfo('GSE81454',request = 'data')
    idColnames = datasetInfo('GSE81454',request = 'data',IdColnames = TRUE)
    idColnamesFalse = datasetInfo('GSE81454',request = 'data',IdColnames = FALSE)
    testthat::expect_true(nchar(colnames(idColnames)[7])< nchar(colnames(idColnamesFalse)[7]))
    
    
    testthat::expect_is(nonFiltered,'data.frame')
    filtered = datasetInfo('GSE81454',request = 'data',filter=TRUE)
    testthat::expect_is(filtered,'data.frame')
    testthat::expect_true(nrow(filtered)<nrow(nonFiltered))
    
    f = tempfile()
    datasetInfo('GSE81454',request = 'design',file = f)
    
    lines = readLines(gzfile(f),n = 100)
    skip = lines %>% grepl('^#',x = .) %>% which %>% max
    readFile = readr::read_tsv(gzfile(f), col_names= TRUE,skip = skip)    
    testthat::expect_is(readFile,'data.frame')
    
    
    
    differential = datasetInfo('GSE12679',request = 'differential')
    resultSetId = differential$resultSets$`456407`$resultSetId
    
    testthat::expect_is(differential,'list')
    testthat::expect_true(length(differential)>0)
    
    difExp = datasetInfo('GSE12679',request = 'diffEx', diffExSet = resultSetId)
    testthat::expect_is(difExp,'list')
    testthat::expect_true(length(difExp)>0)
    
    
    # memoise test. memoised function should be faster
    time = microbenchmark::microbenchmark(datasetInfo('GSE81454',request = 'design'),times = 10,unit = 'ms') %>% summary
    timeMemo = microbenchmark::microbenchmark(datasetInfo('GSE81454',request = 'design',memoised = TRUE),times = 10,unit = 'ms') %>% summary
    testthat::expect_lt(timeMemo$median,time$median)
})
