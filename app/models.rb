class User
  include Mongoid::Document
  
  field :fb_id, type: Integer
  field :name, type: String
  field :access_token, type: String

  def first_name
    self.name.split.first
  end
  
  has_many :posts
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
  
  belongs_to :topic
  belongs_to :user
  
  field :title, type: String
  field :content, type: String
end
