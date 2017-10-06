# this could have been better...

stringArg = function(...,addName = TRUE, sep = '&'){
    stringArgs = list(...)
    out = ''
    for(i in 1:length(stringArgs)){
        if(is.null(stringArgs[[i]])){
            next
        }
        assertthat::assert_that(assertthat::is.string(stringArgs[[i]]),
                                msg = glue::glue(names(stringArgs)[i],
                                                 ' is not a string (a length one character vector).'))
        stringArgs[[i]] %<>% URLencode(reserved = TRUE)
        if(addName){
            out = glue::glue('{out}{names(stringArgs)[i]}={stringArgs[[i]]}')
        } else{
            out = glue::glue('{out}{stringArgs[[i]]}')
        }
        if(i != length(stringArgs)){
            out = paste0(out,sep)
        }
    }
    return(out)
}

logicArg = function(...,addName = TRUE, sep = '&'){
    logicArgs = list(...)
    out = ''
    for(i in 1:length(logicArgs)){
        if(is.null(logicArgs[[i]])){
            next
        }
        assertthat::assert_that(is.logical(logicArgs[[i]]),
                                msg = glue::glue(names(logicArgs)[i],
                                                 ' is not logical'))
        logicArgs[[i]] %<>% tolower()
        if(addName){
            out = glue::glue('{out}{names(logicArgs)[i]}={logicArgs[[i]]}')
        } else{
            out = glue::glue('{out}{logicArgs[[i]]}')
        }
        if(i != length(logicArgs)){
            out = paste0(out,sep)
        }
    }
    return(out)
}


numberArg = function(...,addName = TRUE, sep = '&'){
    numberArgs = list(...)
    out = ''
    for(i in 1:length(numberArgs)){
        if(is.null(numberArgs[[i]])){
            next
        }
        assertthat::assert_that(assertthat::is.number(numberArgs[[i]]),
                                msg = glue::glue(names(numberArgs)[i],
                                                 ' is not a number'))
        numberArgs[[i]] %<>% tolower()
        if(addName){
            out = glue::glue('{out}{names(numberArgs)[i]}={numberArgs[[i]]}')
        } else{
            out = glue::glue('{out}{numberArgs[[i]]}')
        }
        if(i != length(numberArgs)){
            out = paste0(out,sep)
        }
    }
    return(out)
}