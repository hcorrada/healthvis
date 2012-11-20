#' This function creates an interactive Accuracy Table visualization
#'
#' \code{accuracyTableVis} creates an interactive survival plot
#' 
#' @param plot.title The title of the plot to be created
#' @param plot If TRUE the plot is launched in a browser. 
#' @export
#' 
accuracyTableVis <- function(plot.title="Sensitivity/Specificity Plot",plot=TRUE,gae="remote"){
  # Create the healthvis object
  healthvisObj = new("healthvis",
                     plotType="accuracy_table",
                     plotTitle=plot.title,
                     varType=c("continuous","continuous","continuous"),
                     varList=list(Sens=c(0,1),Spec=c(0,1),Prev=c(0,1)),
                     gae=gae)
  
  if (plot)
    plot(healthvisObj)
  
  return(healthvisObj)
}
