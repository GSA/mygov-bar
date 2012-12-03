class MyGovBar.Routers.Router extends Backbone.Router
  routes:
    "": "root"
    
  root: ->
    window.page = new MyGovBar.Models.Page
    indexView = new MyGovBar.Views.Index({ model: page, el: $("#bar") })
        
#window.router = new MyGovBar.Routers.Router
#Backbone.history.start {pushState: true}