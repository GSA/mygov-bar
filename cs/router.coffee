class router extends Backbone.Router

  routes:
    "hidden": "hide"
    "expanded": "expand"
    "related": "related"
    "tags": "tags"
    "search": "search"
    "search/:query": "searchResult"
    "feedback": "feedback"
    "mini": "mini"
    "*path": "minify"

  initialize: ->  
    MyGovBar.page = new MyGovBar.Models.Page()
    Backbone.history.on 'route', @setCurrent
    
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
    
  searchResult: (query) ->
    collection = new MyGovBar.Collections.SearchResults query: query
    collection.fetch()
    view = new MyGovBar.Views.SearchResult collection: collection

  feedback: ->
    view = new MyGovBar.Views.Feedback model: MyGovBar.page
    view.render()

  setCurrent: ->
    tab = Backbone.history.fragment
    tab = "search search-result" if tab.indexOf("search/") != -1
    $('#tabs li.current').removeClass 'current'
    $('#tabs li.' + tab).addClass 'current'
    $('#tabs li.related').addClass 'current' if tab is 'mini'
    $('#bar').removeClass MyGovBar.config.tabs.join(" ") + " search-result"
    $('#bar').addClass tab
    
MyGovBar.Router = new router();