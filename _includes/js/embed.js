(function() {
  var MyGovLoader, XD,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  XD = {
    interval_id: void 0,
    last_hash: void 0,
    cache_bust: 1,
    attached_callback: void 0,
    window: this,
    postMessage: function(message, target_url, target) {
      if (!target_url) {
        return;
      }
      target = target || parent;
      if (window["postMessage"]) {
        return target["postMessage"](message, target_url.replace(/([^:]+:\/\/[^\/]+).*/, "$1"));
      } else {
        if (target_url) {
          return target.location = target_url.replace(/#.*$/, "") + "#" + (+(new Date)) + (cache_bust++) + "&" + message;
        }
      }
    },
    receiveMessage: function(callback, source_origin) {
      var attached_callback, interval_id;
      if (window["postMessage"]) {
        if (callback) {
          attached_callback = function(e) {
            if ((typeof source_origin === "string" && e.origin !== source_origin) || (Object.prototype.toString.call(source_origin) === "[object Function]" && source_origin(e.origin) === !1)) {
              return !1;
            }
            return callback(e);
          };
        }
        if (window["addEventListener"]) {
          return window[(callback ? "addEventListener" : "removeEventListener")]("message", attached_callback, !1);
        } else {
          return window[(callback ? "attachEvent" : "detachEvent")]("onmessage", attached_callback);
        }
      } else {
        interval_id && clearInterval(interval_id);
        interval_id = null;
        if (callback) {
          return interval_id = setInterval(function() {
            var hash, last_hash, re;
            hash = document.location.hash;
            re = /^#?\d+&/;
            if (hash !== last_hash && re.test(hash)) {
              last_hash = hash;
              return callback({
                data: hash.replace(re, "")
              });
            }
          }, 100);
        }
      }
    }
  };

  if (typeof MyGovLoader !== "undefined" && MyGovLoader !== null) {
    return;
  }

  MyGovLoader = (function() {

    MyGovLoader.prototype.rootUrl = '{{ site.url }}';

    MyGovLoader.prototype.scrollTrigger = '{{ site.trigger }}';

    MyGovLoader.prototype.widthMinimized = '{{ site.widthMinimized }}';

    MyGovLoader.prototype.minWidth = '{{ site.minWidth }}';

    MyGovLoader.prototype.animationSpeed = '{{ site.animation_speed }}';

    MyGovLoader.prototype.config = {};

    MyGovLoader.prototype.style = {
      position: 'fixed',
      bottom: 0,
      left: 0,
      background: 'transparent',
      width: '{{ site.widthMinimized }}',
      display: 'none',
      height: '268px',
      border: 0,
      'z-index': 9999999,
      overflow: 'hidden'
    };

    MyGovLoader.prototype.isLoaded = false;

    MyGovLoader.prototype.id = 'myGovBar';

    MyGovLoader.prototype.el = false;

    MyGovLoader.prototype.state = 'hidden';

    function MyGovLoader() {
      this.recieve = __bind(this.recieve, this);

      this.show = __bind(this.show, this);

      this.onResize = __bind(this.onResize, this);

      this.onScroll = __bind(this.onScroll, this);
      if (typeof MyGovConfig !== "undefined" && MyGovConfig !== null) {
        __extends(this.config, MyGovConfig);
      }
      this.config.url = encodeURIComponent(document.location.href.replace(/\/$/, ''));
      if (this.config.load === false) {
        return;
      }
      this.addEvent(document, 'scroll', this.onScroll);
      this.addEvent(window, 'resize', this.onResize);
      this.onResize();
    }

    MyGovLoader.prototype.addEvent = function(el, event, func) {
      if (el.addEventListener) {
        return el.addEventListener(event, func, false);
      } else if (el.attachEvent) {
        return el.attachEvent("on" + event, func);
      }
    };

    MyGovLoader.prototype.onScroll = function() {
      if (this.offsetBottom() > this.scrollTrigger) {
        return this.show();
      } else if (this.offsetBottom() < this.scrollTrigger) {
        return this.hide();
      }
    };

    MyGovLoader.prototype.onResize = function() {
      if (window.innerWidth < this.minWidth && this.state === "shown") {
        this.maximize();
        return this.send('expanded');
      }
    };

    MyGovLoader.prototype.positionTop = function() {
      if (window.pageYOffset != null) {
        return window.pageYOffset;
      }
      if (html.scrollTop != null) {
        return html.scrollTop;
      }
      if (body.scrollTop != null) {
        return body.scrollTop;
      }
      return 0;
    };

    MyGovLoader.prototype.pageHeight = function() {
      return Math.max(Math.max(document.body.scrollHeight, document.documentElement.scrollHeight), Math.max(document.body.offsetHeight, document.documentElement.offsetHeight), Math.max(document.body.clientHeight, document.documentElement.clientHeight));
    };

    MyGovLoader.prototype.windowHeight = function() {
      return window.innerHeight || html.clientHeight || body.clientHeight || screen.availHeight;
    };

    MyGovLoader.prototype.offsetBottom = function() {
      return 100 * (this.positionTop() + this.windowHeight()) / this.pageHeight();
    };

    MyGovLoader.prototype.configSerialized = function() {
      var key, value;
      return ((function() {
        var _ref, _results;
        _ref = this.config;
        _results = [];
        for (key in _ref) {
          value = _ref[key];
          _results.push(this.toParam(key, value));
        }
        return _results;
      }).call(this)).join("&");
    };

    MyGovLoader.prototype.toParam = function(key, value) {
      var v;
      if (value == null) {
        return;
      }
      if (typeof value !== "object") {
        return key + "=" + value;
      }
      return ((function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = value.length; _i < _len; _i++) {
          v = value[_i];
          _results.push(this.toParam(key, v));
        }
        return _results;
      }).call(this)).join("&");
    };

    MyGovLoader.prototype.load = function(callback) {
      var key, value, _ref;
      this.el = document.createElement('iframe');
      this.el.name = this.id;
      this.el.id = this.id;
      this.el.src = this.rootUrl + '/mygov-bar.html#' + this.configSerialized();
      _ref = this.style;
      for (key in _ref) {
        value = _ref[key];
        this.el.style[key] = value;
      }
      document.body.appendChild(this.el);
      XD.receiveMessage(this.recieve, this.rootUrl.match(/([^:]+:\/\/.[^/]+)/)[1]);
      this.isLoaded = true;
      if (callback != null) {
        return callback();
      }
    };

    MyGovLoader.prototype.setWidth = function(width) {
      return this.el.style.width = width;
    };

    MyGovLoader.prototype.setHeight = function(height) {
      return this.el.style.height = height;
    };

    MyGovLoader.prototype.show = function() {
      if (this.state === 'shown') {
        return;
      }
      if (!this.isLoaded) {
        return this.load(this.show);
      }
      this.el.style.display = 'block';
      return this.setState('shown');
    };

    MyGovLoader.prototype.hide = function() {
      var _this = this;
      if (this.state === 'hidden') {
        return;
      }
      this.setState('hidden');
      return setTimeout(function() {
        if (_this.state = "hidden") {
          return _this.el.style.display = 'none';
        }
      }, this.animationSpeed);
    };

    MyGovLoader.prototype.maximize = function() {
      return this.setWidth('100%');
    };

    MyGovLoader.prototype.minimize = function() {
      return this.setWidth(this.widthMinimized);
    };

    MyGovLoader.prototype.send = function(msg) {
      var iframe;
      iframe = document.getElementById(this.id);
      return XD.postMessage(msg, iframe.src, frames.myGovBar);
    };

    MyGovLoader.prototype.recieve = function(msg) {
      msg = msg.data.split("-");
      switch (msg[0]) {
        case "mini":
          return this.minimize();
        case "expanded":
          return this.maximize();
        case "height":
          return this.setHeight(msg[1]);
      }
    };

    MyGovLoader.prototype.setState = function(state) {
      this.state = state;
      return this.send(state);
    };

    return MyGovLoader;

  })();

  window.MyGovLoader = new MyGovLoader();

}).call(this);
