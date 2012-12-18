_.each MyGovBar.config.tabs, (tab) ->
  console.log "#tabs ." + tab
  $("#tabs ." + tab).addClass "activated"