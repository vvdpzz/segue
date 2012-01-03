class PostsController < ApplicationController
  # respond_to :json
  
  def create
    post = Post.new params[:post]
    if post.save
      hash = {key: 0, comment: "Success", post: post}
    else
      hash = {key: 1, comment: "Database error"}
    end
    render :json => hash, status: :ok
  end
end
