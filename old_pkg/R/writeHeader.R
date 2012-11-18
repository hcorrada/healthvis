#' This function writes the header for an Interactive Health Visualization
#'
#' \code{writeHeader} writes the header of the healthvis graphic page.
#'
#' @param d3.css The CSS code for the visualization
#' @param plot.title The title of the plot to appear on the HTML page
#' @param var.type The type of each interactive variable, must be "factor" or "continuous"
#' @param var.list A list containing the names and (min,max) ranges for continous variables
#' or the levels for factor variables
#' @return header-  The source code for the header of the healthvis page.
#' @export


writeHeader <- function(d3.css, plot.title="Individualized survival plot", var.type=c("continuous","factor","continuous"),var.list=list(age=c(10,99),sex=c("male","female"),weight=c(100,300))){
	
	header <- paste('<!DOCTYPE html>\n<html lang="en">\n\t<head>\n\t\t<meta charset="utf-8">\n')
	header <- paste(header,'\n\t\t\t<title>',plot.title,'</title>\n')
	

	# May need to change the location of these scripts (Jquery, Jquery Validation Plugin, Twitter Bootstrap)
	header <- paste(header,'\n\t\t\t<link href="http://biostat.jhsph.edu/~jleek/bootstrap/css/bootstrap.css" rel="stylesheet">
							\n\t\t\t<script type="text/javascript" src="http://biostat.jhsph.edu/~jleek/validate/jquery-1.4.4.js"></script>
							\n\t\t\t<script type="text/javascript" src="http://biostat.jhsph.edu/~jleek/validate/jquery.validate.js"></script>
							\n\t\t\t<script type="text/javascript" src="http://d3js.org/d3.v2.js"></script>
							\n\t\t\t<script src="http://malsup.github.com/jquery.form.js"></script>\n')


	# This is where we make the error message red
	header <- paste(header,'\n\n\t\t\t<style>
							\n\t\t\t\tlabel.error{
							\n\t\t\t\t\tfont-weight: bold;
							\n\t\t\t\t\tcolor: red;
  							\n\t\t\t\t\tpadding: 2px 8px;
  							\n\t\t\t\t\tmargin-top: 2px;
							\n\t\t\t\t}
	  						\n\t\t\t</style>')

	# This is the part where we add the form validation script

	header <- paste(header, writeValidate(var.type,var.list))

	# little test function
	
	header <- paste(header, "\n\t\t\t<script>
 							$(document).ready(function() { 
								$('#covariate-form :input').change(function() {
									  if($('#covariate-form').valid()){
										  var newcov = $('#covariate-form').serializeArray();
										  fig_update(newcov);									  };
								});
							});
					 \n\t\t\t</script>")

	# Add d3 CSS
	header <- paste(header, '\n\t', d3.css)

	#Close header
	header <- paste(header,'\n\t</head>')

	return(header)
}
