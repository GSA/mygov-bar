class MyGovBar.Models.Rating extends Backbone.Model
  
  url: ->
    MyGovBar.config.api_url + "/pages/" + @get( 'page_id') + "/ratings.json"
  
  defaults: ->
    { page_id: MyGovBar.page.get( 'id' ), value: 0 }