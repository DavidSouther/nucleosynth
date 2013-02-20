define ->
	Stencil = do
		/*
			Prep the canvas with any common tools needed.
			Generally, call the super method as the first action in the overloaded method then put
			gradients, filters etc in `defs`.
		 */
		prepare = (canvas = @canvas)->
			defs = @canvas.svg.select \defs

		/*
			Constructor takes a reference to a canvas with an SVG element in {svg} to draw atoms on.
			Requires a `canvas`.
		*/
		(@canvas, prepare = prepare)->
			@prepare @canvas

			/*
				Pass specific data for this particular element (eg position in the layer) in the first params,
				and an svg:g or svg:svg element in the last position as the layer to draw on.
			 */
			(data, layer = @canvas.svg)->
				throw "Draw not implemented."