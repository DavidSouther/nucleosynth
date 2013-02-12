define <[ canvas atom stencil ]>, (canvas, Atom, Stencil)->
	reaction-options = {}
	class Reactions extends Stencil
		(canvas, @options = reaction-options)->
			super canvas

		prepare: !(canvas, defs = super.canvas)->

		draw: (layer = @canvas.svg)->
			d3.json "assets/reactions.json", !(errors, reactions)~>
				reactions = for chain, action of reactions
					{'chain': chain, 'action': action}
				reactions = layer.selectAll \g
					.data reactions
					.enter!append \svg:g
					.each ~> @react it

		react: !(reaction)->
			reaction = @parse reaction.action.reaction

		parse: (reaction)->
			reaction = reaction.split \>
			reaction.agents = reaction.1
			reaction.products = reaction.2
			reaction.agents = reaction.agents.split ' '
			reaction.products = reaction.products.split ' '