class Phone
  include Mongoid::Document
  include Mongoid::Timestamps

  field :country_code,    type: Integer,     default: 55
  field :region_code,     type: Integer
  field :number,          type: Integer
  field :is_valid,        type: Boolean,    default: false
  field :verified,        type: Boolean,    default: false
  field :type,            type: String
  field :location,        type: String
  field :is_mobile,       type: Boolean,    default: false

  validates :country_code, presence: true, numericality: { only_integer: true }
  validates :region_code, presence: true, numericality: { only_integer: true }
  validates :number, presence: true, numericality: { only_integer: true }

  embedded_in :customer

  scope :verifieds,     -> { where(verified: true) }
  scope :not_verifieds, -> { where(verified: false) }
  scope :valids,        -> { where(verified: true, is_valid: true) }
  scope :invalids,      -> { where(verified: true, is_valid: false) }
  scope :valids_mobile, -> { where(verified: true, is_valid: true, is_mobile: true) }

  def is_valid?
    self[:is_valid]
  end

  def verified?
    self[:verified]
  end

  def is_mobile?
    self[:is_mobile]
  end

  def full_phone
    "+#{country_code} (#{region_code}) #{number}"
  end

  def full_number
    "#{country_code}#{region_code}#{number}"
  end

end