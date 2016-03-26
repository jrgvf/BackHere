class Phone
  include Mongoid::Document
  include Mongoid::Timestamps

  field :country_code,    type: Integer,     default: 55
  field :region_code,     type: Integer
  field :number,          type: Integer
  field :is_valid,        type: Boolean,    default: false
  field :verified,        type: Boolean,    default: false

  validates :country_code, presence: true, numericality: { only_integer: true }
  validates :region_code, presence: true, numericality: { only_integer: true }
  validates :number, presence: true, numericality: { only_integer: true }

  embedded_in :customer

  def is_valid?
    self[:is_valid]
  end

  def verified?
    self[:verified]
  end

  def full_phone
    "+#{country_code} (#{region_code}) #{number}"
  end

end