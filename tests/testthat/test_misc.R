context("misc tests")
httr::set_config(httr::config(ssl_verifypeer = 0L)) 


testthat::test_that('forgetGemmaMemoised',{
    x = taxonInfo('human','datasets',memoised = TRUE)
    timeRemember = microbenchmark::microbenchmark(taxonInfo('human','datasets',memoised = TRUE),times = 1,unit = 'ms') %>% summary
    forgetGemmaMemoised()
    timeForgot = microbenchmark::microbenchmark(taxonInfo('human','datasets',memoised = TRUE),times = 1,unit = 'ms') %>% summary
    testthat::expect_lt(timeRemember$mean,timeForgot$mean)
    
})

testthat::test_that('overwrite',{
    functionList = c(allDatasets,
                     datasetInfo,
                     datasetInfo,
                     allPlatforms,
                     platformInfo,
                     geneInfo,
                     allTaxa,
                     taxonInfo,
                     annotationInfo)
    args = list(allDatasets = NULL,
                datasetInfo = list(dataset = 'GSE81454'),
                datasetInfo2 = list(dataset = 'GSE81454', request = 'data'),
                allPlatforms = NULL,
                platformInfo = list(platform = 'GPL1355'),
                geneInfo = list(gene = 1859),
                allTaxa = NULL,
                taxonInfo = list(taxon = 'human'),
                annotationInfo = list(annotation = "http://purl.obolibrary.org/obo/OBI_0000105"))
    for(i in seq_along(functionList)){
        file = tempfile()
        suppressWarnings(file.remove(file))
        arguments = c(args[[i]],
                      list(file = file,
                           return = TRUE,
                           overwrite= FALSE))
        invisible(do.call(functionList[[i]],arguments))
        info = file.info(file)
        testthat::expect_warning(do.call(functionList[[i]],arguments),"Skipping")
        info2 = file.info(file)
        testthat::expect_equal(info$mtime,info2$mtime)
        arguments$overwrite = TRUE
        invisible(do.call(functionList[[i]],arguments))
        info3 = file.info(file)
        testthat::expect_true(info$mtime<info3$mtime)
    }
})