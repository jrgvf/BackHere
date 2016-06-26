 class Order
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Multitenancy::Document

  tenant(:account)

  field :imported_from,               type: String
  field :remote_id,                   type: String
  field :store_id,                    type: String
  field :placed_at,                   type: DateTime
  field :total_price,                 type: Float
  field :placed_in,                   type: String
  field :payment_method,              type: String
  field :available_for_notification,  type: Boolean,    default: true

  belongs_to :status,       inverse_of: nil
  belongs_to :customer,     inverse_of: nil

  has_many :notifications

  embeds_one  :billing_address,   class_name: "Address",        cascade_callbacks: true
  embeds_one  :shipping_address,  class_name: "Address",        cascade_callbacks: true
  embeds_one  :shipping,          class_name: "ShippingInfo",   cascade_callbacks: true
  embeds_many :items,             class_name: "Item",           cascade_callbacks: true
  embeds_many :trackings,         class_name: "StatusHistory",  cascade_callbacks: true

  validates_presence_of :imported_from, :remote_id, :placed_at, :total_price, :status, :customer, :billing_address, :items
  validates :remote_id, uniqueness: { scope: :imported_from, case_sensitive: false }

  accepts_nested_attributes_for :status, :billing_address, :shipping_address, :shipping, :items, :trackings

  def internal_code
    "(#{imported_from}) ##{remote_id}"
  end

  def self.available_for_notification(account, statuses)
    customer_ids = Customer.available_for_notification.pluck(:id).compact
    self.where(account: account, available_for_notification: true).in(customer_id: customer_ids, status: statuses)
  end

end