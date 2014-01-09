'use strict';

var jamoose = require('../lib/jamoose.js'),
    Mailer;

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

exports['jamoose_test'] = {
  setUp: function(done) {
    Mailer = new jamoose({
      tplPath: '/../tmp/'
    });
    done();
  },
  createEmail: function(test) {
    test.expect(1);
    var email = Mailer.createEmail({});
    test.ok(email, 'should get email from provider.');
    test.done();
  },
  getHtml: function(test) {
    test.expect(2);
    Mailer.getHtml('123', { name: 'asdf'}, function(err, html) {
      test.ifError(err);
      test.ok(/<h1>asdf<\/h1>/.test(html));
      test.done();
    });
  }
};
