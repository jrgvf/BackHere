class Email
  include Mongoid::Document
  include Mongoid::Timestamps

  field :address,         type: String
  field :is_valid,        type: Boolean,    default: false
  field :verified,        type: Boolean,    default: false

  validates_presence_of :address
  validates_format_of :address, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  embedded_in :customer

  def is_valid?
    self[:is_valid]
  end

  def verified?
    self[:verified]
  end

end
