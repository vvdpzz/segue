class User < ActiveRecord::Base
  attr_accessible :provider, :uid, :name, :nickname, :email, :bio, :location, :avatar_url, :html_url
  
  has_many :posts

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
end
