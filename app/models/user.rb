class User < ActiveRecord::Base
  include Redis::Objects
  
  attr_accessible :provider, :uid, :name, :nickname, :email, :bio, :location, :avatar_url, :html_url
  
  # relations
  has_many :posts
  
  # sphinx index
  define_index do
    indexes name, :sortable => true
    indexes nickname, :sortable => true
    
    has created_at
  end
  
  # redis objects
  set :cached_followings
  set :cached_followers
  set :cached_tags
  list :cached_timeline
  counter :cached_offset
  # cached New Posts Count
  counter :cached_npc
  
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      if auth['info']
        %w(name nickname email).each do |field|
          user[field] = auth['info'][field] || ""
        end
      end
      if auth['extra']
        %w(bio location avatar_url html_url).each do |field|
          user[field] = auth['extra']['raw_info'][field] || ""
        end
      end
      if auth['credentials']
        user['token'] = auth['credentials']['token'] || ""
      end
    end
  end
  
  def home_timeline(page = 1)
    self.cached_offset.reset if page == 1
    offset = self.cached_offset.value
    from, to = (page - 1) * 20 + offset, (page * 20) + offset - 1
    Post.where(:id => self.cached_timeline[from..to].to_a)
  end
  
  def newest_posts
    npc = self.cached_npc.value
    if npc > 0
      self.cached_npc.reset
      Post.where(:id => self.cached_timeline[0..npc-1].to_a)
    end
  end
  
  def follow_user(friend_id)
    self.id == friend_id ? false : Friendship.find_or_create_by_user_id_and_friend_id(self.id, friend_id)
  end
  
  def unfollow_user(friend_id)
    self.id == friend_id ? false : Friendship.find_by_user_id_and_friend_id(self.id, friend_id).destroy
  end
  
  def follow_tag(tag_id)
    Tagship.find_or_create_by_user_id_and_tag_id(self.id, tag_id)
  end
  
  def unfollow_tag(tag_id)
    Tagship.find_by_user_id_and_tag_id(self.id, tag_id).destroy
  end
  
  # Github
  class << self
    def fetch_repo_and_lang_and_col_from login
      langs, repos, collaborators = {}, [], []
      github = Octokit::Client.new
      github.repos(login).collect{|r| {:fork => r.fork, :name => r.name}}.each do |repo|
        if not repo[:fork]
          langs.merge! github.languages("#{login}/#{repo[:name]}")
          collaborators += github.collaborators("#{login}/#{repo[:name]}").map(&:login)
        end
        repos << repo[:name]
      end
      langs.keys.each {|lang| $redis.sadd("user:#{login}:lang", lang)}
      repos.each {|repo| $redis.sadd("user:#{login}:repo", repo)}
      collaborators.uniq.each{|user| $redis.sadd("user:#{login}:col", user)}
      
      # rm self from collaborators
      $redis.srem("user:#{login}:col", login)
    end
  
    %w(repo lang col).each do |name|
      define_method("#{name}_of") do |login|
        $redis.smembers "user:#{login}:#{name}"
      end
    end
    
    def get_github_followers login
      github = Octokit::Client.new
      github.followers(login)
    end

    def get_github_following login
      github = Octokit::Client.new
      github.following(login)
    end
  end
end
