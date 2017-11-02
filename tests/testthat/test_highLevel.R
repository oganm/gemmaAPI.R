context('high level functions')


testthat::test_that('compileMetadata',{
    
    meta167 = compileMetadata(167)
    testthat::expect_is(compileMetadata(167),'data.frame')
    testthat::expect_true(all(grepl('\\|',meta167$accession)))
    
    meta167NoCollapse = compileMetadata(167,collapseBioMaterials = FALSE)
    
    testthat::expect_gt(nrow(meta167NoCollapse), nrow(meta167))
    meta924 = compileMetadata(924)
    
    testthat::expect_true(meta924$experimentAnnotClassOntoID %>% stringr::str_split('\\|') %>% {.[[1]][1] == "NA"})
    
    
    mouseStudies = taxonInfo('mouse',request = 'datasets',limit = 0)
    
    studyIDs = mouseStudies %>% purrr::map_int('id')
    
    
    mouseMetadata = studyIDs[1:10] %>% lapply(function(x){
        print(x)
        compileMetadata(x)
    })
    
    # mouseMetadata = studyIDs[studyIDs > 5384] %>% lapply(function(x){
    #     print(x)
    #     compileMetadata(x)
    #     })

    
})
    