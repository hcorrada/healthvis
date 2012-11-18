\name{writeBody}
\alias{writeBody}
\title{This function writes the HTML body for an Interactive Health Visualization}
\usage{
  writeBody(d3.script,
    plot.title = "Individualized survival plot",
    var.type = c("continuous", "factor", "continuous"),
    var.list = list(age = c(10, 99), sex = c("male", "female"), weight = c(100, 300)))
}
\arguments{
  \item{d3.script}{The Javasscript code for the
  visualization built in D3}

  \item{plot.title}{The title of the plot to appear on the
  HTML page}

  \item{var.type}{The type of each interactive variable,
  must be "factor" or "continuous"}

  \item{var.list}{A list containing the names and (min,max)
  ranges for continous variables or the levels for factor
  variables}
}
\value{
  html.body - The source code for the body of the HTML page
}
\description{
  \code{writeBody} writes the body of the HTML page for a
  healthvis graphic
}

