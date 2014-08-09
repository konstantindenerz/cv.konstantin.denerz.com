$ ()->
  $skills = $ '.skills'
  window.lab = window.lab or {}
  window.lab.ui = window.lab.ui or {}
  window.lab.ui.graph = window.lab.ui.graph or {}
  # Define helper functions
  if typeof String.prototype.endsWith isnt 'function'
    String.prototype.endsWith = (suffix)-> this.indexOf(suffix, this.length - suffix.length) isnt -1

  class SkillsGraph
    init: ()->
      width = 400
      height = 400
      me = 'Konstantin Denerz'
      window.color = d3.scale.category20()

      window.force = d3.layout.force()
          .charge(-150)
          .linkDistance(25)
          .size [width, height]


      svg = d3
        .select(".skills .graph")
        .append("svg")
        .attr("width", '100%')
        .attr("height", '100%')
        .attr('viewBox',"0 0 #{Math.min width, height} #{Math.min width, height}")
        .attr('preserveAspectRatio','xMinYMin')

      skills = window.data.skillsData
      force
        .nodes(skills.nodes)
        .links(skills.links)
        .start()

      link = svg.selectAll '.link'
        .data skills.links
        .enter()
        .append 'line'
        .attr 'class', 'link'
        .style 'stroke-width', (d)-> return Math.sqrt d.value

      node = svg.selectAll('.node')
        .data(skills.nodes)
        .enter()
        .append 'g'
        .attr 'data-tooltip', ''
        .attr 'data-width', (d)->
          duration = d.duration || 1
          10 + duration * 2
        .attr 'class', 'node'
        .call force.drag

      node.append 'circle'
        .attr 'class', 'ic'
        .attr 'r', (d)->
          duration = d.duration || 1
          10 + duration * 2
        .attr "data-foo", (d)-> d.name
        .style 'fill', (d)->
          if d.name is me
            return 'transparent'
          else
            return color d.group

      imageWidth = 20
      imageHeight = 20
      node.append 'image'
        .attr 'xlink:href', (d)->
          if d.name is me
            return 'style/assets/css/me.png'
          else if d.duration
            return 'style/assets/css/p4.png'
          else
            switch d.type
              when 'language' then return 'style/assets/css/language.png'
              when 'technology' then return 'style/assets/css/technology.png'
              when 'tool' then return 'style/assets/css/tool.png'
        .attr 'x', -imageWidth / 2
        .attr 'y', -imageHeight / 2
        .attr 'width', imageWidth
        .attr 'height', imageHeight

      node.append 'div'
        .attr 'class', 'tooltip-content'
        .text (d)-> return d.source or d.name

      force.on 'tick', ()->
        link
          .attr 'x1', (d)-> return d.source.x
          .attr 'y1', (d)-> return d.source.y
          .attr 'x2', (d)-> return d.target.x
          .attr 'y2', (d)-> return d.target.y
          .style 'stroke-width', (d)-> return Math.sqrt d.value
        node.attr 'transform', (d)-> return "translate(#{d.x},#{d.y})"

        node.select '.ic'
          .attr 'data-selected', (d)-> return window.currentSelection and d.source in window.currentSelection.split(';')
          .attr 'r', (d)->
            duration = d.duration || 1
            if window.currentSelection && d.source in window.currentSelection.split(';')
              return 20
            else
              return 6 + duration
        node.select 'image'
          .attr 'x', (d)->
            if window.currentSelection && d.source in window.currentSelection.split(';')
              return -imageWidth
            else return -imageWidth / 2
          .attr 'y', (d)->
            if window.currentSelection && d.source in window.currentSelection.split(';')
              return -imageHeight
            else return -imageHeight / 2
          .attr 'width', (d)->
            if window.currentSelection && d.source in window.currentSelection.split(';')
              return imageWidth * 2
            else return imageWidth
          .attr 'height', (d)->
            if window.currentSelection && d.source in window.currentSelection.split(';')
              return imageHeight * 2
            else return imageHeight

  window.lab.ui.graph.skills = new SkillsGraph
  lab.ui.graph.skills.init()

  class SkillsList
    init: ()->
      data = window.data.skillsData
      sortedNodes = data.nodes.sort (sourceA, sourceB)->
        a = $.extend true, {}, sourceA
        b = $.extend true, {}, sourceB
        prop = 'source'
        result = 0
        for object in [a, b]
          object[prop] = if object[prop] then object[prop] else '1'
        if a[prop].toUpperCase() > b[prop].toUpperCase()
          result = 1
        else if a[prop].toUpperCase() < b[prop].toUpperCase()
          result = -1
        return result
      types = ['language', 'technology', 'tool']
      $skills.find('.type > ul').children().remove()
      add = (node)->
        setCurrentSelection = ()->
          window.currentSelection = $(this).attr('data-source')
          force.start()
        removeCurrentSelection = ()-> window.currentSelection = undefined
        # default view
        $list = $skills.find(".type.#{node.type} > ul")
        if $list.find("li[data-source=\"#{node.source}\"]").length is 0
          bg = color node.group
          isFav = if node.isFavorite then '<img src="style/assets/css/fav.png">' else "<div class='placeholder'></div>"
          $item = $("<li data-source='#{node.source}'><div class=color-mapping style='background:#{bg}'></div>#{isFav}<span>#{node.source}</span></li>")
          $item.appendTo $list
          $item.hover setCurrentSelection, removeCurrentSelection
        # view for small devices
        $list = $skills.find(".type.#{node.type} select")
        if $list.find("option[data-source=\"#{node.source}\"]").length is 0
          $item = $("<option data-source='#{node.source}'>#{node.source}</option>")
          $item.appendTo $list

      add node for node in sortedNodes when node.type in types
      $lists = $skills.find('.type select')
      $lists.change ()->
        window.currentSelection = ''
        $lists.each ()->
          window.currentSelection += if window.currentSelection is '' then '' else ';'
          window.currentSelection += $(this).val()
        force.start()

  lab.ui.graph.skills.list = new SkillsList
  lab.ui.graph.skills.list.init()
  lab.ui.tooltip.init '[data-tooltip]', ($object)->
    rect = object = $object[0].getBoundingClientRect()
    result =
      width: rect.width
      height: rect.height
  # Common
  $lists = $skills.find '.lists'

  updateTab = ()->
    $activeTab = $lists.find 'li.active'
    for type in ['language', 'technology', 'tool']
      $list = $lists.find ".type.#{type}"
      if $activeTab.hasClass type
        $list.show()
      else
        $list.hide()
  updateTab()
  $tabs = $lists.find '.nav li'
  $tabs.click ()->
      $otherTabs = $lists.find('li').not this
      $otherTabs.removeClass 'active'
      $activeTab = $ this
      $activeTab.addClass 'active'
      updateTab()


  # Help
  $helpButton = $skills.find '.help.icon'
  # Animation for help button
  helpButtonAnimation = ()->
    animation = 'animated wobble'
    $helpButton.addClass animation
    window.setTimeout (()-> $helpButton.removeClass animation), 2000

  interval = window.setInterval helpButtonAnimation, 5000

  $helpButton.hover ()-> window.clearInterval interval, ()->

  $helpButton.click ()->
    if lab.ui.sidebar.isVisible 'skills-explanation'
      lab.ui.sidebar.hide()
    else
      lab.ui.sidebar.show 'skills-explanation'
