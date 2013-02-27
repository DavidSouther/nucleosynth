define <[ stencils/atom stencils/stencil ]>, (Atom, Stencil)->
	reaction-options = {}
	isNumeric = ->!isNaN(parseFloat it) && isFinite it


	forceLayout = !->
		nodes = [@energy]
		@links = []

		for agent in @agents
			nodes.push agent
			@links.push do
				source: agent
				target: @energy

		for product in @products
			nodes.push product
			@links.push do
				source: @energy
				target: product

		force = d3.layout.force!
			.size [100, 75]
			.nodes nodes
			.links @links
			.linkDistance 5
			.charge -10

		force.start!
		for a in [0 to 1]
			force.tick!
		force.stop!

	clusterLayout = !->
		@energy.children = [@agents, @products]

		cluster = d3.layout.cluster!
			.size [100, 75]

		nodes = cluster.nodes @energy
		@links = cluster.links nodes

	class Reaction
		(str)->
			@reaction = str.replace /[\s+]/g, '_'
			reaction = str.split \>
			@agents = {children: [{symbol: symbol} for symbol in reaction.0.trim!split ' ']}
			@products = {children: [{symbol: symbol} for symbol in reaction.1.trim!split ' ']}
			@energy = {mev: 0}

			p = @products.children # Only for the next 3 lines.
			if isNumeric +(p[p.length - 1].symbol)
				@energy.mev = +(p[p.length - 1].symbol)
				p.length --

			@_layout!

		_layout: clusterLayout

	Reactions = (canvas)->
		atomizer = Atom canvas
		diagonal = d3.svg.diagonal!
			.projection -> [it.x, it.y]

		Reacts = !(selection)->
			selection.enter!append \svg:g

			selection.selectAll \.link
				.data -> it.links
				.enter!append \svg:path
				.attr do
					\class : \link
					\d : diagonal

			selection
				.selectAll \.agents
				.data -> it.agents.children
				.call atomizer

			selection
				.selectAll \.products
				.data -> it.products.children
				.call atomizer

		Chains = !(selection)->
			selection.enter!append \svg:g
				.attr do
					\class : -> it.reaction

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
					{'chain': chain, 'action': action}

				layer.append \svg:g
					.attr \class, 'reactions'
					.selectAll \.chain
					.data chains
					.call Chains