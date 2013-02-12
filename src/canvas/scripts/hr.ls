require <[ canvas spectroscope starmap reactions ]>, (canvas, spectral, Starmap, Reaction)->
	canvas = canvas \#chart
	canvas.svg.style \background, "url('assets/dfb.png') black"

	(new Starmap canvas).draw canvas.svg.append \svg:g

	(new Reaction canvas).draw canvas.svg.append \svg:g

