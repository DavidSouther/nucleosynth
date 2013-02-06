d3.layout.spiral = 
	// Nodes are objects that will get `px, py` set relative to the spiral's center. nodes[0] will always get `{px: 0, py:0}`
	// Follows an Archimedian spiral `r = a + b * theta`
	function (nodes, options){
		var settings = {
			a: options.a || 0.3,
			b: options.b || 1,
			exponent: options.exponent || 1/2,
			spins: options.spins || 3
		};

		function Ticker(){
			var theta = 0,
			    scale = d3.scale.pow()
			                    .domain([0, nodes.length])
			                    .range([0, settings.spins * 2 * Math.PI])
			                    .exponent(settings.exponent);

			return function(){
				return scale(theta++);
			}
		}

		function archimedes(theta){
			return settings.a + (settings.b * theta);
		}

		function golden(theta){
			return settings.a * Math.exp(settings.b * theta);
		}

		var ticker = Ticker(),
		    func = archimedes,
		    r, theta, node,
		    i_, len_ = nodes.length;

		for(i_ = 0; i_ < len_; i_++){
			node = nodes[i_];
			theta = ticker();
			r = func(theta);
			node.px = r * Math.cos(theta);
			node.py = r * Math.sin(theta);
		}
	}