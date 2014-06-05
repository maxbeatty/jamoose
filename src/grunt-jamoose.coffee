###*
 * jamoose
 * https://github.com/maxbeatty/jamoose
 *
 * Copyright (c) 2014 Max Beatty
 * Licensed under the MIT license.
###

step = require 'step'
jade = require 'jade'
juice = require 'juice'

module.exports = (grunt) ->

  grunt.registerMultiTask 'jamoose', 'Preprocesses HTML Email Templates', ->
    done = @async()

    # Merge task-specific and/or target-specific options with defaults
    options = @options
      templateCompiler: 'jade'
      cssInliner: 'juice'
      jade: {}
      juice:
        url: "file://#{process.cwd()}/"

    templateCompilers =
      jade: (filepath, cb) ->
        try
          options.jade.filename = filepath
          cb null, jade.renderFile(filepath, options.jade)
        catch err
          cb err

      # could add others later

    cssInliners =
      juice: (html, cb) ->
        juice.juiceContent html, options.juice, cb

      # could add others later

    JamooseException = (subject, filepath, err) ->
      grunt.log.warn subject + ' failed on ' + filepath
      grunt.log.error err
      done err

    self = @

    step(
      ->
        group = @group()

        # Iterate over all specified file groups.
        self.files.forEach (f) ->
          f.src.forEach (filepath) ->
            # Warn on and remove invalid source files (if nonull was set)
            unless grunt.file.exists filepath
              grunt.log.warn "Source file '#{filepath}' not found."
            else
              cb = group()
              grunt.log.debug 'Processing: ' + filepath

              try
                templateCompilers[options.templateCompiler] filepath, (err, html) ->
                  if err
                    JamooseException options.templateCompiler, filepath, err
                  else
                    grunt.log.debug 'Compiled: ' + filepath

                    cssInliners[options.cssInliner] html, (err, inlinedHtml) ->
                      if err
                        JamooseException options.cssInliner, filepath, err
                      else
                        grunt.log.debug 'Inlined: ' + filepath

                        grunt.file.write f.dest, inlinedHtml

                        grunt.log.writeln "File '#{f.dest}' created."

                        cb()
              catch e
                grunt.log.error e
                done err

        return
      done
    )
