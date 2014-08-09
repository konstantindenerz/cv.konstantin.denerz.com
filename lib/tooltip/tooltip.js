(function() {
  $(function() {
    var Tooltip, alignSet, arrowSize, checkTouchEvent, create, distance, generator, getCustomSize, hover, internalReferenceId, layout, leave, referenceAttribute, tooltipAlignAttribute, tooltipContentSelector, tooltipSelector;
    internalReferenceId = 0;
    window.lab = window.lab || {};
    window.lab.ui = window.lab.ui || {};
    tooltipSelector = '.lab-tooltip';
    tooltipContentSelector = '.tooltip-content';
    tooltipAlignAttribute = 'data-tooltip-align';
    distance = 25;
    arrowSize = 10;
    alignSet = ['top', 'right', 'left', 'bottom'];
    referenceAttribute = 'data-tooltip-ref';
    getCustomSize = null;
    checkTouchEvent = function() {
      var result;
      result = false;
      try {
        document.createEvent('TouchEvent');
        result = true;
      } catch (_error) {

      }
      return result;
    };
    window.isTouchDevice = checkTouchEvent();
    generator = {
      tooltip: '<div class="lab-tooltip"><div class="content"></div></div>',
      arrow: '<div class="arrow"></div>'
    };
    create = function(content) {
      var $parent, $tooltip;
      $parent = $('body');
      $tooltip = $(generator.tooltip);
      $tooltip.find('.content').html(content);
      $tooltip.append(generator.arrow);
      $tooltip.appendTo($parent);
      $tooltip.click(leave);
      return $tooltip;
    };
    hover = function() {
      var $content, $target, $tooltip, content, currentReferenceId;
      $target = $(this);
      $content = $target.find(tooltipContentSelector);
      content = $content.html() || $content.text();
      $tooltip = create(content);
      currentReferenceId = -1;
      if (!$target.attr(referenceAttribute)) {
        currentReferenceId = internalReferenceId++;
        $target.attr(referenceAttribute, currentReferenceId);
      } else {
        currentReferenceId = $target.attr(referenceAttribute);
      }
      $tooltip.attr(referenceAttribute, currentReferenceId);
      $tooltip.addClass($target.attr('data-tooltip'));
      return layout.update($tooltip, $target);
    };
    leave = function() {
      var $tooltip;
      $tooltip = $(tooltipSelector);
      return $tooltip.remove();
    };
    $(window).resize(leave);
    if (window.isTouchDevice) {
      $(document).bind('touchstart', function(e) {
        var $target, $tooltip, currentReference, currentTooltipReference;
        $tooltip = $(tooltipSelector);
        currentReference = $tooltip.attr(referenceAttribute);
        if (currentReference) {
          try {
            $target = $(e.target);
            currentTooltipReference = $target.attr(referenceAttribute);
            if (currentReference !== currentTooltipReference) {
              return $tooltip.remove();
            }
          } catch (_error) {
            return $tooltip.remove();
          }
        }
      });
    }
    layout = {
      update: function($tooltip, $target) {
        var $arrow, align, alignDefinition, animationEffect, calculateNewArrowPosition, calculateNewPosition, client, containerSize, currentAlign, getAlignment, getSize, maxWidth, position, targetOffset, targetSize, tooltipSize, tooltipWidth, w, widthLimit, _fn, _i, _len;
        w = {
          width: window.innerWidth,
          height: window.innerHeight
        };
        client = {
          width: window.document.body.clientWidth,
          height: window.document.body.clientHeight
        };
        tooltipWidth = $tooltip.width() + 2 * distance;
        widthLimit = w.width - 2 * distance;
        if (widthLimit <= tooltipWidth) {
          tooltipWidth = widthLimit;
          $tooltip.width(tooltipWidth);
        }
        alignDefinition = $target.attr(tooltipAlignAttribute);
        maxWidth = 0;
        if (alignDefinition) {
          switch (alignDefinition) {
            case 'top':
              maxWidth = window.innerWidth - 2 * distance;
              break;
            case 'right':
              maxWidth = window.innerWidth - $target.offset().left - $target.width - 2 * distance;
              break;
            case 'left':
              maxWidth = $target.offset().left - 2 * distance;
              break;
            case 'bottom':
              maxWidth = window.innerWidth - 2 * distance;
          }
        }
        if (maxWidth !== 0) {
          $tooltip.css('max-width', maxWidth);
        }
        getSize = function(object) {
          var result;
          result = {
            width: Math.max(object.width(), parseInt(object.css('width'))),
            height: Math.max(object.height(), parseInt(object.css('height')))
          };
          if (result.width === 0 && result.height === 0 && typeof getCustomSize === 'function') {
            result = getCustomSize(object);
          }
          return result;
        };
        getAlignment = function(tooltipSize, targetSize, targetOffset, containerSize) {
          var align;
          align = void 0;
          if (tooltipSize.height + distance <= targetOffset.top) {
            align = 'top';
          } else if (tooltipSize.width + distance <= containerSize.width - targetOffset.left - targetSize.width) {
            align = 'right';
          } else if (tooltipSize.width + distance <= targetOffset.left) {
            align = 'left';
          } else if (tooltipSize.height + distance <= containerSize.height - targetOffset.top - targetSize.height) {
            align = 'bottom';
          }
          return align;
        };
        containerSize = w;
        tooltipSize = getSize($tooltip);
        targetSize = getSize($target);
        targetOffset = $target.offset();
        align = void 0;
        if (!align && $target.is('[' + tooltipAlignAttribute + ']')) {
          align = $target.attr(tooltipAlignAttribute);
        }
        if (!align) {
          align = getAlignment(tooltipSize, targetSize, targetOffset, containerSize);
        }
        if (!align) {
          containerSize = client;
          align = getAlignment(tooltipSize, targetSize, targetOffset, containerSize);
        }
        if (!align) {
          align = 'bottom';
        }
        calculateNewPosition = function(tooltipSize, targetSize, targetOffset, containerSize) {
          var position, targetXCenter, targetYCenter, tooltipHalf;
          position = {};
          switch (align) {
            case 'top':
              targetXCenter = targetOffset.left + (targetSize.width / 2);
              tooltipHalf = tooltipSize.width / 2;
              position.left = Math.max(distance, Math.min(containerSize.width - distance - tooltipSize.width, targetXCenter - tooltipHalf));
              position.top = targetOffset.top - tooltipSize.height - distance;
              break;
            case 'right':
              targetYCenter = targetOffset.top + (targetSize.height / 2);
              tooltipHalf = tooltipSize.height / 2;
              position.left = targetOffset.left + targetSize.width + distance;
              position.top = Math.max(distance, targetYCenter - tooltipHalf);
              break;
            case 'left':
              targetYCenter = targetOffset.top + (targetSize.height / 2);
              tooltipHalf = tooltipSize.height / 2;
              position.left = targetOffset.left - distance - tooltipSize.width;
              position.top = Math.max(distance, targetYCenter - tooltipHalf);
              break;
            case 'bottom':
              targetXCenter = targetOffset.left + (targetSize.width / 2);
              tooltipHalf = tooltipSize.width / 2;
              position.left = Math.max(distance, Math.min(containerSize.width - distance - tooltipSize.width, targetXCenter - tooltipHalf));
              position.top = targetOffset.top + targetSize.height + distance;
          }
          return position;
        };
        position = calculateNewPosition(tooltipSize, targetSize, targetOffset, containerSize);
        $tooltip.offset(position);
        calculateNewArrowPosition = function() {
          var targetYCenter, tooltipHalf;
          position = {};
          switch (align) {
            case 'top':
              position.left = targetOffset.left + (targetSize.width / 2);
              position.top = targetOffset.top - distance - 1;
              break;
            case 'right':
              position.left = targetOffset.left + targetSize.width + distance - arrowSize + 1;
              position.top = targetOffset.top + (targetSize.height / 2);
              break;
            case 'left':
              targetYCenter = targetOffset.top + (targetSize.height / 2);
              tooltipHalf = tooltipSize.height / 2;
              position.left = targetOffset.left - distance - 1;
              position.top = targetOffset.top + (targetSize.height / 2);
              break;
            case 'bottom':
              position.left = targetOffset.left + (targetSize.width / 2);
              position.top = targetOffset.top + targetSize.height + distance - arrowSize + 1;
          }
          return position;
        };
        position = calculateNewArrowPosition(containerSize);
        $arrow = $tooltip.find('.arrow');
        _fn = function(currentAlign) {
          $tooltip.removeClass(currentAlign);
          return $arrow.removeClass(currentAlign);
        };
        for (_i = 0, _len = alignSet.length; _i < _len; _i++) {
          currentAlign = alignSet[_i];
          _fn(currentAlign);
        }
        $arrow.offset(position);
        $arrow.addClass(align);
        $tooltip.addClass(align);
        animationEffect = 'fadeInDown';
        switch (align) {
          case 'bottom':
            animationEffect = 'fadeInUp';
            break;
          case 'left':
            animationEffect = 'fadeInLeft';
            break;
          case 'right':
            animationEffect = 'fadeInRight';
            break;
          default:
            animationEffect = 'fadeInDown';
        }
        return $tooltip.addClass("animated " + animationEffect);
      }
    };
    Tooltip = (function() {
      function Tooltip() {}

      Tooltip.prototype.init = function(newSelector, getSize) {
        var $targets, selector;
        getCustomSize = getSize;
        selector = newSelector || '[data-tooltip]';
        $targets = $(selector);
        return $targets.hover(hover, leave);
      };

      return Tooltip;

    })();
    return window.lab.ui.tooltip = new Tooltip();
  });

}).call(this);
