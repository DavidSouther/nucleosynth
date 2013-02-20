define "atom", <[ sphere elements ]>, (Sphere, elements)->
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
		Function to place highlighted spheres at a position.
		Returned function expects an entered D3 selection whose data has `{px, py, color}`.
		`px` and `py` are the circle centers. `color` is either an object that can be coerced to an SVG color,
		or if `params.highlight` is true a string referencing an ID of a gradient to apply as fill.
	 */

	Sphere = (params)->
		list = (circles)->
			circles.append \svg:circle
				.attr do
					r: ->params.radius
					cx: ->it.px
					cy: ->it.py

		!(circles)->
			circle = circles.append \svg:g
				.attr \class, ->it.color
			backgrounds = list circle
				.style do
					\stroke : -> "black"
					\stroke-width : -> "1"
				.attr \fill, -> colors[it.color]

			highlights = list circle
				.attr \fill, -> "url(\##{it.color})"

	/*
		Class to stencil atoms.
	 */
	atom-defaults =
		highlight: true
		radius: 10
	class Atom extends Stencil
		(canvas, @options = atom-defaults)->
			super canvas

		prepare: !(canvas, defs = super canvas)->
			<[ proton neutron ]>.forEach ~>
				grad = defs.append \svg:radialGradient
					.attr { id: it } <<< highlight
				grad.append \svg:stop
					.attr do
						'offset': 0
						'stop-color': "white"
						'stop-opacity': 0.5
				grad.append \svg:stop
					.attr do
						'offset': 1
						'stop-color': "white"
						'stop-opacity': 0

		/*
			Given a string describing an atom like '125Pb', return a bare object describing that isotope.
			Returned object has {name, number, symbol, isotope, period}
		 */
		_parse: (iso)->
			regex = //([0-9]*)([A-Z][a-z]*)//
			parts = regex.exec iso
			atom = elements.by.symbol[parts.2]
			atom.symbol = parts.2
			atom.isotope = if +parts.1 then (parts.1 - atom.number) else atom.number
			atom.period = elements.period atom.number
			atom

		/*
			Given the bare description of the atom and a list of proton/neutron objects, return an array of objects
			with an appropriate {cx, cy}.
		 */
		_spiral: (atom, nodes)->
			spiral = d3.layout.spiral {spins: 1.5 * atom.period, exponent: 1/3, func: d3.layout.spiral.archimedes! }
			d3.shuffle nodes
			spiral nodes
			nodes = nodes.reverse!
			nodes

		/*
			Given an atomic string, draw the element at a given position in a layer, or directly on the stencil's canvas.
		 */
		draw: !(iso, center, layer = @canvas.svg)->
			atom = @_parse iso
			protons = d3.range atom.number .map -> { color: \proton }
			neutrons = d3.range atom.isotope .map -> { color: \neutron }
			nodes = @_spiral atom, protons ++ neutrons

			scale = 1 / atom.period
			g = layer.append \g
				.attr do
					class: atom.name
					transform: "translate(#{center.x}, #{center.y}) scale(#{scale})"

			spherate = Sphere do
				@options

			circles = g.selectAll \circle
				.data nodes
				.enter!

			spherate circles

		list: -> elements.by.number
