define "starmap", ->
	(hr)->
		ddd.csv "assets/hr.csv", !(error, stars)->
			stars.forEach !->
				it.mag = +it.mag
				it.temp = +it.temp

			# Reverse the temp axis for historical reasons.
			domain = (d3.extent stars, (->it.temp)).reverse!
			hr.x.domain domain .nice!
			ht.y.domain ddd.extent stars, (->it.mag) .nice!

			# labels data

			herzrus = hr.svg.append \svg:g
				.attr \id, "herzrus"
				.attr \transform, "translate(#{margin.left}, #{margin.right})"
				.style \opacity, 0.7

			herzrus.selectAll \circle
				.data stars
				.enter!
				.append \circle
				.attr \r, 20
				.attr \cx, ->x it.temp
				.attr \cy, ->y it.mag
				.style \fill, ->hr.spectral.color it.temp
				.style \opacity, 0.9