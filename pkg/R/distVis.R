#' Create a distance matrix visualization
#'
#' \code{distVis} takes a matrix input and creates a matrix of
#' distance values for all numeric columns. Points are colored by
#' distance values in the data. Users can order the distance matrix
#' by various clusterings and recalculate distances using various metrics.
#'
#' @param mat A matrix to visualize
#' @param colors Vector of colors that the heatmap should range through (3 colors: low, medium, high)
#' @param plot.title The title of the plot to appear on the HTML page
#' @param plot If TRUE a browser launches and displays the interactive graphic.
#' @param gaeDevel use the appengine local dev server (for testing only, users should ignore)
#' @return healthvisObj An object of class "healthvis" containing the HTML, Javascript,
#' and CSS code needed to generate the interactive graphic
#' @export
#' @examples
#' # Let's use random data drawn from a binomial distribution, but add interesting names.
#' testData <- matrix(rbinom(n=100*100,prob=.1,size=10),ncol=100)
#' Put something here
#' distVis(testData)

distVis <- function(mat,colors = c("#D33F6A","#E99A2C","#E2E6BD"),plot.title="Distance Matrix", plot=TRUE, gaeDevel=TRUE,url=NULL,...){
  
  if(class(mat) != "matrix"){
	stop("mat must be a matrix object")
  }
   
  if(length(colors) != 3){
      stop("need exactly three colors: low, medium, high.")
  }

  if(is.null(rownames(mat))){rownames(mat) = 1:nrow(mat)}

  distMethods <- c("euclidean", "maximum", "manhattan", "canberra", "binary", "minkowski")
  clustMethods<- c("average", "single", "complete", "ward", "mcquitty", "median", "centroid")

  nd <- length(distMethods)
  nc <- length(clustMethods)
  nr <- nrow(mat)

  distMats = lapply(distMethods,function(i) dist(mat,method = i))
  names(distMats) <-distMethods
  levels = lapply(clustMethods,function(i){lapply(1:nd,function(j){hc=(hclust(distMats[[j]],method=i)$order-1)})})

  names(levels) = clustMethods

  for(i in 1:nc){
    names(levels[[i]])<-distMethods
  }
  for(i in 1:nd){
    distMats[[i]]<- as.matrix(distMats[[i]])
  }
  
  minmax = sapply(distMats,function(i){c(min(i),max(i))})
  minV   = minmax[1,]
  maxV   = minmax[2,]

  defaultDist="euclidean"
  defaultClust ="average"

  # Parameters to pass to javascript
  d3Params <- list(distMats=distMats,
            permutations=levels,
            distNames = distMethods,
            clustNames= clustMethods,
            colors=colors,
            min = minV,
            max = maxV,
            defaultDist = "euclidean",
            defaultClust= "average",
            rownames = rownames(mat),
                   ...)
  
  # Form input types and ranges/options
  varType <- c("factor","factor")
  
  varList <- list("Clustering metric" = as.character(c(clustMethods,"none")),"Distance metrics"= as.character(distMethods))
  
  # Initialize healthvis object
  healthvisObj <- new("healthvis",
                      plotType="dist",
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