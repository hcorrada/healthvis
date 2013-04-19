.gaeVersion = gsub("\\.","-",packageVersion("healthvis"))
#' Options list
#' @export
healthvisOptions=new.env()

  healthvisOptions$.gaeDevelURL <- "http://localhost:8080"
  healthvisOptions$.gaeURL  <- "http://healthviz.appspot.com"

  healthvisOptions$.gaeVersion <- .gaeVersion
  healthvisOptions$.gaeTestURL <- sprintf("http://%s.healthviz.appspot.com", .gaeVersion)
  healthvisOptions$.testingRelease <- FALSE
  healthvisOptions$.wsPort <- 7245L

