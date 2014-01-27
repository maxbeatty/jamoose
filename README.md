# jamoose [![Build Status](https://secure.travis-ci.org/maxbeatty/jamoose.png?branch=master)](http://travis-ci.org/maxbeatty/jamoose) [![Built with Grunt](https://cdn.gruntjs.com/builtwith.png)](http://gruntjs.com/)

> Preprocessing and Sending HTML Emails in Node.js


## Getting Started
This plugin requires Grunt `~0.4.2`

If you haven't used [Grunt](http://gruntjs.com/) before, be sure to check out the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains how to create a [Gruntfile](http://gruntjs.com/sample-gruntfile) as well as install and use Grunt plugins. Once you're familiar with that process, you may install this plugin with this command:

```shell
npm install jamoose --save
```

Once the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript:

```js
grunt.loadNpmTasks('jamoose');
```

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

_Pro Tip: End your `url` with a trailing slash_

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

See the [examples](https://github.com/maxbeatty/jamoose/tree/master/examples)

### Sending Email

Currently, jamoose uses [SendGrid](https://github.com/sendgrid/sendgrid-nodejs) to send emails underneath the covers. These environment variables must be set:

- `SENDGRID_USER`
- `SENDGRID_KEY`

Please submit a pull request to add more service providers.

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [Grunt](http://gruntjs.com/).

## Release History
_(Nothing yet)_

## License
Copyright (c) 2014 Max Beatty
Licensed under the MIT license.
