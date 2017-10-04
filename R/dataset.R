#' All datasets
#'
#' Lists all datasets, or datasets with provided identifiers
#'
#' @param datasets Character vector of identifiers. 
#' Identifiers can either be the ExpressionExperiment ID or its short name (e.g. GSE1234). 
#' Retrieval by ID is more efficient.
#' Only datasets that user has access to will be available.
#' 
#' Do not combine different identifiers in one query.
#' @param filter Filtering can be done on any* property of a supported type or nested property that the ExpressionExperiment class has ( and is mapped by hibernate ). E.g: 'curationDetails' or 'curationDetails.lastTroubledEvent.date'
#' Currently supported types are:
#' \itemize{
#'     \item String - property of String type, required value can be any String.
#'     \item Number - any Number implementation. Required value must be a string parseable to the specific Number type.
#'     \item Boolean - required value will be parsed to true only if the string matches 'true', ignoring case.
#' }    
#' Accepted operator keywords are:
#' \itemize{
#'     \item '=' - equality
#'     \item '!=' - non-equality
#'     \item '<' - smaller than
#'     \item '=>' - larger or equal
#'     \item 'like' similar string, effectively means 'contains', translates to the sql 'LIKE' operator (given value will be surrounded by % signs)
#' }
#' Multiple filters can be chained using 'AND' or 'OR' keywords.
#' 
#' Leave space between the keywords and the previous/next word! 
#' 
#' E.g: ?filter=property1 < value1 AND property2 like value2
#' 
#' If chained filters are mixed conjunctions and disjunctions, the query must be in conjunctive normal form (CNF). Parentheses are not necessary - every AND keyword separates blocks of disjunctions.
#' Example:
#' 
#'?filter=p1 = v1 OR p1 != v2 AND p2 <= v2 AND p3 > v3 OR p3 < v4
#'
#' Above query will translate to: 
#' 
#' (p1 = v1 OR p1 != v2) AND (p2 <= v2) AND (p3 > v3 OR p3 < v4;)
#' 
#' Breaking the CNF results in an error.
#' 
#' Filter "curationDetails.troubled" will be ignored if user is not an administrator.
#' 
#' @inheritParams queryLimit 
#' @inheritParams sortArg
#'
#' @return List of lists containing experiment data.
#' @export
#'
#' @examples
#' # only non-troubled datasets
#' allDatasets(filter ='curationDetails.troubled = false')
#' 
#' # return all datasets. it is slower and prone to connection interruptions
#' # alternative is to loop using offset and limit
#' allDatasets(limit = 0)
allDatasets = function(datasets = NULL,
                       filter = NULL,
                       offset = 0,
                       limit = 20,
                       sort = '+id'){
    
    if(!is.null(datasets)){
        assertthat::assert_that(is.character(datasets))
        datasets %<>% paste(collapse =',')
        datasets %<>% URLencode(reserved = TRUE)
    } else{
        datasets = ''
    }
    
    if(!is.null(filter)){
        assertthat::assert_that(assertthat::is.string(filter))
        filter %<>% URLencode(reserved = TRUE)
        filter = glue::glue('filter={filter}')
    } else{
        filter = ''
    }
    
    
    url = glue::glue(gemmaBase(),'datasets/{datasets}?{queryLimit(offset,limit)}&{sortArg(sort)}&{filter}')
    
    content = getContent(url)
    names(content) =  content %>% purrr::map_chr('shortName')
    return(content)
}



#' datasetInfo
#'
#' Retrieves information about a single dataset based on the given dataset 
#' identifier. Combines several API calls
#'
#' @param dataset Character. Can either be the dataset ID or its short name 
#' (e.g. GSE1234).
#' @param request Character. If NULL retrieves the dataset object. Otherwise
#'  \itemize{
#'      \item \code{platforms}: Retrieves platforms for the given dataset
#'      \item \code{samples}: Retrieves samples for the given dataset
#'      \item \code{annotations}: Retrieves the annotations for the given dataset
#'      \item \code{design}: Retrieves the design for the given dataset
#'      \item \code{data}: Retrieves the data for the given dataset. Parameters:
#'          \itemize{
#'              \item \code{filter}: Optional, defaults to false. If true, call
#'               returns filtered expression data.
#'          }
#'      \item \code{differential}: Retrieves the differential analysis results
#'       for the given dataset. Parameters:
#'          \itemize{
#'              \item \code{qValueThreshold}: Required. Q-value threshold.
#'              \item \code{offset}: Optional, defaults to 0. Skips the specified amount of objects when retrieving them from the database.
#'              \item \code{limit}: Optional, defaults to 20. Limits the result to specified amount of objects. Use 0 for no limit.
#'          }
#' }
#' @param ... Use if the specified request has additional parameters.
#' @param file Character. File path. If provided, response will be saved to file
#' @return 
#' @export
#'
#' @examples
#' datasetInfo('GSE81454')
#' datasetInfo('GSE81454', request = 'platforms')
#' datasetInfo('GSE81454', request='data',filter = FALSE)
datasetInfo  = function(dataset, 
                        request = NULL,
                        ...,
                        file = NULL){
    assertthat::assert_that(assertthat::is.string(dataset))
    requestParams = list(...)
    
    url = glue::glue(gemmaBase(),'datasets/{dataset}')
    if(!is.null(request)){
        request = match.arg(request, choices = c('platforms','samples','annotations','design','data','differential'))
        url = glue::glue('{url}/{request}')
        if(request == 'data'){
            # if not provoided, returns false
            filter = requestParams$filter
            if(is.null(filter)){
                filter = FALSE
            }
            assertthat::assert_that(is.logical(filter))
            filter = filter %>% tolower()
            # if other parameters are around send out a warning
            if(any(names(requestParams) != 'filter')){
                warning("Data request only accepts 'filter' as parameter")
            }
            url = glue::glue('{url}?filter={filter}')
            
        } else if(request == 'differential') {
            qValueThreshold = requestParams$qValueThreshold
            assertthat::assert_that(assertthat::is.number(qValueThreshold))
            if(is.null(requestParams$offset)){
                requestParams$offset = 0
            }
            if(is.null(requestParams$limit)){
                requestParams$limit = 20
            }
            
            if(any(!names(requestParams) %in% c('qValueThreshold','offset','limit'))){
                warning("Differential request only accepts 'qValueThreshold', 'offset' and 'limit' as parameters")
            }
            
            url = glue::glue('{url}?qValueThreshold={requestParams$qValueThreshold}',
                             '&{queryLimit(requestParams$offset, requestParams$limit)}')
        } else {
            if(length(requestParams)>0){
                warning('Your request does not accept parameters. Ignoring')
            }
        }
    }
    
    content = getContent(url,file = file)
    # just setting names. not essential
    if(!is.null(request)){
        if(request %in% c('platforms')){
            names(content) =  content %>% purrr::map_chr('shortName')
        } else if (request %in% c('samples')){
            names(content) =  content %>% purrr::map_chr('name')
        } else if(request %in% 'annotations'){
            names(content) =  content %>% purrr::map_chr('className')
        }
    }
    return(content)
}
