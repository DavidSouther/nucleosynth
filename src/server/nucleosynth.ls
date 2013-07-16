/*
 * nucleosynth
 * https://github.com/southerd/nucleosynth
 *
 * Copyright (c) 2013 David Souther
 * Licensed under the MIT license.
 */

require! { express, nconf }
server = express!

nconf.argv!
	.env!
	.file { file: 'config.json' }
	.defaults { port: 3000 }

# Use index.html for /
server.get '/d3', !(req, res)->
	res.sendfile "lib/canvas/index.html"

# Otherwise, serve requests as static files from lib/canvas/
server.use '/d3/', express.static 'lib/canvas/'

# Use index.html for /
server.get '/three', !(req, res)->
	res.sendfile "lib/three/index.html"

# Otherwise, serve requests as static files from lib/canvas/
server.use '/three/', express.static 'lib/three/'


# Use index.html for /
server.get '/glow', !(req, res)->
	res.sendfile "lib/glow/index.html"

# Otherwise, serve requests as static files from lib/canvas/
server.use '/glow/', express.static 'lib/glow/'

# Start the server.
server.listen nconf.get 'port'
