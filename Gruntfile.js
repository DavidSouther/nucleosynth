module.exports = function(grunt) {
	'use strict';
	grunt.initConfig({
		pkg: grunt.file.readJSON('package.json'),
		clean: {
			all: ['lib/']
		},
		jade: {
			canvas: {
				files: {
					'lib/canvas/index.html': ['src/canvas/*jade']
				}
			}
		},
		stylus: {
			canvas: {
				files: {
					'lib/canvas/styles/<%= pkg.name %>.css': ['src/canvas/*styl']
				}
			}
		},
		livescript: {
			server: {
				files: {
					'lib/server/<%= pkg.name %>.js': ['src/server/**/*ls']
				}
			},
			canvas: {
				files: {
					'lib/canvas/scripts/*.js': 'src/canvas/**/*.ls',
				},
				options: {
					bare: false
				}
			},
		},
		jshint: {
			all: ['src/canvas/**/*.js']
		},
		copy: {
			vendors: {
				files: {
					'lib/canvas/vendors/': 'vendors'
				}
			},
            assets: {
				files: {
					'lib/canvas/assets/': 'src/canvas/assets/*',
					'lib/canvas/scripts/': 'src/canvas/scripts/*js'
				}
			}
		},
		server: {
			base: "lib/canvas",
			port: 3000
		},
		watch: {
			canvas: {
				files: [
					'src/canvas/**/*jade',
					'src/canvas/**/*ls',
					'src/canvas/**/*styl'
				],
				tasks: ['build-canvas']
			}
		}
	});

	grunt.loadNpmTasks('grunt-contrib');
	grunt.loadNpmTasks('grunt-contrib-jshint');
	grunt.loadNpmTasks('grunt-livescript');

	grunt.registerTask('vendors', 'copy:vendors');
	grunt.registerTask('build-canvas', ['jade:canvas', 'stylus:canvas', 'livescript:canvas', 'copy:assets']);
	grunt.registerTask('build-server', ['livescript:server']);
	grunt.registerTask('build', ['build-server', 'build-canvas']);
	grunt.registerTask('default', ['clean', 'build']);

	// HACK
	// Until grunt-contrib-connect comes.
	var connect = require('connect');
	grunt.registerTask('server', 'Start a custom static web server.', function() {
		grunt.log.writeln('Starting static web server in "lib/canvas" on port 3000.');
		try{
			connect(connect.static('lib/canvas')).listen(3000);
		} catch (e){}
	});
};
