\name{writeHeader}
\alias{writeHeader}
\title{This function writes the header for an Interactive Health Visualization}
\usage{
  writeHeader(d3.css,
    plot.title = "Individualized survival plot",
    var.type = c("continuous", "factor", "continuous"),
    var.list = list(age = c(10, 99), sex = c("male", "female"), weight = c(100, 300)))
}
\arguments{
  \item{d3.css}{The CSS code for the visualization}

  \item{plot.title}{The title of the plot to appear on the
  HTML page}

  \item{var.type}{The type of each interactive variable,
  must be "factor" or "continuous"}

  \item{var.list}{A list containing the names and (min,max)
  ranges for continous variables or the levels for factor
  variables}
}
\value{
  header- The source code for the header of the healthvis
  page.
}
\description{
  \code{writeHeader} writes the header of the healthvis
  graphic page.
}

