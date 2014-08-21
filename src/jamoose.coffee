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

class Mailer
  constructor: (options) ->
    # return grunt task if called w/ grunt
    if options.hasOwnProperty 'registerMultiTask'
      return require('./grunt-jamoose')(options)

    for prop in ['tplPath', 'fromEmail']
      unless options.hasOwnProperty prop
        throw new Error "must have property '#{prop}' in constructor options"

    {@tplPath, @fromName, @fromEmail, @bcc} = options

  getHtml: (tplName, data, cb) ->
    filename = path.resolve @tplPath + '/' + tplName + '.html'
    fs.readFile filename, 'utf8', (err, contents) ->
      if err
        cb err
      else
        try
          template = hogan.compile contents
        catch err
          return cb err
        cb null, template.render(data)

  send: (to, subject, tplName, tplData, cb) ->
    @getHtml tplName, tplData, (err, html) =>
      if err
        cb err
      else
        msg =
          to: to
          subject: subject
          html: html

        switch
          when process.env.NODE_ENV is 'development'
            tmp = require 'tmp'

            tmp.file { keep: true, postfix: '.html' }, (err, path, fd) ->
              return cb err if err

              fs.writeFile path, html, (err) ->
                if err
                  cb err
                else
                  console.log '[jamoose] wrote email to file: ' + path
                  cb null

          when process.env.SENDGRID_USER # sendgrid
            msg.bcc = [ @bcc ] if @bcc
            msg.from = @fromEmail
            msg.fromname = if @fromName then @fromName else @fromEmail

            sg = require('sendgrid')(process.env.SENDGRID_USER, process.env.SENDGRID_KEY)
            email = new sg.Email msg
            sg.send email, cb

          when process.env.MANDRILL # mandrill
            msg.to = [ email: to ]
            msg.bcc_address = @bcc if @bcc
            msg.from_email = @fromEmail
            msg.from_name = if @fromName then @fromName else @fromEmail
            msg.track_opens = true
            msg.track_clicks = true
            msg.auto_text = true

            mandrill = require 'mandrill-api/mandrill'
            mandrillClient = new mandrill.Mandrill process.env.MANDRILL
            mandrillClient.send
              message: msg
            , (result) -> cb null, result
            , cb

          else cb null

module.exports = Mailer
