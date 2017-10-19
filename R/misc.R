gemmaBase = function(x){
    'http://www.chibi.ubc.ca/Gemma/rest/v2/'
}

gemmaRead_tsv = function(file){
    lines = readLines(gzfile(f),n = 100)
    skip = lines %>% grepl('^#',x = .) %>% which %>% max
    readFile = read_tsv(gzfile(f), col_names= TRUE,skip = skip)   
}

# detects what the content is, reads it if return = TRUE, saves it if file path is provided
# if json, reads json, if not attempts to read it as a table
# if content can't be converted into text, assumes it is a gzipped platform
# annotation file
getContent = function(url,file = NULL, return = TRUE,overwrite = FALSE){
    if(return == FALSE & overwrite == FALSE & !is.null(file) && file.exists(file)){
        warning(file,' exists. Skipping')
        return(NULL)
    }
    
    raw = httr::GET(url = url)
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
                               writeBin(raw$content,file)
                               
                               return(c('THISISFILE',file))
                           })
    
    if(contentText[1] == 'THISISFILE' & return){
        # if output is a gz file and return is desired, read the gzfile.
        # this is a bad heuristics. will fail if file has a header comment longer that 100 lines
        lines = readLines(gzfile(contentText[2]),n = 100)
        skip = lines %>% grepl('^#',x = .) %>% which %>% max
        con = gzfile(contentText[2])
        content = readr::read_tsv(con, col_names= TRUE,skip = skip)
        close(con)
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


