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
#' \dontrun{
#' allDatasets(limit = 0)
#' }
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
        names(content) =  content %>% purrr::map_chr('shortName', .default = NA)
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
#'  parameters. \code{request} parameter cannot be specified for inputs of length>1
#'  unless specifiet otherwise in request description.
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
#'      \item \code{differential}: Retrieves available differential expression
#'      tests for the given dataset.
#'          \itemize{
#'              \item \code{offset}: Optional, defaults to 0. Skips the 
#'              specified amount of objects when retrieving them from the
#'               database.
#'              \item \code{limit}: Optional, defaults to 20. Limits the result 
#'              to specified amount of objects. Use 0 for no limit.
#'          }
#'      \item \code{degs}: Retrieves the differential expression results for the given dataset.
#'          \itemize{
#'              \item \code{differential}: Differential id of the differential expression. Can be acquired
#'              from the \code{differential} endpoint.
#'          }
#'      \item \code{diffExExpr}: Retrieves expression values for differential expression subsets for the given datasets.
#'      Parameters:
#'          \itemize{
#'              \item \code{diffExSet}: Result set id of the differential expression. Can be
#'              acquired from the \code{differential} endpoint:
#'              
#'              \code{datasetInfo('GSE43364',request = 'differential')$resultSets[[1]]$id}
#'              \item \code{keepNonSpecific}: Optional, defaults to FALSE.
#'              
#'              If set to false, the response will only include elements that map exclusively to each gene
#'              
#'              If set to true, the response will include all elements that map to each gene, even if they also map to other genes.
#'              \item \code{threshold}: Optional, defaults to 100. 
#'              The threshold that the differential expression has to meet to be included in the response.
#'              \item \code{limit}: Optional, defaults to 100. Maximum amount of returned gene-probe expression level pairs to include in the response.
#'              \item \code{consolidate}: Optional. Defaults no NULL. 
#'              
#'              Whether genes with multiple elements should consolidate the information. If the 'keepNonSpecific' parameter is set to true, then all gene non-specific vectors are excluded from the chosen procedure.
#'              
#'              The options are:
#'                  \itemize{
#'                      \item \code{NULL}:list all vectors separately. 
#'                      \item \code{"pickmax"}: only return the vector that has the highest expression (mean over all its bioAssays).
#'                      \item \code{"pickvar"}: only return the vector with highest variance of expression across its bioAssays
#'                      \item \code{"average"}: create a new vector that will average the bioAssay values from all vectors
#'                  }
#'          }
#'      \item \code{geneExpression}: Retrieves the expression levels of given genes for 
#'      given datasets. Can be used with multiple datasets. Parameters:
#'          \itemize{
#'              \item \code{genes}: Required. A list of identifiers, separated by commas (e.g: 1859, 5728).
#'              
#'              Can either be the NCBI ID (1859), Ensembl ID (ENSG00000157540) or official symbol (DYRK1A) of the gene.
#'              
#'              NCBI ID is the most efficient (and guaranteed to be unique) identifier.
#'              
#'              Official symbol represents a gene homologue for a random taxon, unless used in a specific taxon (see the Taxa Endpoints).
#'              
#'              If the gene taxon does not match the taxon of the given datasets, expression levels for that gene will be missing from the response
#'              
#'              You can combine various identifiers in one query, but any invalid identifier will cause the call to yield an error. Duplicate identifiers of the same gene will result in duplicates in the response.
#'              
#'              \item \code{keepNonSpecific}: Optional. Defaults to FALSE. 
#'              
#'              If set to false, the response will only include elements that map exclusively to each queried gene
#'              
#'              If set to true, the response will include all elements that map to each queried gene, even if they also map to other genes.
#'              
#'              \item \code{consolidate}: Optional. Defaults no NULL. 
#'              
#'              Whether genes with multiple elements should consolidate the information. If the 'keepNonSpecific' parameter is set to true, then all gene non-specific vectors are excluded from the chosen procedure.
#'              
#'              The options are:
#'                  \itemize{
#'                      \item \code{NULL}:list all vectors separately. 
#'                      \item \code{"pickmax"}: only return the vector that has the highest expression (mean over all its bioAssays).
#'                      \item \code{"pickvar"}: only return the vector with highest variance of expression across its bioAssays
#'                      \item \code{"average"}: create a new vector that will average the bioAssay values from all vectors
#'                  }
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
        # allow multiple dataset inputs if gene expression is requested
        if(request %in% c('geneExpression')){
            assertthat::assert_that(is.character(dataset) | is.numeric(dataset))
            dataset %<>% paste(collapse =',')
        }
        
        url = glue::glue(gemmaBase(),'datasets/{stringArg(dataset = dataset,addName=FALSE)}')
        assertthat::assert_that(length(dataset)==1)
        request = match.arg(request, 
                            choices = c('platforms',
                                        'samples',
                                        'annotations',
                                        'design','data',
                                        'differential',
                                        'degs',
                                        'diffExExpr',
                                        'geneExpression'))
        
        allowedArguments = list(data = c('filter','IdColnames'),
                                differential = c('offset',
                                                 'limit'),
                                degs = c('differential'),
                                diffExExpr = c('diffExSet',
                                            'keepNonSpecific',
                                            'threshold',
                                            'limit',
                                            'consolidate'),
                                geneExpression = c('genes',
                                                   'keepNonSpecific',
                                                   'consolidate'))
        mandatoryArguments = list(geneExpression = 'genes',
                                  degs = c('differential'),
                                  diffExExpr = 'diffExSet')
        
        checkArguments(request,requestParams,allowedArguments,mandatoryArguments)
        if(request == 'differential'){
            url = glue::glue('{url}/analyses/differential?',
                             '{queryLimit(requestParams$offset, requestParams$limit)}')
        } else if(request == 'diffExExpr'){
            url = glue::glue('{url}/expressions/differential?',
                             numberArg(diffExSet = requestParams$diffExSet, 
                                       threshold = requestParams$threshold, 
                                       limit = requestParams$limit), '&',
                             logicArg(keepNonSpecific= requestParams$keepNonSpecific),'&',
                             stringArg(consolidate = requestParams$consolidate))
        } else if (request == 'geneExpression'){
            requestParams$genes %<>% paste(collapse=',')
            requestParams$consolidate %<>% match.arg(choices = c('NULL',
                                                                 'pickmax',
                                                                 'pickvar',
                                                                 'average'))
            if(requestParams$consolidate == 'NULL'){
                # match arg fucks up when you use NULL as a choice
                requestParams$consolidate = NULL
            }
            url = glue::glue('{url}/expressions/genes/{stringArg(genes = requestParams$genes,addName = FALSE)}?',
                             stringArg(consolidate = requestParams$consolidate), '&', logicArg(keepNonSpecific = requestParams$keepNonSpecific))
        }else if(request =='degs'){
            
            # this is a special little request that is handled asyncrounusly on gemma's side and not a real part of the API right now
            # consider moving this to high level functions later
            gemma = gemmaBase() %>% dirname() %>% dirname()
            
            # shortname mandatory it seems
            dts = datasetInfo(dataset)
            diffs = datasetInfo(dataset, request = 'differential')
            bioAssaySetId = diffs[[requestParams$differential]]$bioAssaySetId
            
            shortName = dts[[1]]$shortName
            

            temp = tempfile(fileext = '.zip')
            
            if(is.null(file)){
                file = tempfile()
            }
            url = glue::glue('{gemma}/getData.html?file={bioAssaySetId}_{shortName}_diffExpAnalysis_{requestParams$differential}.zip')

            download.file(url, temp)
            dir.create(file,showWarnings = FALSE)
            files = utils::unzip(temp,exdir = file)
            if(return){
                output = files %>% purrr::map(function(x){
                    skip = readLines(x) %>% grepl('^#',x = .) %>% which %>% max
                    readr::read_tsv(x, col_names= TRUE,skip = skip)
                    
                })
                names(output) = gsub('\\.txt','',basename(files))
                return(output)
                
            }else{
                return(NULL)
            }
            

            
        } else{
            url = glue::glue('{url}/{request}')
        }
        if(request == 'data'){
            url = glue::glue('{url}?{logicArg(filter = requestParams$filter)}')
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
                colnames(content) %<>% simplifyExpressionColnames()
            }
        }else if(request %in% c('platforms')){
            names(content) =  content %>% purrr::map_chr('shortName',.null = NA)
        } else if (request %in% c('samples')){
            names(content) =  content %>% purrr::map_chr('name',.null = NA)
        } else if(request %in% 'annotations'){
            names(content) =  content %>% purrr::map_chr('termName',.null = NA)
        } else if (request %in% 'differential'){
            
            names(content) = content %>% purrr::map_chr('id')
            content %<>% lapply(function(x){
                names(x$resultSets) = x$resultSets %>% purrr::map_chr('resultSetId',.default = NA)
                
                x$resultSets %<>% lapply(function(y){
                    names(y$experimentalFactors) = y$experimentalFactors %>% purrr::map_chr('category',.default = NA)
                    return(y) 
                })
                
                return(x)
                
            })
  
        } else if (request == 'diffExExpr'){
            content = content[[1]]$geneExpressionLevels
            names(content) = content %>% purrr::map_chr('geneOfficialSymbol')
        } else if(request %in% 'geneExpression'){
            names(content) =  content %>% purrr::map_chr('datasetId',.default = NA)
            content %<>% lapply(function(x){
                names(x$geneExpressionLevels) = x$geneExpressionLevels %>% 
                    purrr::map_chr('geneNcbiId', .default = NA)
                x$geneExpressionLevels %<>% lapply(function(y){
                    names(y$vectors) = y$vectors %>% purrr::map_chr('designElementName', .default = NA)
                    return(y)
                })
                return(x)
            })
        }
    }
    return(content)
}
