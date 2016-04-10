class Address
  include Mongoid::Document

  field :customer_name,     type: String
  field :street,            type: String
  field :number,            type: String
  field :city,              type: String
  field :region,            type: String
  field :post_code,         type: String
  field :country,           type: String
  field :phone,             type: String

  embedded_in :order, inverse_of: :billing_address
  embedded_in :order, inverse_of: :shipping_address

  validates_presence_of :customer_name, :street, :city, :post_code, :country

end