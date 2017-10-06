

#' All taxa
#'
#' Lists all available taxa.
#'
#' @inheritParams fileReturn
#' @return List of lists containing experiment object.
#' @export
#'
#' @examples
#' allTaxa()
allTaxa = function(file = NULL,
                       return = TRUE){

    url = paste0(gemmaBase(),'taxa')
    
    content = getContent(url, file = file, return = return)
    if(return){
        names(content) =  content %>% purrr::map_chr('scientificName')
    }
    return(content)
}


# use ogbox::roxygenTabular to re-create the table if needed
#' Title
#'
#' @param taxon can either be Taxon ID, Taxon NCBI ID, or one of its string
#'   identifiers: scientific name, common name, abbreviation. 
#'   
#'   It is recommended
#'   to use Taxon ID for efficiency. 
#'   
#'   Please note, that not all taxa have all the
#'   possible identifiers available. 
#'   
#'   Use the \code{allTaxa} function to retrieve the
#'   necessary information. For convenience, below is a list of few example taxa:
#'   
#'   \tabular{rlllr}{
#' \strong{ID} \tab \strong{Comm.name} \tab \strong{Scient.name}    \tab \strong{Abbr.} \tab \strong{NcbiID}\cr
#' 1            \tab human               \tab Homo sapiens             \tab                 \tab 9606            \cr
#' 2            \tab mouse               \tab Mus musculus             \tab                 \tab 10090           \cr
#' 3            \tab rat                 \tab Rattus norvegicus        \tab                 \tab 10116           \cr
#' 4            \tab salmonid            \tab Salmonidae               \tab                 \tab 8015            \cr
#' 5            \tab atlantic salmon     \tab Salmo salar              \tab ssal            \tab 8030            \cr
#' 6            \tab rainbow trout       \tab Oncorhynchus mykiss      \tab omyk            \tab 8022            \cr
#' 7            \tab whitefish           \tab Coregonus clupeaformis   \tab cclu            \tab 59861           \cr
#' 8            \tab chinook salmon      \tab Oncorhynchus tshawytscha \tab otsh            \tab 74940           \cr
#' 10           \tab rainbow smelt       \tab Osmerus mordax           \tab omor            \tab 8014            \cr
#' 11           \tab yeast               \tab Saccharomyces cerevisiae \tab                 \tab 4932            \cr
#' 12           \tab zebrafish           \tab Danio rerio              \tab                 \tab 7955            \cr
#' 13           \tab fly                 \tab Drosophila melanogaster  \tab                 \tab 7227            \cr
#' 14           \tab worm                \tab Caenorhabditis elegans   \tab                 \tab 6239            
#' }
#' 
#'   
#' @param request character. If NULL retrieves the dataset object. Otherwise
#'     \itemize{
#'         \item \code{datasets}: Retrieves datasets for the given taxon. Parameters:
#'             \itemize{
#'                 \item \code{filter}: Optional see \code{\link{allPlatforms}} filter argument.
#'                 \item \code{offset}: Optional, defaults to 0. Skips the specified amount of objects when retrieving them from the database
#'                 \item \code{limit}: Optional, defaults to 20. Limits the result to specified amount of objects. Use 0 for no limit.
#'                 \item \code{sort}: Character. Optional parameter (defaults to +id) sets the ordering property and direction. Format is [+,-][property name]. E.g. "-accession" will translate to descending ordering by the Accession property. Note that this does not guarantee the order of the returned entities. Nested properties are also supported (recursively). 
#'                 
#'                 E.g: +curationDetails.lastTroubledEvent.date
#'             }
#'         \item \code{phenotypes}: Loads all phenotypes for the given taxon. Paremeters:
#'             \itemize{
#'                 \item \code{editableOnly}: Optional, defaults to FALSE. Whether to only list editable objects.
#'                 \item \code{tree}: Optional, defaults to FALSE. Whether the returned structure should be an actual tree (nested JSON objects). 
#'                 
#'                 Default is false - the tree is flattened and the tree structure information is stored as the values of the returned object.
#'             }
#'         \item \code{phenoCandidateGenes}: Given a set of phenotypes, return all genes associated with them. Parameters:
#'             \itemize{
#'                 \item \code{editableOnly}: Optional, defaults to FALSE. Whether to only list editable objects.
#'                 \item \code{phenotypes}: Required. Phenotype value URIs separated by commas.
#'             }
#'         \item \code{gene}: Retrieves genes matching the identifier on the given taxon. Parameters:
#'             \itemize{
#'                 \item \code{gene}: Required. Can either be the NCBI ID (1859), Ensembl ID (ENSG00000157540) or official symbol (DYRK1A) of the gene.
#'                 
#'                 NCBI ID is the most efficient (and guaranteed to be unique) identifier.
#'                 
#'                 Official symbol represents a gene homologue for a random taxon, unless used in a specific taxon (see the Taxa Endpoints).
#'             }
#'         \item \code{geneEvidence}: Retrieves gene evidence for the gene on the given taxon. Parameters:
#'             \itemize{
#'                 \item \code{gene}: Required. Same as "gene" request
#'             }
#'         \item \code{geneLocation}: Retrieves gene evidence for the gene on the given taxon. Parameters:
#'             \itemize{
#'                 \item \code{gene}: Required. Same as "gene" request
#'             }
#'         \item \code{genesAtLocation}: Finds genes overlapping a given region. Parameters:
#'             \itemize{
#'                 \item \code{chromosome}: Required. The chromosome of the query location. Eg: 3, 21, X
#'                 \item \code{strand}: Optional. Can either be + or -. 
#'                 
#'                 This is a WIP parameter and does currently not do anything.
#'                 
#'                 When using in scripts, remember to URL-encode the '+' plus character (see the compiled URL below).
#'                 \item \code{start}: Required. Number of the start nucleotide of the desired region.
#'                 \item \code{size}: Required. Amount of nucleotides in the desired region (i.e. the length of the region).
#'             }
#'     }
#' @param ... Use if the specified request has additional parameters.
#' @inheritParams fileReturn
#'
#' @return a list
#' @export
#'
#' @examples
#' taxonInfo('human')
#' taxonInfo('human', request = 'datasets')
#' taxonInfo('human',request = 'phenotypes')
#' taxonInfo('human',request = 'phenoCandidateGenes',
#'     phenotypes = c('http://purl.obolibrary.org/obo/DOID_11934',
#'                    'http://purl.obolibrary.org/obo/DOID_3119'))
#' taxonInfo('human', request= 'gene',gene='DYRK1A')
#' taxonInfo('human', request= 'geneLocation',gene='DYRK1A')
taxonInfo = function(taxon,
                     request = NULL,
                     ...,
                     file = NULL,
                     return = TRUE){

    # optional paramters go here
    requestParams = list(...)
    url = glue::glue(gemmaBase(),'taxa/{stringArg(taxon = taxon,addName=FALSE)}')
    if(!is.null(request)){
        request %<>%  match.arg(c('datasets',
                              'phenotypes',
                              'phenoCandidateGenes',
                              'gene',
                              'geneEvidence',
                              'geneLocation',
                              'genesAtLocation'))
        
        allowedArguments = list(datasets = c('filter','offset','limit','sort'),
                                phenotypes = c('editableOnly','tree'),
                                phenoCandidateGenes = c('editableOnly','phenotypes'),
                                gene = c('gene'),
                                geneEvidence = c('gene'),
                                geneLocation = c('gene'),
                                genesAtLocation = c('chromosome','strand','start','size'))
        
        mandatoryArguments = list(gene = 'gene',
                                  geneEvidence = 'gene',
                                  geneLocation = 'gene',
                                  genesAtLocation = c('chromosome','start','size'))
        
        checkArguments(request,requestParams,allowedArguments,mandatoryArguments)
        
        
        if(request == 'datasets'){
                url = glue::glue(url,'/{request}?',
                                 queryLimit(requestParams$offset, requestParams$limit),
                                 '&',sortArg(requestParams$sort))
        }else if (request %in% 'phenotypes'){
            url = glue::glue(url,'/phenotypes?',logicArg(editableOnly = requestParams$editableOnly,
                                                         tree = requestParams$tree))
        } else if(request %in% 'phenoCandidateGenes'){
            phenotypes = requestParams$phenotypes
            assertthat::assert_that(is.character(phenotypes))
            phenotypes %<>% paste(collapse =',')

            url = glue::glue(url,'/phenotypes?',logicArg(editableOnly = requestParams$editableOnly),
                             '&',stringArg(phenotypes = phenotypes))
        } else if(request %in% 'gene'){
            url = glue::glue(url,'/genes/{stringArg(gene = requestParams$gene,addName=FALSE)}')
        } else if(request %in% 'geneEvidence'){
            url = glue::glue(url,'/genes/{stringArg(gene = requestParams$gene,addName=FALSE)}/evidence')
        } else if(request %in% 'geneLocation'){
            url = glue::glue(url,'/genes/{stringArg(gene = requestParams$gene,addName=FALSE)}/locations')
        } else if (request %in% 'genesAtLocation'){
            url = glue::glue(url,'/chromosomes/{requestParams$chromosome}/genes?',
                             stringArg(strand = requestParams$strand),'&',
                             'start={requestParams$start}&size={requestParams$size}')
        }
        
    }
        
    
    content = getContent(url,file = file, return = return)
    # just setting names. not essential
    if(return & !is.null(request)){
        if(request %in% 'datasets'){
            names(content) =  content %>% purrr::map_chr('shortName')
        } else if(request %in% c('phenoCandidateGenes','phenotypes')){
            names(content) =  content %>% purrr::map_chr('value')
        } else if(request %in% c('gene','geneEvidence','genesAtLocation')){
            names(content) =  content %>% purrr::map_chr('ncbiId')
        }
    }
    return(content)
}
