#' @export
getPlatform = function(platform = NULL, offset = 0, sort = '+id'){
    limit = 9999
    if(!is.null(platform)){
        platform = paste0(platform,'/')
    } else{
        platform = ''
    }
    url = glue::glue(gemmaBase(),'platforms/{platform}','?offset={offset}&limit={limit}&sort{URLencode(sort,reserved = TRUE)}')
    content = getContent(url)
    if(platform == ''){
        names(content) = content %>% purrr::map_chr('shortName')
    }
    return(content)
}

