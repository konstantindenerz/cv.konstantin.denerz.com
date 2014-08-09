module.exports = function(grunt) {

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    watch: {
      content: {
        files: ['templates/**/*.jade'],
        tasks: ['jade']
      },
      scripts: {
        files: ['coffee/**/*.coffee'],
        tasks: ['coffee', 'uglify']
      },
      style: {
        files: ['style/**/*.less'],
        tasks: ['less']
      },
      assets: {
        files: ['assets/**/*'],
        tasks: ['copy']
      },
      options: { livereload: true },
      livereload: {
        // Here we watch the files the sass task will compile to
        // These files are sent to the live reload server after sass compiles to them

        files: ['dest/**/*']

      }
    },
    uglify: {
      my_target: {
        files: {
          'dest/scripts/cv.min.js': ['dest/scripts/cv.js']
        }
      }
    },
    jade: {
      compile: {
        options: {
          data: {
            debug: false,
            rev: "?v=0.0.1."+ new Date().getTime()
          }
        },
        files: {
          "dest/index.html": ["templates/index.jade"],
          "dest/impressum.html": ["templates/impressum.jade"]
        }
      }
    },
    less: {
      development: {
        options: {
          paths: ["assets/css"],
          compress: false,
          cleancss: true,
          modifyVars: {
            rev: "?v=0.0.1."+ new Date().getTime()
          }
        },
        files: {
          "dest/style/core.css": "style/*.less"
        }
      },
      production: {
        options: {
          paths: ["assets/css"],
          compress: true,
          cleancss: true,
          modifyVars: {
            rev: "?v=0.0.1."+ new Date().getTime()
          }
        },
        files: {
          "dest/style/core.css": "style/*.less"
        }
      }
    },
     bower: {
      install: {
        options: {
          targetDir: './dest/lib',
          layout: 'byType',
          install: true,
          verbose: false,
          cleanTargetDir: false,
          cleanBowerDir: false,
          bowerOptions: {
            production: true
          }
        }
      }
    },
    copy: {
      main: {
        files: [
          // includes files within path
          {expand: true, src: ['assets/fonts/**'], dest: 'dest/style'},
          // includes files within path
          {expand: true, src: ['assets/css/**'], dest: 'dest/style'},
          {expand: true, src: ['lib/**'], dest: 'dest/'}
        ]
      }
    },
    coffee: {
      compile: {
        options: {
          join: true
        },
        files: {
          'dest/scripts/cv.js': ['coffee/**/*.coffee']
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-jade');
  grunt.loadNpmTasks('grunt-contrib-less');
  grunt.loadNpmTasks('grunt-bower-task');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-uglify');

  grunt.registerTask('default', ['coffee', 'jade', 'less', 'bower', 'copy', 'uglify']);

};
