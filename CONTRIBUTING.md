
Contributing to gemmaAPI
========================

Endpoint functions in gemmaAPI follow a simple pattern and their documentation is lifted from the documentation page for the restful API unless R specific clarifications/changes are required.

Adding a new request to an endpoint
-----------------------------------

1.  **Update the documentation:** The request will be specified by the `request` argument. Add the name and description of the request as an item under the request section as shown below

        #' @param request Character. If NULL retrieves the dataset object. Otherwise
        #'  \itemize{
        #'      \item \code{platforms}: Retrieves platforms for the given dataset
        #'      \item \code{newRequest}: does whatever the request does
        #'  }

    If the request has arguments create another itemized list under the request name and description

        #' @param request Character. If NULL retrieves the dataset object. Otherwise
        #'  \itemize{
        #'      \item \code{platforms}: Retrieves platforms for the given dataset
        #'      \item \code{newRequest}: does whatever the request does
        #'          \itemize{
        #'              \item \code{argumentForNewRequest}: this arg is needed because...
        #'              \item \code{otherArgForNewRequest}: this arg is needed because...
        #'          }
        #'  }

2.  **Add the request as an aviable option:** All endpoint functions check request with `match.args`. Go to this line and add your request

    ``` r
    request = match.args(request,
                        choices  = c('platforms',
                                     'newRequest'))
    ```

3.  **Add the accepted arguments as available arguments:** All endpoint functions check for allowed arguments for a given request. If the new request arguments, add them to the list named `allowedArguments`

    ``` r
    allowedArguments = list( # ... allowed arguments for other requests are listed here
                            newRequest = c('argumentForNewRequest',
                                           'otherArgForNewRequest'))
    ```

4.  **Add the mandatory arguments:** Similar to `allowedArguments` list, all endpoint functions check to see if all mandatory arguments for a request is probided. If the new request has mandatory arguments add them to the list named `mandatoryArguments`

    ``` r
    mandatoryArguments = list(# ... mandatory arguments for other requests are listed here
                              newRequest = c('argumentForNewRequest'))
    ```

    In this case when the endpoint is called with `request = newRequest` it will give a warning if any arguments other than `argumentForNewRequest` and `otherArgForNewRequest` is provided and an error if `argumentForNewRequest` is not provided.

    1.  **Build the URL for the request:** Below the lines you just edited, you'll see logic for building the URLs. Normally, a base url is constructed and request specific additions are added based on what request is made. `glue` function is used to do this in a clean looking way. Any arguments for a request is added by `stringArg`, `logicArg` and `numberArg` functions. `stringArg` allows both numbers and strings since many string inputs also accept identifiers in numeric form. It also uses `URLencode` on the input. `logicArg` makes sure the input is logical and `numberArg` makes sure it is numeric. If the inputs of these functions are NULL they'll return empty strings so no need to check if a non-mandatory input is provided or not. Note that the `addName` argument can be used to control if names of the arguments should be added.

    ``` r
    stringArg(anArg = 'Arbitrary*String',anotherArg = 'Arbitrary_String',addName= TRUE)
    ```

        ## anArg=Arbitrary%2AString&anotherArg=Arbitrary_String

    ``` r
    stringArg(anArg = 'Arbitrary*String',anotherArg = 'Arbitrary_String',addName= FALSE)
    ```

        ## Arbitrary%2AString&Arbitrary_String

    Note that if the request does not follow the basic formula, you may have to re-write the url from scratch.

    ``` r
    if(request ='platforms'){
        url = glue::glue(url,'/platforms')
    } else if(request=='newRequest'){
        url = glue::glue(url,'/newRequest?',stringArg(argumentForNewRequest = argumentForNewRequest),'&',
                         logicArg(otherArgForNewRequest = otherArgForNewRequest))
    }
    ```

5.  **If the output is a list, name the elements:** If the output of the request is a gzipped table, it will be read and returned as a dataframe, but in most cases output is a JSON which is returned as a list.

    The output is saved in `content` object, whose elements are renamed before returning. An identifying property of the elements is used as the name. This property must always be defined and ideally be unique to the element. For instance in the below example, platforms always have shortNames and they are good identifying strings so they are used. For our `newRequest` we choose the `namingElement`.

    ``` r
    if(return){
        if(is.null(request)){
            names(content) =  content %>% purrr::map_chr('officialSymbol')
        } else if (request %in% 'plaftorm'){
            names(content) =  content %>% purrr::map_chr('shortName')
        } else if(request %in% 'newRequest'){
            names(content) = content %>% purrr::map_chr('namingElement')
        }
    }
    ```

6.  **Write tests:** Each endpoint has it's own test file in 'tests/testthat' repo New test files must start with the name `test` to be visible to `testthat` package. A minimal testing should be done to ensure the output has the right type and and is not empty. Certain behaviors of Gemma API changed over time so it is good to provide tests for inputs with expected lengths so you can fail if something changes in the future again. Errors from absance of mandatory inputs could be included. Below some examples are provided.

    1.  Validating the output type

        ``` r
        testthat::expect_is(datasetInfo('GSE12679',request = 'differential',
                            qValueThreshold = 1),'list')
        ```

    2.  Validating the length of the output

        ``` r
        testthat::expect_length(datasetInfo('GSE81454'),1)
        testthat::expect_true(length(datasetInfo('GSE81454',
                                                 request = 'samples'))>0)
        ```

    3.  Error from absance of mandatory input

        ``` r
        testthat::expect_error(datasetInfo('GSE81454',request = 'differential'),
                               regexp = 'qValueThreshold')
        ```
