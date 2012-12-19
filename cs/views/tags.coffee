class MyGovBar.Views.Tags extends Backbone.View
  el: "#drawer"
  template: $('#tags_template').html()
  events:
    "change #tag_list": "updateTags"
  
  render: ->
    compiled = _.template @template
    @$el.html compiled( @model.toJSON() )
  
  updateTags: ->
    @model.save tag_list: $('#tag_list').val() 