\name{heatmapVis}
\alias{heatmapVis}
\title{Create a sortable heatmap.}
\usage{
  heatmapVis(data, sort.by,
    colors = c("#D33F6A", "#E99A2C", "#E2E6BD"),
    plot.title = "Heatmap Visualization", plot = TRUE,
    gaeDevel = FALSE, url = NULL)
}
\arguments{
  \item{data}{Matrix to be displayed in heatmap from (rows
  are observations/subjects/etc.) Row and column names are
  used in the figure.}

  \item{sort.by}{Dataframe of outcomes to sort on (same
  number of rows as data)}

  \item{colors}{Vector of colors that the heatmap should
  range through (3 colors: low, medium, high)}

  \item{plot.title}{The title of the plot to be created}

  \item{plot}{If TRUE the plot is launched in a browser.}

  \item{gaeDevel}{use appengine local dev server (for
  testing only, users should ignore)}
}
\description{
  \code{heatmapVis} creates an interactive, sortable
  heatmap. Visualizes a matrix of subjects by observations,
  and uses an accompanying matrix of subjects by additional
  covariates to sort.
}
\examples{
# Create a matrix of random values for a set of subjects
nsubj = 40
nobs = 25
data1 <- matrix(rnorm(nsubj*nobs), nsubj, nobs)
rownames(data1) <- sapply(1:nsubj, function(x){paste("S", x, sep="")})
colnames(data1) <- sapply(1:nobs, function(x){paste("V", x, sep="")})

# Create a random set of discrete and continuous covariates to sort by
sort.by1 <- data.frame("Treatment"=rbinom(nsubj, 1, 0.4), "Age"=rpois(nsubj, 30))

heatmapVis(data=data1, sort.by=sort.by1)
}

