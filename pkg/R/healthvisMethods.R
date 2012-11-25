#' Constructor for healthvis objects
#' 
#' Posts data to server
#'
#' @param plotType the type of plot
#' @param plotTitle the title of the plot
#' @param varType a list of variable types (list contains "continuous" or "factor")
#' @param d3Params list of parameters used in d3 script
#' @param gae where to run the http server ("remote" on google app engine, "local" on google app engine local dev server, "none" use localhost httpd server)
#' 
#' @exportMethod initialize
setMethod("initialize", signature=c("healthvis"),
          function(.Object, plotType, plotTitle, varType, varList, d3Params=list(),gae=c("remote","local","none")) {
            .Object@plotType=plotType
            .Object@plotTitle=plotTitle
            .Object@varType=varType
            .Object@varList=varList
            .Object@d3Params=d3Params
            
            .Object@url=switch(gae,
                               remote=.gaeURL,
                               local=.gaeLocalURL,
                               none=.localURL)
            postParams=list(
              plottitle=plotTitle,
              plottype=plotType,
              varlist=rjson::toJSON(varList),
              vartype=rjson::toJSON(varType),
              varnames=rjson::toJSON(names(varList)),
              d3Params=rjson::toJSON(d3Params))
            
            url = sprintf("%s/post_data", .Object@url)
            cat("Posting data to URL:", url, "\n")
            
            serverID = RCurl::postForm(url,.params=postParams)
            
            # TODO better error mechanism
            if(serverID=="error")
              stop("Error posting data to server")
            .Object@serverID=serverID
            .Object
})

if (!isGeneric("plot"))
  setGeneric("plot", function(x,y,...) standardGeneric("plot"))

#' Plot a healthvis object
#' 
#' @param x the healthvis object to plot
#' 
#' @importMethodsFrom graphics plot
#' @exportMethod plot
setMethod("plot", signature=c("healthvis","missing"),
          function(x,y,...) {
            if (x@url == .localURL && !healthvis::isServerRunning())
              healthvis::startServer()
            
            url=sprintf("%s/display/%s", x@url, x@serverID)
            cat("Opening plot at URL: ", url, "\n")
            browseURL(url)
})

