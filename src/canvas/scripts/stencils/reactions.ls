define <[ stencils/atom stencils/stencil ]>, (Atom, Stencil)->
	reaction-options = {}
	isNumeric = ->!isNaN(parseFloat it) && isFinite it

	clusterLayout = !->
		@energy.children = [@agents, @products]

		cluster = d3.layout.cluster!size [360, 25]

		@nodes = cluster.nodes @energy
		@links = cluster.links @nodes

	class Reaction
		(str)->
			@reaction = str.replace /[\s+]/g, '_'
			reaction = str.split \>
			@agents = {children: [{symbol: symbol} for symbol in reaction.0.trim!split ' ']}
			@products = {children: [{symbol: symbol} for symbol in reaction.1.trim!split ' ']}
			@energy = {mev: 0, x: 0, y: 0}

			p = @products.children # Only for the next 3 lines.
			if isNumeric +(p[p.length - 1].symbol)
				@energy.mev = +(p[p.length - 1].symbol)
				p.length --

			@_layout!
			for link in @links
				link.mev = @energy.mev

		_layout: clusterLayout

	color = do
		scale = d3.scale.linear!
			.domain [-0.93, 14.06]
			.range [0, 80]
		(mev)->
			hue = scale mev
			col = d3.hsl hue, 1, 0.5
			col

	Reactions = (canvas)->
		atomizer = Atom canvas
		diagonal = d3.svg.diagonal.radial!
			.projection -> [it.y, it.x / 180 * Math.PI]

		React = !(selection)->
			selection.enter!append \svg:g

			selection
				.attr do
					\class : \reactant
					\transform : ->"rotate(#{it.x - 90}) translate(#{it.y})"
				.selectAll \.atom
				.data (d)->[{d.symbol}]
				.call atomizer

		Reacts = !(selection)->
			selection.enter!append \svg:g

			selection.selectAll \.link
				.data -> it.links
				.enter!append \svg:path
				.attr do
					\class : \link
					\d : diagonal
				.style do
					\stroke : -> color it.mev

			selection
				.attr do
					\transform : "rotate(180)"
				.selectAll \.reactant
				.data -> it.agents.children ++ it.products.children
				.call React

		Chains = !(selection)->
			selection.enter!append \svg:g

			# Convert affinity to x,y position.

			selection
				.attr do
					\class : ->"chain #{it.chain}"
					\transform : ->"translate(#{canvas.scale.x it.action.affinity.0}, #{canvas.scale.y it.action.affinity.1})"
				.selectAll \.reaction
				.data ->it.action.reactions
				.call Reacts

		(layer = @canvas.svg)->
			d3.json "assets/reactions.json", !(errors, chains)->
				chains = for chain, action of chains
					action.reactions = [new Reaction reaction for reaction in action.reactions]
					# Calculate affinity?
					{'chain': chain, 'action': action}

				layer.attr \class, 'reactions'
					.selectAll \.chain
					.data chains
					.call Chains