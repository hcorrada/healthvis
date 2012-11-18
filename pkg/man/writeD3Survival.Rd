\name{writeD3Survival}
\alias{writeD3Survival}
\title{This function writes the D3.js code for the healthvis survival plot}
\usage{
  writeD3Survival(dat, c.sort, c.names, vars, menu.type,
    day.max = 1000, line.col = "steelblue")
}
\arguments{
  \item{dat}{The survival data in JSON format}

  \item{c.sort}{The sorted coefficients from the Cox
  regression}

  \item{c.names}{The names of the sorted coefficients}

  \item{vars}{A list of the variables in the formula}

  \item{menu.type}{Whether the menus for each variable
  should be factor or continuous}

  \item{day.max}{The maximum day for the survival plot}

  \item{line.col}{The color to make the survival plot
  line.}
}
\value{
  d3.js The D3.js javascript implementing the plot
}
\description{
  This function writes the D3.js code for the healthvis
  survival plot
}

