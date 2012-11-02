class MyGovLoader
    
    el: 'logo'
    css: ['css/mygov-bar.css']
    js: ['js/mygov-bar.js']
    loaded: false
    
    init: ->
        el = document.getElementById @el
        
        el.href = "#"
        
        if ( el.addEventListener )
            el.addEventListener( 'click', @load, false )
       
        #IE<9 Support    
        else if (el.attachEvent)
            el.attachEvent( 'onclick', @load )
    
    loadCSS: (src) ->
        css = document.createElement 'link'
        css.rel = 'stylesheet'
        css.href = src
        document.body.appendChild css
        
    loadJS: (src) ->
        script = document.createElement 'script'
        script.src = src
        document.body.appendChild script

    load: =>
        
        if @loaded
            return false
            
        @loadCSS src for src in @css
        @loadJS src for src in @js
        
        @loaded = true
        return false

loader = new MyGovLoader
loader.init()