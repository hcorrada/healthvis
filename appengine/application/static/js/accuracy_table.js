function HealthvisAccuracyTable() {

    var sens = 0.9;
    var spec = 0.3;
    var prev = 0.9;
	
	this.lg_font_size = this.h/10;
	this.md_font_size = this.h/20
	this.sm_font_size = this.h/35;
	

    // This is TP, FN, FP, TN
    var res_arr = [sens*prev, (1-sens)*prev, (1-spec)*(1-prev), spec*(1-prev)];

    function font_choose(l,w,fs){
        if(l < 10){
            return(0);
        } else {
            return(Math.max(0.001*l*w, fs));
        }
    }

    function name_choose(l,fs){
        if(l < 10){
            return(0);
        } else {
            return(fs);
        }
    }

	this.svg = null;
    this.rectVis = null;
	this.rectTxtVis = null;
	this.rectTxtCornVis = null;
	this.textVis = null;
	this.rectTxt = null;
	this.rectCornTxt = null;
	this.text = null;
	this.rdim = null;
	this.w = 700;
	this.h = 500;
	this.tmph = this.h*0.6;
	this.tmpw = this.w*0.9;
	this.padding = this.h/100;	

    this.init = function(elementId, d3Params) {
	
	
		var dimensions = healthvis.getDimensions(this.w, this.h);
				
		this.w = dimensions.width;
		this.h = dimensions.height;
		
		this.tmph = this.h*0.6;
		this.tmpw = this.w*0.9;
		this.padding = this.h/100;
		this.lg_font_size = this.h/10;
		this.md_font_size = this.h/20
		this.sm_font_size = this.h/35;
		
		this.colors = d3Params.colors;
		
		this.rdim = [];
		this.rectTxt = [];
		this.rectCornTxt = [];
		this.text = [];
		var rectTmp = ["True +", "False +", "False -", "True -"];
		var textTmp = ["There are 250 people with disease who test positive.", "There are 250 people without disease who test positive.", "There are 250 people with disease who test negative.", "There are 250 people without disease who test negative."];
			
		for(var i =0; i <2; i++){
			for(var j=0; j <2; j++){
				this.rdim.push({"x": this.padding+(this.tmpw/2)*j+this.padding*j, "y": this.padding+(this.tmph/2)*i+this.padding*i, "h": this.tmph/2, "w": this.tmpw/2, "col": this.colors[Math.abs(i-j)]});
				this.rectTxt.push({"x":this.padding+(this.tmpw/2)*j+(this.tmpw/5), "y": this.padding+(this.tmph/2)*i+(this.tmph/3.5), "text":"250", "font_size": this.lg_font_size});
				this.rectCornTxt.push({"x": 2*this.padding+(this.tmpw/2)*j+this.padding*j, "y": 4*this.padding+(this.tmph/2)*i+this.padding*i, "text":rectTmp[2*i+j], "font_size": this.sm_font_size});
				this.text.push({"x":this.padding, "y": 1.2*this.tmph+this.md_font_size*(2*i+j), "text":textTmp[(2*i+j)], "col": this.colors[Math.abs(i-j)]});
			}
		}
		
        this.svg = d3.select(elementId)
            .append('svg:svg')
            .attr('width', this.w)
            .attr('height', this.h);

    }

    this.visualize = function() {
		
		this.rectVis = this.svg.selectAll('rect')
					 .data(this.rdim).enter().append('rect')
					 .attr('x', function(d){return d.x;})
					 .attr('y', function(d){return d.y;})
					 .attr('height', function(d){return d.h;})
					 .attr('width', function(d){return d.w;})
					 .style('fill', function(d){return d.col;});

		this.rectTxtVis = this.svg.selectAll()
						.data(this.rectTxt).enter().append('text')
						.attr('x', function(d){return d.x;})
						.attr('y', function(d){return d.y;})
						.attr('text-anchor', 'left')
						.style('fill', 'white')
						.style('font-size',function(d){return d.font_size+'px';})
						.text(function(d){return d.text;});
					 
		this.rectCornTxtVis = this.svg.selectAll()
						.data(this.rectCornTxt).enter().append('text')
						.attr('x', function(d){return d.x;})
						.attr('y', function(d){return d.y;})
						.attr('text-anchor', 'left')
						.style('fill', 'white')
						.style('font-size',function(d){return d.font_size+'px';})
						.text(function(d){return d.text;});
					 
		this.textVis = this.svg.selectAll()
						.data(this.text).enter().append('text')
						.attr('x', function(d){return d.x;})
						.attr('y', function(d){return d.y;})
						.attr('text-anchor', 'left')
						.style('fill', function(d){return d.col;})
						.style('font-size',this.md_font_size+'px')
						.text(function(d){return d.text;});
			
    }

    this.update = function(newcov) {
		res_arr = [newcov[0].value*newcov[2].value, (1-newcov[0].value)*newcov[2].value, (1-newcov[1].value)*(1-newcov[2].value), newcov[1].value*(1-newcov[2].value)];
		var tot_area = this.tmph*this.tmpw;
		var l_wd = this.tmpw*(res_arr[0]+res_arr[2]);
		var nh_tp = tot_area*res_arr[0]/l_wd;
		var nh_fn = tot_area*res_arr[1]/(this.tmpw-l_wd);
		var nx_tp_txt = (l_wd+2*this.padding)/2 + this.padding;
		var ny_tp_txt = (nh_tp+2*this.padding)/2 + this.padding;
		var ny_fn_txt = (nh_fn+2*this.padding)/2 + this.padding;
	
		var new_dim = [];
		var tmp_txt = ["with disease who test positive.", "with disease who test negative.", "without disease who test positive.", "without disease who test negative."];
		var new_txt = [];
		var idx = null;
	
		for(var i = 0; i < 2; i++){
			for(var j = 0; j < 2; j++){
				idx = 2*i+j;
				this.rdim[idx].x = this.padding+j*(this.padding+l_wd);
				this.rdim[idx].y = this.padding+i*this.padding+Math.max(i-j, 0)*nh_tp + i*j*nh_fn;
				this.rdim[idx].h = j*nh_fn + (1-j)*nh_tp+Math.max(i-j, 0)*(this.tmph-2*nh_tp) + i*j*(this.tmph-2*nh_fn);
				this.rdim[idx].w = l_wd + j*(this.tmpw-2*l_wd);
				
				this.rectTxt[idx].x = this.rdim[idx].x + this.rdim[idx].w/3;
				this.rectTxt[idx].y = this.rdim[idx].y + this.rdim[idx].h/2;
				this.rectTxt[idx].text = Math.round(res_arr[idx]*1000);
				this.rectTxt[idx].font_size = font_choose(this.rdim[idx].h, this.rdim[idx].w, this.sm_font_size);
			
				this.rectCornTxt[idx].x = this.rdim[idx].x + Math.max(this.rdim[idx].w/50, 2*this.padding);
				this.rectCornTxt[idx].y = this.rdim[idx].y + Math.max(this.rdim[idx].h/10, 4*this.padding);
				this.rectCornTxt[idx].font_size = name_choose(this.rdim[idx].h, this.sm_font_size);
			
				this.text[idx].text = "There are "+Math.round(res_arr[idx]*1000)+" people "+tmp_txt[idx];
			}
		}
	
		this.rectVis.transition()
					.attr("x", function(d){return d.x;})
					.attr("y", function(d){return d.y;})
					.attr("height", function(d){return d.h;})
					.attr("width", function(d){return d.w;});

		this.rectTxtVis.transition()
					.attr("x", function(d){return d.x;})
					.attr("y", function(d){return d.y;})
					.attr("text-anchor", "midde")
					.style("font-size", function(d){return d.font_size+'px';})
					.text(function(d){return d.text;});
					 
		this.rectCornTxtVis.transition()
						.attr("x", function(d){return d.x;})
						.attr("y", function(d){return d.y;})
						.style("font-size", function(d){return d.font_size+'px';})
	
					 
		this.textVis.transition().text(function(d){return d.text;});	
    }
	
}

healthvis.register(new HealthvisAccuracyTable());
