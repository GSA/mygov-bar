#Conditionally load jQuery
#inspired by http://bit.ly/cFPMER

#function to fire once jQuery is loaded
init = ->
  jQuery(document).ready ($) ->
    $('body').append('<script src="http://gsa-ocsit.github.com/mygov-bar/embed-code.js"></script>')
    
#conditionally load jQuery
maybeLoadJq = ->
  if !jQuery? 
    jQ = document.createElement 'script'
    jQ.type = 'text/javascript'
    jQ.onload = jQ.onreadystatechange = init
    jQ.src = '//ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js';
    document.body.appendChild(jQ);
  else 
    init()
  
# Source: http://bit.ly/TWwg2z

if window.addEventListener #W3C
  window.addEventListener 'load', maybeLoadJq, false 
  
else if window.attachEvent #IE
  window.attachEvent 'onload', maybeLoadJq

