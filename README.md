# jamoose [![Build Status](https://secure.travis-ci.org/maxbeatty/jamoose.png?branch=master)](http://travis-ci.org/maxbeatty/jamoose) [![Built with Grunt](https://cdn.gruntjs.com/builtwith.png)](http://gruntjs.com/)

> Preprocessing and Sending HTML Emails in Node.js

## Goals

1. Send HTML Emails
2. Use preprocessors like [Jade](http://jade-lang.com/) and [Sass](http://sass-lang.com/) to write them
3. Only care about the template and its data at time of sending

## Getting Started
This plugin requires Grunt `~0.4.2`

If you haven't used [Grunt](http://gruntjs.com/) before, be sure to check out the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains how to create a [Gruntfile](http://gruntjs.com/sample-gruntfile) as well as install and use Grunt plugins. Once you're familiar with that process, you may install this plugin with this command:

```shell
npm install jamoose --save
```

Once the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript:

```js
require('jamoose')(grunt);
```

_If you can figure out how I can use `loadNpmTasks`, please open a pull request_

You can require it in your application like so:

```js
var jamoose = require('jamoose'),
    Mailer = new jamoose({});
```

## The Grunt task

### Overview
In your project's Gruntfile, add a section named `jamoose` to the data object passed into `grunt.initConfig()`.

```js
grunt.initConfig({
  jamoose: {
    options: {
      // Task-specific options go here.
    },
    your_target: {
      // Target-specific file lists and/or options go here.
    },
  },
});
```

### Options

#### options.jade
Type: `Object`
Default value: `{}`

Same as [Jade API options](http://jade-lang.com/api/)

_**NB**: `options.jade.filename` defaults to the current file's path

#### options.juice
Type: `Object`
Default value: `{ url: 'file://' + process.cwd() + '/' }`

Same as [Juice options](https://github.com/LearnBoost/juice#juicefilepath-options-callback)

_**Important**: End your `url` with a trailing slash_

### Usage Example

```js
grunt.initConfig({
  jamoose: {
    default_options: {
      files: [
        {
          expand: true,
          flatten: false,
          cwd: 'test/fixtures',
          src: '**/*.jade',
          dest: 'tmp',
          ext: '.html'
        }
      ]
    }
  }
});
```

## Using in your application

See the [examples](https://github.com/maxbeatty/jamoose/tree/master/examples) for detailed, working code.

1. Create your email template using Jade. Use Jade variables for anything you want replaced at build time (think cross-app vars like domains and dates). Use Mustache variables for anything you want inserted at send time (think user-specific details like name or address)

```jade
//- welcome.jade
html
  head
    link(rel="stylesheet", href="path/to/email.css")
  body
    table
      tr
        td
          h1 Welcome {{name}}

      tr
        td
          a(href=domain + '/privacy') Privacy Policy
```

```sass
// email.sass
h1
  font-size: 30px
  color: #333
```

2. Build your templates with Grunt

```bash
$ grunt sass jamoose
```

You now will have an HTML file with inlined CSS* and Mustache variables still in tact.

* Thanks to [LearnBoost/juice](https://github.com/LearnBoost/juice)

```html
<html>
  <body>
    <table>
      <tr>
        <td>
          <h1 style="font-size:30px;color:#333">Welcome {{name}}</h1>
        </td>
      </tr>
      <tr>
        <td>
          <a href="http://your.domain.from.grunt/privacy">Privacy Policy</a>
        </td>
      </tr>
    </table>
  </body>
</html>
```

3. Send an email in your app

```js
var jamoose = require('jamoose'),
    mailer = new jamoose({
      tplPath: 'path/to/templates/from/grunt/',
      fromEmail: 'sender@edc.ba'
    });

mailer.send(
  'test@abc.de', // to
  'Welcome!', // subject
  'welcome', // template
  { // data
    name: 'John Smith'
  },
  function(err) { // callback
    if (err) { console.log(err); }
  }
);
```

"Welcome John Smith" will be sent to "test@abc.de" from "sender@edc.ba" with the subject "Welcome!"

### Email Providers

Currently supporting:

- [SendGrid](http://sendgrid.com/)
- [Mandrill](https://mandrillapp.com/)

Please submit a pull request to add more service providers.

Set the environment variables for the provider of your choice and it will be used automatically.

#### SendGrid

[SendGrid's node library](https://github.com/sendgrid/sendgrid-nodejs) is used under the hood. Required environment variables:

- `SENDGRID_USER` - API user (usually email address)
- `SENDGRID_KEY` - API key (usually your password)

#### Mandrill

[Mandrill's node library](https://bitbucket.org/mailchimp/mandrill-api-node) is used under the hood. Required environment variable:

- `MANDRILL` - API key (create one from [your settings page](https://mandrillapp.com/settings/index))

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [Grunt](http://gruntjs.com/).

### Testing

Tests are written with [nodeunit](https://github.com/caolan/nodeunit) and can be run with `npm test`

## Release History

v2.0.0 - Drop support for Node v0.8
v1.0.0 - Add Mandrill support

## License
Copyright (c) 2014 Max Beatty
Licensed under the MIT license.
