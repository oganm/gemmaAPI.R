gemmaBase = function(x){
    'http://www.chibi.ubc.ca/Gemma/rest/v2/'
}



getContent = function(url,file = NULL, return = TRUE){
    raw = httr::GET(url = url)
    if(raw$status_code != 200){
        stop("Received a response with status ", raw$status_code, '\n', content$error$message);
    }
    
    contentText = rawToChar(raw$content)
    
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


