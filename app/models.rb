class User
  include Mongoid::Document
  
  field :fb_id, type: Integer
  field :name, type: String
  field :access_token, type: String

  def first_name
    self.name.split.first
  end

end

class Topic
  include Mongoid::Document

  field :title, type: String
  
  validates_uniqueness_of :title

  def urlify
    self.title.downcase.gsub(" ", "_")
  end
end

class String
  def titlefy
    self.split("_").each { |word| word.capitalize! }.join(" ")
  end
end
