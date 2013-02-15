class MyGovBar.Views.Hidden extends Backbone.View
  
  el: "#bar"
  
  render: ->
    $('.row').css 'width', window.innerWidth + 'px'
    @$el.animate {left: '-100%'}, MyGovBar.config.animation_speed, 'swing', =>
      @reset()
      
  reset: ->
    @$el.removeClass 'shown'
    @$el.addClass 'hidden'
    @$el.removeClass 'expanded'
    @$el.clearQueue()
    $('.row').css 'width', '100%'
    @$el.css 'left', '-100%'
