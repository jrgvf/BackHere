class Platform
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Multitenancy::Document

  tenant(:account)
  belongs_to :account

  field :name,                    type: String
  field :last_customer_update,    type: DateTime
  field :time_zone,               type: String,     default: 'Brasilia'

  validates_presence_of :name

  def platform_name
    raise NotImplementedError
  end

  def fetch_customers
    raise NotImplementedError
  end

  def synchronizer
    raise NotImplementedError
  end

  def sidekiq_queue
    :default
  end

  def self.platform_queue(platform_id)
    platform = Platform.find(platform_id)
    platform.present? ? platform.sidekiq_queue : :default
  end

end
