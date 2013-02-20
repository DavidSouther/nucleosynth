define "atom", <[ sphere elements ]>, (Sphere, elements)->
	if d3.layout.grid
		tableMap = (atom)->
			atom = Atom.data atom
			pos = {row: atom.period, col: -1}
			switch atom.period
			| 1 =>
				pos.col = if atom.number is 1 then 1 else 18
			| 2 =>
				pos.col = if atom.number < 5 then atom.number - 2 else atom.number + 8
			| 3 =>
				pos.col = if atom.number < 13 then atom.number - 10 else atom.number
			| 4 =>
				pos.col = atom.number - 18
			| 5 =>
				pos.col = atom.number - 36
			| 6 =>
				if 56 < atom.number < 72
					pos.col = atom.number - 54 + 0.25
					pos.row = pos.row + 2.5
				else
					pos.col = if atom.number < 57 then atom.number - 54 else atom.number - 68
			| 7 =>
				if 88 < atom.number < 104
					pos.col = atom.number - 86 + 0.25
					pos.row = pos.row + 2.5
				else
					pos.col = if atom.number < 89 then atom.number - 86 else atom.number - 100

			pos

		d3.layout.grid.element = (layer)->
			options =
				rows: 10
				cols: 18
				map: tableMap
				scales:
					height: d3.scale.linear().domain([1, 10]).range([25, layer.height - 25])
					width: d3.scale.linear().domain([1, 18]).range([25, layer.width - 25])
			d3.layout.grid options

	colors =
		proton: \red
		neutron: \silver

	highlight =
		cx: '40%'
		cy: '60%'
		fx: '25%'
		fy: '35%'
		r: '55%'

	/*
		Class to stencil atoms.
	 */
	atom-defaults =
		highlight: true
		radius: 10
	Atom = do
		/*
			Given the bare description of the atom and a list of proton/neutron objects, return an array of objects
			with an appropriate {cx, cy}.
		 */
		_spiral = (atom, nodes)->
			spiral = d3.layout.spiral {spins: 1.5 * atom.period, exponent: 1/3, func: d3.layout.spiral.archimedes! }
			d3.shuffle nodes
			spiral nodes
			nodes = nodes.reverse!
			nodes

		(canvas, options = atom-defaults)->
			options <<<
				colors: colors
				svg: canvas.svg
			spherate = Sphere do
				options

			/*
				Given an atomic string, draw the element at a given position in a layer, or directly on the stencil's canvas.
			 */
			!(layer)->
				g = layer.enter!append \svg:g
					.datum -> Atom.data it
					.attr do
						class: ->"atom #{it.symbol}"
						transform: ->"translate(#{it.px}, #{it.py}) scale(#{it.scale})"

				circles = g
					.selectAll \circle
					.data -> it.nodes
					.call spherate

	Atom <<<
		list: -> elements.by.number

		/*
			Given a string describing an atom like '125Pb', return a bare object describing that isotope.
			Returned object has {name, number, symbol, isotope, period}
		 */
		parse: (iso)->
			regex = //([0-9]*)([A-Z][a-z]*)//
			parts = regex.exec iso
			atom = elements.by.symbol[parts.2]
			atom.symbol = parts.2
			atom.isotope = if +parts.1 then (parts.1 - atom.number) else atom.number
			atom.period = elements.period atom.number
			atom

		data: (atom)->
			atom <<< Atom.parse atom.symbol
			atom <<<
				protons: d3.range atom.number .map -> { color: \proton }
				neutrons: d3.range atom.isotope .map -> { color: \neutron }
				scale: 1 / atom.period
			atom.nodes = _spiral atom, atom.protons ++ atom.neutrons
			atom
	Atom
