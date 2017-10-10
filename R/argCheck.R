# this could have been better...
argCheck = function(...,addName = TRUE, sep = '&',checkFunction,processFunction=NULL,error){
    args = list(...)
    out = ''
    for(i in 1:length(args)){
        if(is.null(args[[i]])){
            next
        }
        assertthat::assert_that(checkFunction(args[[i]]),
                                msg = glue::glue(names(args)[i],
                                                 ' {error}'))
        if(!is.null(processFunction)){
            args[[i]] %<>% processFunction
        }
        if(addName){
            if(is.null(names(args)[i])){
                stop('addName = TRUE but some arguments do not have names')
            }
            out = glue::glue('{out}{names(args)[i]}={args[[i]]}')
        } else{
            out = glue::glue('{out}{args[[i]]}')
        }
        if(i != length(args)){
            out = paste0(out,sep)
        }
    }
    return(out)
}


stringArg = function(...,addName = TRUE, sep = '&'){
    argCheck(...,addName = addName,
             sep = sep,
             checkFunction = assertthat::is.string,
             processFunction = function(x){utils::URLencode(x,reserved = TRUE)},
             error = "is not a string (a length one character vector).")
}

logicArg = function(...,addName = TRUE, sep = '&'){
    argCheck(...,addName = addName,sep = sep,
             checkFunction = is.logical,
             processFunction = tolower,
             error = "is not logical")
}


numberArg = function(...,addName = TRUE, sep = '&'){
    argCheck(...,addName = addName, sep = sep,
             checkFunction = assertthat::is.number,
             error = "is not a number")
}