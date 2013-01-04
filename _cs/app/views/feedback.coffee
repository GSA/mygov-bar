class MyGovBar.Views.Feedback extends Backbone.View
  el: "#drawer"
  saveOnChange: false
  
  events:
    "submit #feedback": "submitComment"
  
  render: ->
    MyGovBar.router.expand() unless $('#bar').hasClass 'expanded'
    @$el.html JST.feedback()
    @initStars()
        
  saveRating: (value, link) =>
    return unless @saveOnChange
    @model.save rating: value

  submitComment: (e) =>
    input = $('#comment')
    e.preventDefault()
    comment = new MyGovBar.Models.Comment page_id: @model.get 'id'
    comment.on 'sync', @commentSuccess
    comment.save body: input.val()
    input.val('')
    false
    
  commentSuccess: ->
    $('#comment_submitted').fadeIn().delay(5000).fadeOut()
  
  initStars: ->
    star = $ 'input.star'
    star.rating callback: @saveRating
    star.rating 'select', Math.round( parseFloat( @model.get 'avg_rating' ) ) - 1
    @saveOnChange = true
