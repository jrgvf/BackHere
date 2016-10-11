class Item
  include Mongoid::Document

  field :remote_id,         type: String
  field :sku,               type: String
  field :name,              type: String
  field :quantity,          type: Integer
  field :type,              type: String
  field :weight,            type: Float
  field :price,             type: Float
  field :original_price,    type: Float
  field :discount,          type: Float
  field :total_price,       type: Float
  field :total_weight,      type: Float

  embedded_in :order

  # validates_presence_of :remote_id, :sku, :name, :quantity, :weight, :price, :original_price, :discount, :total_price, :total_weight
  validates_presence_of :quantity, :price, :original_price, :total_price

end