class MyGovBar.Views.Hidden extends MyGovBar.Views.Collapsed
  
  render: ->
    $("#tabs .icon").addClass "activated"
    @$el.clearQueue()
    @$el.css 'width', MyGovBar.config.width_minimized
    @$el.addClass 'hidden'
    @$el.removeClass 'expanded'
    @$el.removeClass 'collapsed'
    MyGovBar.CrossDomain.sendHeight()