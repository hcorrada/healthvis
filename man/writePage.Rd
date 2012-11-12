\name{writePage}
\alias{writePage}
\title{This function writes the HTML page containing an Interactive Health Visualization}
\usage{
  writePage(d3.script, d3.css,
    plot.title = "Individualized survival plot",
    var.type = c("continuous", "factor", "continuous"),
    var.list = list(age = c(10, 99), sex = c("male", "female"), weight = c(100, 300)))
}
\arguments{
  \item{d3.script}{The Javasscript code for the
  visualization built in D3}

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
  html.page - The source code for the interactive graphic
  HTML page
}
\description{
  \code{writePage} is a wrapper that writes the HTML page
  for a healthvis graphic graphic.
}

