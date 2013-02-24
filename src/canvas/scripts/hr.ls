require <[ canvas stencils/starmap stencils/reactions stencils/atom ]>, !(canvas, Starmap, Reaction, Atom)->
	canvas = canvas \#chart, {scale: x: 'log'}

	# Reverse the temperature axis for historical reasons.
	# scales taken from hr.cvs
	canvas.scale.x.domain [100000, 1000] .nice!
	canvas.scale.y.domain [-8, 7] .nice!

	canvas.svg = canvas.svg.append \svg:g
		.attr \style, 'filter:url(#oil);'

	canvas.svg
		.append \svg:image
		.attr do
			\xlink:href : "assets/dfb.png"
			\width : canvas.size.width + canvas.margin.leftright
			\height : canvas.size.height + canvas.margin.topbottom
			\x : 0
			\y : 0

	(Starmap canvas) canvas.svg.append \svg:g

	(Reaction canvas) canvas.svg.append \svg:g