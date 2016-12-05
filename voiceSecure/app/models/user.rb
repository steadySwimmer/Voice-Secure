class User
  include Mongoid::Document
  field :nickname, type: String
  field :email, type: String
  field :friends, type: Collection
end
