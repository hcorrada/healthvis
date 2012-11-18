#' This function creates an interactive Accuracy Table visualization
#'
#' \code{accuracyTableVis} creates an interactive survival plot
#' 
#' @param plot.title The title of the plot to be created
#' @param plot If TRUE the plot is launched in a browser. 
#' @export
#' 

accuracyTableVis <- function(plot.title="Sensitivity/Specificity Plot",plot=TRUE,local=FALSE){
  # Create the healthvis object
  healthvisObj <- list()
  class(healthvisObj) <- "healthvis"
  healthvisObj$type <- "accuracyTable"
  healthvisObj$var.type <-c("continuous","continuous","continuous")
  healthvisObj$var.list <- list(Sens=c(0,1),Spec=c(0,1),Prev=c(0,1))
  healthvisObj$plot.title <- plot.title
  
  healthvisObj$url=ifelse(local, .localURL, .gaeURL)
  url = sprintf("%s/post_data", healthvisObj$url)
  cat("Posting data to URL:", url, "\n")
  
  obj.id = RCurl::postForm(sprintf("%s/post_data", healthvisObj$url),
                           .params=list(
                            plottitle=healthvisObj$plot.title,
                            plottype=healthvisObj$type,
                            varlist=rjson::toJSON(healthvisObj$var.list),
                            vartype=rjson::toJSON(healthvisObj$var.type),
                            varnames=rjson::toJSON(names(healthvisObj$var.list)))
  )
  if (obj.id == "error")
    stop("Error posting data")
  
  healthvisObj$id=obj.id
  
  if(plot){
    plot(healthvisObj)
  }
  return(healthvisObj)
}
