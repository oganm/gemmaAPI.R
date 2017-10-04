
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
    # do not accept NULL since they have defaults
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
    assertthat::assert_that(assertthat::is.string(sort))
    sort %<>% URLencode(reserved =  TRUE)
    glue::glue('sort={sort}')
}


