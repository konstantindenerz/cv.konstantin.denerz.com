$ ()->
  window.lab = window.lab or {}
  window.lab.ui = window.lab.ui or {}
  window.lab.ui.sidebar = window.lab.ui.sidebar or {}
  $w = $ window
  $sidebar = $ '.sidebar'
  $sibling = $('.sidebar ~:first')
  showSidebar = (view)->
    if not view
      view = 'default'
    $view = $sidebar.find ".#{view}"
    $otherViews = $sidebar.find('.view').not($view);
    $view.show()
    $otherViews.hide()
    $sidebar.css 'display', 'block'
    $sidebar.addClass 'visible'
    $sidebar.stop(true, false).animate
      left: 0
    #$sibling.stop(true, false).animate # avoid overlap and move the content to right side
    #  left: parseInt $sidebar.css 'width'

  hideSidebar = ()->
    $sidebar.removeClass 'visible'
    $sidebar.scrollTop 0
    $sidebar.stop(true, false).animate left: -((parseInt $sidebar.css 'width') + 420), ()-> $sidebar.hide()
    #$sibling.stop(true, false).animate
    #  left: 0
  updateSize = ()->
    $sidebar.height(window.innerHeight);
  init= ()->
    updateSize()
    hideSidebar()
    $sidebar.find('.navigation a').click ()-> hideSidebar()
    $w.scroll updateSize
    $w.resize updateSize
  init()
  startX = 0
  $sidebar.bind 'touchstart', (event)->
    startX = event.originalEvent.changedTouches[0].clientX
  $sidebar.bind 'touchmove', (event)->
    x = event.originalEvent.changedTouches[0].clientX
    distance = startX - x
    if distance > 0
      $sidebar.offset
        left: -distance
    event.stopPropagation()
  $sidebar.bind 'touchend', (event)->
    x = event.originalEvent.changedTouches[0].clientX
    requiredDistance = 40
    if x < startX and startX - x > requiredDistance
      hideSidebar()
    else
      currentView = getCurrentView()
      showSidebar currentView
  getCurrentView = ()->
    result = undefined
    $visibleView = $sidebar.find '.view:visible'
    if $visibleView.length isnt 0
      result = $visibleView.attr('class').replace('view','').trim()
    result
  # ## Menu
  $menuButtons = $ '.menu-button'
  $menuButtons.click ()->
    if $sidebar.hasClass 'visible'
      hideSidebar()
    else
      showSidebar()

  menuButtonAnimation = ()->
    animation = 'animated wobble'
    $menuButtons.addClass animation
    window.setTimeout (()-> $menuButtons.removeClass animation), 2000

  interval = window.setInterval menuButtonAnimation, 12000
  menuButtonAnimation()

  lab.ui.sidebar.show = (view)->
    showSidebar(view)
    if view is 'skills-explanation'
      $projectCircles = $sidebar.find '.circle.project'
      $projectCircles.css 'background-color', color 5000
  lab.ui.sidebar.isVisible = (view)->
    getCurrentView() is view
  lab.ui.sidebar.hide = hideSidebar
