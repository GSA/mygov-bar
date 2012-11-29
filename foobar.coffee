class MyGovLoader
  
  rootUrl: 'http://localhost:4000/'
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
    width: '20%'
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
    el.id = @id
    el.src = @rootUrl + 'mygov-bar.html'    
    
    for key,value of @style
      el.style[key] = value

    document.body.appendChild el
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
  
    @setWidth '20%';
    @state = 'shown'
  
  #hide iframe
  hide: ->
    
    if @state is 'hidden'
      return
    console.log 'hiding'
    @setWidth '0px'
    @state = 'hidden'
        
    
window.MyGovLoader = new MyGovLoader()
