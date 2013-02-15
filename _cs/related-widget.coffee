class MyGovRelated
  
  el: document.getElementById 'MyGovRelated'

  constructor: ->
   script = document.createElement 'script'
   script.src = "{{site.api_url}}/pages?url=" + document.location.href + "&callback=mygovrelated.callback"
   document.body.appendChild script
   
  callback: (data) ->
    return unless data? and data.related? and data.related.length
    @addPage page for page in data.related
    
  addPage: (page) ->
    @el.innerHTML += '<li><a href="' + page.url + '">' + page.title + '</a></li>'
    
window.mygovrelated = new MyGovRelated()