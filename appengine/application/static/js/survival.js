function init_coefs(coef_nums, coef_names){
    var coefs = new Array(coef_names.length);
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

// decalre global variables (not a big fan of this, but for now...)
var w = 700;
var h = 400;

// Base vis layer
var vis = d3.select('#main')
            .append('svg:svg')
            .attr('width', w)
            .attr('height', h)
            .append('svg:g')
            .attr('transform', 'translate(' + 40 + ',' + 10 + ')');


// these depend on d3Params read in the d3.json call
var init_data;
var init_vals;
var coef_names;
var coef;
var covar;
var vtype;
var line;
var x,y;

d3.json(healthvisParams(), function(json) {
    d3Params=json;
    visualizeIt();
});

function visualizeIt() {
    init_data = JSON.parse(d3Params.data); //", dat ,";
    var coef_nums = d3Params.csort; //[", paste(c.sort, collapse=", ") ,"];
    coef_names = d3Params.cnames; //[", paste("'", paste(c.names, collapse="', '"), "'", sep="") ,"];
    var vlist = d3Params.vars; //[", paste("'", paste(vars, collapse="', '"), "'", sep="") ,"];
    var mtype = d3Params.menutype; //[", paste("'", paste(menu.type, collapse="', '"), "'", sep="") ,"];

    //var init_vals = [", paste(rep(0, length(c.sort)), collapse=", ") ,"];
    init_vals = new Array(coef_names.length);
    for (var i=0; i<coef_names.length; i++) {
        init_vals[coef_names[i]]=0;
    }

// Initialize associative array of coefficients and coef names
//    var coef = init_coefs(coef_nums, coef_names);
    coef=coef_nums;
// Initialize patient values to 0 to get baseline hazard
    //var covar = init_coefs(init_vals, coef_names);
    covar=init_vals;
// Initialize associative array of variable names
    vtype = init_coefs(mtype, vlist);
// Initialize baseline hazard function
    var data = update_hazard(init_data, coef, covar);
    var colors = [d3Params.linecol]; // Color of line

// Scales
    x = d3.scale.linear().domain([0,d3Params.daymax]).range([0, w]);
    y = d3.scale.linear().domain([-0.2,1.1]).range([h, 0]);

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
    line = d3.svg.line()
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
        .text(function(d){return 'Day: '+d.time+'\nSurvival: '+Math.round(d.haz*1000)/1000;});
}

function update_covar(newcov){
    for (var j=0; j<coef_names.length; j++) {
        covar[coef_names[j]]=0;
    }
    for(var j=0; j < newcov.length; j++){
        if(vtype[newcov[j].name] == 'continuous'){
            covar[newcov[j].name] = parseFloat(newcov[j].value);
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
