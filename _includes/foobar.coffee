class MyGovLoader
  
  #settings
  rootUrl: 'http://localhost:4000' #domain of iframe to embed
  scrollTrigger: 80 # % down document to display disovery bar
  widthExpanded: '100%' # % of screen to take up when expanded
  widthMinimized: '20%' # % of screen to consume when minimized
  
  #css to be applied to iframe
  style:
    position: 'fixed'
    bottom: 0
    left: 0
    background: 'transparent'
    width: '20%'
    display: 'none'
    height: '110px'
    border: 0
    'z-index': 9999999
    overflow: 'hidden'
  
  #state and other instance variables
  isLoaded: false
  id: 'myGovBar'
  el: false
  
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
    @el = document.createElement 'iframe'
    @el.name = @id
    @el.id = @id
    @el.src = @rootUrl + '/mygov-bar.html#' + encodeURIComponent document.location.href    
    
    for key,value of @style
      @el.style[key] = value

    document.body.appendChild @el
    XD.receiveMessage @recieve, @rootUrl
    @isLoaded = true    

  #bar completely hidden
  isHidden: ->
    
    if !@el
      return true
        
    @el.style.display == 'none'
  
  #bar visibile
  isShown: ->
    !@isHidden()
  
  #bar minimized
  isMinimized: ->
    @el.style.widht == @widthMinimized
    
  #set width of MyGovBar iframe
  setWidth: (width) ->
    document.getElementById( @id ).style.width = width
  
  #show iframe
  show: ->
    
    if @isShown()
      return
    
    if !@isLoaded
      @load()
  
    @el.style.display = 'block'
    @send 'shown'
    
  #hide iframe
  hide: ->

    if @isHidden()
      return
    
    @el.style.display = 'none'
    @send 'hidden'
        
  maximize: ->
    @setWidth @widthMaximized
    
  minimize: ->
    @setWidth @widthMinimized
  
  toggleMore: ->
    if @el.style.width is @widthMinimized
      @setWidth @widthExpanded
    else
      @setWidth @widthMinimized
  
  send: (msg) ->
    iframe = document.getElementById @id
    XD.postMessage msg, iframe.src, frames.myGovBar
    
  recieve: (msg) =>
    switch msg.data
      when "toggle" then @toggleMore()
  
window.MyGovLoader = new MyGovLoader()