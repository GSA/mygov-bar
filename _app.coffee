# 
# * a backwards compatable implementation of postMessage
# * by Josh Fraser (joshfraser.com)
# * released under the Apache 2.0 license.  
# *
# * this code was adapted from Ben Alman's jQuery postMessage code found at:
# * http://benalman.com/projects/jquery-postmessage-plugin/
# * 
# * other inspiration was taken from Luke Shepard's code for Facebook Connect:
# * http://github.com/facebook/connect-js/blob/master/src/core/xd.js
# *
# * the goal of this project was to make a backwards compatable version of postMessage
# * without having any dependency on jQuery or the FB Connect libraries
# *
# * my goal was to keep this as terse as possible since my own purpose was to use this 
# * as part of a distributed widget where filesize could be sensative.
# * 
# 

# everything is wrapped in the XD function to reduce namespace collisions
XD =
  interval_id: undefined
  last_hash: undefined
  cache_bust: 1
  attached_callback: undefined
  window: this
  
  postMessage: (message, target_url, target) ->
    return  unless target_url
    target = target or parent # default to parent
    if window["postMessage"]
      
      # the browser supports window.postMessage, so call it with a targetOrigin
      # set appropriately, based on the target_url parameter.
      target["postMessage"] message, target_url.replace(/([^:]+:\/\/[^\/]+).*/, "$1")
    
    # the browser does not support window.postMessage, so set the location
    # of the target to target_url#message. A bit ugly, but it works! A cache
    # bust parameter is added to ensure that repeat messages trigger the callback.
    else target.location = target_url.replace(/#.*$/, "") + "#" + (+new Date) + (cache_bust++) + "&" + message  if target_url

  receiveMessage: (callback, source_origin) ->
    
    # browser supports window.postMessage
    if window["postMessage"]
      
      # bind the callback to the actual event associated with window.postMessage
      if callback
        attached_callback = (e) ->
          if (typeof source_origin is "string" and e.origin isnt source_origin) or (Object::toString.call(source_origin) is "[object Function]" and source_origin(e.origin) is not 1)
            console.log "cross iframe request blocked. Domains " + e.origin + " and " + source_origin + " must match."
            return not 1
          callback e
      if window["addEventListener"]
        window[(if callback then "addEventListener" else "removeEventListener")] "message", attached_callback, not 1
      else
        window[(if callback then "attachEvent" else "detachEvent")] "onmessage", attached_callback
    else
      
      # a polling loop is started & callback is called whenever the location.hash changes
      interval_id and clearInterval(interval_id)
      interval_id = null
      if callback
        interval_id = setInterval(->
          hash = document.location.hash
          re = /^#?\d+&/
          if hash isnt last_hash and re.test(hash)
            last_hash = hash
            callback data: hash.replace(re, "")
        , 100)
class MyGovBar.Models.Comment extends Backbone.Model
  
  url: ->
    MyGovBar.config.api_url + "/pages/" + @get( 'page_id') + "/comments.json"
  
  defaults: ->
    { page_id: MyGovBar.page.get( 'id' ),
    body: "" }

class MyGovBar.Collections.Comments extends Backbone.Collection
  model: MyGovBar.Models.Comment
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
    @set 'tags', new MyGovBar.Collections.Tags
    @lookup()
      
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
  
class MyGovBar.Collections.PagesCollection extends Backbone.Collection
  model: MyGovBar.Models.Page
  url: '/pages'

class MyGovBar.Models.SearchResult extends Backbone.Model

class MyGovBar.Collections.SearchResults extends Backbone.Collection

  model: MyGovBar.Models.SearchResult
  
  url: ->
    url = 'http://search.usa.gov/api/search.json?'
    url += '&affiliate=' + MyGovBar.config.search_affiliate
    url += '&query=' + @query
    url += '&callback=?'
    url
  
  parse: (data) ->
 
    #convert unicode encoded highlighting to HTML
    # see https://search.usa.gov/affiliates/3204/api
    _.each data.results, (result) =>
      result[field] = @htmlHighlight result[field] for field in ['title', 'content']
          
    data.results
    
  initialize: (args) ->
    return unless args.query?
    @query = args.query
  

  htmlHighlight: (string) ->
    string.replace(/\ue000/g, '<span class="highlight">').replace(/\ue001/g, '</span>')

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
      
class MyGovBar.Views.Expanded extends Backbone.View
  el: "#bar"
  
  events:
    "click #tabs li.tags a": "tags"
    "click #tabs li.search a": "search"
    "click #tabs li.feedback a": "feedback"
  
  render: ->
    @$el.clearQueue()
    @$el.css 'width', @$el.css 'width' #make width abs
    
    setTimeout => #give pushMessage a second to work before checking page width
      @$el.animate {width: '100%'}, MyGovBar.config.animation_speed, 'swing', =>
        @$el.removeClass 'mini'
        @$el.addClass 'shown'
        @$el.addClass 'expanded'
        @$el.removeClass 'hidden'
        MyGovBar.CrossDomain.sendHeight()
        @trigger 'render'
    , 1
    
  tags: (e) ->
    MyGovBar.router.go 'tags', e
    
  search: (e) ->
    MyGovBar.router.go 'search', e

  feedback: (e) ->
    MyGovBar.router.go 'feedback', e



class MyGovBar.Views.Feedback extends Backbone.View
  el: "#drawer"
  saveOnChange: false
  
  events:
    "submit #feedback": "submitComment"
  
  render: ->
    MyGovBar.router.expand() unless $('#bar').hasClass 'expanded'
    @$el.html JST.feedback()
    @initStars()
        
  saveRating: (value, link) =>
    return unless @saveOnChange
    @model.save rating: value

  submitComment: (e) =>
    input = $('#comment')
    e.preventDefault()
    comment = new MyGovBar.Models.Comment page_id: @model.get 'id'
    comment.on 'sync', @commentSuccess
    comment.save body: input.val()
    input.val('')
    false
    
  commentSuccess: ->
    $('#comment_submitted').fadeIn().delay(5000).fadeOut()
  
  initStars: ->
    star = $ 'input.star'
    star.rating callback: @saveRating
    star.rating 'select', Math.round( parseFloat( @model.get 'avg_rating' ) ) - 1
    @saveOnChange = true

class MyGovBar.Views.Hidden extends Backbone.View
  
  el: "#bar"
  
  render: ->
    $('.row').css 'width', window.innerWidth + 'px'
    @$el.animate {width: '0px'}, MyGovBar.config.animation_speed, 'swing', =>
      @$el.removeClass 'shown'
      @$el.addClass 'hidden'
      @$el.removeClass 'mini'
      @$el.removeClass 'expanded'
      @$el.clearQueue()
      $('.row').css 'width', '100%'

class MyGovBar.Views.Mini extends Backbone.View
  
  el: '#bar'
    
  events:
    "click .expand a": "toggle"
    "click #tabs li.related a": "related"
    "click #close-bar": "close"
  
  render: ->
    @$el.clearQueue()
    @$el.addClass 'mini'
    @$el.addClass 'shown'
    @$el.removeClass 'expanded'
    @$el.removeClass 'hidden'
    $('.row').css 'width', window.innerWidth + 'px'
    setTimeout =>
      @$el.animate {width: '100%'}, MyGovBar.config.animation_speed, 'swing', =>
        $('.row').css 'width', '100%'
        @related()
    , 1
    
  toggle: (e) ->
    MyGovBar.router.go 'expanded', e
    @related()
    
  related: (e) ->
    MyGovBar.router.go 'related', e

  close: (e) ->
    MyGovBar.router.go 'hidden', e
class MyGovBar.Views.Related extends Backbone.View
  
  el: "#drawer"
  template: $("#related_template").html()
  class: "related"
  
  render: =>
    @$el.html JST.related( @model.toJSON() )
    MyGovBar.CrossDomain.sendHeight()
    
  initialize: ->
    @model.on 'change:related', @render
class MyGovBar.Views.Search extends Backbone.View
  el: "#drawer"
  template: $('#search_template').html()

  events:
    "submit #search": "submit"
  
  render: ->
    @$el.html JST.search()
    
  submit: (e) =>
    MyGovBar.router.go "search/" + $('#search_query').val(), e

class MyGovBar.Views.SearchResult extends Backbone.View
  el: "#drawer"
  template: $('#search_result_template').html()
  
  initialize: ->
    @collection.on 'reset', @render
  
  render: =>
    MyGovBar.router.expand() unless $('#bar').hasClass 'expanded'
    @$el.html JST.search_result query: @collection.query, results: @collection.toJSON().splice(0,3)
    MyGovBar.CrossDomain.sendHeight()
class MyGovBar.TagManager
  compareItems: (a,b) ->
    return true if a.get('name') is b.get('name')
    false
    
  init: (core) ->
  
  filter: (list, query) ->
    _.filter list.models, (item) ->
      return @itemContains item, query
    
  itemContains: (item, needle) ->
    item.get('name').indexOf(query) == 0
    
  itemToString: (item) ->
    item.get 'name'
  
  stringToItem: (string) ->
    tag = new MyGovBar.Models.Tag()
    tag.set 'name', string
    tag

class MyGovBar.Views.Tags extends Backbone.View
  el: "#drawer"
  template: $('#tags_template').html()
  
  render: =>
    MyGovBar.router.expand() unless $('#bar').hasClass 'expanded'
      
    @$el.html JST.tags( page: @model.toJSON(), tags: @model.get('tags').toJSON() )
    $('#tag_list').textext
      plugins: 'tags autocomplete suggestsions ajax'
      tagsItems: @model.get('tags').models
      itemManager: MyGovBar.TagManager
      ajax:
        url: MyGovBar.config.api_url + '/tags.json'

    #hijack the setSuggestions event so that we can
    #pass backbone objects to TagManager, rather than JSON objects
    #todo: I think we can use the ext argument to do this smarter
    $('#tag_list').unbind 'setSuggestions'
    $('#tag_list').on setSuggestions: (e, data) ->
      tags = []
      _.each data.result, (tag) ->
        tags.push new MyGovBar.Models.Tag tag
      data.result = tags
      $('#tag_list').textext()[0].autocomplete().onSetSuggestions e, data
    
    $('#tag_list').on 'setFormData', (e, data) ->
      MyGovBar.page.get('tags').update data
      
class CrossDomain

  bar: $('#bar')

  constructor: ->
    parts = decodeURIComponent( document.location.hash.replace(/^#/, '') ).match(/([^:]+:\/\/.[^/]+)/)
    if !parts?
      return
      
    @parent_url = parts[1]
    XD.receiveMessage @recieve, @parent_url
    Backbone.history.on 'route', @sendHeight

  recieve: (msg) =>
    MyGovBar.router.navigate msg.data, true
    
  send: (msg) =>
    XD.postMessage msg, @parent_url

  #tell the parent page to update the height of the iframe
  sendHeight: =>
    @send 'height-' + @bar.height() + 'px'

MyGovBar.CrossDomain = new CrossDomain()
class Router extends Backbone.Router

  routes:
    "hidden": "hide"
    "expanded": "expand"
    "related": "related"
    "tags": "tags"
    "search": "search"
    "search/:query": "searchResult"
    "feedback": "feedback"
    "mini": "mini"
    "*path": "minify"

  initialize: ->
    MyGovBar.page = new MyGovBar.Models.Page()
    Backbone.history.on 'route', @setCurrent
    window.onbeforeunload = ->
      sessionStorage.myGovBarExpanded = Backbone.history.fragment != "mini" and Backbone.history.fragment != "hidden"
      return
      
  mini: ->
    MyGovBar.CrossDomain.send 'mini'
    new MyGovBar.Views.Mini(model: MyGovBar.page).render()
    
  minify: ->
    @navigate 'mini', true
    
  expand: ->
    MyGovBar.CrossDomain.send 'expanded'
    new MyGovBar.Views.Expanded().render()
    @setCurrent()
    
  hide: ->
    MyGovBar.CrossDomain.send 'hidden'
    new MyGovBar.Views.Hidden().render()
  
  tags: ->
    new MyGovBar.Views.Tags(model: MyGovBar.page).render()
    
  related: ->
    new MyGovBar.Views.Related( model: MyGovBar.page).render()
    
  search: ->
    new MyGovBar.Views.Search().render()
    
  searchResult: (query) ->
    collection = new MyGovBar.Collections.SearchResults query: query
    collection.fetch()
    new MyGovBar.Views.SearchResult collection: collection

  feedback: ->
    new MyGovBar.Views.Feedback(model: MyGovBar.page).render()
    
  setCurrent: ->
    tab = Backbone.history.fragment
    tab = "search search-result" if tab.indexOf("search/") != -1
    $('#tabs li.current').removeClass 'current'
    $('#tabs li.' + tab).addClass 'current'
    $('#bar').removeClass MyGovBar.config.tabs.join(" ") + " search-result"
    $('#bar').addClass tab
    
  go: (hash, e) ->
    e.preventDefault() if e?
    @navigate hash, true
    false
    
MyGovBar.router = new Router()
_.each MyGovBar.config.tabs, (tab) ->
  $("#tabs ." + tab).addClass "activated"
  
Backbone.history.start()

if sessionStorage.myGovBarExpanded? and sessionStorage.myGovBarExpanded is "true"
  MyGovBar.router.navigate 'expanded', true
