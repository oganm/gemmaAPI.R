context('other endpoints')


testthat::test_that('annotation endpoint',{
    defaultCall = annotationInfo('http://purl.obolibrary.org/obo/OBI_0000105')
    shortCall = annotationInfo('OBI_0000105')
    testthat::expect_is(defaultCall,'list')
    testthat::expect_identical(defaultCall,shortCall)
    expCall = annotationInfo('OBI_0000105', request = 'experiments')
    testthat::expect_is(expCall,'list')
})
