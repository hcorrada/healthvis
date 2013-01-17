function HealthvisIconArray() {

    this.rectDemo = null;

    this.init = function(elementId, d3Params) {
        this.grid = d3.select('#main')
            .append('svg:svg')
            .attr('width', 700)
            .attr('height', 500)
	    .attr('class', 'chart');
	
	var data = [];

	var cellWidth = 59;
	var cellHeight = 39;
	var start = 10;
	var xpos = start;
	var ypos = start;
	var xBuffer = 69;
	Var yBuffer = 49;

	for(var i=0; i < 10; i++){
	    for(var j=0; k < 10; j++){
	    	data[i].push({
			      width: cellWidth,
			      height: cellHeight,
			      x: xpos,
			      y: ypos,
			    });
		xpos += xBuffer;
	}
	xpos = start;
	ypos += yBuffer;
    }

    this.visualize = function() {
        this.row = grid.selectAll('.row')
                  .data(data)
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
		 .style('fill', gray)

    }

    this.update = function(newcov) {
	
    }
}

healthvis.register(new HealthvisIconArray());
