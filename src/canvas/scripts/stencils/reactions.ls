define <[ stencils/atom stencils/stencil ]>, (Atom, Stencil)->
	reaction-options = {}
	isNumeric = ->!isNaN(parseFloat it) && isFinite it

	class Reaction
		(str)->
			reaction = str.split \>
			@agents = [{symbol: symbol} for symbol in reaction.0.trim!split ' ']
			@products = [{symbol: symbol} for symbol in reaction.1.trim!split ' ']
			@energy = {mev: 0}

			p = @products # Only for the next 3 lines.
			if isNumeric +(p[p.length - 1].symbol)
				@energy = +(p[p.length - 1].symbol)
				p.length --

			@_layout!

		_layout: !->
			# Put agents in a column on the left
			x = 0
			y = 0
			for agent in @agents
				agent.px = x
				agent.py = y
				x += 25
			# Put products in a column on the right
			x = 0
			y = 50
			for product in @products
				product.px = x
				product.py = y
				x += 25
			# Put the energy in the middle.
			@energy.px = 25
			@energy.py = 25

	Reactions = (canvas)->
		atomizer = Atom canvas

		Reacts = !(selection)->
			selection.enter!append \svg:g

			selection
				.selectAll \.agents
				.data -> it.agents
				.call atomizer

			selection
				.selectAll \.products
				.data -> it.products
				.call atomizer

		Chains = !(selection)->
			selection.enter!append \svg:g

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