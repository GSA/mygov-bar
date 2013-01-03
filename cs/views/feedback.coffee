class MyGovBar.Views.Feedback extends Backbone.View
  el: "#drawer"
  template: $('#feedback_template').html()
    
  render: ->
    MyGovBar.Router.expand() unless $('#bar').hasClass 'expanded'
    compiled = _.template @template
    @$el.html compiled()
    star = $('input.star')
    star.rating callback: @saveRating
    star.rating 'select', ( Math.round( parseFloat( @model.get 'avg_rating' ) ) - 1 )
  
  saveRating: (value, link) =>
    @model.save rating: value
