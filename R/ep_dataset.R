#' All datasets
#'
#' Lists all datasets, or datasets with provided identifiers
#'
#' @param datasets Character vector of identifiers. 
#' Identifiers can either be the ExpressionExperiment ID or its short name 
#' (e.g. GSE1234). 
#' Retrieval by ID is more efficient.
#' Only datasets that user has access to will be available.
#' 
#' Do not combine different identifiers in one query.
#' 
#' @inheritParams filterArg 
#' @inheritParams queryLimit 
#' @inheritParams sortArg
#' @inheritParams fileReturn
#' @inheritParams memoised
#' @return List of lists containing experiment object.
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
                       sort = '+id',
                       file = NULL,
                       return = TRUE,
                       overwrite = FALSE,
                       memoised = FALSE){
    if(memoised){
        mem_allDatasets(datasets = datasets,
                        filter = filter,
                        offset = offset,
                        limit = limit,
                        sort = sort,
                        file = file,
                        return = TRUE,
                        overwrite = overwrite,
                        memoised = FALSE) -> out
        return(out)
    }
    
    
    if(!is.null(datasets)){
        assertthat::assert_that(is.character(datasets) | is.numeric(datasets))
        datasets %<>% paste(collapse =',')
        datasets %<>% utils::URLencode(reserved = TRUE)
    } else{
        datasets = ''
    }
    
    
    url = 
        glue::glue(gemmaBase(),
                   'datasets/{datasets}?{queryLimit(offset,limit)}&{sortArg(sort)}&{filterArg(filter)}')
    
    content = getContent(url, file = file, return = return,overwrite = overwrite)
    if(return){
        names(content) =  content %>% purrr::map_chr('shortName')
    }
    return(content)
}



#' datasetInfo
#'
#' Retrieves information about a single dataset based on the given dataset 
#' identifier. Combines several API calls
#'
#' @param dataset Character. Can either be the dataset ID or its short name 
#' (e.g. GSE1234). If a vector of length>1 is provided return all matching dataset
#'  objects similar to \code{\link{allDatasets}} but without access to additional 
#'  parameters. \code{request} parameter cannot be specified for vector inputs
#' @param request Character. If NULL retrieves the dataset object. Otherwise
#'  \itemize{
#'      \item \code{platforms}: Retrieves platforms for the given dataset
#'      \item \code{samples}: Retrieves samples for the given dataset
#'      \item \code{annotations}: Retrieves the annotations for the given dataset
#'      \item \code{design}: Retrieves the design for the given dataset
#'      \item \code{data}: Retrieves the data for the given dataset. Parameters:
#'          \itemize{
#'              \item \code{filter}: Optional, defaults to FALSE. If TRUE, call
#'               returns filtered expression data.
#'               \item \code{IdColnames}: Optional. defaults to FALSE.
#'                If true shortens data column names to only include the bioAssayId
#'                which is unique to samples in Gemma. Makes it easier to match to
#'                samples acqured from the "samples" request.
#'          }
#'      \item \code{differential}: Retrieves the differential analysis results
#'       for the given dataset. Parameters:
#'          \itemize{
#'              \item \code{qValueThreshold}: Required. Q-value threshold.
#'              \item \code{offset}: Optional, defaults to 0. Skips the 
#'              specified amount of objects when retrieving them from the
#'               database.
#'              \item \code{limit}: Optional, defaults to 20. Limits the result 
#'              to specified amount of objects. Use 0 for no limit.
#'          }
#' }
#' @param ... Use if the specified request has additional parameters.
#' @inheritParams fileReturn
#' @inheritParams memoised
#' @return A data.frame or a list depending on the request
#' @export
#'
#' @examples
#' datasetInfo('GSE81454')
#' datasetInfo('GSE81454', request = 'platforms')
#' datasetInfo('GSE81454', request='data',filter = FALSE)
datasetInfo  = function(dataset, 
                        request = NULL,
                        ...,
                        file = NULL,
                        return = TRUE,
                        overwrite = FALSE,
                        memoised = FALSE){
    if(memoised){
        mem_datasetInfo(dataset = dataset,
                        request = request,
                        ...,
                        file = file,
                        return = return,
                        overwrite = overwrite,
                        memoised = FALSE) -> out
        return(out)
    }
    # optional paramters go here
    requestParams = list(...)
    
    if(!is.null(request)){
        url = glue::glue(gemmaBase(),'datasets/{stringArg(dataset = dataset,addName=FALSE)}')
        assertthat::assert_that(length(dataset)==1)
        request = match.arg(request, 
                            choices = c('platforms',
                                        'samples',
                                        'annotations',
                                        'design','data',
                                        'differential'))
        
        allowedArguments = list(data = c('filter','IdColnames'),
                                differential = c('qValueThreshold',
                                                 'offset',
                                                 'limit'))
        mandatoryArguments = list(differential = 'qValueThreshold')
        
        checkArguments(request,requestParams,allowedArguments,mandatoryArguments)
        
        if(request == 'differential'){
            url = glue::glue('{url}/analyses/differential')
        } else{
            url = glue::glue('{url}/{request}')
        }
        if(request == 'data'){
            url = glue::glue('{url}?{logicArg(filter = requestParams$filter)}')
        } else if(request == 'differential') {
            url = glue::glue('{url}?{numberArg(qValueThreshold = requestParams$qValueThreshold)}',
                             '&{queryLimit(requestParams$offset, requestParams$limit)}')
        }
    } else{
        content = allDatasets(dataset,limit = 0,file=file,return= return,overwrite = overwrite,memoised = memoised)
        return(content)
    }
    content = getContent(url,file = file,return=return,overwrite = overwrite)
    # just setting names. not essential
    if(return){
        if(is.null(request)){
            # currently no one comes here
            # names(content) =  content %>% purrr::map_chr('shortName')
        } else if(request == 'data'){
            if(!is.null(requestParams$IdColnames) && requestParams$IdColnames){
                colnames(content)[grepl('BioAssayId\\=',colnames(content))] %<>% 
                    stringr::str_extract('(?<=BioAssayId\\=).*(?=Name)')
            }
        }else if(request %in% c('platforms')){
            names(content) =  content %>% purrr::map_chr('shortName')
        } else if (request %in% c('samples')){
            names(content) =  content %>% purrr::map_chr('name')
        } else if(request %in% 'annotations'){
            names(content) =  content %>% purrr::map_chr('className')
        } else if (request %in% 'differential'){
            names(content) =  content %>% purrr::map_chr('probe')
        }
    }
    return(content)
}
