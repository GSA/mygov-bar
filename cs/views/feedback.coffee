class MyGovBar.Views.Feedback extends Backbone.View
  el: "#drawer"
  template: $('#feedback_template').html()
  
  events:
    "submit #feedback": "submitComment"
  
  render: ->
    MyGovBar.Router.expand() unless $('#bar').hasClass 'expanded'
    compiled = _.template @template
    @$el.html compiled()
    star = $('input.star')
    star.rating callback: @saveRating
    star.rating 'select', ( Math.round( parseFloat( @model.get 'avg_rating' ) ) - 1 )
  
  saveRating: (value, link) =>
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