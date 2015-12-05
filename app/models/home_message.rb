class HomeMessage
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :email, type: String
  field :fone, type: Integer
  field :message, type: String

  validates_presence_of :name, :email, :message
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create
  validates :fone, numericality: true, length: { minimum: 10, maximum: 12 }
  validates_uniqueness_of :message, scope: :email

end