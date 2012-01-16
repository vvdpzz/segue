class App.Routers.PostsRouter extends Backbone.Router
  initialize: (options) ->
    @posts = new App.Collections.PostsCollection()
    @posts.reset options.posts

  routes:
    "!/new"      : "newPost"
    "!/index"    : "index"
    "!/:id"      : "show"
    ".*"        : "index"

  newPost: ->
    @view = new App.Views.Posts.NewView(collection: @posts)
    $("#posts").html(@view.render().el)

  index: ->
    @view = new App.Views.Posts.IndexView(posts: @posts)
    $("#posts").html(@view.render().el)

  show: (id) ->
    post = @posts.get(id)

    @view = new App.Views.Posts.ShowView(model: post)
    $("#posts").html(@view.render().el)

  edit: (id) ->
    post = @posts.get(id)

    @view = new App.Views.Posts.EditView(model: post)
    $("#posts").html(@view.render().el)
