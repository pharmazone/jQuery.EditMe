// Generated by CoffeeScript 1.4.0
(function() {

  (function($) {
    return $.fn.getStyleObject = function() {
      var camel, camelize, dom, prop, returns, style, val, _i, _j, _k, _len, _len1, _len2;
      dom = this.get(0);
      returns = {};
      if (window.getComputedStyle) {
        camelize = function(a, b) {
          return b.toUpperCase();
        };
        style = window.getComputedStyle(dom, null);
        for (_i = 0, _len = style.length; _i < _len; _i++) {
          prop = style[_i];
          camel = prop.replace(/\-([a-z])/, camelize);
          val = style.getPropertyValue(prop);
          returns[camel] = val;
        }
        returns;

      }
      if (dom.currentStyle) {
        style = dom.currentStyle;
        for (_j = 0, _len1 = style.length; _j < _len1; _j++) {
          prop = style[_j];
          returns[prop] = style[prop];
        }
        returns;

      }
      if (style = dom.style) {
        for (_k = 0, _len2 = style.length; _k < _len2; _k++) {
          prop = style[_k];
          if (typeof style[prop] !== 'function') {
            returns[prop] = style[prop];
          }
        }
        returns;

      }
      return returns;
    };
  })(jQuery);

}).call(this);