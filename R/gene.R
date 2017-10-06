#' geneInfo
#'
#' @param gene Can either be the NCBI ID (1859), Ensembl ID (ENSG00000157540) or official symbol (DYRK1A) of the gene. 
#' 
#' NCBI ID is the most efficient (and guaranteed to be unique) identifier.
#' 
#' Official symbol represents a gene homologue for a random taxon, unless used in a specific taxon (see the Taxa Endpoints).
#' @param request Character. If NULL retrieves all genes matching the identifier. Otherwise
#'     \itemize{
#'         \item \code{evidence}: Retrieves gene evidence for the given gene
#'         \item \code{locations}: Retrieves the physical location of the given gene
#'         \item \code{probes}: Retrieves the probes (composite sequences) with this gene. Parameters:
#'             \itemize{
#'                 \item \code{offset}: Optional, defaults to 0. Skips the 
#'                 specified amount of objects when retrieving them from the
#'                 database.
#'                 \item \code{limit}: Optional, defaults to 20. Limits the result 
#'                 to specified amount of objects. Use 0 for no limit.
#'             }
#'         \item \code{goTerms}: Retrieves the GO terms of the given gene
#'         \item \code{coexpression}: Retrieves the coexpression of two given genes. Parameters:
#'             \itemize{
#'                 \item \code{with}: Required. Can either be the NCBI ID (1859), Ensembl ID (ENSG00000157540) or official symbol (DYRK1A) of the gene.
#'                 
#'                 NCBI ID is the most efficient (and guaranteed to be unique) identifier.
#'                 
#'                 Official symbol represents a gene homologue for a random taxon, unless used in a specific taxon (see the Taxa Endpoints).
#'                 \item \code{limit}: Optional, defaults to 100. 
#'                 
#'                 Limits the result to specified amount of objects. Use 0 for no limit.
#'                 \item \code{stringency}: Optional, defaults to 1. Sets the stringency of coexpression search.
#'             }
#'     }
#' @param ... Use if the specified request has additional parameters.
#' @inheritParams fileReturn
#' 
#' @return A list
#' @export
#'
#' @examples
#' geneInfo('1859') # single match it is a unique NCBI id
#' geneInfo('DYRK1A') # this returns all genes named DYRK1A from all species
geneInfo = function(gene, request = NULL,
                    ...,
                    file = NULL,
                    return = TRUE){
    requestParams = list(...)
    url = glue::glue(gemmaBase(),'genes/{gene}')
    
    if(!is.null(request)){
        request = match.arg(request, 
                            choices = c('evidence',
                                        'locations',
                                        'probes',
                                        'goTerms',
                                        'coexpression'))
        
        allowedArguments = list(probes = c('limit','offset'),
                                coexpression = c('with','limit','stringency'))
        
        mandatoryArguments = list(coexpression = 'with')
        
        checkArguments(request,requestParams,allowedArguments,mandatoryArguments)
        
        
        if (request %in% c('evidence','locations','goTerms')){
            url = glue::glue(url,'/{request}')
        } else if(request == 'probes'){
            url = glue::glue(url,'/probes?{queryLimit(requestParams$offset, requestParams$limit)}')
        } else if(request == 'coexpression'){
            url = glue::glue(url,'/coexpression?with={requestParams$with}&',
                             numberArg(limit = requestParams$limit,
                                       stringency = requestParams$stringency))
        }
    }
    
    
    content = getContent(url,file = file,return=return)
    if(return){
        if(is.null(request)){
            names(content) =  content %>% purrr::map_chr('officialSymbol')
        } else if (request %in% c('goTerms')){
            names(content) =  content %>% purrr::map_chr('goId')
        } else if(request %in% 'annotations'){
            names(content) =  content %>% purrr::map_chr('className')
        } else if (request %in% 'differential'){
            names(content) =  content %>% purrr::map_chr('probe')
        }
    }
    
    return(content)
}