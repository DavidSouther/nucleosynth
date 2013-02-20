define ->
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
			circle = circles.enter!append \svg:g
				.attr \class, ->it.color
			backgrounds = list circle
				.style do
					\stroke : -> "black"
					\stroke-width : -> "1"
				.attr \fill, -> params.colors[it.color]

			highlights = list circle
				.attr \fill, -> "url(\##{it.color})"