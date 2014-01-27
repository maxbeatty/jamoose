module.exports = (grunt) ->

  #Project configuration
  grunt.initConfig
    nodeunit:
      tests: ['test/**/*_test.coffee']

    coffeelint:
      gruntfile:
        files:
          src: 'Gruntfile.coffee'
      src:
        files:
          src: ['src/**/*.coffee']
      test:
        files:
          src: ['test/**/*.coffee']

    watch:
      gruntfile:
        files: 'Gruntfile.coffee'
        tasks: ['coffeelint:gruntfile']
      src:
        files: ['src/**/*.coffee']
        tasks: ['coffeelint:src', 'nodeunit']
      test:
        files: ['test/**/*.coffee']
        tasks: ['coffeelint:test', 'nodeunit']

    coffee:
      options:
        bare: true
      server:
        files: [
          {
            expand: true
            flatten: false
            cwd: 'src'
            src: '**/*.coffee'
            dest: 'lib'
            ext: '.js'
          }
        ]

    # Before generating any new files, remove any previously-created files
    clean:
      tests: ['.tmp']

    # Configuration to be run (and then tested)
    jamoose:
      default_options:
        files: [
          {
            expand: true
            flatten: false
            cwd: 'test/fixtures'
            src: '**\/*.jade'
            dest: '.tmp'
            ext: '.html'
          }
        ]

  # Actually load this plugin's task(s)
  require('./src/jamoose')(grunt)

  # These plugins provide necessary tasks
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-nodeunit'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-clean'

  grunt.registerTask 'test', ['clean', 'jamoose', 'nodeunit']

  grunt.registerTask 'default', ['coffeelint', 'test']
