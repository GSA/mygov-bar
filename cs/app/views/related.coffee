class MyGovBar.Views.Related extends Backbone.View
  
  el: "#drawer"
  template: $("#related_template").html()
  class: "related"
  
  render: =>
    compiled = _.template @template
    @$el.html compiled( @model.toJSON() )
    MyGovBar.CrossDomain.sendHeight()
    
  initialize: ->
    @model.on 'change:related', @render