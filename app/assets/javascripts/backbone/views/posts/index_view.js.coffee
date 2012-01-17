App.Views.Posts ||= {}

class App.Views.Posts.IndexView extends Backbone.View
  template: JST["backbone/templates/posts/index"]
  events:
    "submit #new-tweet": "save"
    "click textarea": "rmCondensed"
    "blur textarea": "addCondensed"

  initialize: () ->
    @options.posts.bind('reset', @addAll)
    
  rmCondensed: ->
    @$("form").closest(".tweet-box").removeClass("condensed")
  
  addCondensed: ->
    if @model.get("text").length == 0
      @$("form").closest(".tweet-box").addClass("condensed")
  
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
