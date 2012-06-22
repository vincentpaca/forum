class Topic
  include Mongoid::Document

  field :title, type: String
  field :code, type: String
  
  validates_uniqueness_of :title, :code
  
  has_many :posts
end


