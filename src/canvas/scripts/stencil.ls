define ->
	class Stencil
		/*
			Constructor takes a reference to a canvas with an SVG element in {svg} to draw atoms on.
		*/
		(@canvas)->
			@prepare @canvas

		prepare: (canvas = @canvas)->
			defs = @canvas.svg.select \defs
			# Override, call, and put gradients, filters etc in `defs`