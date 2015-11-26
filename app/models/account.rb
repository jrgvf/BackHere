class Account
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, type: String

  has_many :sellers, dependent: :destroy
end
