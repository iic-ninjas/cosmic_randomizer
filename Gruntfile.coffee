module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")

    clean: ['./temp', './public/js/', './public/css/']

    copy:
      main:
        files: [
          {expand: true, cwd: 'vendor/js/', src: ['**'], dest: 'public/js/'}
          {expand: true, cwd: 'vendor/css/', src: ['**'], dest: 'public/css/'}
          {expand: true, cwd: 'tmp/js/', src: ['**'], dest: 'public/js/'}
        ]


    coffee:
      compile:
        files: [{
          expand: true,
          cwd: './app/js'
          src: ['**/*.coffee']
          dest: 'tmp/js'
          ext: '.js'
        }]

    sass:
      dist:
        files:
          'public/css/application.css' : 'app/css/application.css.scss'

    watch:
      scripts:
        files: ['app/**/*']
        tasks: ['build']
        options:
          debounceDelay: 250

    grunt.loadNpmTasks "grunt-contrib-jshint"
    grunt.loadNpmTasks "grunt-contrib-uglify"
    grunt.loadNpmTasks "grunt-contrib-watch"
    grunt.loadNpmTasks "grunt-contrib-clean"
    grunt.loadNpmTasks "grunt-contrib-coffee"
    grunt.loadNpmTasks "grunt-contrib-sass"
    grunt.loadNpmTasks "grunt-develop"
    grunt.loadNpmTasks "grunt-contrib-copy"

    grunt.registerTask "build", ['clean', 'sass', 'coffee', 'copy']
    grunt.registerTask "default", ['build', 'watch']