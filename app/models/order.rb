class Order
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Multitenancy::Document

  tenant(:account)

  field :remote_id,         type: String
  field :store_id,          type: String
  field :placed_at,         type: String
  field :total_price,       type: String
  field :placed_in,         type: String
  field :payment_method,    type: String

  belongs_to :status,       inverse_of: nil
  belongs_to :customer

  embeds_one  :billing_address,   class_name: "Address",        cascade_callbacks: true
  embeds_one  :shipping_address,  class_name: "Address",        cascade_callbacks: true
  embeds_one  :shipping,          class_name: "ShippingInfo",   cascade_callbacks: true
  embeds_many :items,             class_name: "Item",           cascade_callbacks: true
  embeds_many :trackings,         class_name: "StatusHistory",  cascade_callbacks: true

  validates_presence_of :remote_id, :placed_at, :total_price, :status, :customer, :billing_address, :items
  validates :remote_id, uniqueness: { case_sensitive: false }

  accepts_nested_attributes_for :status, :billing_address, :shipping_address, :shipping, :items, :trackings

end