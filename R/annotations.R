#' Get Gemma annotations
#' 
#' Gets Gemma's platform annotation files that can be accessed from https://gemma.msl.ubc.ca/annots/
#' 
#' @param platform Can either be the platform ID or its short name (e.g: GPL1355). 
#' Retrieval by ID is more efficient. Only platforms that user has access to will be available.
#' @param annotType Which go terms should the input include
#' @inheritParams fileReturn
#' @return A data frame including annotation information
#' @export
#'
getMicroannot = function(platform,
                         annotType = c('bioProcess','noParents','allParents'),
                         file = NULL,
                         return = TRUE,
                         overwrite = FALSE){
    
    # mostly the same as ogbox::gemmaAnnotte. changed a little to fit
    # other packages
    
    # in case the user uses platform ID instead of the shortname
    platform = platformInfo(platform)[[1]]$shortName
    
    annotType = match.arg(annotType)
    if (annotType == 'allParents'){
        annotType = ''
    } else{
        annotType = paste0('_',annotType)
    }
    
    if(is.null(file)){
       file = tempfile() 
    }
    
    if(file.exists(file) & ! overwrite){
        warning('Annotation file already exists. Not overwriting')
    } else{
        download.file(paste0('https://gemma.msl.ubc.ca/annots/',platform,annotType,'.an.txt.gz'),
                      paste0(file,'.gz'))
        R.utils::gunzip(paste0(file,'.gz'), overwrite=TRUE,remove = TRUE)
    }
     if(return){
         return(readDataFile(file))
     }  
    return(NULL)
}


#' Match probesets to gene in a platform annotation
#' 
#' @param probesets A character vector of probeset names
#' @param annotation Output of \code{\link{getMicroannot}} or a file path to an annotation
#' @param removeNAs If no match is found, NAs will be return. This removes NAs
#' information written by getMicroannot
#' @return A character vector of gene names
#' @export
annotationGeneMatch = function(probesets, annotation , removeNAs = FALSE){
    if('character' %in% class(annotation)){
        annotation = readDataFile(annotation)
    }
    symbols = annotation[match(probesets,annotation$ProbeName),'GeneSymbols'] %>% unlist
    names(symbols) = probesets
    if(removeNAs){
        symbols %<>% na.omit
        attributes(symbols) = NULL
    }
    return(symbols)
}


#' Match probesets to gene in a platform annotation
#' 
#' @param genes A character vector of gene names
#' @param annotation Output of \code{\link{getMicroannot}} or a file path to an annotation
#' information written by getMicroannot
#' @param removeNAs If no match is found, NAs will be return. This removes NAs
#' @return A character vector of probeset names
#' @export
annotationProbesetMatch = function(genes, annotation, removeNAs = FALSE){
    if('character' %in% class(annotation)){
        annotation = readDataFile(annotation)
    }
    probesets = annotation[match(genes,annotation$GeneSymbols),'ProbeName'] %>% unlist
    names(probesets) = genes
    if(removeNAs){
        probesets %<>% na.omit
        attributes(probesets) = NULL
    }
    return(probesets)
}
