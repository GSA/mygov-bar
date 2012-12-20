class router extends Backbone.Router

  routes:
    "hidden": "hide"
    "expanded": "expand"
    "related": "related"
    "tags": "tags"
    "search": "search"
    "feedback": "feedback"
    "mini": "mini"
    "*path": "minify"

  initialize: ->  
    MyGovBar.page = new MyGovBar.Models.Page()
    
  mini: ->
    MyGovBar.CrossDomain.send 'mini'
    miniView = new MyGovBar.Views.Mini model: MyGovBar.page
    miniView.render()
    
  minify: ->
    @navigate 'mini', true
    
  expand: ->
    MyGovBar.CrossDomain.send 'expanded'
    view = new MyGovBar.Views.Expanded
    view.render()
  
  hide: ->
    MyGovBar.CrossDomain.send 'hidden'
    view = new MyGovBar.Views.Hidden
    view.render()
  
  tags: ->
    view = new MyGovBar.Views.Tags model: MyGovBar.page
    view.render()
    
  related: ->
    view = new MyGovBar.Views.Related model: MyGovBar.page
    view.render()
    
  search: ->
    view = new MyGovBar.Views.Search
    view.render()

  feedback: ->
    view = new MyGovBar.Views.Feedback model: MyGovBar.page
    view.render()


MyGovBar.Router = new router();