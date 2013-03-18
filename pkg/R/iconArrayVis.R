#' Create an icon array.
#'
#' \code{iconArrayVis} creates an interactive icon array. Allows for specification of a multinomial
#' logit regression to estimate probability of each group based on a set of covariates. Alternatively,
#' can specify number of groups and group names to manually manipulate icons. This concept is
#' based on research by Zikmund-Fisher et. Al. (http://www.iconarray.com/)
#' 
#' @param mobj Result of multinomial logit regression. Defaults to NULL, meaning groups are manually specified.
#' @param groups Specify number of groups if multinomial model is not provided. Default 2 groups.
#' @param group.names Character vector of group names to appear in legend.
#' @param colors List of colors to use for each group. Should be length of levels of outcome or length of group.names.
#' @param plot.title The title of the plot to be created
#' @param plot If TRUE the plot is launched in a browser. 
#' @param gaeDevel use appengine local dev server (for testing only, users should ignore)
#' @export
#' @examples
#' # To create a simple icon array image
#' iconArrayVis()
#' # To display the results of a multinomial logit (quine data from MASS package)
#' library(MASS)
#' mobj <- multinom(Age~Eth+Sex+Lrn+Days, data=quine)
#' iconArrayVis(mobj, data=quine, colors=rainbow_hcl(4, start=50, end=270), plot.title="School Absenteeism")


iconArrayVis <- function(mobj=NULL, data=NULL, groups=2, group.names=c("Group1", "Group2"), colors=c("deepskyblue", "orangered"), init.color="lightgray", plot.title="Icon Array",plot=TRUE,gaeDevel=FALSE,url=NULL){

	if(is.null(mobj)){
	  obj.flag = 0  # Flag for whether or not an object is passed
	  if(groups <= 0 | groups >=5){
		stop("Must have between 1 and 5 groups.")
	  }

	  if(length(colors) != groups){
		stop("Number of colors does not match number of groups.")
	  }

	  if(length(group.names) != groups){
		stop("Number of group.names does not match number of groups.")
	  }

	  gr <- 1:groups
	  names <- sapply(gr, function(x){paste("group", x)})
	  gr.l <- rep(list(c(0,100)), groups)
	  names(gr.l) <- group.names
	  varType <- rep("continuous", groups)
	  coefs <- ""
	  cats <- ""
	  #ref.cats <- ""
	  row.num <- 0
	  col.num <- 0

	} else {
		obj.flag = 1
		if(is.null(data)){
			stop("Please provide the dataset used for the regression.")
		}
		
		coefs <- summary(mobj)$coefficients
		row.num <- dim(coefs)[1]
		col.num <- dim(coefs)[2]
		cats <- colnames(coefs)

		grouping.var <- all.vars(mobj$terms)[1]
		vars <- all.vars(mobj$terms)[-1] # Ignore the outcome

	      menu.type <- vector("character", length(vars))
		var.list <- list()
#		ref.cats <- c()
  
		for(i in 1:length(vars)){
			cur <- data[[vars[i]]]
			print(class(cur))
			if(class(cur) == "numeric" || class(cur) == "integer"){
				if(length(table(cur)) < 5){
					warning("Variable ", vars[[i]], " has fewer than 5 unique values; treating as continuous, but should this be a factor?")
				}
				menu.type[i] <- "continuous"
				var.list[[vars[i]]] <- range(cur)
			} else if(class(cur) == "factor"){
				if(length(levels(cur)) > 10){
					stop("Variable ", vars[[i]], " has too many levels (>10).")
				}
				menu.type[i] <- "factor"
				var.list[[vars[i]]] <- levels(cur)
				#ref.cats <- c(ref.cats, paste(vars[i], levels(cur)[1], sep=""))
			}
		}

		gr.l <- var.list
		varType <- menu.type
		group.names <- levels(data[[grouping.var]])
		if(length(colors) != length(group.names)){
			print(grouping.var)
			stop("Not enough colors for the categories of your outcome.")
		}
	}

  d3Params=list(obj_flag = obj.flag,
		    color_array=rep(init.color, 100),
		    group_colors=colors,
		    group_names=group.names,
		    coefs=coefs,
		    rows=row.num,
		    cols=col.num,
		    cats=cats,
		    vtype=varType)

  # Create the healthvis object
  healthvisObj = new("healthvis",
                     plotType="icon_array",
                     plotTitle=plot.title,
                     varType=varType,
                     varList=gr.l,
			   d3Params=d3Params,
                     gaeDevel=gaeDevel,
                     url=url)
  
  if(plot){
    plot(healthvisObj)
  }
  
  return(healthvisObj)
} 
