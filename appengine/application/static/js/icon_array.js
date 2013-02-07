function HealthvisIconArray() {

    this.grid = null;
    this.color_array = null;
    this.init_color = null;
    this.group_colors = null;
    this.group_names = null;
    this.formdata = [];

    this.y = d3.scale.linear().domain([0,100]).range([490,10]);


    this.init = function(elementId, d3Params) {
        this.grid = d3.select('#main')
            .append('svg')
            .attr('width', 700)
            .attr('height', 500)
	    .attr('class', 'chart');

	this.color_array = d3Params.color_array;
	this.init_color = this.color_array.slice(0);
	this.group_colors = d3Params.group_colors;
	this.group_names = d3Params.group_names;
	this.init_covars = d3Params.init_covars;
	this.rows = d3Params.rows;
	this.cols = d3Params.cols;

	this.c_tmp = d3Params.coefs;

	// Make a 2-D array so we can loop through and get probabilities for each category
	var coefs = new Array(this.cols);
	for(var i=0; i < this.cols; i++){
		coefs[i] = new Array(this.rows);
		for(var j=0; j < this.rows; j++){
			coefs[i][j] = this.c_tmp[i*this.rows+j];
		}
	}

        this.data = [];

        var cellWidth = 30;
        var cellHeight = 39;
        var start = 10;
        var xpos = start+25;
        var ypos = start;
        var xBuffer = 40;
        var yBuffer = 49;
        var count = 0;

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
           xpos = start+25;
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
        for (var j=0; j<this.group_colors.length; j++) {
            this.formdata[j] = parseFloat(formdata[j].value);
        }
	
	
	var sum=0;
	var col_tmp = this.init_color.slice(0);

	for(var k = 0; k < this.formdata.length; k++){
		for(var m = sum; m < (sum + this.formdata[k]); m++){
			col_tmp[m] = this.group_colors[k];
		}
		sum += this.formdata[k];		
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

healthvis.register(new HealthvisIconArray());
