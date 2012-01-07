class NewPost
  @queue = :new_post
  
  def self.perform(post_id)
    post = Post.find post_id
    
    # collect followers
    followers = []
    post.cached_tags.each {|tag_id| followers += $redis.smembers("tag:#{tag_id}:cached_followers")}
    followers += $redis.smembers("user:#{post.user_id}:cached_followers")
    followers.uniq!
    
    # write into their timeline
    followers.each do |follower|
      $redis.lpush("user:#{follower}:cached_timeline", post_id)
    end
  end
end
