#' This function creates an interactive Accuracy Table visualization
#'
#' \code{accuracyTableVis} creates an interactive survival plot
#' 
#' @param plot.title The title of the plot to be created
#' @param plot If TRUE the plot is launched in a browser. 
#' @export
#' 

accuracyTableVis <- function(plot.title="Sensitivity/Specificity Plot",plot=TRUE){
  # Create the healthvis object
  healthvisObj <- list()
  class(healthvisObj) <- "healthvis"
  healthvisObj$type <- "accuracyTable"
  healthvisObj$var.type <-c("continuous","continuous","continuous")
  healthvisObj$var.list <- list(Sens=c(0,1),Spec=c(0,1),Prev=c(0,1))
  healthvisObj$plot.title <- plot.title
  healthvisObj$page.html <- writePage(writeD3AccuracyTable(), writeD3AccuracyTableCss(),
                            var.type=healthvisObj$var.type,var.list=healthvisObj$var.list,
                            plot.title=healthvisObj$plot.title)
  if(plot){
    plot(healthvisObj)
  }
  return(healthvisObj)
}
