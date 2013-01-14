class MyGovBar.Views.Related extends Backbone.View

  el: "#drawer"
  template: $("#related_template").html()
  class: "related"

  render: ->
    if @model.hasRelated()
      @$el.html JST.related( @model.toJSON() )
    else
      @$el.html JST.loading_related()
    MyGovBar.CrossDomain.sendHeight()
    @
