(function() {
  var expect;

  expect = (typeof chai !== "undefined" && chai !== null ? chai.expect : void 0) || require('chai').expect;

  describe('Embed Code', function() {
    it('should load the embed code', function() {
      return expect(MyGovLoader).to.be.ok;
    });
    return it('should load the bar', function() {
      MyGovLoader.show();
      return expect(jQuery('iframe#myGovBar').length).to.not.equal(0);
    });
  });

  if (typeof window !== "undefined" && window !== null ? window.requirejs : void 0) {
    define(function(require) {
      return {};
    });
  }

}).call(this);
