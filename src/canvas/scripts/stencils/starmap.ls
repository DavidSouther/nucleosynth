define <[ data/spectroscope ]>, (spectral)->
	# Look up the spectral class of a star.
	spectrate = (star)->"class#{spectral.class +star.temp}"

	# A starmap draws a Herzprung Russel diagram on a layer, using the canvas' scale.
	# It is therefore recommended the canvas use linear Y and log X scales.
	# Data should be in a CSV file in assets/hr.csv with header line
	# name,mag,temp
	Starmap = do
		# Add the named gradients for the different spectral classes.
		Color = (star)->
			spectral.color star

		Grad = (canvas)->
			defs = canvas.defs
			_id=0

			(star)->
				id = "#{spectrate star}_#{_id++}"
				"#{id}"

		Filter = (canvas)->
			defs = canvas.defs
			_id=0

			(star)->
				id = "#{spectrate star}_#{_id++}"
				"stellar_#{id}"

		# Get a Starmap to draw on a certain canvas.
		(canvas)->
			grad = Grad canvas
			filt = Filter canvas

			## Filter randoms
			# Turbulance params
			n = d3.random.normal 8, 0.2
			octaves = -> Math.round n!
			frequency = d3.random.normal 0.6, 0.01
			seed = -> Math.floor 100 * Math.random!

			# Gradient params
			center = d3.random.normal 25, 25
			rad = d3.random.logNormal 0, 0.1
			size = -> ((canvas.size.height - it.y) + it.x) / 3 * rad!

			# Reusable Star drawer
			star = !(selection)->
				stars = selection
					.enter!
					.append \svg:g
					.datum ->
						it <<<
							color: Color it.temp
							filtId: filt it
							gradId: grad it
							x: canvas.scale.x +it.temp
							y: canvas.scale.y +it.mag
							r: size it
					.attr do
						\class : -> "star #{spectrate it}"
						\transform : ->"translate(#{it.x} #{it.y}) scale(.1)"
						\style : ->"fill:url(\#radial_#{it.gradId})"

				circles = stars.append \svg:circle
					.attr do
						"class": "star"
						"r": -> it.r
					.style do
						# "opacity": 0.9
						"filter": -> "url(\##{it.filtId})"
						"stroke": -> it.color.darker!darker!darker!
						"stroke-width": "1px"

				selection.exit!
					.remove!

				filter = stars.append \svg:filter
					.attr do
						\id : -> it.filtId

				filter.append \svg:feTurbulence 
					.attr do
						\numOctaves : Math.round octaves!
						\baseFrequency : frequency!
						\type : "fractalNoise"
						\seed : -> seed!
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

				linear = stars.append \svg:linearGradient
					.attr do
						\id : -> "linear_#{it.gradId}"
				linear.append \stop
					.attr do
						\stop-color : -> it.color.brighter!
						\offset : '0%'
				linear.append \stop
					.attr do
						\stop-color : -> it.color
						\offset : '100%'

				radial = stars.append \svg:radialGradient
					.attr do
						\id : ->"radial_#{it.gradId}"
						\xlink:href : ->"\#linear_#{it.gradId}"
						\cx : -> -center!
						\cy : -> center!
						\fx : -> -center!
						\fy : -> center!
						\r : -> it.r
						\gradientTransform : "matrix(1,0,0,1,0,-34)"
						\gradientUnits : "userSpaceOnUse"

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
