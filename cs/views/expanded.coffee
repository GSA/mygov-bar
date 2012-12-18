class MyGovBar.Views.Expanded extends Backbone.View
  el: "#bar"
  
  render: ->
    @$el.clearQueue()
    @$el.animate width: '100%', 1000
    @$el.removeClass 'mini'
    @$el.addClass 'shown'
    @$el.addClass 'expanded'
    @$el.removeClass 'hidden'
