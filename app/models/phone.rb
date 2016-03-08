class Phone
  include Mongoid::Document
  include Mongoid::Timestamps
  include Backhere::VerifiableObject

  embedded_in :customer

  field :country_code,    type: String,     default: '+55'
  field :region_code,     type: String
  field :number,          type: String
  field :is_valid,        type: Boolean,    default: false
  field :verified,        type: Boolean,    default: false

  validates_presence_of :country_code, :region_code, :number

end