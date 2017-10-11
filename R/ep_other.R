#' annotationInfo
#'
#' @param annotation Character. Either plain text, ontology term ID or an ontology term URI.
#' @param request Character. If null retreeives the annotation object. Otherwise
#' \itemize{
#'     \item \code{experiments}: Does a search for datasets containing annotations matching the given string
#' }
#' @inheritParams fileReturn
#' 
#' @return A list
#' @export
#'
#' @examples
#' annotationInfo('http://purl.obolibrary.org/obo/OBI_0000105')
#' annotationInfo('OBI_0000105')
#' annotationInfo('transplantation')
#' annotationInfo('OBI_0000105', request = 'experiments')
annotationInfo = function(annotation,
                          request = NULL,
                          file = NULL,
                          return = TRUE){

    linkRegex = '[-a-zA-Z0-9@:%._\\+~#=]{2,256}\\.[a-z]{2,6}\\b([-a-zA-Z0-9@:%_\\+.~#?&//=]*)'
    annotationRegex = '[A-Za-z]+?_[0-9]+'
    if(!grepl(linkRegex,annotation,perl = TRUE) & 
       grepl(annotationRegex,annotation,perl = TRUE)){
        annotation = paste0('http://purl.obolibrary.org/obo/',annotation)
    }
    
    url = glue::glue(gemmaBase(),'annotations/search/{stringArg(annotation = annotation,addName=FALSE)}')
    if(!is.null(request)){
        request = match.arg(request,choices = 'experiments')
        if(request =='experiments'){
            url = glue::glue(url,'/experiments')
        }
    }
    
    content = getContent(url,file = file,return=return)
    
    
    if(return){
        if(is.null(request)){
            names(content) =  content %>% purrr::map_chr('urlId')
        } else if (request %in% c('experiments')){
            names(content) =  content %>% purrr::map_chr('shortName')
        }
    }
    return(content)
    
}
