class CrossDomain
    
    constructor: ->
      @parent_url = decodeURIComponent( document.location.hash.replace(/^#/, '') ).match(/([^:]+:\/\/.[^/]+)/)[1]
      XD.receiveMessage @recieve, @parent_url
      
    recieve: (msg) =>
      switch msg.data
        when "shown", "hidden" then @toggleVisibility()
      
    send: (msg) =>
      XD.postMessage msg, @parent_url

    toggleVisibility: ->
      MyGovBar.el.toggleClass 'hidden'
      MyGovBar.el.toggleClass 'shown'
      
MyGovBar.CrossDomain = new CrossDomain()