define "atom", ->

	elements = 
		by:
			symbol:
				H:  {name: 'Hydrogen', number: 1}
				He: {name: 'Helium', number: 2}
				Li: {name: 'Lithium', number: 3}
				Be: {name: 'Beryllium', number: 4}
				B:  {name: 'Boron', number: 5}
				C:  {name: 'Carbon', number: 6}
				N:  {name: 'Nitrogen', number: 7}
				O:  {name: 'Oxygen', number: 8}
				F:  {name: 'Fluorine', number: 9}
				Ne: {name: 'Neon', number: 10}
				Na: {name: 'Sodium', number: 11}
				Mg: {name: 'Magnesium', number: 12}
				Al: {name: 'Aluminum', number: 13}
				Si: {name: 'Silicon', number: 14}
				P:  {name: 'Phosphorus', number: 15}
				S:  {name: 'Sulfur', number: 16}
				Cl: {name: 'Chlorine', number: 17}
				Ar: {name: 'Argon', number: 18}
				K:  {name: 'Potassium', number: 19}
				Ca: {name: 'Calcium', number: 20}
				Sc: {name: 'Scandium', number: 21}
				Ti: {name: 'Titanium', number: 22}
				V:  {name: 'Vanadium', number: 23}
				Cr: {name: 'Chromium', number: 24}
				Mn: {name: 'Manganese', number: 25}
				Fe: {name: 'Iron', number: 26}
				Co: {name: 'Cobalt', number: 27}
				Ni: {name: 'Nickel', number: 28}
				Cu: {name: 'Copper', number: 29}
				Zn: {name: 'Zinc', number: 30}
				Ga: {name: 'Gallium', number: 31}
				Ge: {name: 'Germanium', number: 32}
				As: {name: 'Arsenic', number: 33}
				Se: {name: 'Selenium', number: 34}
				Br: {name: 'Bromine', number: 35}
				Kr: {name: 'Krypton', number: 36}
				Rb: {name: 'Rubidium', number: 37}
				Sr: {name: 'Strontium', number: 38}
				Y:  {name: 'Yttrium', number: 39}
				Zr: {name: 'Zirconium', number: 40}
				Nb: {name: 'Niobium', number: 41}
				Mo: {name: 'Molybdenum', number: 42}
				Tc: {name: 'Technetium', number: 43}
				Ru: {name: 'Ruthenium', number: 44}
				Rh: {name: 'Rhodium', number: 45}
				Pd: {name: 'Palladium', number: 46}
				Ag: {name: 'Silver', number: 47}
				Cd: {name: 'Cadmium', number: 48}
				In: {name: 'Indium', number: 49}
				Sn: {name: 'Tin', number: 50}
				Sb: {name: 'Antimony', number: 51}
				Te: {name: 'Tellurium', number: 52}
				I:  {name: 'Iodine', number: 53}
				Xe: {name: 'Xenon', number: 54}
				Cs: {name: 'Cesium', number: 55}
				Ba: {name: 'Barium', number: 56}
				La: {name: 'Lanthanum', number: 57}
				Ce: {name: 'Cerium', number: 58}
				Pr: {name: 'Praseodymium', number: 59}
				Nd: {name: 'Neodymium', number: 60}
				Pm: {name: 'Promethium', number: 61}
				Sm: {name: 'Samarium', number: 62}
				Eu: {name: 'Europium', number: 63}
				Gd: {name: 'Gadolinium', number: 64}
				Tb: {name: 'Terbium', number: 65}
				Dy: {name: 'Dysprosium', number: 66}
				Ho: {name: 'Holmium', number: 67}
				Er: {name: 'Erbium', number: 68}
				Tm: {name: 'Thulium', number: 69}
				Yb: {name: 'Ytterbium', number: 70}
				Lu: {name: 'Lutetium', number: 71}
				Hf: {name: 'Hafnium', number: 72}
				Ta: {name: 'Tantalum', number: 73}
				W:  {name: 'Tungsten', number: 74}
				Re: {name: 'Rhenium', number: 75}
				Os: {name: 'Osmium', number: 76}
				Ir: {name: 'Iridium', number: 77}
				Pt: {name: 'Platinum', number: 78}
				Au: {name: 'Gold', number: 79}
				Hg: {name: 'Mercury', number: 80}
				Tl: {name: 'Thallium', number: 81}
				Pb: {name: 'Lead', number: 82}
				Bi: {name: 'Bismuth', number: 83}
				Po: {name: 'Polonium', number: 84}
				At: {name: 'Astatine', number: 85}
				Rn: {name: 'Radon', number: 86}
				Fr: {name: 'Francium', number: 87}
				Ra: {name: 'Radium', number: 88}
				Ac: {name: 'Actinium', number: 89}
				Th: {name: 'Thorium', number: 90}
				Pa: {name: 'Protactinium', number: 91}
				U:  {name: 'Uranium', number: 92}
				Np: {name: 'Neptunium', number: 93}
				Pu: {name: 'Plutonium', number: 94}
				Am: {name: 'Americium', number: 95}
				Cm: {name: 'Curium', number: 96}
				Bk: {name: 'Berkelium', number: 97}
				Cf: {name: 'Californium', number: 98}
				Es: {name: 'Einsteinium', number: 99}
				Fm: {name: 'Fermium', number: 100}
				Md: {name: 'Mendelevium', number: 101}
				No: {name: 'Nobelium', number: 102}
				Lr: {name: 'Lawrencium', number: 103}
				Rf: {name: 'Rutherfordium', number: 104}
				Db: {name: 'Dubnium', number: 105}
				Sg: {name: 'Seaborgium', number: 106}
				Bh: {name: 'Bohrium', number: 107}
				Hs: {name: 'Hassium', number: 108}
				Mt: {name: 'Meitnerium', number: 109}
				Ds: {name: 'Darmstadtium', number: 110}
				Rg: {name: 'Roentgenium', number: 111}
				Cn: {name: 'Copernicium', number: 112}
				Uut: {name: 'Ununtrium', number: 113}
				Fl: {name: 'Flerovium', number: 114}
				Uup: {name: 'Ununpentium', number: 115}
				Lv: {name: 'Livermorium', number: 116}
				Uus: {name: 'Ununseptium', number: 117}
				Uuo: {name: 'Ununoctium', number: 118}
			number:
				<[ reserved H He Li Be B C N O F Ne Na Mg Al Si P S Cl Ar K Ca Sc Ti V Cr Mn Fe Co Ni Cu Zn Ga Ge As Se Br Kr Rb Sr Y Zr Nb Mo Tc Ru Rh Pd Ag Cd In Sn Sb Te I Xe Cs Ba La Ce Pr Nd Pm Sm Eu Gd Tb Dy Ho Er Tm Yb Lu Hf Ta W Re Os Ir Pt Au Hg Tl Pb Bi Po At Rn Fr Ra Ac Th Pa U Np Pu Am Cm Bk Cf Es Fm Md No Lr Rf Db Sg Bh Hs Mt Ds Rg Cn Uut Fl Uup Lv Uus Uuo]>

		period: (protons)->
			if protons < 3 then return 1
			if protons < 11 then return 2
			if protons < 19 then return 3
			if protons < 37 then return 4
			if protons < 55 then return 5
			if protons < 87 then return 6
			return 7

	class Atom
		(@canvas)->
		draw: (iso, here)->
			regex = //([0-9]*)([A-Z][a-z]*)//
			parts = regex.exec iso
			atom = elements.by.symbol[parts.2]
			isotope = if +parts.1 then (parts.1 - atom.number) else atom.number
			protons = d3.range atom.number .map -> {color: "red"}
			neutrons = d3.range isotope .map -> {color: "silver"}
			period = elements.period protons.length
			scale = 1 / period
			g = @canvas.svg.append \g
				.attr \transform, "translate(#{here.x}, #{here.y}) scale(#{scale})"

			nodes = protons ++ neutrons
			d3.shuffle nodes
			d3.layout.spiral nodes, {spins: 1.5 * period, exponent: 1/3}
			nodes = nodes.reverse!

			g.selectAll \circle
				.data nodes
				.enter!append \svg:circle
				.attr "r", -> 10
				.attr "cx", -> it.px
				.attr "cy", -> it.py
				.style "fill", -> it.color
				.style "stroke", -> "black"
				.style "stroke-width", -> "1"
				.style "z-index", (d, i)-> 0 - i

		list: -> elements.by.number