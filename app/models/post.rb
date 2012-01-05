class Post < ActiveRecord::Base
  include Twitter::Extractor
  
  # relations
  belongs_to :user, :counter_cache => true
  has_many :post_tags
  
  # scopes
  default_scope order("created_at desc")
  
  # callbacks
  before_create :set_user_properties
  after_create :asyncs
  
  # sphinx index
  define_index do
    indexes text
    has created_at
  end
  
  protected
    def set_user_properties
      self.name = self.user.name
      self.nickname = self.user.nickname
      self.avatar_url = self.user.avatar_url
    end

    def asyncs
      Resque.enqueue(ExtractTag, self.id)
    end
end
