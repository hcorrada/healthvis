#' Create an accuracy table visualization
#'
#' \code{accuracyTableVis} allows users to examine the effect of changing
#' a test's sensitivity and specificity or adjusting the prevalence of the
#' disease being tested. Changes in the number of true positives (TP), false
#' positives (FP), true negatives (TN), and false negatives (FN) 
#' are reactively displayed.
#' 
#' @param colors The colors used (two colors, first for TP/TN)
#' @param plot.title The title of the plot to be created
#' @param plot If TRUE the plot is launched in a browser. 
#' @param gaeDevel use appengine local dev server (for testing only, users should ignore)
#' @export
#' @examples
#' accuracyTableVis()
#' 
accuracyTableVis <- function(plot.title="Sensitivity/Specificity Plot", colors = c("deepskyblue", "orangered"), plot=TRUE,gaeDevel=FALSE,url=NULL){

  if(length(colors) != 2 | class(colors) != "character"){
	stop("Please specify two colors: the first for TP/TN,the second from FP/FN.")
  }

  d3Params=list(colors=colors)

  # Create the healthvis object
  healthvisObj = new("healthvis",
                     plotType="accuracy_table",
                     plotTitle=plot.title,
                     varType=c("continuous","continuous","continuous"),
                     varList=list(Sens=c(0,1),Spec=c(0,1),Prev=c(0,1)),
		         d3Params=d3Params,
                     gaeDevel=gaeDevel,
                     url=url)
  
  if (plot)
    plot(healthvisObj)
  
  return(healthvisObj)
}
