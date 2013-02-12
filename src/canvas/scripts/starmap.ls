define "starmap", <[ spectroscope ]>, (spectral)->
	spectrate = (star)->"class#{spectral.class star.temp}"

	(canvas, layer = canvas.svg)->
		grads = canvas.defs.selectAll \radialGradient
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

		d3.csv "assets/hr.csv", !(error, stars)->
			stars.forEach !->
				it.mag = +it.mag
				it.temp = +it.temp

			# Reverse the temp axis for historical reasons.
			domain = (d3.extent stars, (->it.temp)).reverse!
			canvas.scale.x.domain domain .nice!
			canvas.scale.y.domain d3.extent stars, (->it.mag) .nice!

			# labels data

			herzrus = layer
				.attr \id, "herzrus"
				.attr \transform, "translate(#{canvas.margin.left}, #{canvas.margin.right})"
				.style \opacity, 0.7

			herzrus.selectAll \circle
				.data stars
				.enter!.append \circle
				.attr do
					"r": 20
					"cx": ->canvas.scale.x it.temp
					"cy": ->canvas.scale.y it.mag
					"fill": -> "url(\##{spectrate it})"
				.style do
					"opacity": 0.9