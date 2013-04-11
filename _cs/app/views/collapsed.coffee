class MyGovBar.Views.Collapsed extends Backbone.View
  el: "#bar"
  
  events:
    "click #tabs li.related a": "related"
    "click #tabs li.tags a": "tags"
    "click #tabs li.search a": "search"
    "click #tabs li.feedback a": "feedback"
    "click li.hide a": "hide"
  
  render: ->
    $("#tabs .icon").removeClass "activated"
    @$el.clearQueue()
    @$el.css 'width', '100%'
    @$el.addClass 'shown'
    @$el.addClass 'collapsed'
    @$el.removeClass 'expanded'
    @$el.removeClass 'hidden'
    MyGovBar.CrossDomain.sendHeight()
    @trigger 'render'
  
  related: (e) ->
    MyGovBar.router.go 'related', e
  
  tags: (e) ->
    MyGovBar.router.go 'tags', e
    
  search: (e) ->
    MyGovBar.router.go 'search', e

  feedback: (e) ->
    MyGovBar.router.go 'feedback', e
    
  hide: (e) ->
    MyGovBar.router.go 'hidden', e