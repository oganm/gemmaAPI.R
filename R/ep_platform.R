#' All platforms
#' 
#' List all platforms
#'
#' @inheritParams filterArg
#' @inheritParams queryLimit
#' @inheritParams sortArg
#' @inheritParams fileReturn
#' @inheritParams memoised
#' @return List of lists containing platform object.
#' @export
#'
#' @examples
#' allPlatforms()
#' 
#' # return all platforms it is slower and prone to connection interruptions
#' # alternative is to loop using offset and limit
#' allPlatforms(limit = 0)
allPlatforms = function(filter = NULL,
                        offset = 0,
                        limit = 20,
                        sort = '+id',
                        file = NULL,
                        return = TRUE,
                        memoised = FALSE){
    if(memoised){
        mem_allPlatforms(filter = filter,
                         offset = offset,
                         limit = limit,
                         sort = sort,
                         file = file,
                         return = return,
                         memoised = FALSE) -> out
        return(out)
    }
    
    url = 
        glue::glue(gemmaBase(),
                   'platforms/?{queryLimit(offset,limit)}&{sortArg(sort)}&{filterArg(filter)}')
    content = getContent(url,file = file,return = return)
    if(return){
        names(content) =  content %>% purrr::map_chr('shortName')
    }
    return(content)
}


#' platformInfo
#' 
#' Retrieves information about a single platform. Combines several API calls.
#'
#' @param platform Can either be the platform ID or its short name (e.g: GPL1355). Retrieval by ID is more efficient. Only platforms that user has access to will be available.
#' @param request Character. If NULL retrieves the platform object. Otherwise
#' \itemize{
#'     \item \code{datasets}: Retrieves experiments in the given platform. Parameters:
#'         \itemize{
#'             \item \code{offset}: Optional, defaults to 0. Skips the 
#'              specified amount of objects when retrieving them from the
#'               database.
#'             \item \code{limit}: Optional, defaults to 20. Limits the result 
#'              to specified amount of objects. Use 0 for no limit.
#'         }
#'     \item \code{annotations}: Retrieves the annotation file for the given platform. If you set a file path, the downloaded file will be a .gz file.
#'     \item \code{elements}: Retrieves the composite sequences (elements/probes) for the given platform. Parameters:
#'         \itemize{
#'             \item \code{offset}: As in datasets
#'             \item \code{limit}: As in datasets
#'         }
#'     \item \code{specificElement} Retrieves a specific composite sequence (element) for the given platform. Paramaters: 
#'         \itemize{
#'             \item \code{probe}: Required. Can either be the probe name or ID.
#'         }
#'     \item \code{genes} Retrieves the genes on the given platform element. Parameters:
#'         \itemize{
#'             \item \code{probe}: Required. Can either be the probe name or ID.
#'             \item \code{offset}: As in datasets
#'             \item \code{limit}: As in datasets
#'         }
#' }
#' @param ...  Use if the specified request has additional parameters.
#' @inheritParams fileReturn
#' @inheritParams memoised
#'
#' @return A data.frame or a list depending on the request
#' @export
#'
#' @examples
#' platformInfo('GPL1355')
#' platformInfo('GPL1355',request = 'datasets',limit = 10)
platformInfo = function(platform,
                        request = NULL,
                        ...,
                        file = NULL,
                        return = TRUE,
                        memoised = FALSE){
    if(memoised){
        mem_platformInfo(platform = platform,
                         request= request,
                         ...,
                         file = file,
                         return = return,
                         memoised = FALSE) -> out
        return(out)
    }
    
    # optional paramters go here
    requestParams = list(...)
    url = glue::glue(gemmaBase(),'platforms/{stringArg(platform = platform,addName=FALSE)}')
    if(!is.null(request)){
        request = match.arg(request, 
                            choices = c('datasets',
                                        'elements',
                                        'specificElement',
                                        'genes',
                                        'annotations'))
        
        allowedArguments = list(datasets = c('offset','limit'),
                                elements = c('offset','limit'),
                                genes = c('probe','offset','limit'),
                                specificElement = 'probe')
        
        mandatoryArguments = list(genes = 'probe',
                                  specificElement = 'probe')
        
        checkArguments(request,requestParams,allowedArguments,mandatoryArguments)
        
        
        if(request %in% c('datasets','elements')){
            url = glue::glue(url,'/{request}/?',queryLimit(requestParams$offset,
                                                           requestParams$limit))
        } else if (request %in% 'specificElement'){
            url = glue::glue(url,'/elements/',
                             stringArg(probe = requestParams$probe, 
                                          addName=FALSE))
        } else if(request == 'genes'){
            url = glue::glue(url,'/elements/',
                             stringArg(probe = requestParams$probe, 
                                          addName=FALSE),
            '/genes/?',queryLimit(requestParams$offset,requestParams$limit))
        } else if (request == 'annotations'){
            url = glue::glue(url,'/{request}')
        }
        

    }
    
    content = getContent(url,file = file,return=return)
    if(return){
        if(!is.null(request)){
            if(request %in% c('datasets')){
                names(content) =  content %>% purrr::map_chr('shortName')
            } else if (request %in% c('elements')){
                names(content) =  content %>% purrr::map_chr('name')
            }  else if (request %in% 'genes'){
                names(content) =  content %>% purrr::map_chr('name')
            }
        }
    }
    return(content)
    
}
