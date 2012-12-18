class MyGovBar.Views.Mini extends Backbone.View
  
  el: '#bar'
    
  events: 
    "click #toggle": "toggle"
  
  render: ->
    @$el.clearQueue()
    @$el.animate width: '100%', 1000
    @$el.addClass 'mini'
    @$el.addClass 'shown'
    @$el.removeClass 'expanded'
    @$el.removeClass 'hidden'
    relatedView = new MyGovBar.Views.Related model: @model
    
  toggle: ->
    MyGovBar.router.navigate 'expanded', true