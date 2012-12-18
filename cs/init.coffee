_.each MyGovBar.config.tabs, (tab) ->
  $("#tabs ." + tab).addClass "activated"