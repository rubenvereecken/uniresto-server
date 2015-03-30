module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

  # cleans the whole build
    clean:
      build: ['public']

  # copies all file into build that do not need preprocessing
    copy:
      assets:
        files: [
          expand: true
          cwd: 'app/assets'
          src: '**.*'
          dest: 'public/'
        ]

    grunt.registerTask 'client', ['clean', 'copy']
    grunt.loadNpmTasks lib for lib in gruntLibs




gruntLibs = [
  'grunt-contrib-copy'
  'grunt-contrib-clean'
  'grunt-contrib-watch'
  #'grunt-contrib-concat'
  'grunt-browserify'
]
