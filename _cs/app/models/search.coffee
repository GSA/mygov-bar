class MyGovBar.Models.SearchResult extends Backbone.Model

class MyGovBar.Collections.SearchResults extends Backbone.Collection

  model: MyGovBar.Models.SearchResult
  
  url: ->
    url = 'https://search.usa.gov/api/search.json?'
    url += 'affiliate=' + MyGovBar.config.search_affiliate
    url += '&query=' + @query
    url += '&callback=?'
    url
  
  parse: (data) ->
 
    #convert unicode encoded highlighting to HTML
    # see https://search.usa.gov/affiliates/3204/api
    _.each data.results, (result) =>
      result[field] = @htmlHighlight result[field] for field in ['title', 'content']
          
    data.results
    
  initialize: (args) ->
    return unless args.query?
    @query = args.query
  

  htmlHighlight: (string) ->
    string.replace(/\ue000/g, '<span class="highlight">').replace(/\ue001/g, '</span>')
