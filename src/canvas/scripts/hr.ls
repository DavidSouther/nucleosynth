require <[ canvas stencils/starmap stencils/reactions stencils/atom ]>, !(canvas, Starmap, Reaction, Atom)->
	canvas = canvas \#chart,
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
			\width : canvas.size.width + canvas.margin.leftright
			\height : canvas.size.height + canvas.margin.topbottom
			\x : 0
			\y : 0

	(Starmap canvas) background.append \svg:g

	(Reaction canvas) canvas.svg.append \svg:g