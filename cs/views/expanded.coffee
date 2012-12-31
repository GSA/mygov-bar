class MyGovBar.Views.Expanded extends Backbone.View
  el: "#bar"
  
  events: 
    "click #tabs li.tags a": "tags"
    "click #tabs li.search a": "search"
    "click #tabs li.feedback a": "feedback"
  
  render: ->
    @$el.clearQueue()
    @$el.css 'width', @$el.css 'width' #make width abs
    
    setTimeout => #give pushMessage a second to work before checking page width
      @$el.animate width: '100%', 1000, => 
        @$el.removeClass 'mini'
        @$el.addClass 'shown'
        @$el.addClass 'expanded'
        @$el.removeClass 'hidden'
        MyGovBar.CrossDomain.sendHeight()
    , 1
    

      
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