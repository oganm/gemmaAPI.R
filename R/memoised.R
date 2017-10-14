mem_datasetInfo = memoise::memoise(datasetInfo)

mem_allDatasets = memoise::memoise(allDatasets)

mem_allPlatforms = memoise::memoise(allPlatforms)

mem_platformInfo = memoise::memoise(platformInfo)

mem_geneInfo = memoise::memoise(geneInfo)

mem_allTaxa = memoise::memoise(allTaxa)

mem_taxonInfo = memoise::memoise(taxonInfo)

mem_annotationInfo = memoise::memoise(annotationInfo)

#' forgetGemmaMemoised
#' 
#' Deletes caches of all memoised functions within gemmaAPI package.
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
