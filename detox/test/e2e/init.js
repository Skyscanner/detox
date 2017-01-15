var detox = require('../../src/index');
var config = require('../package.json').detox;

before(function (done) {
  this.timeout(240000);
  detox.config(config);
  detox.start(done);
});

afterEach(function (done) {
  detox.waitForTestResult(done);
});

after(function (done) {
  detox.cleanup(done);
});
