#' healthvis class definition
#' 
#' @exportClass healthvis
setClass("healthvis", representation=representation(
  plotType="character",
  plotTitle="character",
  varType="character",
  varList="list",
  url="character",
  serverID="character",
  d3Params="list"))

# TODO: add validity on plotType and varType and varList
