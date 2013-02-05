/*
 * nucleosynth
 * https://github.com/southerd/nucleosynth
 *
 * Copyright (c) 2013 David Souther
 * Licensed under the MIT license.
 */

# `jefri-server` provides an express server configured to handle jefri
# transactions, so we'll use that first. We also need to do some express things.
require! { express, nconf }
server = express!

nconf.argv!
	.env!
	.file { file: 'config.json' }
	.defaults { port: 3000 }

# Use index.html for /
server.get '/', !(req, res)->
	res.sendfile "lib/canvas/index.html"

# Otherwise, serve requests as static files from lib/canvas/
server.use '/', express.static 'lib/canvas/'

# Start the server.
server.listen nconf.get 'port'
