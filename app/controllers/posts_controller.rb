class PostsController < ApplicationController
  def create
    Post.new params[:post]
    if post.save
  end
end
