describe "MyGovBar.Models.Page", ->
  describe "#initialize", ->
    it "invokes lookup", ->
      spyOn(MyGovBar.Models.Page.prototype, 'lookup')
      page = new MyGovBar.Models.Page()
      expect(MyGovBar.Models.Page.prototype.lookup).toHaveBeenCalled()
