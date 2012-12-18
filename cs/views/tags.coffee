class MyGovBar.Views.Tags extends Backbone.View
  el: "#drawer"
  template: $('#tags_template').html()
  
  render: ->
    compiled = _.template @template
    @$el.html compiled( MyGovBar.page.toJSON() )