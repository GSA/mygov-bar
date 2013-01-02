class MyGovBar.Views.Mini extends Backbone.View
  
  el: '#bar'
    
  events: 
    "click .expand a": "toggle"
    "click #tabs li.related a": "related"
  
  render: ->
    @$el.clearQueue()
    @$el.addClass 'mini'
    @$el.addClass 'shown'
    @$el.removeClass 'expanded'
    @$el.removeClass 'hidden'
    $('.row').css 'width', window.innerWidth + 'px'
    setTimeout =>
      @$el.animate {width: '100%'}, MyGovBar.config.animation_speed, 'swing', ->
        $('.row').css 'width', '100%'
    , 1
    
    relatedView = new MyGovBar.Views.Related model: @model
    
  toggle: (e) ->
    e.preventDefault()
    MyGovBar.Router.navigate 'expanded', true
    false
    
  related: (e) ->
    e.preventDefault()
    MyGovBar.Router.navigate 'related', true
    false