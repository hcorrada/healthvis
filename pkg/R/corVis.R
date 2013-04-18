#' Create a correlation matrix visualization
#'
#' \code{corVis} takes a matrix input and creates a matrix of
#' distance values for all numeric columns. Points are colored by
#' distance values in the data. Users can order the distance matrix
#' by various clusterings and recalculate distances using various metrics.
#'
#' @param mat A matrix to visualize
#' @param factors A vector of length nrow(mat) with the factors for each row value
#' @param fun Either, cov or cor
#' @param use Use option for fun (see cor help page)
#' @param colors Vector of colors that the heatmap should range through (3 colors: low, medium, high)
#' @param plot.title The title of the plot to appear on the HTML page
#' @param plot If TRUE a browser launches and displays the interactive graphic.
#' @param gaeDevel use the appengine local dev server (for testing only, users should ignore)
#' @return healthvisObj An object of class "healthvis" containing the HTML, Javascript,
#' and CSS code needed to generate the interactive graphic
#' @export
#' @examples
#' testData <- as.matrix(mtcars)
#' cost <- rep(c("cheap","expensive","moderate",c(5,5,22)))
#' corVis(testData,factors=cost)

corVis <- function(mat,factors=NULL,fun=cor,use="everything",colors = c("#003EFF","#FFFFFF","#FF0000"),plot.title="Correlation Matrix", plot=TRUE, gaeDevel=FALSE,url=NULL,...){
  
  if(class(mat) != "matrix"){
	stop("mat must be a matrix object")
  }
   
  if(length(colors) != 3){
      stop("need exactly three colors: low, medium, high.")
  }

  if(is.null(rownames(mat))){rownames(mat) = 1:nrow(mat)}

  distMethods <- c("euclidean", "maximum", "manhattan", "canberra", "binary", "minkowski")
  clustMethods<- c("average", "single", "complete", "ward", "mcquitty", "median", "centroid")
  corMethods <- c("pearson","kendall","spearman")

  nd <- length(distMethods)
  nc <- length(clustMethods)
  nr <- nrow(mat)
  
  if(is.null(factors)) factors = rep(1,nr)
  if(!is.null(factors)) factors = factor(factors)
  if(length(factors)!=nr){stop("Err: factors aren't of length matrix row")}   
 
  distMats = lapply(distMethods,function(i) dist(mat,method = i))
  names(distMats) <-distMethods
  corMats  = lapply(corMethods,function(i) fun(t(mat),method= i,use=use))
  names(corMats)  <-corMethods
  levels = lapply(clustMethods,function(i){lapply(1:nd,function(j){hc=(hclust(distMats[[j]],method=i)$order-1)})})
  names(levels) = clustMethods

  for(i in 1:nc){
    names(levels[[i]])<-distMethods
  }
  for(i in 1:nd){
    distMats[[i]]<- as.matrix(distMats[[i]])
  }
  
  minV   =-1
  maxV   = 1

  if(is.null(factors)) factors = factor(rep(1,nr))
  if(!is.null(factors)) factors = factor(factors)

  # Parameters to pass to javascript
  d3Params <- list(corMats = corMats,
            permutations=levels,
            distNames = distMethods,
            clustNames= clustMethods,
            corNames = corMethods,
            factors = factors,
            colors=colors,
            min = minV,
            max = maxV,
            defaultDist = "euclidean",
            defaultClust= "average",
            defaultCor  = "pearson",
            rownames = rownames(mat),
                   ...)
  
  # Form input types and ranges/options
  varType <- c("factor","factor","factor")
  
  varList <- list("Clustering metric" = as.character(c(clustMethods,"none")),"Distance metrics"= as.character(distMethods),"Correlation method" = as.character(corMethods))
  
  # Initialize healthvis object
  healthvisObj <- new("healthvis",
                      plotType="cor",
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