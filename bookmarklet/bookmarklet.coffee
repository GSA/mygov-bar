class myGovBookmarklet

    bootstrap: ->

        if jQuery?
            return @init()
            
        jQ = document.createElement 'script'
        jQ.type = 'text/javascript'
        jQ.onload = jQ.onreadystatechange = @init
        jQ.src = '//ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js'
        document.body.appendChild(jQ);  
    
    init: ->
        script = document.createElement 'script'
        script.src = "http://gsa-ocsit.github.com/mygov-bar/embed-code.js"
        document.body.appendChild script
        
m = new myGovBookmarklet()
m.bootstrap()