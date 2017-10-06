
#' queryLimit
#'
#' @keywords internal
#'
#' @name queryLimit
#'
#' @param offset Integer. Optional parameter (defaults to 0) skips the specified amount of datasets when retrieving them from the database.
#' @param limit Integer. Optional parameter (defaults to 20) limits the result to specified amount of datasets. Use 0 for no limit.
#' 
queryLimit = function(offset = 0,
                      limit = 20){
    # enforce defaults in the face of NULL
    if(is.null(offset)){
        offset = 0
    }
    
    if(is.null(limit)){
        limit = 20
    }
    assertthat::assert_that(assertthat::is.number(offset))
    assertthat::assert_that(assertthat::is.number(limit))
    glue::glue('offset={offset}&limit={limit}')
}


#' Sort argument
#'
#' @keywords internal
#'
#' @name sortArg
#'
#' @param sort Character. Optional parameter (defaults to +id) sets the ordering property
#'   and direction. Format is [+,-][property name]. E.g. "-accession" will
#'   translate to descending ordering by the Accession property. Note that this
#'   does not guarantee the order of the returned entities. Nested properties
#'   are also supported (recursively). 
#'   
#'   E.g:
#'   +curationDetails.lastTroubledEvent.date
#' 
#' 
sortArg = function(sort){
    stringArg(sort = sort)
    # assertthat::assert_that(assertthat::is.string(sort))
    # sort %<>% URLencode(reserved =  TRUE)
    # glue::glue('sort={sort}')
}


#' Filter argument
#'
#' @keywords internal
#'
#' @name filterArg
#'
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
filterArg = function(filter){
    stringArg(filter = filter)
    # if(!is.null(filter)){
    #     assertthat::assert_that(assertthat::is.string(filter))
    #     filter %<>% URLencode(reserved = TRUE)
    #     filter = glue::glue('filter={filter}')
    # } else{
    #     filter = ''
    # }
    # 
    # return(filter)
}


# takes in strings, checks if string, combines them into a single query
stringArg = function(...,addName = TRUE, sep = '&'){
    stringArgs = list(...)
    out = ''
    for(i in 1:length(stringArgs)){
        if(is.null(stringArgs[[i]])){
            next
        }
        assertthat::assert_that(assertthat::is.string(stringArgs[[i]]),
                                msg = glue::glue(names(stringArgs)[i],
                                                 ' is not a string (a length one character vector).'))
        stringArgs[[i]] %<>% URLencode(reserved = TRUE)
        if(addName){
            out = glue::glue('{out}{names(stringArgs)[i]}={stringArgs[[i]]}')
        } else{
            out = glue::glue('{out}{stringArgs[[i]]}')
        }
        if(i != length(stringArgs)){
            out = paste0(out,sep)
        }
    }
    return(out)
}

logicArg = function(...,addName = TRUE, sep = '&'){
    logicArgs = list(...)
    out = ''
    for(i in 1:length(logicArgs)){
        if(is.null(logicArgs[[i]])){
            next
        }
        assertthat::assert_that(is.logical(logicArgs[[i]]),
                                msg = glue::glue(names(logicArgs)[i],
                                                 ' is not logical'))
        logicArgs[[i]] %<>% tolower()
        if(addName){
            out = glue::glue('{out}{names(logicArgs)[i]}={logicArgs[[i]]}')
        } else{
            out = glue::glue('{out}{logicArgs[[i]]}')
        }
        if(i != length(logicArgs)){
            out = paste0(out,sep)
        }
    }
    return(out)
}


#' file and return
#'
#' @keywords internal
#'
#' @name fileReturn
#'
#' @param file Character. File path. If provided, response will be saved to file
#' @param return Logical. If the response should be returned. Set to false when
#' you only want to save a file
#' 
NULL