$ ()->
  $roles = $ '.roles'
  $brain = $roles.find '.brain'
  $labels = $roles.find '.brain-labels'
  $smallLabels = $roles.find '.role-to-brain .brain-left, .role-to-brain .brain-right'
  $brainAnimation = $roles.find '.visible-xs .brain-animation'
  updateLabels = ()->
    $active = $labels.find '.brainside.active'
    $other = $labels.find '.brainside:not(.active)'
    $active.removeClass 'active'
    $other.addClass 'active'
  updateSmallLabels = ()->
    $active = $smallLabels.filter '.active'
    $other = $smallLabels.filter ':not(.active)'
    $active.removeClass 'active'
    $other.addClass 'active'
  updateBrain = ()->
    $active = $brain.find '.view.active'
    $other = $brain.find '.view:not(.active)'
    $active.removeClass 'active'
    $other.addClass 'active'
    updateLabels()
    updateSmallLabels()
  $brain.click updateBrain
  startEvent = "mousedown"
  endEvent = "mouseup"
  if window.isTouchDevice
    startEvent = 'touchstart'
    endEvent = 'touchend'
  $brain.bind startEvent, ()-> $(this).addClass 'clicked'
  $brain.bind endEvent, ()-> $(this).removeClass 'clicked'
  updateBrain()
  updateBrain() # show the left side of the brain
  adjustSize = ()->
    width = $brainAnimation.width()
    $g = $brainAnimation.find 'g'
    $g.attr 'transform', "translate(#{width/2}, 160)"
  $(window).resize adjustSize
  adjustSize()
