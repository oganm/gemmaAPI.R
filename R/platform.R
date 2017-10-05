#' All platforms
#' 
#' List all platforms
#'
#' @inheritParams filterArg
#' @inheritParams queryLimit
#' @inheritParams sortArg
#'
#' @return List of lists containing platform object.
#' @export
#'
#' @examples
allPlatforms = function(filter = NULL,
                        offset = 0,
                        limit = 20,
                        sort = '+id'){
    url = 
        glue::glue(gemmaBase(),
                   'platforms/?{queryLimit(offset,limit)}&{sortArg(sort)}&{filterArg(filter)}')
    content = getContent(url)
    names(content) =  content %>% purrr::map_chr('shortName')
    return(content)
}


platformInfo = function(platform,
                        request = NULL,
                        ...,
                        file = NULL){
    
}