
function colorize(min, median, max, colors){

	var colorScale = d3.scale.linear()
	     .domain([min, median, max])
	     .range([colors[0], colors[1], colors[2]]);

	return(colorScale)
}

Colors = {};
Colors.names = {
    white: "#ffffff",
    aqua: "#00ffff", 
    beige: "#f5f5dc",
    black: "#000000",
    blue: "#0000ff",
    brown: "#a52a2a",
    darkblue: "#00008b",
    darkcyan: "#008b8b",
    darkgrey: "#a9a9a9",
    darkgreen: "#006400",
    darkkhaki: "#bdb76b",
    darkmagenta: "#8b008b",
    darkolivegreen: "#556b2f",
    darkorange: "#ff8c00",
    darkorchid: "#9932cc",
    darkred: "#8b0000",
    darksalmon: "#e9967a",
    darkviolet: "#9400d3",
    fuchsia: "#ff00ff",
    gold: "#ffd700",
    green: "#008000",
    indigo: "#4b0082",
    khaki: "#f0e68c",
    lightblue: "#add8e6",
    lightcyan: "#e0ffff",
    lightgreen: "#90ee90",
    lightgrey: "#d3d3d3",
    lightpink: "#ffb6c1",
    lightyellow: "#ffffe0",
    lime: "#00ff00",
    magenta: "#ff00ff",
    maroon: "#800000",
    navy: "#000080",
    olive: "#808000",
    orange: "#ffa500",
    pink: "#ffc0cb",
    purple: "#800080",
    violet: "#800080",
    red: "#ff0000",
    silver: "#c0c0c0",
    yellow: "#ffff00"
};

Colors.random = function() {
    var result;
    var count = 0;
    for (var prop in this.names)
        if (Math.random() < 1/++count)
           result = prop;
    return result;
};

function HealthvisDist() {

    this.width=550;
    this.height=550;
    this.buffer=100;
    this.formdata = [];

    this.grid = null;
    this.distMats = null;
    this.permutations = null;
    this.clustNames = null;
    this.distNames = null;
    this.min = null;
    this.max = null;
    this.rownames = null;
    this.factors = null;

    this.clustMethod = null;
    this.distMetric = null;

    this.init = function(elementId, d3Params) {
        this.grid = d3.select('#main')
          .append('svg')
          .attr('width', this.width+this.buffer)
          .attr('height', this.height+this.buffer)
          .attr('class', 'chart');

      this.rownames = d3Params.rownames;
      this.distMats = d3Params.distMats;
      this.permutations = d3Params.permutations;
      this.clustNames = d3Params.clustNames;
      this.distNames = d3Params.distNames;
      this.min = d3Params.min;
      this.max = d3Params.max;
      this.colors = d3Params.colors;

      this.clustMethod = d3Params.defaultClust;
      this.distMetric = d3Params.defaultDist;

      this.margin = {
        top: 75,
        left: 75,
        bottom: 30,
        right: 30
      }
      
      this.factors = d3Params.factors;
      this.factorColors = {};
      
      var colors = [];
      for (var color in Colors.names) {
        colors.push(Colors.names[color]);
      }
      var colorIndex = 0;
      this.indexColors = [];
      for (var i = 0; i < this.factors.length; ++i) {
        if (!this.factorColors[this.factors[i]]) {
          this.factorColors[this.factors[i]] = colors[colorIndex];
          colorIndex = (colorIndex + 1) % colors.length;
        }
        
        this.indexColors.push(this.factorColors[this.factors[i]]);
      }
     };

    this.visualize = function() {
      this.grid.select('.table').remove();
      this.grid.select('.rows').remove();
      this.grid.select('.cols').remove();
      this.grid.select('.factorRows').remove();
      this.grid.select('.factorCols').remove();
      var table = this.grid.append('g').attr('class', 'table');
      var rows = this.grid.append('g').attr('class', 'rows');
      var factorRows = this.grid.append('g').attr('class', 'factorRows');
      var cols = this.grid.append('g').attr('class', 'cols');
      var factorCols = this.grid.append('g').attr('class', 'factorCols');

      var n = Math.floor(Math.sqrt(this.distMats[this.distMetric].length));
      var cellWidth = this.width / n;
      var cellHeight = this.height / n;
      var max = this.max[this.distMetric];
      var min = this.min[this.distMetric];
      var mean = (max + min) * 0.5;
      var margin = this.margin;
      var colorMap = colorize(min, mean, max, this.colors);
      var ordering = this.clustMethod == 'none' ? d3.range(0, n) : this.permutations[this.clustMethod][this.distMetric];
      table.selectAll('.cell')
        .data(this.distMats[this.distMetric])
        .enter()
        .append('rect')
        .attr('class', 'cell')
        .attr('x', function(d, i) {
          var col = ordering[i % n];
          return col * cellWidth + margin.left;
        })
        .attr('y', function(d, i) {
          var row = ordering[Math.floor(i / n)];
          return row * cellHeight + margin.top;
        })
        .attr('width', cellWidth)
        .attr('height', cellHeight)
        .style('fill', function(d) { return colorMap(d); });

      rows.selectAll('.row')
        .data(this.rownames)
        .enter()
        .append('text')
        .attr('class', 'row')
        .attr('x', margin.left - 23)
        .attr('y', function(d,i){
          var row = ordering[i];
          return row * cellHeight + margin.top;
        })
        .attr('dy', '.7em')
        .attr('text-anchor', 'end')
        .text(function(d,i){return d;})
        .style('font-size', 6+'px');

      cols.selectAll('.column')
        .data(this.rownames)
        .enter()
        .append('text')
        .attr('x', function(d,i){return margin.left + ordering[i]*cellWidth;})
        .attr('y', margin.top - 23)
        .attr('dy', '.7em')
        .attr('text-anchor', 'start')
        .attr('transform', function(d,i){return 'rotate(-90,' + (margin.left + ordering[i]*cellWidth) + "," + (margin.top - 25) +")";})
        .text(function(d) { return d; })
        .style('font-size', 6+'px');

      var self = this;
      factorRows.selectAll('.factor')
        .data(this.factors)
        .enter()
        .append('rect')
        .attr('class', 'factor')
        .attr('x', margin.left - 20)
        .attr('y', function(d,i){
          var row = ordering[i];
          return row * cellHeight + margin.top;
        })
        .attr('width', cellWidth)
        .attr('height', cellHeight)
        .style('fill', function(d, i) { return self.factorColors[d]; });
     
      factorCols.selectAll('.factor')
        .data(this.factors)
        .enter()
        .append('rect')
        .attr('class', 'factor')
        .attr('x', function(d,i){return margin.left + ordering[i]*cellWidth;})
        .attr('y', margin.top - 3)
        .attr('transform', function(d,i){return 'rotate(-90,' + (margin.left + ordering[i]*cellWidth) + "," + (margin.top - 3) +")";})
        .attr('width', cellWidth)
        .attr('height', cellHeight)
        .style('fill', function(d, i) { return self.factorColors[d]; });
    };


    this.update = function(formdata) {
      for (var i = 0; i < formdata.length; ++i) {
        switch(formdata[i].name) {
          case 'Clustering metric':
            this.clustMethod = formdata[i].value;
            break;
          case 'Distance metrics':
            this.distMetric = formdata[i].value;
            break;
        }
      }
      this.visualize();
    };
}

healthvis.register(new HealthvisDist());
