class router extends Backbone.Router
  routes:
    "hidden": "hide"
    "expand": "expand"
    "related": "related"
    "tags": "tags"
    "search": "search"
    "feedback": "feedback"
    "mini": "mini"
    "*path": "minify"
    
  mini: ->
    page = new MyGovBar.Models.Page()
    miniView = new MyGovBar.Views.Mini model: page
    miniView.render()
    
  minify: ->
    @navigate 'mini', true
    
  expand: ->
  
  hide: ->
    view = new MyGovBar.Views.Hidden
    view.render()
  

MyGovBar.Router = new router();