class MyGovBar.Views.Index extends Backbone.View
  
  template: $('#index_template').html()
  
  events: 
    "click #save_tags": "save"
    "click #toggle": "toggle"
  
  render: ->
    rendered = _.template @template 
    $(@el).html( rendered( @model.toJSON() ))  
    @
  
  initialize: ->
    _.bindAll @, "render"
    @.model.bind 'change', @render
    
  save: ->
    @model.save { tag_list: $("#tag_list").val() } 
    false
  
  fetch: ->
    @model.fetch()
    
  toggle: ->
    $(@el).toggleClass 'expanded'
    $(@el).toggleClass 'minimized'
    MyGovBar.CrossDomain.send 'toggle' 