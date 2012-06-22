class User
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  
  field :fb_id, type: Integer
  field :name, type: String
  field :access_token, type: String
  field :last_login, type: DateTime
  field :is_admin, type: Boolean

  def first_name
    self.name.split.first
  end

  def is_online?
    now = Time.now.to_i
    login = self.last_login.to_i

    (now - login).floor / 60 < 10
  end

  def is_admin?
    self.is_admin
  end
  
  has_many :posts
  has_many :comments
end


