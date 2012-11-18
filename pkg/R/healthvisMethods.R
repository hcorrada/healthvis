#' A method for plotting a healthvis object
#'
#' @param x A healthvis object to be plotted
#' @param file.title The file name for the HTML page to be created
#' @S3method plot healthvis
#' @method plot healthvis
#' @return \code{NULL}

plot.healthvis <- function(x){
  url=sprintf("%s/display/%s", x$url, x$id)
  cat("Opening plot at URL: ", url, "\n")
  browseURL(url)
}

