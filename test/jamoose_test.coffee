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

jamoose = require '../src/jamoose'

Mailer = null

exports['jamoose_test'] =
  setUp: (done) ->
    Mailer = new jamoose
      tplPath: __dirname + '/../.tmp/'
    done()

  createEmail: (test) ->
    test.expect(1)

    email = Mailer.createEmail {}
    test.ok email, 'should get email from provider.'

    test.done()

  getHtml: (test) ->
    test.expect(2)

    Mailer.getHtml '123', { name: 'asdf'}, (err, html) ->
      test.ifError err
      test.ok /<h1>asdf<\/h1>/.test(html)

      test.done()
