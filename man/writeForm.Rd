\name{writeForm}
\alias{writeForm}
\title{This function writes the covariate input form for the Interactive Health Visualization}
\usage{
  writeForm(var.type, var.list)
}
\arguments{
  \item{var.type}{The type of each interactive variable,
  must be "factor" or "continuous"}

  \item{var.list}{A list containing the names and (min,max)
  ranges for continuous variables or the levels for factor
  variables}
}
\value{
  form - The covariate input form
}
\description{
  \code{writeForm} writes the covariate input form for a
  healthvis graphic. The formis always written so that the
  id of each element in the form is the same as the
  variable name, and the levels of the factor variable
  appear as the values in dropdown boxes.
}

