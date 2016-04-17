class ShippingInfo
  include Mongoid::Document

  field :method,            type: String
  field :description,       type: String
  field :price,             type: Float
  field :discount,          type: Float,    default: 0

  embedded_in :order, inverse_of: :shipping

  validates_presence_of :method, :description, :price, :discount

end