class MyGovBar.Models.Page extends Backbone.Model
  paramRoot: 'page'
  urlRoot: MyGovBar.config.api_url + "/pages"
  
  url: ->
    url = @urlRoot
    
    if @id?    
     url += "/" + @id
    
    url += ".json?callback=?"
    url
     
  lookup: ->
    old_url = @url
    @url = @urlRoot + "/lookup.json?url=" + @get("url") + "&callback=?"
    @fetch error: (page, err) =>
      if err.status != 404
        return
      
      @save()
      
    @url = old_url
    @trigger 'change'
    
  initialize: ->
    @lookup()
      
  defaults:
    url: document.referrer
  
  get_meta_keywords: ->
    $( "meta[name] ").filter( ->
      this.name.toLowerCase() == "keywords").attr("content")
  
class MyGovBar.Collections.PagesCollection extends Backbone.Collection
  model: MyGovBar.Models.Page
  url: '/pages'
