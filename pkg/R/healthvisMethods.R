#' Constructor for healthvis objects
#' 
#' Posts data to server
#'
#' @param plotType the type of plot
#' @param plotTitle the title of the plot
#' @param varType a list of variable types (list contains "continuous" or "factor")
#' @param d3Params list of parameters used in d3 script
#' @param gaeDevel Use the appengine local dev server (for testing only, users should ignore)
#' 
#' @exportMethod initialize
setMethod("initialize", signature=c("healthvis"),
          function(.Object, plotType, plotTitle, varType, varList, d3Params=list(),gaeDevel=FALSE,url=NULL) {
            .Object@plotType=plotType
            .Object@plotTitle=plotTitle
            .Object@varType=varType
            .Object@varList=varList
            .Object@d3Params=rjson::toJSON(d3Params)
            
            if (is.null(url)) {
              .Object@url=if (gaeDevel) {
                healthvisOptions$.gaeDevelURL }
              else {
                if (healthvisOptions$.testingRelease) {
                  healthvisOptions$.gaeTestURL 
                  } else {
                    healthvisOptions$.gaeURL
                  }
              }
            } else {
              .Object@url=url
            }
            
            # if using a different port this is where it goes
            # TODO: it should be made an argument
            # Otherwise, we might make a healthvis options
            # list and stick it there
            .Object@server <- HVServer$new()
            .Object@server$bindHVObj(.Object)
            
            wsURL <- sprintf("ws://localhost:%d", .Object@server$port)
            postParams=list(
              plottitle=plotTitle,
              plottype=plotType,
              varlist=rjson::toJSON(varList),
              vartype=rjson::toJSON(varType),
              varnames=rjson::toJSON(names(varList)),
              d3Params=wsURL)
            
            url = sprintf("%s/post_data", .Object@url)
            message("Posting plot info to URL:", url, "\n")
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
            url=sprintf("%s/display/%s", x@url, x@serverID)
            message("\nOpening plot at URL: ", url, "\n")
            browseURL(url)
            
            server <- x@server$start()
            on.exit(httpuv::stopServer(server))
            x@server$run()
})

HVServer$methods(
  initialize=function(...) {
    port <<- healthvisOptions$.wsPort
    server <<- NULL
    interrupted <<- FALSE
    callSuper(...)
  },
  start=function(...) {
    callbacks <- list(
      call=function(req) {
        message("This should never be called")
        invisible()
      },
      onWSOpen=function(ws) {
        websocket <<- ws
        websocket$onMessage(.self$msgCallback)
        websocket$onClose(function() {
          invisible()
        })
      })
    server <<- httpuv::startServer("0.0.0.0", port, callbacks)
    return(server)
  },
  run=function() {
    while (!interrupted) {
      httpuv::service(250)
      Sys.sleep(0.001)
    }
  },
  bindHVObj=function(obj) {
    msgCallback <<- function(binary, msg) {
      if (binary) {
        msg <- rawToChar(msg)
      }
      #cat("msg received ", msg, "\n")
      msg = rjson::fromJSON(msg)
      if (msg$type == "request") {
        out=list(type="response", id=msg$id, data=list())
        msg <- msg$data
        if (msg$action == "getParams") {
          out$data=obj@d3Params
        } else if (msg$action == "savePlot") {
          filename <- tempfile()
          filehandle <- file(filename, "w")
          writeChar(obj@d3Params, filename, eos="\r\n")
          close(filehandle)
        
#           if (healthvisOptions$.testingRelease)
#             browser()
#           
          uri <- msg$data
          formParams=list(
            fileup=fileUpload(filename=filename,contentType="text/plain"),
            plotid=obj@serverID
          )
          if (healthvisOptions$.testingRelease) {
            cat("uploading file to ", uri, "\n")
          }
          res <- postForm(uri, .params=formParams)
          if (healthvisOptions$.testingRelease) {
            cat("server id: ", res, "\n")
          }
          out$data=rjson::toJSON(list(id=res))
        }
        if (msg$action == "stopServer") {
          interrupted <<- TRUE
        }
        response=rjson::toJSON(out)
        websocket$send(response)
      } else if (msg$type == "response") {
          
      }
    }
  }
)
