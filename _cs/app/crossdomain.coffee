class CrossDomain

  bar: $('#bar')
  hash: document.location.hash
  allowed_params: ['tabs', 'url']

  constructor: ->
    
    params = $.deparam.fragment true
    @setConfig key, value for key, value of params

    XD.receiveMessage @receive, MyGovBar.config.parent_url
    Backbone.history.on 'route', @sendHeight

  receive: (msg) =>
    MyGovBar.router.navigate msg.data, true

  send: (msg) =>
    XD.postMessage msg, MyGovBar.config.parent_url

  #tell the parent page to update the height of the iframe
  sendHeight: =>
    @send 'height-' + @bar.height() + 'px'

  setConfig: (key, value) ->

    return if _.indexOf(@allowed_params, key) is -1

    #todo, rename configs to prevent this collision
    key = "parent_url" if key is "url"

    MyGovBar.config[key] = value

MyGovBar.CrossDomain = new CrossDomain()