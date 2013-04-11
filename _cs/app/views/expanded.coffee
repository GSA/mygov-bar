class MyGovBar.Views.Expanded extends MyGovBar.Views.Collapsed
  
  render: ->
    $("#tabs .icon").removeClass "activated"
    @$el.clearQueue()
    @$el.css 'width', '100%'
    @$el.addClass 'shown'
    @$el.addClass 'expanded'
    @$el.removeClass 'collapsed'
    @$el.removeClass 'hidden'
    MyGovBar.CrossDomain.sendHeight()
    @trigger 'render'