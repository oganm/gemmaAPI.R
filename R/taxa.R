#' List all taxa or return specific taxa
#' 
#' @param taxon Character. can either be Taxon ID or one of its string
#'   identifiers: scientific name, common name, abbreviation. It is recommended
#'   to use ID for efficiency.
#' @export
getTaxa = function(taxon = NULL){
    url = paste0(gemmaBase(),'taxa/',taxon)
    content = getContent(url)
    
    if(taxon %>% is.null){
        names(content) = content %>% purrr::map_chr('scientificName')
    }
    return(content)
}


