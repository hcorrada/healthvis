#' A method for plotting a healthvis object
#'
#' @param x A healthvis object to be plotted
#' @param file.title The file name for the HTML page to be created
#' @S3method plot healthvis
#' @method plot healthvis
#' @return \code{NULL}

plot.healthvis <- function(x,file.name="healthvis.html"){
  isServerRunning <- function() {
    tools:::httpdPort > 0L
  }
    
  if(!isServerRunning()) {
    	tools:::startDynamicHelp()
  }

  root.dir <- tempdir()
  temp.file <- file.path(root.dir,paste(file.name))
  cat(x$page.html,file=temp.file)

  browseURL(temp.file)

}

