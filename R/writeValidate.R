#' This function writes the validation script for an Interactive Health Visualization
#'
#' \code{writeValidate} writes the validation script for the healthvis graphic. 
#' The continuous values are checked to be within the (min,max) ranges provided
#' in var.list.
#' 
#' @param var.type The type of each interactive variable, must be "factor" or "continuous"
#' @param var.list A list containing the names and (min,max) ranges for continous variables
#' or the levels for factor variables
#' @return validate -  The validation script for the healthvis graphic.
#' @export



writeValidate <- function(var.type,var.list){
	validate <- paste('\n\n\t\t\t<script type="text/javascript">
							\n\t\t\t\t$(document).ready(function(){
							\n\t\t\t\t\t$("#covariate-form").validate({
	  						\n\t\t\t\t\t\trules:{')


	# Write range validation for continous variables 
	n.continuous <- sum(var.type=="continuous")
	which.continuous <- which(var.type=="continuous")
	if(n.continuous > 0){
		cvar.list <- var.list[which.continuous]

		for(i in 1:n.continuous){
			validate <- paste(validate,'\n\t\t\t\t\t\t\t',names(cvar.list)[i],':{')
			validate <- paste(validate,'\n\t\t\t\t\t\t\t\trequired:true,')
			validate <- paste(validate,'\n\t\t\t\t\t\t\t\trange: [',cvar.list[[i]][1],',',cvar.list[[i]][2],']')
			validate <- paste(validate,'\n\t\t\t\t\t\t\t},')
		}
	}

	# Close the validation script
	validate <- paste(validate,'\n\t\t\t\t\t\t}')
	validate <- paste(validate,"\n\t\t\t\t\t});")
	validate <- paste(validate,"\n\t\t\t\t});")
	validate <- paste(validate,'\n\n\t\t\t</script>')
	return(validate)
}
