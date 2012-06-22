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


