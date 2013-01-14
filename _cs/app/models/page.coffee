class MyGovBar.Models.Page extends Backbone.Model
  paramRoot: 'page'
  urlRoot: MyGovBar.config.api_url + "/pages"
  poller: null
  
  url: ->
    url = @urlRoot
    
    if @id?
      url += "/" + @id
    
    url += ".json"
    url
     
  lookup: =>
    old_url = @url
    @url = @urlRoot + ".json?url=" + @get("url") + "&callback=?"
    @fetch
      success: =>
        @initPolling()
    @url = old_url
    
  initialize: ->
    @set 'tags', new MyGovBar.Collections.Tags
    @lookup()
    @on 'change:related', @renderRelated
    @on 'change:tag_list', @renderTags
    
  defaults:
    url: document.referrer
    related: []
    tag_list: ""
    
  parse: (data) ->
    return unless data?
    tags = new MyGovBar.Collections.Tags
    _.each data.tags, (tag) ->
      tags.add( new MyGovBar.Models.Tag(tag), {silent: true} )
    data.tags = tags
    data
    
  hasRelated: ->
    @get('related').length is not 0
  
  initPolling: ->
    @poller = setInterval @poll, 5000 if !@hasRelated()
    
  stopPolling: ->
    clearInterval @poller
    @poller = {}
    
  poll: =>
    @fetch
      success: =>
        return if !@hasRelated()
        @stopPolling()
        @maybeRender()

  renderRelated: ->
    return if Backbone.history.fragment != "related"
    MyGovBar.router.navigate "related", true
  
  renderTags: ->
    return if Backbone.history.fragment != "tags"
    MyGovBar.router.navigate "related", true
  
class MyGovBar.Collections.PagesCollection extends Backbone.Collection
  model: MyGovBar.Models.Page
  url: '/pages'
