var Mailer = require('../../../lib/jamoose'),
    userMailer = new Mailer({
      tplPath: '/../views/mailers/user/'
    });

userMailer.send(
  'test@abc.de', // to
  'Welcome!', // subject
  'welcome', // template
  { // data
    name: 'Test Abcde',
    link: 'http://example'
  },
  function(err) { // callback
    if (err) { console.log(err); }
  }
);