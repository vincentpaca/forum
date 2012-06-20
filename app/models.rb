class User
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  
  field :fb_id, type: Integer
  field :name, type: String
  field :access_token, type: String
  field :last_login, type: DateTime

  def first_name
    self.name.split.first
  end

  def is_online?
    now = Time.now.to_i
    login = self.last_login.to_i

    (now - login).floor / 60 < 10
  end
  
  has_many :posts
  has_many :comments
end

class Topic
  include Mongoid::Document

  field :title, type: String
  field :code, type: String
  
  validates_uniqueness_of :title, :code
  
  has_many :posts
end

class Post
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
 
  belongs_to :topic
  belongs_to :user
  has_many :comments
  
  field :title, type: String
  field :content, type: String
end

class Comment
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  belongs_to :post
  belongs_to :user

  field :content, type: String
end
