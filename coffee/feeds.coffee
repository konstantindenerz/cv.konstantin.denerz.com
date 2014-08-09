$ ()->
  $feeds = $ '.feeds'
  $projects = $feeds.find '.projects'
  $projects.empty()

  $.getJSON 'https://api.github.com/users/konstantindenerz/repos?sort=pushed&type=owner', (data)->
    projects = data

    generate = (project)->
      $item = $ "<div class='item'></div>"
      $title = $ "<div class='title'><a href='#{project.html_url}' target='_blank'>#{project.name}</a><span class='heart'>&hearts;#{project.stargazers_count}</span></div>"
      $description = $ "<div class='description'>#{project.description}</div>"
      $languages = $ "<div class='languages'><img src='style/assets/css/language-inverted.png'><span>#{project.language}</span></div>"
      $.getJSON project.languages_url, (data)->
        if data
          dataArray = for key, value of data
            "#{key}"
          $span = $languages.find 'span'
          $span.text dataArray.join ', '
      $item.append $title
      $item.append $description
      $item.append $languages
      $projects.append $item
    generate projects[i] for i in [0..4]
