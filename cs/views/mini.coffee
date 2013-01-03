class MyGovBar.Views.Mini extends Backbone.View
  
  el: '#bar'
    
  events: 
    "click .expand a": "toggle"
    "click #tabs li.related a": "related"
    "click #close-bar": "close" 
  
  render: ->
    @$el.clearQueue()
    @$el.addClass 'mini'
    @$el.addClass 'shown'
    @$el.removeClass 'expanded'
    @$el.removeClass 'hidden'
    $('.row').css 'width', window.innerWidth + 'px'
    setTimeout =>
      @$el.animate {width: '100%'}, MyGovBar.config.animation_speed, 'swing', =>
        $('.row').css 'width', '100%'
        @related()
    , 1
    
  toggle: (e) ->
    MyGovBar.Router.go 'expanded', e
    @related()
    
  related: (e) ->
    MyGovBar.Router.go 'related', e

  close: (e) ->
    MyGovBar.Router.go 'hidden', e