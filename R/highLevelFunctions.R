#' Read data files from gemma
#'
#' This is a simple wrapper for read_tsv that also deals with comments that are
#' at the beginning of the file. If it is an expression file IdColnames simplifies
#' column names
#'
#' @param expFile Path to a file downloaded from gemma, possibly using datasetInfo
#' function (request = 'data').
#' @param IdColnames Logical. should column names be turned into IDs. Only valid for expression data
#'
#' @return A data frame that includes experiment and sample level data or a list that has experiment
#' and sample level data as separate elements.
#' @export
#' 
readDataFile = function(expFile,IdColnames = FALSE){
    # this is a bad heuristics. will fail if file has a header comment longer that 100 lines
    con = gzfile(expFile)
    lines = readLines(con,n = 100)
    skip = lines %>% grepl('^#',x = .) %>% which %>% max
    close(con)
    con = gzfile(expFile,open = c('rb'))
    expData = suppressMessages(readr::read_tsv(con, col_names= TRUE,skip = skip,
                                               guess_max = R.utils::countLines(expFile) 
                                                ))
    close(con)
    
    if(IdColnames){
        colnames(expData) %<>% simplifyExpressionColnames()
    }
    return(expData)
}

#' Read expression data from gemma
#' @inherit readDataFile
#' @export
readExpression = readDataFile

#'expressionSubset
#'
#' Uses gene expression endpoint to get expression of some genes
#'
#' @param dataset Can either be the dataset ID or its short name
#' (e.g. GSE1234)
#' @param genes A list of identifiers, separated by commas (e.g: 1859, 5728).
#'              
#'              Can either be the NCBI ID (1859), Ensembl ID (ENSG00000157540) or official symbol (DYRK1A) of the gene.
#'              
#'              NCBI ID is the most efficient (and guaranteed to be unique) identifier.
#'              
#'              Official symbol represents a gene homologue for a random taxon, unless used in a specific taxon (see the Taxa Endpoints).
#'              
#'              If the gene taxon does not match the taxon of the given datasets, expression levels for that gene will be missing from the response
#'              
#'              You can combine various identifiers in one query, but any invalid identifier will cause the call to yield an error. Duplicate identifiers of the same gene will result in duplicates in the response.
#'
#' @param keepNonSpecific Defaults to FALSE. 
#'              
#'              If set to false, the response will only include elements that map exclusively to each queried gene
#'              
#'              If set to true, the response will include all elements that map to each queried gene, even if they also map to other genes.
#' @param consolidate Optional. Defaults no NULL. 
#'              Optional, defaults to empty.
#'              
#'              Whether genes with multiple elements should consolidate the information. If the 'keepNonSpecific' parameter is set to true, then all gene non-specific vectors are excluded from the chosen procedure.
#'              
#'              The options are:
#'                  \itemize{
#'                      \item \code{NULL}:list all vectors separately. 
#'                      \item \code{"pickmax"}: only return the vector that has the highest expression (mean over all its bioAssays).
#'                      \item \code{"pickvar"}: only return the vector with highest variance of expression across its bioAssays
#'                      \item \code{"average"}: create a new vector that will average the bioAssay values from all vectors
#'                  }
#'
#' @export
expressionSubset = function(dataset,genes, keepNonSpecific = FALSE, consolidate = NULL,memoised = FALSE){
    
    splits = seq(1,length(genes),by = 500)
    
    splits = (1:length(genes)) %>% 
        cut(breaks= c(seq(0,length(genes),by = 500),length(genes)) %>% unique)
    
    combineOut = lapply(unique(splits),function(split){
        listOut = datasetInfo(dataset,request = 'geneExpression',
                              genes = genes[splits %in% split],
                              keepNonSpecific = keepNonSpecific,
                              consolidate = consolidate,
                              memoised = memoised)
        
        listOut %<>% purrr::map('geneExpressionLevels')
        
        frameOut = listOut %>% lapply(function(x){
            out = x %>% lapply(function(y){
                expression = y$vectors %>% lapply(function(z){
                    vector = z$bioAssayExpressionLevels %>% unlist
                    vectorOut = vector %>% as.numeric()
                    names(vectorOut) = names(vector)
                    return(vectorOut)
                }) %>% as.data.frame() %>% t
                if(nrow(expression) == 0){
                    return(NULL)
                }
                
                data.frame(Probe = names(y$vectors),
                           GeneSymbol = y$geneOfficialSymbol,
                           NCBIid = y$geneNcbiId,expression,
                           check.names = FALSE,row.names = NULL,
                           stringsAsFactors = FALSE)
            })
            
            do.call(rbind,out)
        })
        return(do.call(rbind,frameOut))
    })
    
    return(do.call(rbind,combineOut))
}


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
    # 95 no characteristics for annotations
    
    # prevent NULLs from ruining the data frame
    # turns out this is not needed as .default argument exists
    # rework later
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
    noNull = function(x){
        if(is.null(x)){
            return(NA)
        } else{
            return(x)
        }
    }
    
    combine = function(mapResult , sort = FALSE){
        mapResult %>% 
            purrr::map(stringr::str_replace_all,pattern = ';',replacement = '_') %>%  # escape all ;s
            purrr::map(paste,collapse=';') %>% 
            purrr::map(stringr::str_replace_all,pattern = '\\|',replacement = '_') %>%  # escape all |s
            {
                if(sort){
                    .= sort(unlist(.))
                }
                .
                
            } %>% 
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
    experimentData = list()
    # first compile information specific to the dataset
    basicInfo = datasetInfo(dataset,memoised=memoised)[[1]]
    if(length(basicInfo)==1){
        stop('you caught a bug! use internal Gemma IDs to avoid it')
    }
    
    experimentData$datasetID = basicInfo$id %>% noNull()
    experimentData$datasetName = basicInfo$shortName %>% noNull()
    experimentData$taxon = basicInfo$taxon %>% noNull()
    
    # get experiment annotations
    annotation = datasetInfo(dataset,request = 'annotations',memoised = memoised)
    # experiment annotation class
    experimentData$experimentAnnotClass = annotation %>% 
        mapNoNull('className')  %>%  combine()
    
    experimentData$experimentAnnotClassOntoID = annotation %>% purrr::map('classUri') %>%
        mapNoNull(getAnnotationID) %>% 
        combine()
    experimentData$experimentAnnotClassURI =  annotation %>% 
        mapNoNull('classUri') %>% combine()

    
    
    # experiment annotation
    experimentData$experimentAnnotation = annotation %>% mapNoNull('termName') %>% combine()
    
    experimentData$experimentAnnotationOntoID = annotation %>% mapNoNull('termUri') %>% 
        mapNoNull(getAnnotationID) %>%
        combine()
    
    experimentData$experimentAnnotationURI = annotation %>% mapNoNull('termUri') %>% combine()
    
    # get experiment platforms
    platforms = datasetInfo(dataset,request = 'platforms',memoised = memoised)
    experimentData$platformName = platforms %>% mapNoNull('shortName') %>% combine()

    experimentData$technologyType = platforms %>% mapNoNull('technologyType') %>% combine()
    
    experimentData$externalDatabase = basicInfo$externalDatabase %>% noNull()
    
    experimentData$troubled = basicInfo$troubled %>% noNull()
    experimentData$troubleDetails = basicInfo$troubleDetails %>% noNull()
    
    # get batch confound and geeq quality information
    experimentData$batchConfoundDescription = basicInfo$batchConfound %>% noNull()
    experimentData$batchEffectDescription = basicInfo$batchEffect %>% noNull()
    
    # this could have been written in a vectorized manner but I don't want it
    # to break if geek is changed slightly. also manually naming them has some value
    
    experimentData$geeq.batchConfound = basicInfo$geeq$qScorePublicBatchConfound %>% noNull()
    experimentData$geeq.batchEffect = basicInfo$geeq$qScorePublicBatchEffect %>% noNull()
    experimentData$geeq.batchCorrected = basicInfo$geeq$batchCorrected %>% noNull()
    experimentData$geeq.batchInfo = basicInfo$geeq$qScoreBatchInfo %>% noNull()
    experimentData$geeq.qualityScore = basicInfo$geeq$publicQualityScore %>% noNull()
    experimentData$geeq.suitabilityScore = basicInfo$geeq$publicSuitabilityScore %>% noNull()
    experimentData$geeq.publication = basicInfo$geeq$sScorePublication %>% noNull()
    experimentData$geeq.platformAmount = basicInfo$geeq$sScorePlatformAmount %>% noNull()
    experimentData$geeq.platformsTechMulti = basicInfo$geeq$sScorePlatformsTechMulti %>% noNull()
    experimentData$geeq.platformPopularity = basicInfo$geeq$sScoreAvgPlatformPopularity %>% noNull()
    experimentData$geeq.avgPlatformSize = basicInfo$geeq$sScoreAvgPlatformSize %>% noNull()
    experimentData$geeq.sampleSize = basicInfo$geeq$sScoreSampleSize %>% noNull()
    experimentData$geeq.rawData =  basicInfo$geeq$sScoreRawData %>% noNull()
    experimentData$geeq.missingValues = basicInfo$geeq$sScoreMissingValues %>% noNull()
    experimentData$geeq.outliers = basicInfo$geeq$qScoreOutliers %>% noNull()
    experimentData$geeq.platformTechnology = basicInfo$geeq$qScorePlatformsTech %>% noNull()
    experimentData$geeq.replicates= basicInfo$geeq$qScoreReplicates %>% noNull()
    experimentData$geeq.medianSampleCorrelation = basicInfo$geeq$qScoreSampleMedianCorrelation %>% noNull()
    
    # 

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
            unlist %>% utils::relist(URIs) %>% combine
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
        x %>% mapNoNull(function(y){
            if(is.na(y)[[1]]){
                return(NA)
            } else if(length(y$characteristics) != 0 ){
                return(y$characteristics %>% mapNoNull('value'))
            } else if(length(y$measurement)> 0){
                return(y$measurement$value)
            } else{
                return(y$fvValue)
            }
        }) %>% combine
    }) %>% unlist(recursive = FALSE)
    
    sampleAnnotType = factorValueObjects %>% mapNoNull(function(x){
        x %>% mapNoNull(function(y){
            if(is.na(y)[[1]]){
                return(NA)
            } else if(length(y$measurement) != 0){
                return('continuous')
            }else {
                return('factor')
            }
        }) %>% combine
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
    

    # characteristics 
    characteristics = bioMatData %>% mapNoNull('characteristics')
    otherCharacteristics = characteristics %>% mapNoNull(function(x){
        values = x %>% mapNoNull('value') %>% combine
    }) %>% unlist
    
    # otherCharacteristicCategories = characteristics %>% mapNoNull(function(x){
    #     values = x %>% mapNoNull('category') %>% combine
    # }) %>% unlist

    sampleData = data.frame(id,
                            sampleName,
                            accession,
                            sampleBiomaterialID,
                            sampleAnnotCategory, sampleAnnotCategoryOntoID, sampleAnnotCategoryURI,
                            sampleAnnotBroadCategory, sampleAnnotBroadCategoryOntoID, sampleAnnotBroadCategoryURI,
                            sampleAnnotation, sampleAnnotationOntoID, sampleAnnotType, sampleAnnotationURI,
                            otherCharacteristics,
                            stringsAsFactors = FALSE)
    
    if(collapseBioMaterials & any(duplicated(sampleData$sampleBiomaterialID))){
        bioMaterials = unique(sampleData$sampleBiomaterialID)
        
        sampleData %<>% split(f = sampleData$sampleBiomaterialID) %>% lapply(function(bioMatData){
            # temporary just to see if something's wrong
            assertthat::are_equal(
                bioMatData %>% dplyr::select(-id,-sampleName,-accession) %>% unique %>% nrow,1
            )
            
            newData = data.frame(id = bioMatData$id %>% combine(sort = TRUE),
                                 sampleName = bioMatData$sampleName %>% combine(sort = TRUE),
                                 accession = bioMatData$accession %>% combine(sort = TRUE),
                                 bioMatData %>% dplyr::select(-id,-accession, - sampleName) %>% {.[1,]},
                                 stringsAsFactors = FALSE)
        }) %>% data.table::rbindlist() %>% as.data.frame
    }
    
    if(outputType == 'data.frame'){
        out = cbind(as.data.frame(experimentData,stringsAsFactors = FALSE),sampleData)
    } else {
        out = list(experimentData = experimentData,
                   sampleData = sampleData)
    }
    
    return(out)
    
}
