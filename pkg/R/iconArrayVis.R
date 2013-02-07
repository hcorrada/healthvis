#' This function creates an interactive Icon Array visualization
#'
#' \code{iconArrayVis} Creates an interactive icon array. Allows for specification of a multinomial
#' logit regression to estimate probability of each group based on a set of covariates. Alternatively,
#' can specify number of groups and group names to manually manipulate icons.
#' 
#' @param mobj Result of multinomial logit regression. Defaults to NULL, meaning groups are manually specified.
#' @param groups Specify number of groups if multinomial model is not provided. Default 2 groups.
#' @param group.names Character vector of group names to appear in legend.
#' @param colors List of colors to use for each group. Should be length of levels of outcome or length of group.names.
#' @param plot.title The title of the plot to be created
#' @param plot If TRUE the plot is launched in a browser. 
#' @param gaeDevel use appengine local dev server (for testing only, users should ignore)
#' @export
#' 
iconArrayVis <- function(mobj=NULL, data=NULL, groups=2, group.names=c("Group1", "Group2"), colors=c("deepskyblue", "orangered"),init.color="lightgray", plot.title="Icon Array",plot=TRUE,gaeDevel=FALSE,url=NULL){

	if(is.null(mobj)){
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
	  init.covars <- ""

	} else {
		if(is.null(data)){
			stop("Please provide the dataset used for the regression.")
		}
		
		coefs <- summary(mobj)$coefficients
		row.num <- dim(coefs)[1]
		col.num <- dim(coefs)[2]

		grouping.var <- all.vars(obj$terms)[1]
		vars <- all.vars(obj$terms)[-1] # Ignore the outcome

	      menu.type <- vector("character", length(vars))
		var.list <- list()
		ref.cats <- c()
		init.covars <- c()
  
		for(i in 1:length(vars)){
			cur <- data[[vars[i]]]
			if(class(cur) == "numeric" || class(cur) == "integer"){
				if(length(table(cur)) < 5){
					warning("Variable ", vars[[i]], " has fewer than 5 unique values; treating as continuous, but should this be a factor?")
				}
				menu.type[i] <- "continuous"
				var.list[[vars[i]]] <- range(cur)
				init.covars <- c(init.covars, 0)
			} else if(class(cur) == "factor"){
				if(length(levels(cur)) > 10){
					stop("Variable ", vars[[i]], " has too many levels (>10).")
				}
				menu.type[i] <- "factor"
				var.list[[vars[i]]] <- levels(cur)
				ref.cats <- c(ref.cats, paste(vars[i], levels(cur)[1]))
				init.covars <- c(init.covars, rep(0, length(levels(cur))-1))
			}
		}

		gr.l <- var.list
		varType <- menu.type
		group.names <- levels(data[[grouping.var]])
		if(length(colors) != length(group.names)){
			stop("Not enough colors for the categories of your outcome.")
		}
	}

  d3Params=list(color_array=rep(init.color, 100),
		    group_colors=colors,
		    group_names=group.names,
		    coefs=coefs,
		    rows=row.num,
		    cols=col.num,
		    init_covars=init.covars)

  # Create the healthvis object
  healthvisObj = new("healthvis",
                     plotType="icon_array",
                     plotTitle=plot.title,
                     varType=varType,
                     varList=gr.l,
			   d3Params=d3Params,
                     gaeDevel=gaeDevel,
                     url=url)
  
  if (plot)
    plot(healthvisObj)
  
  return(healthvisObj)
} 
