'use strict';

var grunt = require('grunt');

/*
  ======== A Handy Little Nodeunit Reference ========
  https://github.com/caolan/nodeunit

  Test methods:
    test.expect(numAssertions)
    test.done()
  Test assertions:
    test.ok(value, [message])
    test.equal(actual, expected, [message])
    test.notEqual(actual, expected, [message])
    test.deepEqual(actual, expected, [message])
    test.notDeepEqual(actual, expected, [message])
    test.strictEqual(actual, expected, [message])
    test.notStrictEqual(actual, expected, [message])
    test.throws(block, [error], [message])
    test.doesNotThrow(block, [error], [message])
    test.ifError(value)
*/

exports.jamoose = {
  setUp: function(done) {
    // setup here if necessary
    done();
  },
  default_options: function(test) {
    var files = ['123', 'testing'];
    test.expect(files.length);

    files.forEach(function(f) {
      var fname = f + '.html';
      test.equal(
        grunt.file.read('tmp/' + fname),
        grunt.file.read('test/expected/' + fname),
        fname + ' should match'
      );
    });

    test.done();
  }
};
