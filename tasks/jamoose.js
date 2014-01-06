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
        jobs = 0;

    // Merge task-specific and/or target-specific options with these defaults.
    var options = this.options({
      jade: {},
      juice: {
        url: 'file://' + process.cwd() + '/'
      }
    });

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
          var html, jadeOptions;

          // Compile jade to HTML
          jadeOptions = _.assign(options.jade, { filename: filepath });
          html = jade.renderFile(filepath, jadeOptions);

          // Inline CSS to HTML
          juice.juiceContent(html, options.juice, function (err, inlinedHtml) {
            if (err) {
              grunt.log.warn('Juice failed to inline ' + filepath + '.');
              grunt.log.error(err);
              done(err);
            }

            // Write the destination file.
            grunt.file.write(f.dest, inlinedHtml);

            // Print a success message.
            grunt.log.writeln('File "' + f.dest + '" created.');

            if (--jobs === 0) { done(); }
          });
        } catch (err) {
          grunt.log.warn('Jade failed to compile ' + filepath + '.');
          grunt.log.error(err);
          done(err);
        }
      });
    });
  });
};