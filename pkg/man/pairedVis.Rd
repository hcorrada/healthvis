\name{pairedVis}
\alias{pairedVis}
\title{Create a paired scatterplot matrix visualization}
\usage{
  pairedVis(data, ...,
    plot.title = "My Scatterplot Matrix", plot = TRUE,
    gaeDevel = FALSE, url = NULL)
}
\arguments{
  \item{data}{A data frame to visualize}

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
  \code{pairedVis} takes a data.frame input and creates a
  matrix of paired plots for all numeric columns. Points
  are colored by categorical columns in the data, which the
  user can cycle through using the drop-down menu (points
  are all one color otherwise). Users can highlight points
  in one plot of the matrix to see them highlighted in all
  of the other plots.
}
\examples{
# Let's use the iris data, but add an extra categorical column
test_data <- iris
test_data$content <- sample(c("High", "Med", "Low", "None"), nrow(test_data), replace=T)
pairedVis(test_data)
}

