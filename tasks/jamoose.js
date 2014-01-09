/*
 * jamoose
 * https://github.com/maxbeatty/jamoose
 *
 * Copyright (c) 2014 Max Beatty
 * Licensed under the MIT license.
 */

'use strict';

var _ = require('lodash'),
    jade = require('jade'),
    juice = require('juice');

module.exports = function(grunt) {

  grunt.registerMultiTask('jamoose', 'Preprocesses HTML Email Templates', function() {
    var done = this.async(),

        // Keep track of when we're actually done done
        jobs = 0,

        // Merge task-specific and/or target-specific options with defaults
        options = this.options({
          templateCompiler: 'jade',
          cssInliner: 'juice',
          jade: {},
          juice: {
            url: 'file://' + process.cwd() + '/'
          }
        }),

        templateCompilers = {
          jade: function(filepath, cb) {
            try {
              cb(
                null,
                jade.renderFile(
                  filepath,
                  _.assign(options.jade, { filename: filepath })
                )
              );
            } catch (err) {
              cb(err);
            }
          }

          // could add others later
        },

        cssInliners = {
          juice: function(html, cb) {
            juice.juiceContent(html, options.juice, cb);
          }

          // could add others later
        },

        JamooseException = function(subject, filepath, err) {
          this.name = 'JamooseException';
          this.subject = subject;
          this.filepath = filepath;
          this.err = err;
        };

    // Iterate over all specified file groups.
    this.files.forEach(function(f) {
      ++jobs;

      f.src.filter(function(filepath) {
        // Warn on and remove invalid source files (if nonull was set).
        if (!grunt.file.exists(filepath)) {
          grunt.log.warn('Source file "' + filepath + '" not found.');
          return false;
        } else {
          return true;
        }
      })
      .forEach(function(filepath) {
        try {
          templateCompilers[options.templateCompiler](filepath, function(err, html) {
            if (err) {
              throw new JamooseException(options.templateCompiler, filepath, err);
            } else {
              cssInliners[options.cssInliner](html, function (err, inlinedHtml) {
                if (err) {
                  throw new JamooseException(options.cssInliner, filepath, err);
                } else {
                  grunt.file.write(f.dest, inlinedHtml);

                  grunt.log.writeln('File "' + f.dest + '" created.');

                  if (--jobs === 0) { done(); }
                }
              });
            }
          });
        } catch (e) {
          if (e.name === 'JamooseException') {
            grunt.log.warn(e.subject + ' failed on ' + e.filepath);
            grunt.log.error(e.err);
            done(e.err);
          } else {
            console.log(e);
            done(e);
          }
        }
      });
    });
  });
};