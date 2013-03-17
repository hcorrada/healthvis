\name{accuracyTableVis}
\alias{accuracyTableVis}
\title{Create an accuracy table visualization}
\usage{
  accuracyTableVis(plot.title = "Sensitivity/Specificity Plot",
    colors = rainbow_hcl(2, start = 50, end = 270),
    plot = TRUE, gaeDevel = FALSE, url = NULL)
}
\arguments{
  \item{colors}{The colors used (two colors, first for
  TP/TN)}

  \item{plot.title}{The title of the plot to be created}

  \item{plot}{If TRUE the plot is launched in a browser.}

  \item{gaeDevel}{use appengine local dev server (for
  testing only, users should ignore)}
}
\description{
  \code{accuracyTableVis} allows users to examine the
  effect of changing a test's sensitivity and specificity
  or adjusting the prevalence of the disease being tested.
  Changes in the number of true positives (TP), false
  positives (FP), true negatives (TN), and false negatives
  (FN) are reactively displayed.
}

