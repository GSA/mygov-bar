class CrossDomain
    
    bar: $('#bar')
    
    constructor: ->
      parts = decodeURIComponent( document.location.hash.replace(/^#/, '') ).match(/([^:]+:\/\/.[^/]+)/)
      if !parts?
        return
        
      @parent_url = parts[1]
      XD.receiveMessage @recieve, @parent_url
      
    recieve: (msg) =>
      MyGovBar.Router.navigate msg.data, true
      
    send: (msg) =>
      XD.postMessage msg, @parent_url
      
MyGovBar.CrossDomain = new CrossDomain()