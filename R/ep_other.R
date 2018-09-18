#' annotationInfo
#'
#' @param annotation Character. Either plain text, ontology term ID or an ontology term URI.
#' @param request Character. If null retreeives the annotation object. Otherwise
#' \itemize{
#'     \item \code{datasets}: Does a search for datasets containing annotations matching the given string
#' }
#' @inheritParams fileReturn
#' @inheritParams memoised
#' 
#' @return A list
#' @export
#'
#' @examples
#' annotationInfo('http://purl.obolibrary.org/obo/OBI_0000105')
#' annotationInfo('transplantation')
#' annotationInfo('http://purl.obolibrary.org/obo/OBI_0000105', request = 'datasets')
annotationInfo = function(annotation,
                          request = NULL,
                          file = NULL,
                          return = TRUE,
                          overwrite = FALSE,
                          memoised = FALSE){
    if(memoised){
        mem_annotationInfo(annotation = annotation,
                           request = request,
                           file = file,
                           return = return,
                           overwrite = overwrite,
                           memoised = FALSE) -> out
        return(out)
    }

    url = glue::glue(gemmaBase(),'annotations/search/{stringArg(annotation = annotation,addName=FALSE)}')
    if(!is.null(request)){
        request = match.arg(request,choices = 'datasets')
        if(request =='datasets'){
            url = glue::glue(url,'/datasets')
        }
    }
    
    content = getContent(url,file = file,return=return, overwrite = overwrite)
    
    
    if(return){
        if(is.null(request)){
            names(content) =  content %>% purrr::map_chr('value', .default = NA)
        } else if (request %in% c('datasets')){
            names(content) =  content %>% purrr::map_chr('shortName', .default = NA)
        }
    }
    return(content)
    
}
