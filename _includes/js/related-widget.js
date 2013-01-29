(function() {
  var MyGovRelated;

  MyGovRelated = (function() {

    MyGovRelated.prototype.el = document.getElementById('MyGovRelated');

    function MyGovRelated() {
      var script;
      script = document.createElement('script');
      script.src = "http://staging.discovery.my.usa.gov/pages?url=" + document.location.href + "&callback=mygovrelated.callback";
      document.body.appendChild(script);
    }

    MyGovRelated.prototype.callback = function(data) {
      var page, _i, _len, _ref, _results;
      if (!((data != null) && (data.related != null) && data.related.length)) {
        return;
      }
      _ref = data.related;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        page = _ref[_i];
        _results.push(this.addPage(page));
      }
      return _results;
    };

    MyGovRelated.prototype.addPage = function(page) {
      return this.el.innerHTML += '<li><a href="' + page.url + '">' + page.title + '</a></li>';
    };

    return MyGovRelated;

  })();

  window.mygovrelated = new MyGovRelated();

}).call(this);
