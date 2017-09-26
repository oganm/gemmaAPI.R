# incomplete
#' @export
filterDatasets = function(taxa = NULL,
                          platform = NULL){
    if(is.null(taxa) & is.null(platform)){
        stop('taxa and/or platform must be provided')
    }
    
}

#' @export
downloadDataset = function(dataset, file = NULL,filter = FALSE,return=TRUE){
    url = glue::glue(gemmaBase(),'datasets/{dataset}/data?filter={filter %>% tolower}')
    
    raw = httr::GET(url = url)
    lines = rawToChar(raw$content)
    
    out= readr::read_tsv(file = lines,skip =6)
    if(!is.null(file)){
        write(lines,file = file)
    }
    if(return){
        return(invisible(out))
    } else{
        return(NULL)
    }
}