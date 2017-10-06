gemmaBase = function(x){
    'http://www.chibi.ubc.ca/Gemma/rest/v2/'
}



getContent = function(url,file = NULL, return = TRUE){
    raw = httr::GET(url = url)
    if(raw$status_code != 200){
        stop("Received a response with status ", raw$status_code, '\n', raw$error$message);
    }
    
    
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
        content = read.table(gzfile(contentText[2]), header=T,sep='\t', quote="", stringsAsFactors = F)
        return(content)
    }
    
    # write to file if provided
    if(!is.null(file)){
        write(contentText,file = file)
    }
    
    if(return){
        # check if json. if so read as json, if not read as table
        if(jsonlite::validate(contentText)){
            content = jsonlite::fromJSON(contentText,simplifyVector = FALSE)$data
        } else{
            content = data.table::fread(contentText,data.table=FALSE)
        }
    } else{
        content = NULL
    }
    return(content)
}


