class MyGovBar.Views.Feedback extends Backbone.View
  el: "#drawer"
  #saveOnChange: false
  
  events:
    "submit #feedback": "submitComment"
  
  render: ->
    MyGovBar.router.expand() unless $('#bar').hasClass 'expanded'
    @$el.html MyGovBar.Templates.feedback()
    @$('#stars').raty
      #score: @model.get 'avg_rating'
      width: "200px"
      click: @saveRating
    
  saveRating: (value, event) =>
    rating = new MyGovBar.Models.Rating page_id: @model.get 'id'
    rating.save value: value

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
  
