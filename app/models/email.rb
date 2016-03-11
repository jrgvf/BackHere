class Email
  include Mongoid::Document
  include Mongoid::Timestamps

  field :address,         type: String
  field :is_valid,        type: Boolean,    default: false
  field :verified,        type: Boolean,    default: false

  validates_presence_of :address

  embedded_in :customer

  def is_valid?
    self[:is_valid]
  end

  def verified?
    self[:verified]
  end

end
