App.Views.Posts ||= {}

class App.Views.Posts.IndexView extends Backbone.View
  template: JST["backbone/templates/posts/index"]
  events:
    "submit #new-post": "save"

  initialize: () ->
    @options.posts.bind('reset', @addAll)
    
  save: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @collection.create(@model.toJSON(),
      success: (post) =>
        @addOneToHead(post)
        @$("form")[0].reset()

      error: (post, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )
    
  addAll: () =>
    @options.posts.each(@addOne)

  addOne: (post) =>
    view = new App.Views.Posts.PostView({model : post})
    @$("#stream-items").append(view.render().el)
  
  addOneToHead: (post) =>
    view = new App.Views.Posts.PostView({model : post})
    @$("#stream-items").prepend(view.render().el)
    @$('time').sensible(option)

  render: =>
    $(@el).html(@template(posts: @options.posts.toJSON() ))
    @addAll()
    @$('time').sensible(option)
    @collection = this.options.posts
    @model = new @collection.model()
    this.$("form").backboneLink(@model)

    return this
