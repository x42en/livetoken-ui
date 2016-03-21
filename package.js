Package.describe({
  name: 'benmz:livetoken-ui',
  version: '0.1.0',
  summary: 'User interface using LiveToken.io interaction (token authentication system)',
  git: 'https://github.com/x62en/livetoken-ui.git',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  // Meteor releases below this version are not supported
  api.versionsFrom('1.2.0.1');

  // Core packages and 3rd party packages
  api.use('livetoken-base');

  // The files of this package
  api.addFiles('livetoken-ui.coffee');

});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('livetoken-base');
  api.use('coffeescript');
  api.use('benmz:livetoken-ui');
  api.addFiles('livetoken-base-tests.js');
});