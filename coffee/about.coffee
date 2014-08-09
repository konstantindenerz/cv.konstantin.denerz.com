$ ()->
  $window = $ window
  $about = $ '.about'
  $background = $ '.background'
  $aboutSmall = $about.find '.about-small'
  $blurred = $background.find '.blurred, .blurred-2'
  hideBlurredImages = ()->
    $blurred.stop(true, false).animate
      opacity: 0
  showBlurredImages = ()->
    $blurred.stop(true, false).animate
      opacity: 1
  updateBlurState = (event)->
    width = $about.width()
    left = $about.offset().left
    mousePosition = event.pageX - left
    if mousePosition < width / 2
      showBlurredImages()
    else
      hideBlurredImages()
  # The user can move the mouse over the about section
  # and change the focus to the left or to the right side.
  $about.mousemove updateBlurState
  $about.mouseout hideBlurredImages

  syncSize = ()->
    $aboutSmall.width $about.width()
    $background.width $about.width()
  syncSize()
  $window.resize syncSize

  viewPortCallbacks.addFocusCallback ($element)->
    if $element.hasClass 'about-big'
      $aboutSmall.hide()
      window.setTimeout hideBlurredImages, 1000

  viewPortCallbacks.addDefocusCallback ($element)->
    if $element.hasClass 'about-big'
      $aboutSmall.show()
      showBlurredImages()
