App.Views.Posts ||= {}

class App.Views.Posts.IndexView extends Backbone.View
  template: JST["backbone/templates/posts/index"]
  events:
    "submit #new-tweet": "save"
    "click textarea": "rmCondensed"
    "blur textarea": "addCondensed"
    "keyup textarea": "toggleButton"

  initialize: () ->
    @options.posts.bind('reset', @addAll)
    
  rmCondensed: ->
    @$("form").closest(".tweet-box").removeClass("condensed")
  
  addCondensed: ->
    len = @model.get("text").length
    if len == 0
      @$("form").closest(".tweet-box").addClass("condensed")

  toggleButton: (e) ->
    @$(".tweet-counter").val(140 - e.target.value.length)
    if e.target.value.length == 0
      @$("form").find("button").removeClass("primary-btn").addClass("disabled")
    else
      @$("form").find("button").removeClass("disabled").addClass("primary-btn")
  
  save: (e) ->
    e.preventDefault()
    e.stopPropagation()
    that = this
    @collection.create(@model.toJSON(),
      success: (post) =>
        @addOneToHead(post)
        @$("form")[0].reset()
        that.model.set({text: ""})
        @$("form").closest(".tweet-box").addClass("condensed")
        @$("form").find("button").removeClass("primary-btn").addClass("disabled")

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
