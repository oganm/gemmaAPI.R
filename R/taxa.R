#' @export
taxa = function(taxa = NULL){
    url = paste0(gemmaBase(),'taxa/',taxa)
    getContent(url)
}


