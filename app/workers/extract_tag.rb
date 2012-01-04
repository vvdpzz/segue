class ExtractTag
  @queue = :extract_tag
  
  def self.perform(post_id)
    post = Post.select("id, text").find_by_id post_id
    post.extract_hashtags(post.text).each do |tag|
      post.post_tags.create(:tag => tag)
    end
  end
end
