#' This function writes the HTML body for an Interactive Health Visualization
#'
#' \code{writeBody} writes the body of the HTML page for a healthvis graphic
#' 
#'
#' @param d3.script The Javasscript code for the visualization built in D3
#' @param plot.title The title of the plot to appear on the HTML page
#' @param var.type The type of each interactive variable, must be "factor" or "continuous"
#' @param var.list A list containing the names and (min,max) ranges for continous variables
#' or the levels for factor variables
#' @return html.body -  The source code for the body of the HTML page
#' @export



writeBody <- function(d3.script, plot.title="Individualized survival plot", var.type=c("continuous","factor","continuous"),var.list=list(age=c(10,99),sex=c("male","female"),weight=c(100,300))){
	
	html.body <- paste('\n\t<body>
					   	\n\t\t<div class="container">
					   	\n\t\t\t<div class="page-header">')

	# Add plot title
	html.body <- paste(html.body,'\n\t\t\t\t<h1>',plot.title,'</h1>')

	# Add inHealth/D3 links
	html.body <- paste(html.body,'\n\t\t\t\t<p>created with the <a href="http://healthvis.org">healthvis</a> R package
								 and powered by <a href="http://d3js.org/">Data Driven Documents</a></p>')

	# We will eventually remove the picture of Roger and replace with the svg
	html.body <- paste(html.body,'\n\t\t\t</div>
								\n\t\t\t<div class="row">
								\n\t\t\t\t<div class="span6", id="main">\n',
								d3.script
								,'\n\n\t\t\t\t</div>')

	html.body <- paste(html.body,'\n\t\t\t\t<div class="span3">')

	# Write the web-form

	html.body <- paste(html.body,writeForm(var.type,var.list))

	# Close out the divs/body/html
	html.body <- paste(html.body,'\n\t\t\t\t</div>')
	html.body <- paste(html.body,'\n\t\t\t</div>')

	# Add the publish button

	html.body <- paste(html.body, writePublish())

	html.body <- paste(html.body,'\n\t\t</div>')
	html.body <- paste(html.body,'\n\t</body>')
	html.body <- paste(html.body,'\n</html>')

  return(html.body)
}
