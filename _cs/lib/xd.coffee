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