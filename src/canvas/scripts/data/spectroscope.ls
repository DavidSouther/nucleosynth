define ->
	class Spectroscope
		# Prepare spectroscope for spectrography!
		->
			@classes = <[ L M K G F A B O ]>
			@temps = [2000, 3700, 5200, 6000, 7500, 10000, 33000, 999999]
			@colors = <[ #d20033 #ffbd6f #ffddb4 #fff4e8 #fbf8ff #cad8ff #aabfff #9db4ff]>
			@spectro = d3.zip @classes, @temps, @colors.map (->d3.rgb it)
			@spectro = @spectro.map (->class: it[0], temp: it[1], color: it[2])

		color: (k)->
			for spec in @spectro
				if k < spec.temp
					return spec.color

		class: (k)->
			for spec in @spectro
				if k < spec.temp
					return spec.class

	new Spectroscope!
