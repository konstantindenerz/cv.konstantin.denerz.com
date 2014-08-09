$ ()->
  $common = $ '.common'
  $items = $common.find '.item'
  $items.click ()->
    $this = $ this
    classSelector = ".#{$this.attr('class').split(' ').join('.')}"
    $clone = $items.filter(classSelector).not(this)
    if $this.hasClass 'selected'
      $clone.removeClass 'selected'
      $this.removeClass 'selected'
    else
      $clone.addClass 'selected'
      $this.addClass 'selected'
  window.lab = window.lab or {}
  window.lab.ui = window.lab.ui or {}
  class Number
    init: (selector)->
      $container = $ selector
      if $container and $container.animate
        properties =
          value: 100
        options =
          easing: 'linear'
          duration: 1500
          step: (now, tween)->
            $self = $ this
            value = parseInt $self.attr('data-value')
            newValue= parseInt now * value / 100
            $self.text newValue
        $container.animate properties, options

  window.lab.ui.number =  new Number()

  viewPortCallbacks.addFocusCallback ($element)->
    if $element.hasClass 'inner-common'
      window.setTimeout (()-> lab.ui.number.init '.number'), 1000
