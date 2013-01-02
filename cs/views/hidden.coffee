class MyGovBar.Views.Hidden extends Backbone.View
  
  el: "#bar"
  
  render: ->
    $('.row').css 'width', window.innerWidth + 'px'
    @$el.animate {width: '0px'}, MyGovBar.config.animation_speed, 'swing', =>
      @$el.removeClass 'shown'
      @$el.addClass 'hidden'
      @$el.removeClass 'mini'
      @$el.removeClass 'expanded'
      @$el.clearQueue()
      $('.row').css 'width', '100%'
