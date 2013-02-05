require <[ spectroscope starmap ]>, (spectral, starmap)->
	# Parameters
	margin =
		top: 20
		right: 20
		bottom: 30
		left: 40

	width = 960 - (margin.left + margin.right)
	height = 500 - (margin.top + margin.bottom)

	hr =
		scale:
			x: d3.scale.log!range [0, width]
			y: d3.scale.linear!range [0, height]
		svg: d3.select \#chart .append \svg
			.attr \width, width + margin.left + margin.right
			.attr \height, height + margin.top + margin.bottom
			.style \background, "url('assets/dfb.png') black"
		margin: margin

	starmap hr

	defs = hr.svg.append \svg:defs
	grads = defs.selectAll \radialGradient
		.data spectral.spectro
		.enter!append \svg:radialGradient
		.attr \id, ->"\#class#{it.class}"
		.attr \cx, +0.5
		.attr \cy, +0.5
		.attr \r, +1
	grads.append \stop
		.attr \stop-color, ->it.color
		.attr \offset, '0%'
	grads.append \stop
		.attr \stop-color, ->it.color.darker!
		.attr \offset, '100%'