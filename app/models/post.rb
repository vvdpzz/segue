class Post < ActiveRecord::Base
  belongs_to :user, :counter_cache => true
end
