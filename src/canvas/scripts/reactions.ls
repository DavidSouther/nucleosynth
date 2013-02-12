define <[ canvas atom stencil ]>, (canvas, Atom, Stencil)->
	reaction-options = {}
	isNumeric = ->!isNaN(parseFloat it) && isFinite it
	class Reactions extends Stencil
		(canvas, @options = reaction-options)->
			super canvas

		prepare: !(canvas, defs = super.canvas)->

		draw: (layer = @canvas.svg)->
			d3.json "assets/reactions.json", !(errors, chains)~>
				chains = for chain, action of chains
					action.reactions = [@parse reaction for reaction in action.reactions]
					{'chain': chain, 'action': action}

				cluster = d3.layout.cluster!
				nodes chains

		parse: (reaction)->
			reaction = reaction.split \>
			reaction = # Coerce to bare object.
				agents: reaction.0.trim!split ' '
				products: reaction.1.trim!split ' '
				energy: 0

			p = reaction.products # Only for the next 3 lines.
			if isNumeric p[p.length - 1]
				reaction.energy = p[p.length - 1]
				p.length --

			reaction