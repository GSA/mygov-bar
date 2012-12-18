class router extends Backbone.Router
  routes:
    "expand": "expand"
    "related": "related"
    "tags": "tags"
    "search": "search"
    "feedback": "feedback"
    "*path": "mini"
    
  mini: ->
    page = new MyGovBar.Models.Page()
    miniView = new MyGovBar.Views.Mini model: page
    miniView.render()
    
  expand: ->

MyGovBar.Router = new router();