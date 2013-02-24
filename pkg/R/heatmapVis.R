#' This function creates an interactive heatmap visualization
#'
#' \code{heatmapVis} Creates an interactive heatmap. Creates a standard clustered
#' heatmap via R hclust, and also takes in vectors of outcomes by which to sort the
#' data.
#'
#' @param data Dataframe to be displayed in heatmap from (rows are observations). 
#' @param sort.by Dataframe of outcomes to sort on (same number of rows as data)
#' @param colors Vector of colors that the heatmap should range through (3 colors: low, medium, high)
#' @param plot.title The title of the plot to be created
#' @param plot If TRUE the plot is launched in a browser. 
#' @param gaeDevel use appengine local dev server (for testing only, users should ignore)
#' @export
#' 

heatmapVis <- function(data, sort.by, colors = heat_hcl(3), plot.title="Heatmap Visualization", plot=TRUE, gaeDevel=FALSE,url=NULL){
	if(is.null(dim(data)) | is.null(dim(sort.by))){
		stop("data and sort.by must be matrices and/or data.frames.")
	}

	if(nrow(data) != nrow(sort.by)){
		stop("sort.by must have same number of rows as data.")
	}

	if(length(colors) != 3){
		stop("need exactly three colors: low, medium, high.")
	}	

	if(is.null(colnames(sort.by))){
		stop("please provide column names for your sorting variables.")
	}

	ordering <- apply(sort.by, 2, order) # Gets ordering for each outcome

	if(is.null(rownames(data))){
		rownames <- 1:nrow(data)
	} else {
		rownames <- rownames(data)
	}


	if(is.null(colnames(data))){
		colnames <- 1:ncol(data)
	} else {
		colnames <- colnames(data)
	}
	
	#vlist <- list("Sort By"=c("None", colnames(sort.by)), "Junk"=c("A", "B"))
	vlist <- list("Sort By"=c("None", colnames(sort.by)))
	medians <- apply(data, 2, median)
	names(medians) <- NULL

	d3Params=list(data=data,
		    rownames=rownames,
		    colnames=colnames,
		    ordering=ordering,
		    ordnames=colnames(sort.by),
		    colors=colors,
		    nsubj=nrow(data),
		    nobs=ncol(data),
		    ncov=ncol(ordering),
		    medians=medians)

	# Create the healthvis object
	healthvisObj = new("healthvis",
                     plotType="heatmap",
                     plotTitle=plot.title,
#                     varType=c("factor", "factor"),
			   varType="factor",
                     varList=vlist,
			   d3Params=d3Params,
                     gaeDevel=gaeDevel,
                     url=url)
  
	if(plot){
		plot(healthvisObj)
	}
  
	return(healthvisObj)
}
