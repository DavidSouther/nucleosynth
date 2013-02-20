define "canvas", ->
	/*
		Get a new SVG canvas, with margins and scales. Defaults:

		{
			size: # Size of SVG. Returned size will be smaller by the size of the margins.
				width: 960
				height: 500
			margin: # Margins for the graphic.
				top: 20
				right: 20
				bottom: 30
				left: 40
			scale: # d3.scales to scale against the canvas
				x: linear
				y: linear
			svg: SVG_Element # SVG root
			defs: SVG_Defs_Element # <defs> to attach gradient and filter definitions to.
		}
	*/
	(root = \body, options = {})->
		# Ensure options are lookupable
		options
			..{}size
			..{}margin
			..{}scale

		# Parameters
		margin =
			top: options.margin.top || 20
			right: options.margin.top || 20
			bottom: options.margin.top || 30
			left: options.margin.top || 40

		width = (options.size.width || 960) - (margin.left + margin.right)
		height = (options.size.height || 500) - (margin.top + margin.bottom)

		svg = d3.select root
			.attr do
				\width : width + margin.left + margin.right
				\height : height + margin.top + margin.bottom

		canvas =
			scale:
				x: d3.scale[options.scale.x || 'linear']!range [0, width]
				y: d3.scale[options.scale.y || 'linear']!range [0, height]
			size:
				width: width
				height: height
			margin: margin
			svg: svg
			defs: svg.select \defs
