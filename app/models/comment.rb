class Comment
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  belongs_to :post
  belongs_to :user

  field :content, type: String
end
