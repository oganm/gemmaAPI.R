#' Gemma authentication
#' 
#' Allows the user to access information that requires logging in to Gemma. To log out, run
#' \code{setGemmaUser} without specifying the username or password
#'
#' @param username Gemma username
#' @param password Gemma password
#'
#' @export
#'
#' @examples
#' setGemmaUser('username','password') # login
#' setGemmaUser() # log out
setGemmaUser = function(username = NULL, password = NULL){
    options(gemmaPassword = password)
    options(gemmaUsername = username)
}


gemmaBase = function(x){
    if(is.null(options('gemmaBase')$gemmaBase)){
        'https://gemma.msl.ubc.ca/rest/v2/'
    } else{
        options('gemmaBase')$gemmaBase
    }
}

simplifyExpressionColnames = function(cn){
    cn[grepl('BioAssayId\\=',cn)] %<>% 
        stringr::str_extract_all('(?<=BioAssay(Impl|)Id\\=)[0-9]*(?=Name)') %>% 
        lapply(sort) %>% sapply(paste,collapse = '|')
    return(cn)
}

# detects what the content is, reads it if return = TRUE, saves it if file path is provided
# if json, reads json, if not attempts to read it as a table
# if content can't be converted into text, assumes it is a gzipped platform
# annotation file
getContent = function(url,file = NULL, return = TRUE,overwrite = FALSE){
    if(!is.null(options('gemmaDebug')$gemmaDebug) && options('gemmaDebug')$gemmaDebug){
        print(url)
    }
    if(return == FALSE & overwrite == FALSE & !is.null(file) && file.exists(file)){
        warning(file,' exists. Skipping')
        return(NULL)
    }
    if(!is.null(getOption('gemmaPassword')) & !is.null(getOption('gemmaUsername'))){
        raw = httr::GET(url = url, httr::authenticate(getOption('gemmaUsername'), 
                                                      getOption('gemmaPassword')))
    } else{
        raw = httr::GET(url = url)
    }
    if(raw$status_code != 200){
        stop("Received a response with status ", raw$status_code, '\n', raw$error$message);
    }
    
    # browser()
    contentText = tryCatch(rawToChar(raw$content),
                           error = function(e){
                               # if you find a file save it. as temp file if address not provided
                               if(is.null(file)){
                                   file = paste0(tempfile(),'.txt.gz')
                               }
                               if(file.exists(file) & !overwrite){
                                   warning(file, ' exists but overwrite = FALSE.\n Skipping writing to file.\nOutput will be read from existing file.')
                               } else{
                                   writeBin(raw$content,file)
                               }
                               return(c('THISISFILE',file))
                           })
    
    if(contentText[1] == 'THISISFILE' & return){
        # if output is a gz file and return is desired, read the gzfile.
        # browser()
        content = readDataFile(contentText[2])
        # content = utils::read.table(gzfile(contentText[2]), header=T,sep='\t', quote="", stringsAsFactors = F)
        return(content)
    }
    
    # write to file if provided
    if(!is.null(file) & contentText[1] != 'THISISFILE' ){
        if(file.exists(file) & !overwrite){
            warning(file,' exists. Skipping')
        }else{
            write(contentText,file = file)
        }
    }
    
    if(return){
        # check if json. if so read as json, if not read as table
        if(jsonlite::validate(contentText)){
            content = jsonlite::fromJSON(contentText,simplifyVector = FALSE)$data
        } else{
            # probably obsolete now
            skip = contentText %>% grepl('^#',x = .) %>% which %>% max
            content = readr::read_tsv(contentText, col_names= TRUE,skip = skip)
        }
    } else{
        content = NULL
    }
    return(content)
}


checkArguments = function(request, requestParams, allowedArguments,mandatoryArguments){

    if(is.null(allowedArguments[[request]]) & length(requestParams)>0){
        warning('Your request does not accept parameters. Ignoring.')
    } else if(any(!names(requestParams) %in% allowedArguments[[request]])){
        # if request is made with unkown arguments complain
        warning(request,
                " request only accepts '",
                paste(allowedArguments[[request]],collapse = "', '"),"'. Ignoring.")
    }
    
    # if request has mandatory arguments that are not provided, fail
    if(length(mandatoryArguments[[request]]>0)){
        if(!all(mandatoryArguments[[request]] %in% names(requestParams))){
            stop(request, " request requires '", paste(mandatoryArguments[[request]], collapse = "', '"), "' specified.")
        }
    }
}


