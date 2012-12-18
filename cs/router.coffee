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
    MyGovBar.CrossDomain.send 'mini'
    MyGovBar.page = new MyGovBar.Models.Page() if not MyGovBar.page?
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
  

MyGovBar.Router = new router();