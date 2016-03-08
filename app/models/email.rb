class Email
  include Mongoid::Document
  include Mongoid::Timestamps
  include Backhere::VerifiableObject

  embedded_in :customer

  field :address,         type: String
  field :is_valid,        type: Boolean,    default: false
  field :verified,        type: Boolean,    default: false

  validates_presence_of :address
  
end
