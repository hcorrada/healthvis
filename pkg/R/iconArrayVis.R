#' This function creates an interactive Icon Array visualization
#'
#' \code{iconArrayVis} creates an interactive icon array
#' 
#' @param plot.title The title of the plot to be created
#' @param plot If TRUE the plot is launched in a browser. 
#' @param gaeDevel use appengine local dev server (for testing only, users should ignore)
#' @export
#' 
iconArrayVis <- function(groups=2, colors=c("deepskyblue", "orangered"),init.color="lightgray", plot.title="Icon Array",plot=TRUE,gaeDevel=FALSE,url=NULL){

  if(groups <= 0 | groups >=5){
	stop("Must have between 1 and 5 groups.")
  }

  if(length(colors) != groups){
	stop("Number of colors does not match number of groups.")
  }

  gr <- 1:groups
  names <- sapply(gr, function(x){paste("group", x, sep=".")})
  gr.l <- rep(list(c(0,100)), groups)
  names(gr.l) <- names

  d3Params=list(color_array=rep(init.color, 100),
		    group_colors=colors)

  # Create the healthvis object
  healthvisObj = new("healthvis",
                     plotType="icon_array",
                     plotTitle=plot.title,
                     varType=rep("continuous", groups),
                     varList=gr.l,
			   d3Params=d3Params,
                     gaeDevel=gaeDevel,
                     url=url)
  
  if (plot)
    plot(healthvisObj)
  
  return(healthvisObj)
} 
