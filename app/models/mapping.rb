class Mapping
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Multitenancy::Document

  tenant(:account)

  field :services,    type: Array

  belongs_to :status_type,  inverse_of: nil

  validates_presence_of :status_type, :services

  accepts_nested_attributes_for :status_type

  def type
    status_type.code
  end

  def services_enum
    [
      ["Email", :email],
      ["SMS", :sms]
    ]
  end

  def self.services_enum
    new().services_enum
  end

  def services_names
    services_enum.map {|x| x[0] if services.include?(x[1].to_s) }.compact.join(" | ")
  end

end