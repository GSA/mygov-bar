class MyGovLoader
  
  #settings
  rootUrl: '{{ site.url }}' #domain of iframe to embed
  scrollTrigger: '{{ site.trigger }}' # % down document to display discovery bar
  widthMinimized: '{{ site.widthMinimized }}' # % of screen to consume when minimized
  minWidth: '{{ site.minWidth }}' #minimum width to allow "mini mode" to go before snapping to expanded by default
  
  #css to be applied to iframe
  style:
    position: 'fixed'
    bottom: 0
    left: 0
    background: 'transparent'
    width: '{{ site.widthMinimized }}'
    display: 'none'
    height: '268px'
    border: 0
    'z-index': 9999999
    overflow: 'hidden'
  
  #state and other instance variables
  isLoaded: false
  id: 'myGovBar'
  el: false
  state: 'hidden'
  
  #fire on init
  constructor: ->
    @addEvent document, 'scroll', @onScroll 
    @addEvent window, 'resize', @onResize
    @onResize()
    
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
    else if @offsetBottom() < @scrollTrigger 
      @hide()
      
  onResize: =>
    if window.innerWidth < @minWidth and @isShown()
      @maximize()
      @send 'expanded'
    
  #cross-browser position of top of window relative to top of document
  #see http://help.dottoro.com/ljnvjiow.php
  positionTop: ->
    return window.pageYOffset if window.pageYOffset?
    return html.scrollTop if html.scrollTop?
    return body.scrollTop if body.scrollTop?
    0
        
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
  load: (callback) ->
    @el = document.createElement 'iframe'
    @el.name = @id
    @el.id = @id
    @el.src = @rootUrl + '/mygov-bar.html#' + encodeURIComponent document.location.href    
    
    for key,value of @style
      @el.style[key] = value

    document.body.appendChild @el
    XD.receiveMessage @recieve, @rootUrl.match(/([^:]+:\/\/.[^/]+)/)[1]
    @isLoaded = true
    
    if callback?
      callback()
  
  #bar minimized
  isMinimized: ->
    @el.style.width == @widthMinimized
    
  #set width of MyGovBar iframe
  setWidth: (width) ->
    @el.style.width = width
  
  #iframe is asking us to adjust height
  setHeight: (height) ->
    @el.style.height = height
    
  #show iframe
  show: =>
        
    if @state is 'shown'
      return
    
    if !@isLoaded
      return @load @show
    
    @el.style.display = 'block'
    @setState 'shown'

  #hide iframe
  hide: ->
  
    if @state is 'hidden'
      return
          
    @setState 'hidden'
    setTimeout =>
      @el.style.display = 'none'
    , 1200
    
  maximize: ->
    @setWidth '100%'
    
  minimize: ->
    @setWidth @widthMinimized
   
  send: (msg) ->
    iframe = document.getElementById @id
    XD.postMessage msg, iframe.src, frames.myGovBar
    
  recieve: (msg) =>
    msg = msg.data.split "-"
    switch msg[0]
      when "mini" then @minimize()
      when "expanded" then @maximize()
      when "height" then @setHeight msg[1]
  
  setState: (state) ->
    @state = state
    @send state
    
    
window.MyGovLoader = new MyGovLoader()