\name{distVis}
\alias{distVis}
\title{Create a distance matrix visualization}
\usage{
  distVis(mat, factors = NULL,
    colors = c("#D33F6A", "#E99A2C", "#E2E6BD"),
    plot.title = "Distance Matrix", plot = TRUE,
    gaeDevel = FALSE, url = NULL, ...)
}
\arguments{
  \item{mat}{A matrix to visualize}

  \item{factors}{A vector of length nrow(mat) with the
  factors for each row value}

  \item{colors}{Vector of colors that the heatmap should
  range through (3 colors: low, medium, high)}

  \item{plot.title}{The title of the plot to appear on the
  HTML page}

  \item{plot}{If TRUE a browser launches and displays the
  interactive graphic.}

  \item{gaeDevel}{use the appengine local dev server (for
  testing only, users should ignore)}
}
\value{
  healthvisObj An object of class "healthvis" containing
  the HTML, Javascript, and CSS code needed to generate the
  interactive graphic
}
\description{
  \code{distVis} takes a matrix input and creates a matrix
  of distance values for all numeric columns. Points are
  colored by distance values in the data. Users can order
  the distance matrix by various clusterings and
  recalculate distances using various metrics.
}
\examples{
testData <- as.matrix(mtcars)
cost <- rep(c("cheap","expensive","moderate"),c(5,5,22))
distVis(testData,factors=cost)
}

