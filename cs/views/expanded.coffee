class MyGovBar.Views.Expanded extends Backbone.View
  el: "#bar"
  
  events: 
    "click #tabs li.tags a": "tags"
    "click #tabs li.search a": "search"
    "click #tabs li.feedback a": "feedback"
  
  render: ->
    @$el.clearQueue()
    @$el.animate width: '100%', 1000
    @$el.removeClass 'mini'
    @$el.addClass 'shown'
    @$el.addClass 'expanded'
    @$el.removeClass 'hidden'

  tags: (e) ->
    e.preventDefault()
    MyGovBar.Router.navigate 'tags', true
    false
    
  search: (e) ->
    e.preventDefault()
    MyGovBar.Router.navigate 'search', true
    false
    
  feedback: (e) ->
    e.preventDefault()
    MyGovBar.Router.navigate 'feedback', true
    false