class MyGovBar.Models.Page extends Backbone.Model
  paramRoot: 'page'
  urlRoot: MyGovBar.config.api_url + "/pages"
  
  url: ->
    url = @urlRoot
    
    if @id?    
     url += "/" + @id
    
    url += ".json"
    url
     
  lookup: ->
    old_url = @url
    @url = @urlRoot + ".json?url=" + @get("url") + "&callback=?"
    @fetch()
    @url = old_url
    
  initialize: ->
    @lookup()
      
  defaults:
    url: document.referrer
    related: []
    tags: new MyGovBar.Collections.Tags
    tag_list: ""
    
  parse: (data) ->
    return unless data?
    tags = new MyGovBar.Collections.Tags
    _.each data.tags, (tag) ->
      tags.add( new MyGovBar.Models.Tag(tag), {silent: true} )
    data.tags = tags
    data
  
class MyGovBar.Collections.PagesCollection extends Backbone.Collection
  model: MyGovBar.Models.Page
  url: '/pages'
