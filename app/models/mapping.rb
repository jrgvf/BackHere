class Mapping
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Multitenancy::Document

  tenant(:account)

  belongs_to :status_type,  inverse_of: nil

  validates_presence_of :status_type

  accepts_nested_attributes_for :status_type

  def type
    status_type.code
  end

end