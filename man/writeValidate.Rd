\name{writeValidate}
\alias{writeValidate}
\title{This function writes the validation script for an Interactive Health Visualization}
\usage{
  writeValidate(var.type, var.list)
}
\arguments{
  \item{var.type}{The type of each interactive variable,
  must be "factor" or "continuous"}

  \item{var.list}{A list containing the names and (min,max)
  ranges for continous variables or the levels for factor
  variables}
}
\value{
  validate - The validation script for the healthvis
  graphic.
}
\description{
  \code{writeValidate} writes the validation script for the
  healthvis graphic. The continuous values are checked to
  be within the (min,max) ranges provided in var.list.
}

