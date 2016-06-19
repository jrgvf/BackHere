class Email
  include Mongoid::Document
  include Mongoid::Timestamps

  field :address,         type: String
  field :is_valid,        type: Boolean,    default: false
  field :verified,        type: Boolean,    default: false

  validates_presence_of :address

  embedded_in :customer

  scope :verifieds,     -> { where(verified: true) }
  scope :not_verifieds, -> { where(verified: false) }
  scope :valids,        -> { where(verified: true, is_valid: true) }
  scope :invalids,      -> { where(verified: true, is_valid: false) }

  def is_valid?
    self[:is_valid]
  end

  def verified?
    self[:verified]
  end

end
