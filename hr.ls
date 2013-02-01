ddd = d3

# Parameters
margin =
	top: 20
	right: 20
	bottom: 30
	left: 40

width = 960 - (margin.left + margin.right)
height = 500 - (margin.top + margin.bottom)

x = ddd.scale.log!range [0, width]
y = ddd.scale.linear!range [0, height]

axes =
	x: ddd.svg.axis!scale x .orient "bottom"
	y: ddd.svg.axis!scale y .orient "left"

svg = ddd.select \#chart .append \svg
	.attr \width, width + margin.left + margin.right
	.attr \height, height + margin.top + margin.bottom
	.style \background, "url('dfb.png') black"
defs = svg.append \svg:defs

ddd.csv "hr.csv", !(error, stars)->
	stars.forEach !->
		it.mag = +it.mag
		it.temp = +it.temp

	# Reverse the temp axis for historical reasons.
	domain = (ddd.extent stars, (->it.temp)).reverse!
	x.domain domain .nice!
	y.domain ddd.extent stars, (->it.mag) .nice!

	# labels data

	herzrus = svg.append \svg:g
		.attr \id, "herzrus"
		.attr \transform, "translate(#{margin.left}, #{margin.right})"

	herzrus.selectAll \circle
		.data stars
		.enter!
		.append \circle
		.attr \r, 20
		.attr \cx, ->x it.temp
		.attr \cy, ->y it.mag
		.style \fill, ->spectroscope it.temp
		.style \opacity, 0.9

# Prepare spectroscope for spectrography!
classes = <[ L M K G F A B O ]>
temps = [2000, 3700, 5200, 6000, 7500, 10000, 33000, 999999]
colors = <[ #d20033 #ffbd6f #ffddb4 #fff4e8 #fbf8ff #cad8ff #aabfff #9db4ff]>
spectro = _.zip classes, temps, _(colors).map (->ddd.rgb it)
spectro = _(spectro).map (->class: it[0], temp: it[1], color: it[2])

function spectroscope k
	for spec in spectro
		if k < spec.temp
			return spec.color

function spectroclass k
	for spec in spectro
		if k < spec.temp
			return spec.class

grads = defs.selectAll \radialGradient
	.data spectro
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

## Helpers

# Create labels
function labels data
	svg.append \g
		.attr \class, 'x axis'
		.attr \transform, "translate(0, #{height})"
		.style \stroke, \#fff
		.call axes.x
		.append \text
		.attr \class, 'label'
		.attr \x, width
		.attr \y, -6
		.style 'text-anchor', 'end'
		.text "Star Temperature"

	svg.append \g
		.attr \class, 'y axis'
		.style \stroke, \#fff
		.call axes.y
		.append \text
		.attr \class, 'label'
		.attr \transform, 'rotate(-90)'
		.attr \y, 6
		.attr \dy, ".71em"
		.style 'text-anchor', 'end'
		.text "Absolute Magnitude"