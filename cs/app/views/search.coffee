class MyGovBar.Views.Search extends Backbone.View
  el: "#drawer"
  template: $('#search_template').html()

  events:
    "submit #search": "submit"
  
  render: ->
    compiled = _.template @template
    @$el.html compiled()
    
  submit: (e) =>
    MyGovBar.router.go "search/" + $('#search_query').val(), e

class MyGovBar.Views.SearchResult extends Backbone.View
  el: "#drawer"
  template: $('#search_result_template').html()
  
  initialize: ->
    @collection.on 'reset', @render
  
  render: =>
    MyGovBar.router.expand() unless $('#bar').hasClass 'expanded'
    compiled = _.template @template
    @$el.html compiled query: @collection.query, results: @collection.toJSON().splice(0,3)
    MyGovBar.CrossDomain.sendHeight()