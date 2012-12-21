class MyGovBar.Views.Search extends Backbone.View
  el: "#drawer"
  template: $('#search_template').html()

  events: 
    "submit #search": "submit"
  
  render: ->
    compiled = _.template @template
    @$el.html compiled()
    
  submit: (e) =>
    e.preventDefault()
    MyGovBar.Router.navigate "search/" + $('#search_query').val(), true
    false

class MyGovBar.Views.SearchResult extends Backbone.View
  el: "#drawer"
  template: $('#search_result_template').html()
  
  render: ->
    compiled = _.template @template
    @$el.html compiled query: @query