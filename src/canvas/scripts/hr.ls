require <[ canvas stencils/starmap stencils/reactions stencils/atom ]>, !(canvas, Starmap, Reaction, Atom)->
	canvas = canvas \#chart,
		size:
			height: 700
			width: 1200
		scale:
			x: 'log'
		domain:
			x: [28000, 2000]
			y: [-8, 17]

	background = canvas.svg.append \svg:g
		.attr \style, 'filter:url(#oil);'

	background
		.append \svg:image
		.attr do
			\xlink:href : "assets/dfb.png"
			\width : (canvas.size.width + canvas.margin.leftright) * 1.1
			\height : (canvas.size.height + canvas.margin.topbottom) * 1.1
			\x : -10
			\y : -10

	(Starmap canvas) canvas.svg.append \svg:g

	(Reaction canvas) canvas.svg.append \svg:g