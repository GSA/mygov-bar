class MyGovLoader
  
  rootUrl: 'http://gsa-ocsit.github.com/'
  scrollTrigger: 80
  loaded: false
  state: 'hidden'
  id: 'myGovBar'
  
  #css to be applied to iframe
  style:
    position: 'fixed'
    bottom: 0
    left: 0
    background: 'transparent'
    width: '100%'
    height: '110px'
    border: 0
    'z-index': 9999999
    overflow: 'hidden'
  
  #fire on init
  constructor: ->
    @addEvent document, 'scroll', @onScroll 
  
  #add event listener to dom (cross browser)
  addEvent: (el, event, func ) ->
    
    if ( el.addEventListener )
      el.addEventListener event, func, false
       
    #IE<9 Support    
    else if (el.attachEvent)
      el.attachEvent "on" + event, func

  #scroll event listener
  onScroll: =>
    if @offsetBottom() > @scrollTrigger
      @show()
    else 
      @hide()
  
  #cross-browser position of top of window relative to top of document
  #see http://help.dottoro.com/ljnvjiow.php
  positionTop: ->
    window.pageYOffset || body.scrollTop || html.scrollTop
    
  #cross-browser total document height
  #see http://james.padolsey.com/javascript/get-document-height-cross-browser/
  pageHeight: ->
    Math.max(
        Math.max(document.body.scrollHeight, document.documentElement.scrollHeight),
        Math.max(document.body.offsetHeight, document.documentElement.offsetHeight),
        Math.max(document.body.clientHeight, document.documentElement.clientHeight)
    )
  
  #cross-browser height of window
  windowHeight: ->
    window.innerHeight || html.clientHeight  || body.clientHeight || screen.availHeight
  
  #percentage of page scrolled (~0 to ~100)  
  offsetBottom: ->
    100 * ( @positionTop() + @windowHeight() ) / @pageHeight()

  #append iframe to parent page    
  load: ->
    el = document.createElement 'iframe'
    el.name = @id
    el.id = @id
    el.src = @rootUrl + 'mygov-bar/mygov-bar.html#' + encodeURIComponent document.location.href    
    
    for key,value of @style
      el.style[key] = value

    document.body.appendChild el
    XD.receiveMessage @recieve, @rootUrl.replace( /\/$/, '')
    @loaded = true    
  
  #set width of MyGovBar iframe
  setWidth: (width) ->
    document.getElementById( @id ).style.width = width
  
  #show iframe
  show: ->
    
    if @state is 'shown'
      return
    
    if !@loaded
      @load()
  
    @setWidth '100%'
    @state = 'shown'
    @send @state
    
  #hide iframe
  hide: ->
    
    if @state is 'hidden'
      return
    @setWidth '0px'
    @state = 'hidden'
    @send @state
  
  send: (msg) ->
    iframe = document.getElementById @id
    XD.postMessage msg, iframe.src, frames[0] 
    
  recieve: (msg) ->
    alert msg.data
  
window.MyGovLoader = new MyGovLoader()