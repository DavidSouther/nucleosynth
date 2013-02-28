define <[ data/spectroscope ]>, (spectral)->
	# Look up the spectral class of a star.
	spectrate = (star)->"class#{spectral.class +star.temp}"

	# A starmap draws a Herzprung Russel diagram on a layer, using the canvas' scale.
	# It is therefore recommended the canvas use linear Y and log X scales.
	# Data should be in a CSV file in assets/hr.csv with header line
	# name,mag,temp
	Starmap = do
		# Add the named gradients for the different spectral classes.
		prepare = !(canvas)->
			defs = canvas.defs
			grads = defs.selectAll \radialGradient
				.data spectral.spectro
				.enter!

			linear = grads.append \svg:linearGradient
				.attr do
					\id : ->"linear_#{spectrate it}"
			linear.append \stop
				.attr do
					\stop-color : ->it.color.brighter!
					\offset : '0%'
			linear.append \stop
				.attr do
					\stop-color : ->it.color
					\offset : '100%'

			radial = grads.append \svg:radialGradient
				.attr do
					\id : ->"radial_#{spectrate it}"
					\xlink:href : ->"\#linear_#{spectrate it}"
					\cx : "-1"
					\cy : "-1"
					\fx : "-1"
					\fy : "-1"
					\r : "25"
					\gradientTransform : "matrix(1,0,0,1.0658729,0,-33.938973)"
					\gradientUnits : "userSpaceOnUse"

			filter = grads.append \svg:filter
				.attr do
					\id : -> "stellar_#{spectrate it}"

			filter.append \svg:feTurbulence 
				.attr do
					\numOctaves : "6"
					\baseFrequency : "0.6"
					\type : "fractalNoise"
					\seed : ->Math.floor 100 * Math.random!
					\in : "SourceGraphic"
			filter.append \svg:feColorMatrix 
				.attr do
					\result : "result0"
					\values : "1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 3 -1 "
			filter.append \svg:feFlood 
				.attr do
					"flood-opacity" : "0.25"
					"flood-color" : -> it.color.darker!darker!
					\result : "result1"
			filter.append \svg:feBlend 
				.attr do
					\in2 : "FillPaint"
					\mode : "normal"
					\in : "result1"
					\result : "result2"
			filter.append \svg:feComposite 
				.attr do
					\in2 : "result0"
					\operator : "out"
					\result : "result3"
			filter.append \svg:feComposite 
				.attr do
					\in2 : "SourceGraphic"
					\operator : "atop"

		# Get a Starmap to draw on a certain canvas.
		(canvas)->
			prepare canvas

			# Reusable Star drawer
			star = !(selection)->
				stars = selection.enter!
					.append \svg:g
					.attr do
						\transform : ->"translate(#{canvas.scale.x +it.temp} #{canvas.scale.y +it.mag})"
						\style : ->"fill:url(\#radial_#{spectrate it})"

				circles = stars.append \svg:circle
					.attr do
						"class": "star"
						"r": 20
					.style do
						"opacity": 0.9
						"filter": -> "url(\#stellar_#{spectrate it})"

				selection.exit!
					.remove!

			# Possibly override the layer to draw on. Useful for grouping.
			!(layer)->
				d3.csv "assets/hr.csv", !(error, stars)~>
					# Update the layer
					layer
						.attr \id, "herzrus"
						.attr \transform, "translate(#{canvas.margin.left}, #{canvas.margin.top})"
						# Draw star mag/temp data.
						.selectAll \.star
						.data stars
						.call star
