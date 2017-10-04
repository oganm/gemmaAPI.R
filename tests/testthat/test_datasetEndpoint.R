context('dataset endpoints')

testthat::test_that('allDatasets',{
    defaultCall = allDatasets() 
    testthat::expect_is(defaultCall,'list')
    testthat::expect_length(defaultCall,20)
    limitCall = allDatasets(limit = 10) 
    testthat::expect_length(limitCall,10)
    filterCall = allDatasets(filter ='curationDetails.troubled = true')
    listCall = allDatasets(datasets = c('GSE2871','GSE2869','GSE2868'))
    testthat::expect_equal(names(listCall),  c('GSE2871','GSE2869','GSE2868'))
})


testthat::test_that('datasetInfo',{
    testthat::expect_is(datasetInfo('GSE81454'),'list')
    testthat::expect_true(length(datasetInfo('GSE81454'))>0)
    
    testthat::expect_is(datasetInfo('GSE81454',request = 'samples'),'list')
    testthat::expect_true(length(datasetInfo('GSE81454',request = 'samples'))>0)
    
    testthat::expect_is(datasetInfo('GSE81454',request = 'annotations'),'list')
    testthat::expect_true(length(datasetInfo('GSE81454',request = 'annotations'))>0)
    
    testthat::expect_is(datasetInfo('GSE81454',request = 'platforms'),'list')
    testthat::expect_true(length(datasetInfo('GSE81454',request = 'platforms'))>0)
    
    testthat::expect_is(datasetInfo('GSE81454',request = 'design'),'data.frame')
    nonFiltered  = datasetInfo('GSE81454',request = 'data')
    testthat::expect_is(nonFiltered,'data.frame')
    filtered = datasetInfo('GSE81454',request = 'data',filter=TRUE)
    testthat::expect_is(filtered,'data.frame')
    testthat::expect_true(nrow(filtered)<nrow(nonFiltered))
    
    f = tempfile()
    datasetInfo('GSE81454',request = 'design',file = f)
    readFile = data.table::fread(f,data.table=FALSE)
    
    testthat::expect_is(readFile,'data.frame')
    
    
    testthat::expect_error(datasetInfo('GSE81454',request = 'differential'),regexp = 'qValueThreshold')
    testthat::expect_is(datasetInfo('GSE12679',request = 'differential',qValueThreshold = 1),'list')
    testthat::expect_true(length(datasetInfo('GSE12679',request = 'differential',qValueThreshold = 1))>0)
    
})
