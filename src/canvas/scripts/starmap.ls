define "starmap", <[ spectroscope stencil ]>, (spectral, Stencil)->
	# Look up the spectral class of a star.
	spectrate = (star)->"class#{spectral.class +star.temp}"

	# A starmap draws a Herzprung Russel diagram on a layer, using the canvas' scale.
	# It is therefore recommended the canvas use linear Y and log X scales.
	# Data should be in a CSV file in assets/hr.csv with header line
	# name,mag,temp
	Starmap = do
		# Add the named gradients for the different spectral classes.
		prepare = !(canvas)->
			defs = canvas.svg.select \defs
			grads = defs.selectAll \radialGradient
				.data spectral.spectro
				.enter!append \svg:radialGradient
				.attr do
					\id, ->spectrate it
					\cx, +0.5
					\cy, +0.5
					\r, +1
			grads.append \stop
				.attr \stop-color, ->it.color
				.attr \offset, '0%'
			grads.append \stop
				.attr \stop-color, ->it.color.darker!
				.attr \offset, '100%'

		# Get a Starmap to draw on a certain canvas.
		(canvas)->
			prepare canvas

			# Reusable Star drawer
			star = !(selection)->
				circles = selection
					.enter!
					.append \svg:circle
					.attr do
						"r": 20
						"class": "star"
					.style do
						"opacity": 0.9

				circles
					.attr do
						"cx": ->canvas.scale.x +it.temp
						"cy": ->canvas.scale.y +it.mag
						"fill": -> "url(\##{spectrate it})"

				selection.exit!
					.remove!

			# Possibly override the layer to draw on. Useful for grouping.
			!(layer)->
				d3.csv "assets/hr.csv", !(error, stars)~>
					# Reverse the temperature axis for historical reasons.
					domain = (d3.extent stars, (-> +it.temp)).reverse!
					canvas.scale.x.domain domain .nice!
					canvas.scale.y.domain d3.extent stars, (-> +it.mag) .nice!

					# Update the layer
					layer
						.attr \id, "herzrus"
						.attr \transform, "translate(#{canvas.margin.left}, #{canvas.margin.right})"
						.style \opacity, 0.9
						# Draw star mag/temp data.
						.selectAll \.star
						.data stars
						.call star
