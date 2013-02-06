define "starmap", <[ spectroscope ]>, (spectral)->
	(hr)->
		d3.csv "assets/hr.csv", !(error, stars)->
			stars.forEach !->
				it.mag = +it.mag
				it.temp = +it.temp

			# Reverse the temp axis for historical reasons.
			domain = (d3.extent stars, (->it.temp)).reverse!
			hr.scale.x.domain domain .nice!
			hr.scale.y.domain d3.extent stars, (->it.mag) .nice!

			# labels data

			herzrus = hr.svg.append \svg:g
				.attr \id, "herzrus"
				.attr \transform, "translate(#{hr.margin.left}, #{hr.margin.right})"
				.style \opacity, 0.7

			herzrus.selectAll \circle
				.data stars
				.enter!
				.append \circle
				.attr \r, 20
				.attr \cx, ->hr.scale.x it.temp
				.attr \cy, ->hr.scale.y it.mag
				.style \fill, ->spectral.color it.temp
				.style \opacity, 0.9