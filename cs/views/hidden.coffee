class MyGovBar.Views.Hidden extends Backbone.View
  
  el: "#bar"
  
  render: ->
    @$el.removeClass 'shown'
    @$el.addClass 'hidden'
    @$el.removeClass 'mini'
    @$el.removeClass 'expanded'
    @$el.clearQueue()
    @$el.animate width: '0px', 1000