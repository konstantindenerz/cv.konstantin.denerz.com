viewPortCallbacks =
  _focusCallbacks: []
  _defocusCallbacks: []
  _hasFocusCallbacks: []
  addFocusCallback: (callback)-> this._focusCallbacks.push callback
  getFocusCallbacks: ()-> this._focusCallbacks
  addDefocusCallback: (callback)-> this._defocusCallbacks.push callback
  getDefocusCallbacks: ()-> this._defocusCallbacks
  addHasFocusCallback: (callback)-> this._hasFocusCallbacks.push callback
  getHasFocusCallbacks: ()-> this._hasFocusCallbacks

$ ()->
  $contents = $ '.content'
  viewPort = new lab.ui.Viewport
    selector: '.content'
    overlap: 40
  viewPortCallbacks.addFocusCallback ($element)->
    $element.stop(true, false).animate
      opacity: 1
  viewPortCallbacks.addDefocusCallback ($element)->
    $element.stop(true, false).animate
      opacity: 0
  viewPort.focus (elements)->
    for element in elements
      do (element)->
        for focus in viewPortCallbacks.getFocusCallbacks()
          focus $ element
  viewPort.defocus (elements)->
    for element in elements
      do (element)->
        for defocus in viewPortCallbacks.getDefocusCallbacks()
          defocus $ element
  viewPort.update()

  # TODO Use a DI / module framework to manage modules and move this to about.coffee
  hasFocusOnAbout = viewPort.hasFocus (element)-> $(element).hasClass 'about-big'
  if not hasFocusOnAbout
    $aboutSmall = $ '.about-small'
    $aboutSmall.show()

  checkTouchEvent = ()->
    result = false
    try
      document.createEvent 'TouchEvent'
      result = true
    catch
    return result

  window.isTouchDevice = checkTouchEvent()
