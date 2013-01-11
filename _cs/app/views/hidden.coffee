class MyGovBar.Views.Hidden extends Backbone.View
  
  el: "#bar"
  
  render: ->
    $('.row').css 'width', window.innerWidth + 'px'
    @$el.fadeOut =>
      @$el.removeClass 'shown'
      @$el.addClass 'hidden'
      @$el.removeClass 'mini'
      @$el.removeClass 'expanded'
      @$el.clearQueue()
      $('.row').css 'width', '100%'
