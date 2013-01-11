class MyGovBar.Views.Mini extends Backbone.View
  
  el: '#bar'
    
  events:
    "click .expand a": "toggle"
    "click #tabs li.related a": "related"
    "click #close-bar": "close"
    "click .less": "minify"
  
  render: ->
    @$el.clearQueue()
    @$el.addClass 'mini'
    @$el.addClass 'shown'
    @$el.removeClass 'expanded'
    @$el.removeClass 'hidden'
    $('.row').css 'width', window.innerWidth + 'px'
    setTimeout =>
      @$el.animate {left: '0px', width: '100%'}, MyGovBar.config.animation_speed, 'swing', =>
        $('.row').css 'width', '100%'
        @related()
    , 1
    
  toggle: (e) ->
    MyGovBar.router.go 'expanded', e
    @related()
    
  related: (e) ->
    MyGovBar.router.go 'related', e

  close: (e) ->
    MyGovBar.router.go 'hidden', e

  minify: (e) ->
    MyGovBar.router.go 'mini', e