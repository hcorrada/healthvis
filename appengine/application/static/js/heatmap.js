function HealthvisHeatmap() {
	
    this.width=700;
    this.height=500;
    this.formdata = [];
    this.data = null;
    this.rownames = null;
    this.colnames = null;
    this.ordering = null;
    this.colors = null;

    this.y = d3.scale.linear().domain([0,100]).range([490,10]);

    this.init = function(elementId, d3Params) {
        this.grid = d3.select('#main')
            .append('svg')
            .attr('width', this.width)
            .attr('height', this.height)
	    .attr('class', 'chart');

	this.data = d3Params.data;
	alert(this.data);
	this.rownames = d3Params.rownames;
	this.colnames = d3Params.colnames;
	this.ordering = d3Params.ordering;
	this.colors = d3Params.colors;

     };

    this.visualize = function() {
	
	this.xrange = d3.scale.ordinal().rangeBands([0,this.width]);
	this.yrange = d3.scale.ordinal().rangeBands([0,this.height]);

        this.col = this.grid.selectAll('.col')
                  .data(this.data)
                .enter().append('svg:g')
                  .attr('class', 'col');

	this.row = this.col.selectAll('.row')
		       .data(function(d){return d;})
		       .enter().append('svg:rect')
		       .attr('class', 'row')
                       .attr('x', function(d) { return d.x; })
                       .attr('y', function(d) { return d.y; })
                       .attr('width', function(d) { return d.width; })
                       .attr('height', function(d) { return d.height; })
		       .style('fill', function(d,i) { return d.color; });		       
	
	var yAxis = d3.svg.axis().scale(this.y).ticks(10).orient('left');
	
	this.grid.append('svg:g')
                .attr('class', 'y axis')
                .attr('transform', 'translate(30,0)')
                .call(yAxis);

	// Add legend

	var legend = this.grid.append('g')
		  .attr('class', 'legend')
		  .attr('x', 700 - 240)
		  .attr('y', 125)
		  .attr('height', 200)
		  .attr('width', 200);

	legend.selectAll('rect')
	   .data(this.group_colors).enter().append('rect')
	  .attr('x', 700 - 240)
	  .attr('y', function(d,i){return i*20+100;})
	  .attr('width', 10)
	  .attr('height', 10)
	  .style('fill', function(d) { return d; });

	var group_names = this.group_names;

	legend.selectAll('text')
	   .data(this.group_names).enter().append('text')
	  .attr('x', 700 - 220)
	  .attr('y', function(d,i){return i*20 + 110;})
	  .text(function(d) { return d; });

    };


    this.update = function(formdata) {
	if(this.obj_flag == 0){	
		for (var j=0; j<this.group_colors.length; j++) {
			this.formdata[j] = parseFloat(formdata[j].value);
		}
		var nums = this.formdata;

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

		var nums = this.pcts;
	}

	var sum=0;
	var col_tmp = this.init_color.slice(0);

	for(var k = 0; k < nums.length; k++){
		for(var m = sum; m < (sum + nums[k]); m++){
			col_tmp[m] = this.group_colors[k];
		}
		sum += nums[k];		
	}

	this.color_array = col_tmp.reverse();

	var count=0;
	for(var i=0; i < 10; i++){
		for(var j=0; j <10; j++){
			this.data[i][j].color = this.color_array[count];
			count += 1;
		}
	}

	this.col.transition().style('fill', function(d) { return d.color; });
	
    };
}

healthvis.register(new HealthvisHeatmap());
