class MyGovBar.Views.Search extends Backbone.View
  el: "#drawer"
  template: $('#search_template').html()
  
  render: ->
    compiled = _.template @template
    @$el.html compiled()