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
    
  mini: ->
    MyGovBar.page = new MyGovBar.Models.Page() if not MyGovBar.page?
    miniView = new MyGovBar.Views.Mini model: MyGovBar.page
    miniView.render()
    
  minify: ->
    @navigate 'mini', true
    
  expand: ->
    view = new MyGovBar.Views.Expanded
    view.render()
  
  hide: ->
    view = new MyGovBar.Views.Hidden
    view.render()
  

MyGovBar.Router = new router();