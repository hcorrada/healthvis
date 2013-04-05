#' Create a paired scatterplot matrix visualization
#'
#' \code{pairedVis} takes a data.frame input and creates a matrix of
#' paired plots for all numeric columns. Points are colored by
#' categorical columns in the data, which the user can cycle through
#' using the drop-down menu (points are all one color otherwise). Users
#' can highlight points in one plot of the matrix to see them highlighted
#' in all of the other plots.
#'
#' @param data A data frame to visualize
#' @param plot.title The title of the plot to appear on the HTML page
#' @param plot If TRUE a browser launches and displays the interactive graphic.
#' @param gaeDevel use the appengine local dev server (for testing only, users should ignore)
#' @return healthvisObj An object of class "healthvis" containing the HTML, Javascript,
#' and CSS code needed to generate the interactive graphic
#' @export
#' @examples
#' # Let's use the iris data, but add an extra categorical column
#' test_data <- iris
#' test_data$content <- sample(c("High", "Med", "Low", "None"), nrow(test_data), replace=T)
#' pairedVis(test_data)

pairedVis <- function(data, ..., plot.title="My Scatterplot Matrix", plot=TRUE, gaeDevel=FALSE,url=NULL){
  
  if(class(data) != "data.frame"){
	stop("data must be a data frame")
  }
  classes <- sapply(data, class)
  
  nr <- nrow(data)
  cn <- colnames(data)
  ll <- vector("list", length=nr)
  for (irow in 1:nr) ll[[irow]] <- data[irow,]
  
  dropouts <- cn[classes != "numeric"]

  levels <- toJSON(sapply(dropouts, function(x){
			l <- levels(data[[x]])
			if(is.null(l)){
				return( names(table(data[[x]])) )
			} else {
				return(l)
			}
		}, simplify=F))

  n <- sum(classes=="numeric")
  js <- toJSON(ll)

  if (length(dropouts) == 1) dropouts <- list(dropouts)
  if (length(dropouts) == 0) dropouts <- list("None")
  # Parameters to pass to javascript
  d3Params <- list(json=js,
			 levels=levels,
                   dropouts=dropouts,
                   n = n,
                   ...)
  
  # Form input types and ranges/options
  varType <- c("factor")
  
  varList <- list("Category" = dropouts)
  
  # Initialize healthvis object
  healthvisObj <- new("healthvis",
                      plotType="paired",
                      plotTitle=plot.title,
                      varType=varType,
                      varList=varList,
                      d3Params=d3Params,
                      gaeDevel=gaeDevel,
                      url=NULL)
  
  if(plot){
    plot(healthvisObj)
  }
  
  return(healthvisObj)
  
}