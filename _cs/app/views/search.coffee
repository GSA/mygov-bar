class MyGovBar.Views.Search extends Backbone.View
  el: "#drawer"
  template: $('#search_template').html()

  events:
    "submit #search": "submit"
  
  render: ->
    MyGovBar.router.expand() unless $('#bar').hasClass 'expanded'
    @$el.html MyGovBar.Templates.search()
    
  submit: (e) =>
    MyGovBar.router.go("search/" + $('#search_query').val(), e) if $('#search_query').val()

class MyGovBar.Views.SearchResult extends Backbone.View
  el: "#drawer"
  template: $('#search_result_template').html()
  
  initialize: ->
    @collection.on 'reset', @render
  
  render: =>
    MyGovBar.router.expand() unless $('#bar').hasClass 'expanded'
    @$el.html MyGovBar.Templates.search_result query: @collection.query, results: @collection.toJSON().splice(0,3)
    MyGovBar.CrossDomain.sendHeight()