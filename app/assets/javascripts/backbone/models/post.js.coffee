class App.Models.Post extends Backbone.Model
  paramRoot: 'post'

  defaults:
    text: null

class App.Collections.PostsCollection extends Backbone.Collection
  model: App.Models.Post
  url: '/posts'