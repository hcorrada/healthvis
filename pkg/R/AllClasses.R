# TODO: add validity on plotType and varType and varList

#' healthvis socket class definition
#' 
#' @importClassesFrom httpuv WebSocket
#' @exportClass HVSocket
HVServer = setRefClass("HVServer",
                       fields=list(
                         port="integer",
                         websocket="ANY",
                         msgCallback="function"))
                         
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
  d3Params="character",
  server="HVServer")
)

