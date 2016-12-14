class Message
  include Mongoid::Document
  field :from_email, type: String
  field :to_email, type: String
  field :msg_ref, type: String
  #belong_to :user
end
