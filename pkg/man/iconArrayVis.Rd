\name{iconArrayVis}
\alias{iconArrayVis}
\title{Create an icon array.}
\usage{
  iconArrayVis(mobj = NULL, data = NULL, groups = 2,
    group.names = c("Group1", "Group2"),
    colors = c("deepskyblue", "orangered"),
    init.color = "lightgray", plot.title = "Icon Array",
    plot = TRUE, gaeDevel = FALSE, url = NULL)
}
\arguments{
  \item{mobj}{Result of multinomial logit regression.
  Defaults to NULL, meaning groups are manually specified.}

  \item{groups}{Specify number of groups if multinomial
  model is not provided. Default 2 groups.}

  \item{group.names}{Character vector of group names to
  appear in legend.}

  \item{colors}{List of colors to use for each group.
  Should be length of levels of outcome or length of
  group.names.}

  \item{plot.title}{The title of the plot to be created}

  \item{plot}{If TRUE the plot is launched in a browser.}

  \item{gaeDevel}{use appengine local dev server (for
  testing only, users should ignore)}
}
\description{
  \code{iconArrayVis} creates an interactive icon array.
  Allows for specification of a multinomial logit
  regression to estimate probability of each group based on
  a set of covariates. Alternatively, can specify number of
  groups and group names to manually manipulate icons. This
  concept is based on research by Zikmund-Fisher et. Al.
  (http://www.iconarray.com/)
}
\examples{
# To create a simple icon array image
iconArrayVis()
# To display the results of a multinomial logit (quine data from MASS package)
library(MASS)
library (nnet) # contains function multinom
mobj <- multinom(Age~Eth+Sex+Lrn+Days, data=quine)
iconArrayVis(mobj, data=quine, colors=c("deepskyblue", "orangered"), plot.title="School Absenteeism")
}

