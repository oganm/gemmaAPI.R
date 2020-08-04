context('high level functions')
httr::set_config(httr::config(ssl_verifypeer = 0L)) 

testthat::test_that('get gene expression',{
    out = expressionSubset(3888,genes = c('1859','6506'))
    
    testthat::expect_is(out,'data.frame')

})

testthat::test_that('compileMetadata',{
    # double accession dataset  removed find another test
    # meta167 = compileMetadata(167)
    # testthat::expect_is(compileMetadata(167),'data.frame')
    # testthat::expect_true(all(grepl('\\|',meta167$accession)))
    # 
    # meta167NoCollapse = compileMetadata(167,collapseBioMaterials = FALSE)
    # 
    # testthat::expect_gt(nrow(meta167NoCollapse), nrow(meta167))
    # testthat::expect_equal(ncol(meta167NoCollapse), ncol(meta167))
    
    
    meta6049 = compileMetadata(6049)
    meta6049NoCollapse = compileMetadata(6049,collapseBioMaterials = FALSE)
    testthat::expect_gt(nrow(meta6049NoCollapse), nrow(meta6049))
    testthat::expect_equal(ncol(meta6049NoCollapse), ncol(meta6049))
    
    # test for datasets with missing fields
    metaRoss = compileMetadata('ross-adipogenesis')
    testthat::expect_equal(ncol(meta6049), ncol(metaRoss))
    
    
    # meta924 = compileMetadata(924)
    # testthat::expect_true(meta924$experimentAnnotClassOntoID %>% stringr::str_split('\\|') %>% {.[[1]][1] == "NA"})
    
    
    mouseStudies = taxonInfo('mouse',request = 'datasets',limit = 0)
    
    studyIDs = mouseStudies %>% purrr::map_int('id')
    
    
    mouseMetadata = studyIDs[1:10] %>% lapply(function(x){
        # print(x)
        compileMetadata(x)
    })
    
    meta3 = compileMetadata(3)
    testthat::expect_true(any(grepl('GENE_',meta3$sampleAnnotationOntoID)))

    # test empty metadata
    meta210 = compileMetadata(210)
    testthat::expect_is(meta210,'data.frame')
    
    # mouseMetadata = studyIDs[studyIDs > 5384] %>% lapply(function(x){
    #     print(x)
    #     compileMetadata(x)
    #     })

    
})


testthat::test_that('Matching colnames in expression data and metadata',{
    data = datasetInfo('GSE1294',request= 'data', IdColnames = TRUE)
    
    metadata=  compileMetadata('GSE1294')
    
    testthat::expect_true(all(metadata$id %in% colnames(data)))
})

testthat::test_that('readExpression, splitExpression',{
    temp = tempfile()
    data = datasetInfo('GSE1294',request= 'data', IdColnames = TRUE,return = TRUE,file = temp)
    readData =  readExpression(temp)
    testthat::expect_identical(readData %>% dim, data %>% dim)
    
    readData2 =  readExpression(temp,IdColnames = TRUE)
    testthat::expect_identical(readData2, data)
    
    splitExp = splitExpression(readData)
    
    testthat::expect_is(splitExp$gene$GeneSymbol,'character')
    testthat::expect_is(splitExp$exp[,1,drop=TRUE],'numeric')
    
    
})