class User
  include Mongoid::Document
  
  field :fb_id, type: Integer
  field :name, type: String
  field :access_token, type: String

end
