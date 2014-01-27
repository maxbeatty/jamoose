###
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
###

grunt = require 'grunt'

exports.jamoose =
  setUp: (done) ->
    # setup here if necessary
    done()

  default_options: (test) ->
    files = ['123', 'testing']

    test.expect files.length

    files.forEach (f) ->
      fname = f + '.html'
      test.equal(
        grunt.file.read('.tmp/' + fname),
        grunt.file.read('test/expected/' + fname),
        fname + ' should match'
      )

    test.done()
