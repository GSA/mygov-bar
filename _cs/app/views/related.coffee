class MyGovBar.Views.Related extends Backbone.View

  el: "#drawer"
  template: $("#related_template").html()
  class: "related"

  render: ->
    MyGovBar.router.expand() unless $('#bar').hasClass 'expanded'
    if @model.hasRelated()
      @$el.html MyGovBar.Templates.related( @model.toJSON() )
    else
      @$el.html MyGovBar.Templates.loading_related()
    MyGovBar.CrossDomain.sendHeight()
    @
