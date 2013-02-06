define "canvas", ->
	(root = \body)->
		# Parameters
		margin =
			top: 20
			right: 20
			bottom: 30
			left: 40

		width = 960 - (margin.left + margin.right)
		height = 500 - (margin.top + margin.bottom)

		svg = d3.select root .append \svg
			.attr \width, width + margin.left + margin.right
			.attr \height, height + margin.top + margin.bottom

		canvas =
			scale:
				x: d3.scale.log!range [0, width]
				y: d3.scale.linear!range [0, height]
			size:
				width: width
				height: height
			margin: margin
			svg: svg
			defs: svg.append \svg:defs