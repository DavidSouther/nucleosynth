d3.layout.grid = function(options){
	if(!(options.rows && options.cols)){throw "Must provide a size (max rows and cols) for the grid.";}

	// Set a variety of default options.
	options.scales = options.scales || {};
	var settings = {
		rows: options.rows,
		cols: options.cols,
		// Map maps from data point to rectangular (r, c) position.
		map: options.map || d3.layout.grid.rectangular(options.rows, options.cols),
		// Scales map between grid (r, c) coordinates to layer (px, py) coords.
		scales: {
			height: options.scales.height || d3.scale.linear().domain([0, options.rows]).range([25, (options.rows * 50) + 25]),
			width: options.scales.width || d3.scale.linear().domain([0, options.cols]).range([25, (options.cols * 50) + 25])
		}
	};

	// Nodes are objects that will get `px, py` set relative to the spiral's center.
	// Follows an Archimedian spiral `r = a + b * theta`
	var grid = function(nodes){
		var pos, i_, len_ = nodes.length;

		for(i_ = 0; i_ < len_; i_++){
			node = nodes[i_];
			pos = settings.map(node);
			node.px = settings.scales.width(pos.col);
			node.py = settings.scales.height(pos.row);
		}
		return nodes;
	};

	return grid;
};

/*
	The gridder function is called successively with each data point, and should return a bare object
	with {row: _int_, col: _int_} where row and col are the 0-based row and column positions to place
	the object. The gridder should assume an idealized grid- the layout will map from (r, c) to (px, py).
	This gridder is *very* non-idempotent, and will return different results for each time it is called.
	It takes a required number of rows and columns. If columns is set to zero, the grid will grow as tall
	as needed. Otherwise, and exception will be thrown *WHEN GROWING LARGER THAN THE NUMBER OF ROWS*.
 */
d3.layout.grid.rectangular = function(rows, cols){
	var r, c, g;
	r = c = 0;
	return function(){
		var pos = {
			row: r,
			col: c
		};
		c += 1;
		if(c > cols){r += 1; c = 0;}
		if(rows > 0 && r > rows){ throw "Gridder too large, too many rows! (max " + rows + ")";}
		return pos;
	};
};
