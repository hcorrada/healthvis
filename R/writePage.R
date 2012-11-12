#' This function writes the HTML page containing an Interactive Health Visualization
#'
#' \code{writePage} is a wrapper that writes the HTML page for a healthvis graphic
#' graphic. 
#'
#' @param d3.script The Javasscript code for the visualization built in D3
#' @param d3.css The CSS code for the visualization
#' @param plot.title The title of the plot to appear on the HTML page
#' @param var.type The type of each interactive variable, must be "factor" or "continuous"
#' @param var.list A list containing the names and (min,max) ranges for continous variables
#' or the levels for factor variables
#' @return html.page -  The source code for the interactive graphic HTML page
#' @export


writePage <- function(d3.script, d3.css, plot.title = "Individualized survival plot", var.type = c("continuous","factor","continuous"), var.list = list(age=c(10,99), sex = c("male","female"),weight=c(100,300))){
  
  html.page <- writeHeader(d3.css, plot.title,var.type,var.list)
  html.page <- paste(html.page,writeBody(d3.script,plot.title,var.type,var.list))
  return(html.page)
}
