require <[ canvas spectroscope starmap atom ]>, (canvas, spectral, Starmap, atom)->
	canvas = canvas \#chart
	canvas.svg.style \background, "url('assets/dfb.png') black"

	(new Starmap canvas).draw canvas.svg.append \svg:g

	atom = new atom canvas
	elements = atom.list!
	atoms = canvas.svg.append \svg:g
		.attr \id, 'atoms'

	x = 50
	y = 50
	for element in <[ 1H 2H 3H 3He 4He ]> ++ elements[3 to ]
		atom.draw element, {x: x, y: y}, atoms
		x += 50
		if x > canvas.size.width
			x = 50
			y += 50

