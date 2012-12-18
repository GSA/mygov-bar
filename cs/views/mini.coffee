class MyGovBar.Views.Mini extends Backbone.View
  
  el: '#bar'
    
  events: 
    "click #toggle": "toggle"
  
  render: ->
    @$el.addClass 'mini'
    @$el.removeClass 'expanded'
    relatedView = new MyGovBar.Views.Related model: @model
    #relatedView.render()
        
  toggle: ->
    MyGovBar.router.navigate 'expanded', true