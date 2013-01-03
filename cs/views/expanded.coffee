class MyGovBar.Views.Expanded extends Backbone.View
  el: "#bar"
  
  events: 
    "click #tabs li.tags a": "tags"
    "click #tabs li.search a": "search"
    "click #tabs li.feedback a": "feedback"
    #"click #close-bar": "close" 
  
  render: ->
    @$el.clearQueue()
    @$el.css 'width', @$el.css 'width' #make width abs
    
    setTimeout => #give pushMessage a second to work before checking page width
      @$el.animate {width: '100%'}, MyGovBar.config.animation_speed, 'swing', => 
        @$el.removeClass 'mini'
        @$el.addClass 'shown'
        @$el.addClass 'expanded'
        @$el.removeClass 'hidden'
        MyGovBar.CrossDomain.sendHeight()
    , 1
    
  tags: (e) ->
    MyGovBar.Router.go 'tags', e
    
  search: (e) ->
    MyGovBar.Router.go 'search',e 

  feedback: (e) ->
    MyGovBar.Router.go 'feedback', e


