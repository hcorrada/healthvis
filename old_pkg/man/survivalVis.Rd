\name{survivalVis}
\alias{survivalVis}
\title{This function creates an interactive survival plot}
\usage{
  survivalVis(cobj, data, plot.title = "", plot = TRUE)
}
\arguments{
  \item{cobj}{An object created with a call to
  \code{\link{coxph}}}

  \item{plot.title}{The title of the plot to appear on the
  HTML page}

  \item{data}{The dataset used to creat the coxph object.}

  \item{plot}{If TRUE a browser launches and displays the
  interactive graphic.}
}
\value{
  healthvisObj An object of class "healthvis" containing
  the HTML, Javascript, and CSS code needed to generate the
  interactive graphic
}
\description{
  \code{survivalVis} creates an interactive survival plot
}

