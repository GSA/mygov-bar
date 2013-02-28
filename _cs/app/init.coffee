_.each MyGovBar.config.tabs, (tab) ->
  $("#tabs ." + tab).addClass "activated"
  
Backbone.history.start()

#ET phones home (in case html or subsequent JS is cached)
#ping.js is an empty static file served directly by the webserver,
#but this could changed to an image or rails controller action
$.getJSON "{{ site.api_url }}/ping.js?src=embed&url=" + MyGovBar.config.parent_url + "&callback=?"

if sessionStorage.myGovBarExpanded? and sessionStorage.myGovBarExpanded is "true"
  MyGovBar.router.navigate 'expanded', true
