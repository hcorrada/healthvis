#' This function writes the CSS code for the survival SVG. 
#'
#' @param line.size The line width
#' @param axis.size The axis width 
#' @return d3.css The CSS for the D3.js implemented SVG.
#' @export

writeD3SurvivalCss <- function(line.size=2, axis.size=1){
  
  d3.css <- paste("\n\t\t\t<style type='text/css'>
		#main path {
        stroke: #000;
        stroke-width: ", line.size ,"px;
        fill: none;
}
        .axis {
        shape-rendering: crispEdges;
        }
        
        .x.axis line {
        stroke: lightgrey;
        }
        
        .x.axis .minor {
        stroke-opacity: .5;
        }
        
        .x.axis path {
        display: none;
        }
        
        .y.axis line {
        stroke: lightgrey;
        }
        
        .y.axis path {
        //fill: none;
        stroke: #000;
        stroke-width: ", axis.size ,"px;
        }
        </style>
        ", sep="")
  return(d3.css)
  }
