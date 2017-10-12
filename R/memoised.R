#' @export
mem_datasetInfo = memoise::memoise(datasetInfo)

#' @export
mem_allDatasets = memoise::memoise(allDatasets)

#' @export
mem_allPlatforms = memoise::memoise(allPlatforms)

#' @export
mem_platformInfo = memoise::memoise(platformInfo)

#' @export
mem_geneInfo = memoise::memoise(geneInfo)

#' @export
mem_allTaxa = memoise::memoise(allTaxa)

#' @export
mem_taxonInfo = memoise::memoise(taxonInfo)

#' @export
mem_annotationInfo = memoise::memoise(annotationInfo)

#' forgetGemmaMemoised
#' 
#' Deletes caches of all memoised functions within gemmaAPI package.
#' 
#' @export
forgetGemmaMemoised = function(){
    memoise::forget(mem_datasetInfo)
    memoise::forget(mem_allDatasets)
    memoise::forget(mem_allPlatforms)
    memoise::forget(mem_platformInfo)
    memoise::forget(mem_geneInfo)
    memoise::forget(mem_allTaxa)
    memoise::forget(mem_taxonInfo)
    memoise::forget(mem_annotationInfo)
    return(NULL)
}

# temporary
#' @export
forgetTest = function(){
    mem_allDatasets(limit = 0)
}
