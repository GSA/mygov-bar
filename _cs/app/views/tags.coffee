class MyGovBar.TagManager
  compareItems: (a,b) ->
    return true if a.get('name') is b.get('name')
    false
    
  init: (core) ->
  
  filter: (list, query) ->
    _.filter list.models, (item) ->
      return @itemContains item, query
    
  itemContains: (item, needle) ->
    item.get('name').indexOf(query) == 0
    
  itemToString: (item) ->
    item.get 'name'
  
  stringToItem: (string) ->
    tag = new MyGovBar.Models.Tag()
    tag.set 'name', string
    tag

class MyGovBar.Views.Tags extends Backbone.View
  el: "#drawer"
  template: $('#tags_template').html()
  
  render: =>
    MyGovBar.router.expand() unless $('#bar').hasClass 'expanded'
      
    @$el.html MyGovBar.Templates.tags( page: @model.toJSON(), tags: @model.get('tags').toJSON() )
    $('#tag_list').textext
      plugins: 'tags autocomplete suggestsions ajax'
      tagsItems: @model.get('tags').models
      itemManager: MyGovBar.TagManager
      ajax:
        url: MyGovBar.config.api_url + '/tags.json'

    #hijack the setSuggestions event so that we can
    #pass backbone objects to TagManager, rather than JSON objects
    #todo: I think we can use the ext argument to do this smarter
    $('#tag_list').unbind 'setSuggestions'
    $('#tag_list').on setSuggestions: (e, data) ->
      tags = []
      _.each data.result, (tag) ->
        tags.push new MyGovBar.Models.Tag tag
      data.result = tags
      $('#tag_list').textext()[0].autocomplete().onSetSuggestions e, data
    
    $('#tag_list').on 'setFormData', (e, data) ->
      MyGovBar.page.get('tags').update data
      