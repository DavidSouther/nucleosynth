require <[ canvas starmap reactions atom ]>, (canvas, Starmap, Reaction, Atom)->
	canvas = canvas \#chart, {scale: x: 'log'}
	canvas.svg = canvas.svg.append \svg:g
		.attr \style, 'filter:url(#oil);'

	canvas.svg
		.append \svg:image
		.attr do
			\xlink:href : "assets/dfb.png"
			\width : 960
			\height : 500
			\x : 0
			\y : 0

	(new Starmap canvas) canvas.svg.append \svg:g

	elements = [{symbol: sym} for sym in <[ 1H 2H 3H 3He 4He ]> ++ Atom.list![3 to ]]
	grid = d3.layout.grid.element canvas.size
	# Munge the first 3 Hydrogen and the next couple helium
	elements[0 to 4].forEach !->it.scale = 0.7
	elements[0]
		..px = 15
		..py = 15
	elements[1]
		..px = 35
		..py = 15
	elements[2]
		..px = 25
		..py = 35
	elements[3]
		..px = 860
	elements[4]
		..px = 890
	elements = grid elements

	atomizer = Atom canvas

	canvas.svg
		.append \svg:g
		.attr \id, 'atoms'
		.selectAll \.atom
		.data elements
		.call atomizer