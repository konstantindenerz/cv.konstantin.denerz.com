$ ()->
  $root = $ 'body, html'
  $timeline = $ '.timeline'
  $events = $timeline.find '.event'

  selected = 'selected'
  icon = '.duration img'
  iconAnimation = 'animated bounce'
  moreAnimation = 'animated fadeInDown'
  more = '.description .more'
  $moreContent = $timeline.find '.content-container'
  reset = ()->
    $events.removeClass selected
    $events.find(icon).removeClass iconAnimation
    $events.find(more).addClass 'hidden'
    $moreContent.removeClass moreAnimation

  $events.click ()->
    $event = $ this
    $toolbar = $ '.about-small'
    correction = $toolbar.height()
    if not $event.hasClass selected
      reset()
      $event.addClass selected
      $icon = $event.find icon
      $icon.addClass iconAnimation
      $more = $event.find more
      $more.removeClass('hidden')
      $moreContent.addClass moreAnimation
      $root.animate
        scrollTop: $event.offset().top - correction
    else
      reset()
      $root.animate
        scrollTop: $timeline.offset().top - 20
