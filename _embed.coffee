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
            #console.log "cross iframe request blocked. Domains " + e.origin + " and " + source_origin + " must match."
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
return if MyGovLoader?

class MyGovLoader
  
  # settings
  rootUrl: '{{ site.url }}' #domain of iframe to embed
  scrollTrigger: '{{ site.trigger }}' # % down document to display discovery bar
  widthMinimized: '{{ site.width_minimized }}' # % of screen to consume when minimized
  minWidth: '{{ site.minWidth }}' #minimum width to allow "mini mode" to go before snapping to collapsed by default
  #minWidth: '100%' #minimum width to allow "mini mode" to go before snapping to expanded by default
  animationSpeed: '{{ site.animation_speed }}'
  config: {}
  
  # css to be applied to iframe
  style:
    position: 'fixed'
    bottom: 0
    left: 0
    background: 'transparent'
    width: '100%'
    display: 'block'
    height: '57px'
    border: 0
    'z-index': 9999999
    overflow: 'hidden'
    '-webkit-transition': "height {{ site.animation_speed }}ms, width {{ site.animation_speed }}ms"
    '-moz-transition': "height {{ site.animation_speed }}ms, width {{ site.animation_speed }}ms"
    '-ms-transition': "height {{ site.animation_speed }}ms, width {{ site.animation_speed }}ms"
    '-o-transition': "height {{ site.animation_speed }}ms, width {{ site.animation_speed }}ms"
    'transition': "height {{ site.animation_speed }}ms, width {{ site.animation_speed }}ms"
  
  # state and other instance variables
  isLoaded: false
  id: 'myGovBar'
  el: false
  state: 'shown'
  
  # fire on init
  constructor: ->

    @config extends MyGovConfig if MyGovConfig?    
    @config.url = encodeURIComponent document.location.href.replace /\/$/, ''
    return if @config.load is false

    @show()
    
    @addEvent window, 'resize', @onResize
    @onResize()
    
  # add event listener to dom (cross browser)
  addEvent: (el, event, func ) ->
    
    if ( el.addEventListener )
      el.addEventListener event, func, false
       
    #IE<9 Support    
    else if (el.attachEvent)
      el.attachEvent "on" + event, func

  onResize: =>
    if window.innerWidth < @minWidth and @state is "shown"
      @maximize()
      @send 'collapsed'
    
  # cross-browser position of top of window relative to top of document
  # see http://help.dottoro.com/ljnvjiow.php
  positionTop: ->
    return window.pageYOffset if window.pageYOffset?
    return html.scrollTop if html.scrollTop?
    return body.scrollTop if body.scrollTop?
    0
        
  # cross-browser total document height
  #see http://james.padolsey.com/javascript/get-document-height-cross-browser/
  pageHeight: ->
    Math.max(
        Math.max(document.body.scrollHeight, document.documentElement.scrollHeight),
        Math.max(document.body.offsetHeight, document.documentElement.offsetHeight),
        Math.max(document.body.clientHeight, document.documentElement.clientHeight)
    )
  
  # cross-browser height of window
  windowHeight: ->
    window.innerHeight || html.clientHeight  || body.clientHeight || screen.availHeight
  
  # percentage of page scrolled (~0 to ~100)  
  offsetBottom: ->
    100 * ( @positionTop() + @windowHeight() ) / @pageHeight()

  configSerialized: ->
    (@toParam key, value for key, value of @config).join "&"
  
  toParam: (key,value) ->
    return unless value?
    return key + "=" + value unless typeof value is "object"
    return (@toParam key, v for v in value).join "&"
    
  # append iframe to parent page    
  load: (callback) ->
    
    @el = document.createElement 'iframe'
    @el.name = @id
    @el.id = @id
    @el.src = @rootUrl + '/mygov-bar.html#' + @configSerialized()
    
    for key,value of @style
      @el.style[key] = value

    document.body.appendChild @el
    @addPageMargin()
    
    XD.receiveMessage @receive, @rootUrl.match(/([^:]+:\/\/.[^/]+)/)[1]
    @isLoaded = true
    
    if callback?
      callback()

  # add margin to page (we do not just want to add to document.body.style['marginBottom']
  # because of all kinds of potential issues with adding margins with different units)
  addPageMargin: ->
    div = document.createElement 'div'
    div.id = @id + 'Margin'
    div.style.height = @style.height
    document.body.appendChild div
    
  #set width of MyGovBar iframe
  setWidth: (width) ->
    @el.style.width = width
  
  # iframe is asking us to adjust height
  setHeight: (height) ->
    @el.style.height = height
    
  # show iframe
  show: =>
    if !@isLoaded
      return @load @show
    if @state is 'shown'
      return
    @el.style.display = 'block'
    @setState 'shown'

  # hide iframe
  # first, send the hidden message to start the hide animation
  # once the animation is complete, hide the iframe
  # note: we check that @state is still "hidden" in case the user
  # scrolled > 80% and then back > 80% while the animation was working
  hide: ->
    if @state is 'hidden'
      return   
    @setState 'hidden'
    @minimize
    #setTimeout =>
    #  @el.style.display = 'none' if @state = "hidden"
    #, @animationSpeed
    
  maximize: ->
    @setWidth '100%'
    
  minimize: ->
    @setWidth @width_minimized
       
  send: (msg) ->
    iframe = document.getElementById @id
    XD.postMessage msg, iframe.src, frames.myGovBar
    
  receive: (msg) =>
    msg = msg.data.split "-"
    switch msg[0]
      when "expanded" then @maximize()
      when "hidden" then @hide()
      when "height" then @setHeight msg[1]
  
  setState: (state) ->
    @state = state
    @send state

window.MyGovLoader = new MyGovLoader()