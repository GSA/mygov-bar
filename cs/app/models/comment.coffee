class MyGovBar.Models.Comment extends Backbone.Model
  
  url: ->
    MyGovBar.config.api_url + "/pages/" + @get( 'page_id') + "/comments.json"
  
  defaults: ->
    { page_id: MyGovBar.page.get( 'id' ),
    body: "" }

class MyGovBar.Collections.Comments extends Backbone.Collection
  model: MyGovBar.Models.Comment