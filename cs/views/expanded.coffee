class MyGovBar.Views.Expanded extends Backbone.View
  el: "#bar"
  
  render: ->
    @$el.removeClass 'mini'
    @$el.addClass 'expanded'
    MyGovBar.CrossDomain.send 'toggle'