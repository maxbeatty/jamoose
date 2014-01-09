/*
 * jamoose
 * https://github.com/maxbeatty/jamoose
 *
 * Copyright (c) 2014 Max Beatty
 * Licensed under the MIT license.
 */

'use strict';

var fs = require('fs'),
    path = require('path'),

    // templateCompilers
    hogan = require('hogan.js'),

    // service providers
    sendgrid = require('sendgrid')(process.env.SENDGRID_USER, process.env.SENDGRID_KEY);

module.exports = (function() {
  function Mailer(options) {
    this.options = options;
    // tplPath is path relative to this file
  }

  Mailer.prototype.createEmail = function (params) {
    var Email = sendgrid.Email;
    return new Email(params);
  };

  Mailer.prototype.getHtml = function (tplName, data, cb) {
    var filename = path.resolve(__dirname + this.options.tplPath + tplName + '.html');
    fs.readFile(filename, 'utf8', function (err, contents) {
      if (err) {
        cb(err);
      } else {
        var template = hogan.compile(contents);
        cb(null, template.render(data));
      }

    });
  };

  Mailer.prototype.send = function(to, subject, tplName, tplData, cb) {
    var email = this.createEmail({
      to: to,
      subject: subject
    });

    this.getHtml(tplName, tplData, function(err, html) {
      if (err) {
        cb(err);
      } else {
        email.setHtml(html);

        sendgrid.send(email, cb);

        // TODO: queuing, retry
      }
    });
  };

  return Mailer;
})();