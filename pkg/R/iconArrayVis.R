#' This function creates an interactive Icon Array visualization
#'
#' \code{iconArrayVis} creates an interactive icon array
#' 
#' @param plot.title The title of the plot to be created
#' @param plot If TRUE the plot is launched in a browser. 
#' @param gaeDevel use appengine local dev server (for testing only, users should ignore)
#' @export
#' 
iconArrayVis <- function(groups=2, plot.title="Icon Array",plot=TRUE,gaeDevel=FALSE,url=NULL){

  if(groups <= 0 | groups >=5){
	stop("Must have between 1 and 5 groups.")
  }

  gr <- 1:groups
  names <- sapply(gr, function(x){paste("group", x, sep=".")})
  gr.l <- rep(list(c(0,100)), groups)
  names(gr.l) <- names

  # Create the healthvis object
  healthvisObj = new("healthvis",
                     plotType="icon_array",
                     plotTitle=plot.title,
                     varType=rep("continuous", groups),
                     varList=gr.l,
                     gaeDevel=gaeDevel,
                     url=url)
  
  if (plot)
    plot(healthvisObj)
  
  return(healthvisObj)
} 
