class MyGovBar.Views.Related extends Backbone.View
  
  el: "#drawer"
  template: $("#related_template").html()
  class: "related"
  
  render: =>
    @$el.html JST.related( @model.toJSON() )
    MyGovBar.CrossDomain.sendHeight()
    
  initialize: ->
    @model.on 'change:related', @render