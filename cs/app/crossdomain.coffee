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