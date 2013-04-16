// Create an initial set of covariates
// where everything is set to 0 except
// for the intercept.

function init_covar(cats){
	var covar = new Array(cats.length);

	for(var i = 0; i < cats.length; i++){	
		if(cats[i] == "(Intercept)"){
			covar[cats[i]] = 1;
		} else {
			covar[cats[i]] = 0;
		}
	}
	
	return covar;
}

// This is an implementation of the estimation of
// response probabilities for a multinomial logit.
// See Agrest's Categorical Data Analysis 7.1.3
// (pg. 271 in the 2002 edition)

function update_covar(covar, coef, len, rows, cols){
	var tmp_pct = new Array(len);
	var pct_tot = 0;
	var tot = 0;
	var keys = Object.keys(covar);

	// Get the total for the denominator
	for(var i=0; i < rows; i++){
		var subtot1 = 0;
		var k = 0;
		for(var j=0; j < cols; j++){
			subtot1 = subtot1 + coef[j][i]*covar[keys[k]];			
			k++;
		}
		tot = tot + Math.exp(subtot1);
	}

	// Get each numerator
	for(var i=0; i < rows; i++){
		var subtot2 = 0;
		var m = 0;
		for(var j=0; j < cols; j++){
			subtot2 = subtot2 + coef[j][i]*covar[keys[m]];
			m++;
		}

		tmp_pct[i+1] = Math.exp(subtot2)/(1+tot); // Skip the baseline for now
		pct_tot = pct_tot + tmp_pct[i+1];
	}

	tmp_pct[0] = 1 - pct_tot;

	for(var q=0; q < tmp_pct.length; q++){
		tmp_pct[q] = Math.round(tmp_pct[q]*100);
	}

	return tmp_pct;
}

function HealthvisIconArray() {

    this.grid = null;
    this.color_array = null;
    this.init_color = null;
    this.group_colors = null;
    this.group_names = null;
    this.formdata = [];
	
	this.w = 700;
	this.h = 500;
	this.legw = this.w/3.5;
	this.legh = this.h/2.5;
    this.y = d3.scale.linear().domain([0,100]).range([this.h*0.98,this.h*0.02]);
 
    // Need better way of setting plot dimensions
    this.init = function(elementId, d3Params) {
		var dimensions = healthvis.getDimensions(this.w, this.h);
		this.w = dimensions.width;
		this.h = dimensions.height;
		this.legw = this.w/3.5;
		this.legh = this.h/2.5;
	
        this.grid = d3.select('#main')
            .append('svg')
            .attr('width', this.w)
            .attr('height', this.h)
	    .attr('class', 'chart');

		this.flag = d3Params.obj_flag;
		this.color_array = d3Params.color_array;
		this.init_color = this.color_array.slice(0);
		this.group_colors = d3Params.group_colors;
		this.group_names = d3Params.group_names;
		this.rows = d3Params.rows;
		this.cols = d3Params.cols;
		this.cats = d3Params.cats;
		this.vtype = d3Params.vtype;

		this.pcts = new Array(this.rows+1); // Add 1 for the baseline category (asumed to be this.pcts[0])

		this.covar = init_covar(this.cats);

		this.c_tmp = d3Params.coefs;

		// Make a 2-D array so we can loop through and get probabilities for each category
		var coefs = new Array(this.cols);
		for(var i=0; i < this.cols; i++){
			coefs[i] = new Array(this.rows);
			for(var j=0; j < this.rows; j++){
				coefs[i][j] = this.c_tmp[i*this.rows+j];
			}
		}

		this.coefs = coefs;

        this.data = [];

	// These things should all depend on plot dimensions
        var cellWidth = this.w/23;
        var cellHeight = this.h/13;
        var start = this.w/70;
        var xpos = start+this.w/28;
        var ypos = start;
        var xBuffer = cellWidth+start;
        var yBuffer = cellHeight+start;
        var count = 0;

	// Initialize an object giving position and color info
	// for each rect.
        for(var i=0; i < 10; i++){
	    this.data.push(new Array());
     	    for(var j=0; j < 10; j++){
	        this.data[i].push({
		    width: cellWidth,
		    height: cellHeight,
    		    x: xpos,
		    y: ypos,
		    color: this.color_array[count]
		});
  	        xpos += xBuffer;
	        count += 1;
     	    }
           xpos = start+this.w/28;
           ypos += yBuffer;
        }


     };

    this.visualize = function() {

        this.row = this.grid.selectAll('.row')
                  .data(this.data)
                .enter().append('svg:g')
                  .attr('class', 'row');

	this.col = this.row.selectAll('.cell')
                 .data(function (d) { return d; })
                .enter().append('svg:rect')
                 .attr('class', 'cell')
                 .attr('x', function(d) { return d.x; })
                 .attr('y', function(d) { return d.y; })
                 .attr('width', function(d) { return d.width; })
                 .attr('height', function(d) { return d.height; })
		 .style('fill', function(d,i) { return d.color; });
	
	var yAxis = d3.svg.axis().scale(this.y).ticks(10).orient('left');
	
	this.grid.append('svg:g')
                .attr('class', 'y axis')
                .attr('transform', 'translate('+this.w/24+',0)')
                .call(yAxis);

	// Add legend

	var legend = this.grid.append('g')
		  .attr('class', 'legend')
		  .attr('x', this.w*(2/3))
		  .attr('y', this.h/4)
		  .attr('height', this.legh)
		  .attr('width', this.legw);
		  
	var lh = this.legh;

	legend.selectAll('rect')
	   .data(this.group_colors).enter().append('rect')
	  .attr('x', this.w*(2/3))
	  .attr('y', function(d,i){return i*(lh/15)+lh/2.2;})
	  .attr('width', this.legw/20)
	  .attr('height', this.legh/20)
	  .style('fill', function(d) { return d; });

	var group_names = this.group_names;

	legend.selectAll('text')
	   .data(this.group_names).enter().append('text')
	  .attr('x', this.w*(2/3)+(1/35)*this.w)
	  .attr('y', function(d,i){return i*(lh/15)+lh/2;})
	  .text(function(d) { return d; });

    };


    this.update = function(formdata) {

	var nums = null;
	
	if(this.flag == 0){	
		for (var j=0; j<this.group_colors.length; j++) {
			this.formdata[j] = parseFloat(formdata[j].value);
		}
		nums = this.formdata;

	} else {
		this.covar = init_covar(this.cats); // Reset everything
		
		// Set the covariates correctly
		for (var j=0; j<formdata.length; j++) {
			if(this.vtype[j] == "factor"){
				this.covar[(formdata[j].name+formdata[j].value)] = 1;
			} else {
				this.covar[formdata[j].name] = parseFloat(formdata[j].value);
			}
		}
		
		this.pcts = update_covar(this.covar, this.coefs, this.pcts.length, this.rows, this.cols);

		nums = this.pcts;
	}


	// Reset colors based on new numbers for each covariate
	var sum=0;
	var col_tmp = this.init_color.slice(0);

	for(var k = 0; k < nums.length; k++){
		for(var m = sum; m < (sum + nums[k]); m++){
			col_tmp[m] = this.group_colors[k];
		}
		sum += nums[k];		
	}

	if(sum > 100){
		alert("Inputs total >100...figure will update, but it may not be how you want.");
	}

	// Reverse, since we need to go from bottom to top
	this.color_array = col_tmp.reverse();

	// Set new colors in data object
	var count=0;
	for(var i=0; i < 10; i++){
		for(var j=0; j <10; j++){
			this.data[i][j].color = this.color_array[count];
			count += 1;
		}
	}

	// Here is the transition: fill new colors
	this.col.transition().style('fill', function(d) { return d.color; });
	
    };
}

healthvis.register(new HealthvisIconArray());
