#' This function writes the covariate input form for the Interactive Health Visualization
#'
#' \code{writeForm} writes the covariate input form for a healthvis graphic. The formis always written
#' so that the id of each element in the form is the same as the variable name,
#' and the levels of the factor variable appear as the values in dropdown boxes.
#' 
#'
#' @param var.type The type of each interactive variable, must be "factor" or "continuous"
#' @param var.list A list containing the names and (min,max) ranges for continuous variables
#' or the levels for factor variables
#' @return form -  The covariate input form
#' @export

writeForm <- function(var.type,var.list){
	form <- paste('\n\t\t\t\t\t<form class="form-horizontal" action="#" id="covariate-form">
				   \n\t\t\t\t\t\t<fieldset>')

	# Do continuous variables first
	n.continuous <- sum(var.type=="continuous")
	which.continuous <- which(var.type=="continuous")
	
	if(n.continuous > 0){
		cvar.list <- var.list[which.continuous]	
		
		for(i in 1:n.continuous){
			form <- paste(form,'\n\t\t\t\t\t\t<div class="control-group">
						   \n\t\t\t\t\t\t\t<label class="control-label" for="',names(cvar.list)[i],
						   '">',names(cvar.list)[i],'</label>',sep="")
			form <- paste(form,'\n\t\t\t\t\t\t\t<div class="controls">')
			form <- paste(form,'\n\t\t\t\t\t\t\t\t<input type="text" id="',names(cvar.list)[i],
						  '" name="',names(cvar.list[i]),'" value="',cvar.list[[i]][1],'">',sep="")
			form <- paste(form,'\n\t\t\t\t\t\t\t</div>')
			form <- paste(form,'\n\t\t\t\t\t\t</div>')
			form <- paste(form,"\n")
		}

	}

	# Then do the factor variables
	n.factor <- sum(var.type=="factor")
	which.factor <- which(var.type=="factor")

	if(n.factor > 0){
		fvar.list <- var.list[which.factor]

		for(i in 1:n.factor){
			form <- paste(form,'\n\t\t\t\t\t\t<div class="control-group">
						   \n\t\t\t\t\t\t\t<label class="control-label" for="',names(fvar.list)[i],
						   '">',names(fvar.list)[i],'</label>',sep="")
			form <- paste(form,'\n\t\t\t\t\t\t\t<div class="controls">')
			form <- paste(form,'\n\t\t\t\t\t\t\t\t<select id="',names(fvar.list)[i],'" name="',names(fvar.list)[i],'">',sep="")
			
			# Add the select box options
			for(j in 1:length(fvar.list[[i]])){
				if(j==1){
					form <- paste(form,'\n\t\t\t\t\t\t\t\t\t<option value="',fvar.list[[i]][j],'" selected="selected">',fvar.list[[i]][j],'</option>',sep="")
				}else{
					form <- paste(form,'\n\t\t\t\t\t\t\t\t\t<option value="',fvar.list[[i]][j],'">',fvar.list[[i]][j],'</option>',sep="")
				}
			}

			form <- paste(form,'\n\t\t\t\t\t\t\t\t</select>')
			form <- paste(form,'\n\t\t\t\t\t\t\t</div>')
			form <- paste(form,'\n\t\t\t\t\t\t</div>')
			form <- paste(form,"\n")
		}
	}

	# Close the fieldset and the form
 	form <- paste(form,'\n\t\t\t\t\t\t</fieldset>')
 	form <- paste(form,'\n\t\t\t\t\t</form>')

 	return(form)

}
