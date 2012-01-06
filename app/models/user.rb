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
end
