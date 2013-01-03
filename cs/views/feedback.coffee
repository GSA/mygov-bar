class MyGovBar.Views.Feedback extends Backbone.View
  el: "#drawer"
  template: $('#feedback_template').html()
    
  render: ->
    MyGovBar.Router.expand() unless $('#bar').hasClass 'expanded'
    compiled = _.template @template
    @$el.html compiled()
    $('input.star').rating callback: @saveRating
  
  saveRating: (value, link) =>
    @model.save rating: value
