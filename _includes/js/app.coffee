class MyGovBar
    el: $ "#bar"
    
    init: ->
        $("#logo").click( @toggle )
        $('.toggle_pane').click( @togglePane )
        @toggle()
        
    hide: =>
        $('.popout').animate({'height': 0}, 200).promise().done( =>
            $('.expanded').removeClass 'expanded'
            @el.animate {width: "0%"}, 1000
        )
 
    show: =>
        @el.animate {width: "75%"}, 1000
    
    toggle: =>
        if ( @el.css( 'width') == "0px" )
            @show()
        else
            @hide()
            
    togglePane: (e) ->
        e.preventDefault
        if ( $(@).parent().hasClass('expanded') )
            @hidePane $(@).parent()
        else
            @showPane $(@).parent()
        false
        
    showPane: (pane) ->
        popout = $(pane).children('.popout')
        $(popout).clearQueue()
        $(popout).css 'left', $(this).parent().css('left')
        $(popout).animate {height: "300px"}, 1000
        $(pane).addClass('expanded')
    
    hidePane: (pane) ->
        $(pane).children('.popout').animate {height: 0}, 1000
        $(pane).removeClass('expanded')        

$(document).ready( ->
    window.myGovBar = new MyGovBar()
    myGovBar.init()
)
