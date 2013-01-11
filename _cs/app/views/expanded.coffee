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
      @$el.animate {left: '0px'; width: "100%" }, MyGovBar.config.animation_speed, 'swing', =>
        @$el.removeClass 'mini'
        @$el.addClass 'shown'
        @$el.addClass 'expanded'
        @$el.removeClass 'hidden'
        MyGovBar.CrossDomain.sendHeight()
        @trigger 'render'
    , 1
    
  tags: (e) ->
    MyGovBar.router.go 'tags', e
    
  search: (e) ->
    MyGovBar.router.go 'search', e

  feedback: (e) ->
    MyGovBar.router.go 'feedback', e


