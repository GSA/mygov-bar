_.each MyGovBar.config.tabs, (tab) ->
  $("#tabs ." + tab).addClass "activated"
  
Backbone.history.start()

if sessionStorage.myGovBarExpanded? and sessionStorage.myGovBarExpanded is "true"
  MyGovBar.router.navigate 'expanded', true
