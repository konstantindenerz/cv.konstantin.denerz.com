$ ()->
  $feedback = $ '.feedback'
  show = ()->
    $feedback.removeClass 'closed'
    $feedback.animate
      right: 0
  hide = ()->
    $feedback.addClass 'closed'
    defaultRight = $feedback.width() - 30
    $feedback.animate
      right: "-#{defaultRight}px"
  $feedback.click ()->
    if $feedback.hasClass 'closed'
      show()
    else
      hide()
  hide()


  checkFeedbackState = (e)->
    if not $.contains $feedback[0], e.target # hide if the user click outside of feedback container
      hide()

  if window.isTouchDevice
    $(document).bind 'touchstart', checkFeedbackState
  else
    $(document).bind 'click', checkFeedbackState
