function HealthvisIconArray() {

    this.grid = null;
    this.color = null;
    this.color_array = null;
    this.init_color = null;
    this.group_colors = null;
    this.covar = null;

    this.y = d3.scale.linear().domain([0,100]).range([490,10]);


    this.init = function(elementId, d3Params) {
        this.grid = d3.select('#main')
            .append('svg')
            .attr('width', 700)
            .attr('height', 500)
	    .attr('class', 'chart');

	this.color_array = d3Params.color_array;
	this.init_color = this.color_array[0];
	this.group_colors = d3Params.group_colors;

        this.data = [];

        var cellWidth = 50;
        var cellHeight = 39;
        var start = 10;
        var xpos = start+25;
        var ypos = start;
        var xBuffer = 60;
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
		 .style('fill', function(d) { return d.color; });
	
	var yAxis = d3.svg.axis().scale(this.y).ticks(10).orient('left');
	
	this.grid.append('svg:g')
                .attr('class', 'y axis')
                .attr('transform', 'translate(30,0)')
                .call(yAxis);

    };

    this.update_covar = function(newcov){
        for (var j=0; j<this.group_colors.length; j++) {
            this.covar[j] = parseFloat(newcov[j].value);
        }
    };


    this.update = function(newcov) {
	this.update_covar(newcov);
	alert(this.covar);
    };
}

healthvis.register(new HealthvisIconArray());
