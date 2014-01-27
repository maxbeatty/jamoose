###*
 * jamoose
 * https://github.com/maxbeatty/jamoose
 *
 * Copyright (c) 2014 Max Beatty
 * Licensed under the MIT license.
###

fs = require 'fs'
path = require 'path'

# templateCompilers
hogan = require 'hogan.js'

# service providers
sg = require('sendgrid')(process.env.SENDGRID_USER, process.env.SENDGRID_KEY)

class Mailer
  constructor: (@options) ->
    # return grunt task if called w/ grunt
    if options.hasOwnProperty 'registerMultiTask'
      return require('./grunt-jamoose')(options)

    unless @options.hasOwnProperty 'tplPath'
      throw new Error 'must pass "tplPath" in constructor options'

  createEmail: (params) ->
    Email = sg.Email

    new Email params

  getHtml: (tplName, data, cb) ->
    filename = path.resolve @options.tplPath + '/' + tplName + '.html'
    fs.readFile filename, 'utf8', (err, contents) ->
      if err
        cb err
      else
        template = hogan.compile contents
        cb null, template.render(data)

  send: (to, subject, tplName, tplData, cb) ->
    email = @createEmail
      to: to
      subject: subject

    @getHtml tplName, tplData, (err, html) ->
      if err
        cb err
      else
        email.setHtml html

        sg.send email, cb

        # TODO: queuing, retry

module.exports = Mailer
