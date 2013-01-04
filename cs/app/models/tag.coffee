class MyGovBar.Models.Tag extends Backbone.Model
  
  url: ->
    MyGovBar.config.api_url + '/tags' + @get('name') + '.json'
    
  defaults:
    name: ''
    id: null

class MyGovBar.Collections.Tags extends Backbone.Collection
  model: MyGovBar.Models.Tag
  url: MyGovBar.config.api_url + '/tags'
  
  toJSON: ->
    @pluck('name').join(', ')
    
  initialize: ->
    @on 'add remove', =>
      MyGovBar.page.save { tag_list: @toJSON() }
      