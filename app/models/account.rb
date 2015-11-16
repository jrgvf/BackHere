class Account
  include Mongoid::Document

  field :name, type: String

  has_many :sellers, dependent: :destroy
end
