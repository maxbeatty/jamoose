var jamoose = require('../../../lib/jamoose'),
    mailer = new jamoose({
      tplPath: '/../views/mailers/user/',
      fromEmail: 'sender@edc.ba'
    });

mailer.send(
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
