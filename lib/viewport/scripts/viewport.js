(function() {
  $(function() {
    var Viewport, defocusCallbacks, delegate, focusCallbacks, focusFlagAttribute, getFocussedTargets, hasFocusFlag, intersection, intersects, isInViewport;
    window.lab = window.lab || {};
    window.lab.ui = window.lab.ui || {};
    focusFlagAttribute = 'data-viewport-focus';
    delegate = function(context, method) {
      return {
        invoke: function() {
          return method.apply(context, arguments);
        }
      };
    };
    intersects = function(r1, r2) {
      var rectangle, _i, _len, _ref;
      r1 = $.extend({}, r1);
      r2 = $.extend({}, r2);
      if (r1.width <= 0 || r1.height <= 0 || r2.width <= 0 || r2.height <= 0) {
        return false;
      }
      _ref = [r1, r2];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        rectangle = _ref[_i];
        rectangle.right = rectangle.left + rectangle.width;
        rectangle.bottom = rectangle.top + rectangle.height;
      }
      return r1.right > r2.left && r1.bottom > r2.top && r2.right > r1.left && r2.bottom > r1.top;
    };
    intersection = function(r1, r2) {
      var rectangle, result, _i, _len, _ref;
      r1 = $.extend({}, r1);
      r2 = $.extend({}, r2);
      if (r1.width <= 0 || r1.height <= 0 || r2.width <= 0 || r2.height <= 0) {
        return false;
      }
      _ref = [r1, r2];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        rectangle = _ref[_i];
        rectangle.right = rectangle.left + rectangle.width;
        rectangle.bottom = rectangle.top + rectangle.height;
      }
      result = {
        left: r1.left < r2.left ? r2.left : r1.left,
        top: r1.top < r2.top ? r2.top : r1.top,
        right: r1.right > r2.right ? r2.right : r1.right,
        bottom: r1.bottom > r2.bottom ? r2.bottom : r1.bottom
      };
      result.width = result.right - result.left;
      result.height = result.bottom - result.top;
      return result;
    };
    isInViewport = function($element, overlap) {
      var element, elementRectangle, hasRequiredOverlap, intersectionResult, offset, windowRectangle;
      windowRectangle = {
        left: document.documentElement.clientLeft,
        top: document.documentElement.clientTop,
        width: document.documentElement.clientWidth,
        height: document.documentElement.clientHeight
      };
      offset = $element.offset();
      if ($element instanceof jQuery) {
        element = $element[0];
      }
      elementRectangle = element.getBoundingClientRect();
      intersectionResult = intersection(windowRectangle, elementRectangle);
      hasRequiredOverlap = Math.min(Math.max(0, intersectionResult.width), Math.max(0, intersectionResult.height)) >= overlap;
      return intersects(windowRectangle, elementRectangle) && hasRequiredOverlap;
    };
    hasFocusFlag = function($element) {
      return $element.is("[" + focusFlagAttribute + "]");
    };
    getFocussedTargets = function($targets, overlap) {
      var result;
      result = [];
      $targets.each(function(i, element) {
        var $element;
        $element = $(element);
        if (isInViewport($element, overlap)) {
          return result.push($element[0]);
        }
      });
      return result;
    };
    focusCallbacks = [];
    defocusCallbacks = [];
    Viewport = (function() {
      function Viewport(config) {
        var $window, updateDelegate;
        this.config = config;
        $window = $(window);
        updateDelegate = delegate(this, this.update);
        $window.resize(function() {
          return updateDelegate.invoke();
        });
        $window.scroll(function() {
          return updateDelegate.invoke();
        });
      }

      Viewport.prototype.update = function() {
        var $focussed, $targets, callback, element, newDefocussed, newFocussed, _i, _j, _len, _len1, _results;
        $targets = $(this.config.selector);
        $focussed = getFocussedTargets($targets, this.config.overlap);
        newFocussed = (function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = $focussed.length; _i < _len; _i++) {
            element = $focussed[_i];
            if (!hasFocusFlag($(element))) {
              _results.push(element);
            }
          }
          return _results;
        })();
        newDefocussed = [];
        $targets.each(function(i, element) {
          var $element;
          $element = $(element);
          if ($focussed.indexOf(element) === -1) {
            if (hasFocusFlag($element)) {
              newDefocussed.push($element[0]);
            }
            return $element.attr(focusFlagAttribute, null);
          } else {
            return $element.attr(focusFlagAttribute, true);
          }
        });
        if (newFocussed.length) {
          for (_i = 0, _len = focusCallbacks.length; _i < _len; _i++) {
            callback = focusCallbacks[_i];
            callback(newFocussed);
          }
        }
        if (newDefocussed.length) {
          _results = [];
          for (_j = 0, _len1 = defocusCallbacks.length; _j < _len1; _j++) {
            callback = defocusCallbacks[_j];
            _results.push(callback(newDefocussed));
          }
          return _results;
        }
      };

      Viewport.prototype.focus = function(onFocus) {
        return focusCallbacks.push(onFocus);
      };

      Viewport.prototype.defocus = function(onDefocus) {
        return defocusCallbacks.push(onDefocus);
      };

      Viewport.prototype.hasFocus = function(validator) {
        var $focussed, $targets, element, isValid, result, _i, _len;
        result = false;
        $targets = $(this.config.selector);
        $focussed = getFocussedTargets($targets, this.config.overlap);
        for (_i = 0, _len = $focussed.length; _i < _len; _i++) {
          element = $focussed[_i];
          isValid = validator(element);
          if (isValid) {
            result = isValid;
            break;
          }
        }
        return result;
      };

      return Viewport;

    })();
    return window.lab.ui.Viewport = Viewport;
  });

}).call(this);
