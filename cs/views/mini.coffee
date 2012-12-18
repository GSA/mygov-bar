class MyGovBar.Views.Mini extends Backbone.View
  
  el: '#bar'
    
  events: 
    "click .expand a": "toggle"
  
  render: ->
    @$el.clearQueue()
    @$el.animate width: '100%', 1000
    @$el.addClass 'mini'
    @$el.addClass 'shown'
    @$el.removeClass 'expanded'
    @$el.removeClass 'hidden'
    relatedView = new MyGovBar.Views.Related model: @model
    
  toggle: (e) ->
    e.preventDefault()
    MyGovBar.Router.navigate 'expanded', true
    false