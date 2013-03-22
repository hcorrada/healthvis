\name{survivalVis}
\alias{survivalVis}
\title{Create a interactive plot of a cox proportional hazards model}
\usage{
  survivalVis(cobj, data, group = NULL, group.names = "",
    line.col = "deepskyblue", plot.title = "Survival Plot",
    plot = TRUE, gaeDevel = FALSE, url = NULL,
    day.max = 1000)
}
\arguments{
  \item{cobj}{An object created with a call to
  \code{\link{coxph}}}

  \item{data}{The dataset used to creat the coxph object.}

  \item{group}{The covariate in model by which to group. If
  NULL, no grouping.}

  \item{group.names}{Names of groups to appear on legend.
  Default empty string for no grouping.}

  \item{line.col}{Vector of names of colors to use for each
  group. Length must equal number of groups. Default single
  string for no grouping.}

  \item{plot.title}{The title of the plot to appear on the
  HTML page}

  \item{plot}{If TRUE a browser launches and displays the
  interactive graphic.}

  \item{gaeDevel}{use the appengine local dev server (for
  testing only, users should ignore)}
}
\value{
  healthvisObj An object of class "healthvis" containing
  the HTML, Javascript, and CSS code needed to generate the
  interactive graphic
}
\description{
  \code{survivalVis} plots a cox proportional hazards model
  and uses the covariate information to update the figure
  in real time. Users can specify a grouping covariate to
  display a group comparison.
}
\examples{
# Uses the survival package
library(survival)
# Set trt and prior as factors so they are treated as such
veteran$trt <- as.factor(veteran$trt)
veteran$prior <- as.factor(veteran$prior)
cobj <- coxph(Surv(time, status)~trt+age+celltype+prior, data=veteran)
survivalVis(cobj, data=veteran, plot.title="Veteran Survival Data", group="trt", group.names=c("Treatment", "No Treatment"), line.col=c("#E495A5","#39BEB1"))
}

