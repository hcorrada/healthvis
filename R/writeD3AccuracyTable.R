#' This function writes the D3.js code for the accuracy table graphic.
#'
#' @return d3.js The D3.js javascript implementing the plot
#' @export


writeD3AccuracyTable <- function(){
  
  d3.js <- paste("<script type='text/javascript'>
var sens = 0.9;
        var spec = 0.3;
        var prev = 0.9;
        // This is TP, FN, FP, TN
        var res_arr = [sens*prev, (1-sens)*prev, (1-spec)*(1-prev), spec*(1-prev)];
        var min_font = 14;
        
        var rectDemo = d3.select('#main').
        append('svg:svg').
        attr('width', 700).
        attr('height', 500);
        
        var tp = rectDemo.append('svg:rect').
        attr('x', 5).
        attr('y', 5).
        attr('height', 142.5).
        attr('width', 342.5).
        style('fill', 'deepskyblue');
        
        var tp_txt = rectDemo.append('svg:text')
        .attr('x', 342.5/2+5) // width/2 + 5
        .attr('y', 142.5/2+5+50/3) // height/2 + 5 + font-size/3?
        .attr('text-anchor','middle')
        .style('fill', 'white')
        .style('font-size', 50+'px')
        .text(250);
        
        var fn = rectDemo.append('svg:rect').
        attr('x', 352.5).
        attr('y', 5).
        attr('height', 142.5).
        attr('width', 342.5).
        style('fill', 'orangered');
        
        var fn_txt = rectDemo.append('svg:text')
        .attr('x', 342.5 + 342.5/2+5) //200 + width/2 + 5
        .attr('y', 142.5/2 + 5 + 50/3) // height/2 + 5 + font-size/3
        .attr('text-anchor','middle')
        .style('fill', 'white')
        .style('font-size', 50+'px')
        .text(250);
        
        
        var fp = rectDemo.append('svg:rect').
        attr('x', 5).
        attr('y', 152.5).
        attr('height', 142.5).
        attr('width', 342.5).
        style('fill', 'orangered');
        
        var fp_txt = rectDemo.append('svg:text')
        .attr('x', 342.5/2+5)  // width/2 + 5
        .attr('y', 142.5 + 142.5/2 + 5+50/3)  // 100 + height/2 + 5 + 10
        .attr('text-anchor','middle')
        .style('fill', 'white')
        .style('font-size', 50+'px')
        .text(250);
        
        var tn = rectDemo.append('svg:rect').
        attr('x', 352.5).
        attr('y', 152.5).
        attr('height', 142.5).
        attr('width', 342.5).
        style('fill', 'deepskyblue');
        
        var tn_txt = rectDemo.append('svg:text')
        .attr('x', 342.5 + 342.5/2+5)
        .attr('y', 142.5 + 142.5/2 + 5 + 50/3)
        .attr('text-anchor','middle')
        .style('fill', 'white')
        .style('font-size', 50+'px')
        .text(250);
        
        var tp_bt_txt = rectDemo.append('svg:text')
        .attr('x', 5)
        .attr('y', 350)
        .style('fill', 'deepskyblue')
        .style('font-size', 25+'px')
        .text('There are '+250+' people with diesease who test positive.');
        
        var fn_bt_txt = rectDemo.append('svg:text')
        .attr('x', 5)
        .attr('y', 380)
        .style('fill', 'orangered')
        .style('font-size', 25+'px')
        .text('There are '+250+' people with diesease who test negative.');
        
        var fp_bt_txt = rectDemo.append('svg:text')
        .attr('x', 5)
        .attr('y', 410)
        .style('fill', 'orangered')
        .style('font-size', 25+'px')
        .text('There are '+250+' people without diesease who test positive.');
        
        var tn_bt_txt = rectDemo.append('svg:text')
        .attr('x', 5)
        .attr('y', 440)
        .style('fill', 'deepskyblue')
        .style('font-size', 25+'px')
        .text('There are '+250+' people without diesease who test negative.');
        
        function font_choose(l,w){
        if(l < 12){
        return(0);
        } else {
        return(Math.max(0.001*l*w, min_font));
        }
        }
        
        function fig_update(newcov){
        res_arr = [newcov[0].value*newcov[2].value, (1-newcov[0].value)*newcov[2].value, (1-newcov[1].value)*(1-newcov[2].value), newcov[1].value*(1-newcov[2].value)];
        var l_wd=685*(res_arr[0]+res_arr[2]);
        var nh_tp=195225*res_arr[0]/l_wd;
        var nh_fn= 195225*res_arr[1]/(685-l_wd);
        var nx_tp_txt = (5+l_wd+5)/2+5;
        var ny_tp_txt = (5+nh_tp+5)/2+5;
        var ny_fn_txt = (5+nh_fn+5)/2+5;
        tp.transition().attr('height',nh_tp).attr('width', l_wd);
        tp_txt.transition().attr('x',nx_tp_txt).attr('y',ny_tp_txt+nh_tp/10)
        .style('font-size', font_choose(nh_tp,l_wd)+'px')
        .text(Math.round(res_arr[0]*1000));
        fn.transition().attr('height',nh_fn).attr('width',685-l_wd)
        .attr('x', 5+l_wd+5);
        fn_txt.transition().attr('x',342.5+nx_tp_txt).attr('y',ny_fn_txt+nh_fn/10)
        .style('font-size', font_choose(nh_fn,(685-l_wd))+'px')
        .text(Math.round(res_arr[1]*1000));
        fp.transition().attr('height',285-nh_tp).attr('width', l_wd)
        .attr('y', 5+nh_tp+5);
        fp_txt.transition().attr('x',nx_tp_txt).attr('y',142.5+ny_tp_txt+(285-nh_tp)/10)
        .style('font-size', font_choose((285-nh_tp),l_wd)+'px')
        .text(Math.round(res_arr[2]*1000));
        tn.transition().attr('height',285-nh_fn).attr('width',685-l_wd)
        .attr('x', 5+l_wd+5).attr('y', 5+nh_fn+5);
        tn_txt.transition().attr('x',342.5+nx_tp_txt).attr('y',142.5+ny_fn_txt+(285-nh_fn)/10)
        .style('font-size', font_choose((285-nh_fn),(685-l_wd))+'px')
        .text(Math.round(res_arr[3]*1000));
        tp_bt_txt.transition()
        .text('There are '+Math.round(res_arr[0]*1000)+' people with diesease who test positive.');	
        
        fn_bt_txt.transition()
        .text('There are '+Math.round(res_arr[1]*1000)+' people with diesease who test negative.');	
        
        fp_bt_txt.transition()
        .text('There are '+Math.round(res_arr[2]*1000)+' people without diesease who test positive.');	
        
        tn_bt_txt.transition()
        .text('There are '+Math.round(res_arr[3]*1000)+' people without diesease who test negative.');	
        
        }
        </script>
        ", sep="")
  return(d3.js)
}
