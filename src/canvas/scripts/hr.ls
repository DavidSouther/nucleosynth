require <[ canvas spectroscope starmap atom ]>, (canvas, spectral, starmap, atom)->
	canvas = canvas \#chart
	canvas.svg.style \background, "url('assets/dfb.png') black"

	starmap canvas

	atom = new atom canvas
	elements = atom.list!

	x = 50
	y = 50
	for element in <[ 1H 2H 3H 3He 4He ]> ++ elements.slice 3
		atom.draw element, {x: x, y: y}
		x += 50
		if x > canvas.size.width
			x = 50
			y += 50

	grads = canvas.defs.selectAll \radialGradient
		.data spectral.spectro
		.enter!append \svg:radialGradient
		.attr \id, ->"\#class#{it.class}"
		.attr \cx, +0.5
		.attr \cy, +0.5
		.attr \r, +1
	grads.append \stop
		.attr \stop-color, ->it.color
		.attr \offset, '0%'
	grads.append \stop
		.attr \stop-color, ->it.color.darker!
		.attr \offset, '100%'