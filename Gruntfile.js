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
					'lib/canvas/index.html': ['src/canvas/index.jade'],
					'lib/canvas/star.html': ['src/canvas/star.jade']
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
				files: [{
					expand: true,
					cwd: 'src/canvas/scripts/',
					src: ['**/*.ls'],
					dest: 'lib/canvas/scripts/',
					ext: '.js'
				}],
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
					src: 'vendors/',
					dest: 'lib/canvas/vendors/'
				}
			},
            assets: {
				files: [
					{
						expand: true,
						cwd: 'src/canvas/scripts/',
						src: ['**/*.js'],
						dest: 'lib/canvas/scripts/'
					},
					{
						expand: true,
						cwd: 'src/canvas/assets/',
						src: ['**/*'],
						dest: 'lib/canvas/assets/'
					}
				]
			}
		},
		server: {
			base: "lib/canvas",
			port: 3000
		},
		watch: {
			canvas: {
				files: [
					'src/canvas/**/*'
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
