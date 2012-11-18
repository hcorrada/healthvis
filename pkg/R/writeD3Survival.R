#' This function writes the D3.js code for the healthvis survival plot
#'
#' @param dat The survival data in JSON format
#' @param c.sort The sorted coefficients from the Cox regression
#' @param c.names The names of the sorted coefficients
#' @param vars A list of the variables in the formula
#' @param menu.type Whether the menus for each variable should be factor or continuous
#' @param day.max The maximum day for the survival plot
#' @param line.col The color to make the survival plot line. 
#' @return d3.js The D3.js javascript implementing the plot
#' @export


writeD3Survival <- function(dat, c.sort, c.names, vars, menu.type, day.max=1000, line.col="steelblue"){
  
  d3.js <- paste("<script type='text/javascript'>

        function init_coefs(coef_nums, coef_names){
        var coefs = new Array();
        for(var i=0; i < coef_names.length; i++){
        coefs[coef_names[i]] = coef_nums[i];
        }
        
        return coefs;
        }
        
        // Updates hazard function by multiplying each coefficient by its new value
        // We need a function that updates the covariate array when a change is made to the form
        function update_hazard(data, coef, covar){
        var tmpdata = JSON.parse(JSON.stringify(data));
        var xb = 0;
        
        for(key in coef){
        xb = xb + coef[key]*covar[key];
        }
        var prop = Math.exp(xb);
        for(var j=0; j < data.length; j++){
        tmpdata[j].haz = Math.exp(-data[j].haz*prop);
        }
        return tmpdata;
        }
        
        var init_data = ", dat ,";
        var coef_nums = [", paste(c.sort, collapse=", ") ,"];
        var coef_names = [", paste("'", paste(c.names, collapse="', '"), "'", sep="") ,"];
        var init_vals = [", paste(rep(0, length(c.sort)), collapse=", ") ,"];
        var vlist = [", paste("'", paste(vars, collapse="', '"), "'", sep="") ,"];
        var mtype = [", paste("'", paste(menu.type, collapse="', '"), "'", sep="") ,"];
        
        // Initialize associative array of coefficients and coef names
        var coef = init_coefs(coef_nums, coef_names);
        // Initialize patient values to 0 to get baseline hazard
        var covar = init_coefs(init_vals, coef_names);
        // Initialize associative array of variable names
        var vtype = init_coefs(mtype, vlist);
        // Initialize baseline hazard function
        var data = update_hazard(init_data, coef, covar);
        
        
        var w = 700;
        var h = 400;
        var colors = ['", line.col, "']; // Color of line
        
        // Scales
        var x = d3.scale.linear().domain([0,", day.max, "]).range([0, w]);
        var y = d3.scale.linear().domain([-0.2,1.1]).range([h, 0]);
        
        // Base vis layer
        var vis = d3.select('#main')
        .append('svg:svg')
        .attr('width', w)
        .attr('height', h)
        .append('svg:g')
        .attr('transform', 'translate(' + 40 + ',' + 10 + ')');
        
        // create xAxis
        var xAxis = d3.svg.axis().scale(x).tickSize(-h).tickSubdivide(true);
        // Add the x-axis.
        vis.append('svg:g')
        .attr('class', 'x axis')
        .attr('transform', 'translate(0,' + h-10 + ')')
        .call(xAxis);
        // create left yAxis
        var yAxisLeft = d3.svg.axis().scale(y).ticks(4).orient('left');
        // Add the y-axis to the left
        vis.append('svg:g')
        .attr('class', 'y axis')
        .attr('transform', 'translate(-10,0)')
        .call(yAxisLeft);
        
        // Line drawer
        var line = d3.svg.line()
        .x(function(d){return x(d.time);})
        .y(function(d){return y(d.haz);})
        .interpolate('step-after');
        
        // Add path layer
        
        vis.selectAll('.line')
        .data([data])
        .enter().append('path')
        .attr('class', 'line')
        .style('stroke', function(d,i){return colors[i];})
        .attr('d', line);
        
        vis.selectAll('circle')
        .data(data)
        .enter()
        .append('svg:circle')
        .attr('cx', function(d) { return x(d.time); })
        .attr('cy', function(d) { return y(d.haz); })
        .attr('r', 3)
        .attr('opacity', 0)
        .append('svg:title')
        .text(function(d){return 'Day: '+d.time+'\\nSurvival: '+Math.round(d.haz*1000)/1000;});
        
        function update_covar(newcov){
        covar = init_coefs(init_vals, coef_names);
        for(var j=0; j < newcov.length; j++){
        if(vtype[newcov[j].name] == 'continuous'){
        covar[newcov[j].name] = newcov[j].value;
        } else {
        covar[(newcov[j].name+newcov[j].value)]=1;
        }
        }
        }
        
        function fig_update(newcov){
        update_covar(newcov);
        var tmp = update_hazard(init_data, coef, covar)
        vis.selectAll('path.line')
        .data([tmp])
        .transition().duration(1800).delay(100).ease('elastic')
        .attr('width', 0)
        .attr('d',line);
        
        vis.selectAll('circle')
        .data(tmp)
        .transition().duration(1800).delay(100).ease('elastic')
        .attr('cx', function(d) { return x(d.time); })
        .attr('cy', function(d) { return y(d.haz); })
        .attr('r', 3)
        .attr('opacity', 0)
        }
        
        </script>
        ", sep="")
  return(d3.js)
}
