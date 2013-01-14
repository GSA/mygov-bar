class MyGovBar.Views.Related extends Backbone.View

  el: "#drawer"
  template: $("#related_template").html()
  class: "related"

  render: =>
    @$el.html JST.related( @model.toJSON() )
    MyGovBar.CrossDomain.sendHeight()
    @initPolling()
    @
    
  initialize: ->
    @model.on 'change:related', @render

  initPolling: =>
    return if @model.hasRelated()
    @$el.html JST.loading_related()
    setTimeout @poll, 5000
  
  poll: =>
    @model.fetch()