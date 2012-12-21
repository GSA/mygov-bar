class MyGovBar.Views.Hidden extends Backbone.View
  
  el: "#bar"
  
  render: ->
    @$el.animate width: '0px', 1000, ->
      @$el.removeClass 'shown'
      @$el.addClass 'hidden'
      @$el.removeClass 'mini'
      @$el.removeClass 'expanded'
      @$el.clearQueue()
