#' Download Expression file for a dataset
#' 
#' Given an experiment, returns and/or saves the expression data.
#' 
#' @param dataset Character. Can either be the ExpressionExperiment ID or its 
#'   short name (e.g. GSE1234). Retrieval by ID is more efficient. Only datasets
#'   that user has access to will be available
#' @param file Character. File path. If provided expression data will be saved.
#' @param filter Logical. If true filters the expression data so that they do
#'   not contain samples under a minimum threshold.
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