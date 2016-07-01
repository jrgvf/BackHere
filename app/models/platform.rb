class Platform
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Multitenancy::Document

  tenant(:account)
  belongs_to :account

  field :name,                    type: String
  field :last_customer_update,    type: DateTime
  field :last_order_update,       type: DateTime
  field :time_zone,               type: String,     default: 'Brasilia'
  field :start_date,              type: Date

  validates_presence_of :name, :start_date, :time_zone
  validates :name, uniqueness: { scope: [:account], case_sensitive: false }
  
  validates_inclusion_of :time_zone, in: :time_zone_enum

  def time_zone_enum
    ['Brasilia', 'UTC']
  end

  def platform_name
    raise NotImplementedError
  end

  def fetch_customers
    raise NotImplementedError
  end

  def fetch_orders
    raise NotImplementedError
  end

  def synchronizer
    raise NotImplementedError
  end

  def sidekiq_queue
    :default
  end

  def self.queue(platform_id)
    platform = Platform.find(platform_id)
    platform.present? ? platform.sidekiq_queue : :default
  end

end
