
# individual fields of the output needs to be documented.
#' Get list of datasets
#' 
#' Outputs lists of datasets optionally filtered based on taxa and platform.
#'
#' @param taxa Character vector. Can either be Taxon ID or one of its string
#'   identifiers: scientific name, common name, abbreviation. It is recommended
#'   to use ID for efficiency.
#' @param platforms Character vector. Can either be the ArrayDesign ID or its
#'   short name (e.g. "Generic_yeast" or "GPL1355" ). Retrieval by ID is more
#'   efficient. Only platforms that user has access to will be available.
#' @return List
#' @export
getDatasets = function(taxa = NULL,
                       platforms = NULL){
    limit = 999999
    # if nothing is provided get everything
    if(is.null(taxa) & is.null(platforms)){
        url = glue::glue(gemmaBase(),'datasets/?offset=0&limit={limit}&sort=%2Bid')
        content = getContent(url)
        names(content) =  content %>% purrr::map_chr('shortName')
        return(content) # if everything is generated, return everything and be done with it
    } 
    
    # if taxa is specified loop around them to get it all
    contents = list()
    if(!is.null(taxa)){
        contents$taxa = lapply(taxa, function(taxon){
            url = glue::glue(gemmaBase(),'taxa/{taxon}/datasets?offset=0&limit={limit}&sort=%2Bid')
            content = getContent(url)
        }) %>% do.call(c,.)
        names(contents$taxa) = contents$taxa %>% purrr::map_chr('shortName')
    }
    if(!is.null(platforms)){
        contents$platforms = lapply(platforms, function(platform){
            url = glue::glue(gemmaBase(),'platforms/{platform}/datasets?offset=0&limit={limit}&sort=%2Bid')
            content = getContent(url)
        }) %>% do.call(c,.)
        names(contents$platforms) = contents$platforms %>% purrr::map_chr('shortName')
    }
    
    # if both taxa and species is provided, get intersection
    if(length(contents) > 1){
        commonNames = intersect(names(contents$taxa),names(contents$platforms))
        
        out = lapply(commonNames , function(x){
            t = contents$taxa[[x]]
            p = contents$platforms[[x]]
            out = lapply(1:length(t),function(i){
                if(identical(t[[i]],p[[i]])){
                    return(t[[i]])
                } else{
                    return(c(t[[i]],p[[i]])[which.min(c(t[[i]],p[[i]]))]) # this is a temporary hack. can fix after metadata is out but maybe just disable filtering by both species and platform as one probably implies the other, other than that time they used that human chip for chimps
                }
            })
            names(out) = names(t)
            return(out)
        })
        
        names(out) = commonNames

        # remove this later. this was to look at where datasets from taxa and platform filters sometimes differ
        # it is the multiplatform datasets
        # hmm = sapply(commonNames,function(x){
        #     identical(contents$taxa[x],contents$platforms[x])
        # })
        # 
        # hede = sapply(which(!hmm),function(x){
        #     t = contents$taxa[[commonNames[x]]]
        #     p = contents$platforms[[commonNames[[x]]]]
        #     assertthat::are_equal(length(t),length(p))
        #     weird = which(!sapply(1:length(t),function(y){
        #         identical(t[[y]], p[[y]])
        #     }))
        #     print(commonNames[x])
        #     print('#######################')
        #     print(t[weird])
        #     print(p[weird])
        #     NULL
        # })
        
    } else{
        out = contents[[1]]
    }
    
    
    return(out)
    
}




#' Download Expression file for a dataset
#' 
#' Given an experiment, returns and/or saves the expression data.
#'
#' @param dataset Character. Can either be the ExpressionExperiment ID or its
#'   short name (e.g. GSE1234). Retrieval by ID is more efficient. Only datasets
#'   that user has access to will be available
#' @param file Character. File path. If provided expression data will be saved.
#' @param filter Logical. If true filters the expression data so that they do not contain samples under a minimum threshold.
#' @param return Logical. If true returns the expression data.
#'
#' @return A data.frame or NULL depending on return value.
#' @export
downloadDataset = function(dataset, file = NULL,filter = FALSE,return=TRUE){
    url = glue::glue(gemmaBase(),'datasets/{dataset}/data?filter={filter %>% tolower}')
    
    raw = httr::GET(url = url)
    
    if(raw$status_code != 200){
        cat("Received a response with status", raw$status_code, '\n', file = stderr())
        stop(content$error$message);
    }
    
    lines = rawToChar(raw$content)
    
    
    if(!is.null(file)){
        write(lines,file = file)
    }
    if(return){
        out= readr::read_tsv(file = lines,skip =6)
        return(out)
    } else{
        return(NULL)
    }
}