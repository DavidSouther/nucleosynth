d3.layout.spiral = function(options){
	var settings = {
		exponent: options.exponent || 1/2,
		spins: options.spins || 3,
	};

	settings.func = options.func || d3.layout.spiral.archimedes();

	function Ticker(points){
		var theta = 0,
		    scale = d3.scale.pow()
		                    .domain([0, points])
		                    .range([0, settings.spins * 2 * Math.PI])
		                    .exponent(settings.exponent);

		return function(){
			return scale(theta++);
		}
	}

	// Nodes are objects that will get `px, py` set relative to the spiral's center.
	// Follows an Archimedian spiral `r = a + b * theta`
	var spiral = function(nodes){
		var ticker = Ticker(nodes.length),
		    r, theta, node,
		    i_, len_ = nodes.length;

		for(i_ = 0; i_ < len_; i_++){
			node = nodes[i_];
			theta = ticker();
			r = settings.func(theta);
			node.px = r * Math.cos(theta);
			node.py = r * Math.sin(theta);
		}
	};

	spiral.exponent = function(exp){
		if(exp === null){ return settings.exponent; }
		settings.exponent = exp;
		return this;
	};

	spiral.spins = function(spins){
		if(spins === null){ return settings.spin; }
		settings.spins = spins;
		return this;
	}

	return spiral;
};

d3.layout.spiral.linear = d3.layout.spiral.archimedes = function(a, b){
	a = a || 0;
	b = b || 1;
	return function(theta){
		return a + (b * theta);
	}
};

d3.layout.spiral.log = function(a, b){
	a = a || 1;
	b = b || 1;
	return function(theta){
		return a * Math.exp(b * theta);
	}
};

d3.layout.spiral.golden = function(a){
	return d3.layout.spiral.log(a, 0.306349);
}