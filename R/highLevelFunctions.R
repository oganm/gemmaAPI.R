

#' compileMetadata
#' 
#' Compiles metadata for a single dataset that includes sample and sample
#' metadata. Note that this function uses memoised functions to speed up loops.
#' If something changes in gemma as you work and you want to update, restart 
#' your session or use \code{\link{forgetGemmaMemoised}}
#'
#' @param dataset Character. Can either be the dataset ID or its short name 
#' (e.g. GSE1234).
#' @param collapseBioMaterials If TRUE collapses samples into biomaterials
#' Some datasets represent 
#' @param outputType data.frame or list. A data.frame will return a single data frame
#' including experiment and sample data. List output will return a list of length 2 
#' where experiment and sample data are separated.
#' @param memoised Should memoisation be used for base API calls. Useful if calling
#' a large number of datasets in succession, defaults to TRUE. 
#' Use \code{\link{forgetGemmaMemoised}} to clear memory.
#' @return 
#' A data.frame. 
#' @export
#'
#' @examples
#' compileMetadata('GSE11322')
#' compileMetadata(1017)
compileMetadata = function(dataset,collapseBioMaterials = TRUE,outputType = c('data.frame','list'),
                           memoised = TRUE){
    outputType = match.arg(outputType)
    # test cases 
    # 1901 for sub calsses in experimental factors, also no accession
    # 6049 for multiple platforms
    # 154 has NULLs in factor ontologies termUri
    # 167 has double accession
    # 873 was supposed to have double accession. this is parkinson dataset and its crazy
    # 924 has None in experiment category
    mapNoNull = function(.x,.f,...){
        out = purrr::map(.x,.f,...)
        if(length(out)>0){
            out[sapply(out,is.null)] = NA
        } else
        {
            out = NULL
        }
        return(out)
    }
    
    combine = function(mapResult){
        mapResult %>% 
            purrr::map(stringr::str_replace_all,pattern = ';',replacement = '_') %>%  # escape all ;s
            purrr::map(paste,collapse=';') %>% 
            purrr::map(stringr::str_replace_all,pattern = '\\|',replacement = '_') %>%  # escape all |s
            paste(collapse='|')
    }
    

    getAnnotationID = function(URI){
        if(is.null(URI) || is.na(URI)){
            out = "NA"
        }else if(grepl(pattern = '#',URI)){
            out = stringr::str_extract(URI,'(?<=#).*')
        } else if(grepl(pattern = 'ncbi_gene',URI)){
            out = paste0('GENE_',basename(URI))
        }else{
            out = basename(URI)
        }
        return(out)
    }
    
    # getAnnotationID = memoise::memoise(getAnnotationID)
    
    # first compile information specific to the dataset
    basicInfo = datasetInfo(dataset,memoised=memoised)[[1]]
    if(length(basicInfo)==1){
        stop('you caught a bug! use internal Gemma IDs to avoid it')
    }
    
    datasetID = basicInfo$id
    datasetName = basicInfo$shortName
    taxon = basicInfo$taxon
    
    # get experiment annotations
    annotation = datasetInfo(dataset,request = 'annotations',memoised = memoised)
    # experiment annotation class
    experimentAnnotClass = annotation %>% 
        mapNoNull('className')  %>%  combine()
    
    experimentAnnotClassURI =  annotation %>% 
        mapNoNull('classUri') %>% combine()
    experimentAnnotClassOntoID = annotation %>% purrr::map('classUri') %>%
        mapNoNull(getAnnotationID) %>% 
        combine()
    
    
    # experiment annotation
    experimentAnnotation = annotation %>% mapNoNull('termName') %>% combine()
    
    experimentAnnotationOntoID = annotation %>% mapNoNull('termUri') %>% 
        mapNoNull(getAnnotationID) %>%
        combine()
    
    experimentAnnotationURI = annotation %>% mapNoNull('termUri') %>% combine()
    
    # get experiment platforms
    platforms = datasetInfo(dataset,request = 'platforms',memoised = memoised)
    platformName = platforms %>% mapNoNull('shortName') %>% combine()

    technologyType = platforms %>% mapNoNull('technologyType') %>% combine()
    
    experimentData = data.frame(datasetID, datasetName, taxon, 
                                experimentAnnotClass, experimentAnnotClassOntoID, experimentAnnotClassURI,
                                experimentAnnotation, experimentAnnotationOntoID, experimentAnnotationURI, 
                                platformName,
                                technologyType,
                                stringsAsFactors = FALSE)
    
    # get sample annotations
    sampleData = tryCatch(datasetInfo(dataset,request = 'samples',memoised = memoised),
                          error = function(e){
                              return(NULL)
                          })
    if(is.null(sampleData)){
        warning('Weird dataset ', dataset)
        return(NULL)
    }
    
    sampleName = sampleData %>% purrr::map_chr('name')
    id =  sampleData %>% purrr::map_chr('id')
    accession = sampleData %>% mapNoNull('accession') %>% mapNoNull('accession') %>%
        unlist(recursive=FALSE)
    
    # most relevant things are hidden away here
    bioMatData = sampleData %>% mapNoNull('sample')
    sampleBiomaterialID =bioMatData %>% mapNoNull('id') %>% unlist(recursive = FALSE)
    
    # sample annotation category
    factorValueObjects = bioMatData %>% mapNoNull('factorValueObjects')
    
    sampleAnnotCategory  = factorValueObjects %>% mapNoNull(function(x){
        x %>% mapNoNull('characteristics') %>% mapNoNull(mapNoNull,'category') %>% combine
    }) %>% unlist(recursive = FALSE)
    
    sampleAnnotCategoryOntoID = factorValueObjects %>% mapNoNull(function(x){
        URIs = x %>% mapNoNull('characteristics') %>% mapNoNull(mapNoNull,'categoryUri')
        
        URIs %>% unlist(recursive=FALSE) %>% 
            mapNoNull(getAnnotationID) %>% 
            unlist %>% relist(URIs) %>% combine
    }) %>% unlist(recursive = FALSE)
    
    sampleAnnotCategoryURI = factorValueObjects %>% mapNoNull(function(x){
        x %>% mapNoNull('characteristics') %>% mapNoNull(mapNoNull,'categoryUri') %>% combine
    }) %>% unlist(recursive = FALSE)
    
    sampleAnnotBroadCategory = factorValueObjects %>% mapNoNull(function(x){
        x %>% mapNoNull('experimentalFactorCategory') %>% mapNoNull('value') %>% combine
    }) %>% unlist(recursive = FALSE)
    
    sampleAnnotBroadCategoryOntoID = factorValueObjects %>% mapNoNull(function(x){
        x %>% mapNoNull('experimentalFactorCategory') %>% mapNoNull('valueUri') %>% 
            mapNoNull(getAnnotationID) %>% combine
    }) %>% unlist(recursive = FALSE)
    
    sampleAnnotBroadCategoryURI = factorValueObjects %>%  mapNoNull(function(x){
        x %>% mapNoNull('experimentalFactorCategory') %>% mapNoNull('valueUri')%>% combine
    }) %>% unlist(recursive = FALSE)
    
    # sample annotation
    sampleAnnotation =  factorValueObjects %>% mapNoNull(function(x){
        x %>% mapNoNull('characteristics') %>% mapNoNull(mapNoNull,'value') %>% combine
    }) %>% unlist(recursive = FALSE)
    
    sampleAnnotationOntoID = factorValueObjects %>% mapNoNull(function(x){
        URIs = x %>% mapNoNull('characteristics') %>% mapNoNull(mapNoNull,'valueUri')
        
        URIs %>% unlist(recursive=FALSE) %>% 
            mapNoNull(getAnnotationID) %>% 
            unlist %>% relist(URIs) %>% combine
    }) %>% unlist(recursive = FALSE)
    
    sampleAnnotationURI =  factorValueObjects %>% mapNoNull(function(x){
        URIs = x %>% mapNoNull('characteristics') %>% mapNoNull(mapNoNull,'valueUri') %>% combine
    }) %>% unlist(recursive = FALSE)
    
    sampleData = data.frame(id,
                            accession,
                            sampleBiomaterialID,
                            sampleAnnotCategory, sampleAnnotCategoryOntoID, sampleAnnotCategoryURI,
                            sampleAnnotBroadCategory, sampleAnnotBroadCategoryOntoID, sampleAnnotBroadCategoryURI,
                            sampleAnnotation, sampleAnnotationOntoID, sampleAnnotationURI,
                            stringsAsFactors = FALSE)
    
    if(collapseBioMaterials & any(duplicated(sampleData$sampleBiomaterialID))){
        bioMaterials = unique(sampleData$sampleBiomaterialID)
        
        sampleData %<>% split(f = sampleData$sampleBiomaterialID) %>% lapply(function(bioMatData){
            # temporary just to see if something's wrong
            assertthat::are_equal(
                bioMatData %>% dplyr::select(-id,-accession) %>% unique %>% nrow,1
            )
            
            newData = data.frame(id = bioMatData$id %>% combine,
                                 accession = bioMatData$accession %>% combine,
                                 bioMatData %>% dplyr::select(-id,-accession) %>% {.[1,]},
                                 stringsAsFactors = FALSE)
        }) %>% data.table::rbindlist() %>% as.data.frame
    }
    
    if(outputType == 'data.frame'){
        out = cbind(experimentData,sampleData)
    } else {
        out = list(experimentData,
                   sampleData)
    }
    
    return(out)
    
}
