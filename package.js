Package.describe({
  name: 'benmz:livetoken-ui',
  version: '0.1.4',
  summary: 'User interface using LiveToken.io interaction (token authentication system)',
  git: 'https://github.com/x62en/livetoken-ui.git',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  // Meteor releases below this version are not supported
  api.versionsFrom('1.2.0.1');

  // Core packages and 3rd party packages
  api.use('benmz:livetoken-base@0.1.2');
  api.use('coffeescript');
  api.use('mquandalle:jade@0.4.9');
  api.use('templating', 'client');
  api.use('session', 'client');
  api.use('tracker', 'client');

  // The files of this package
  api.addFiles('livetoken-ui.jade', 'client');
  api.addFiles('livetoken-ui.coffee', 'client');

});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('benmz:livetoken-base');
  api.use('templating', 'client');
  api.use('session', 'client');
  api.use('tracker', 'client');
  api.use('coffeescript');
  api.use('mquandalle:jade');
  api.use('benmz:livetoken-ui');

  api.addFiles('livetoken-base-tests.js');
});
