class Magento < Platform

  field :url,                  type: String
  field :api_user,             type: String
  field :api_key,              type: String
  field :api_url,              type: String
  field :version,              type: String
  field :specific_version,     type: String

  validates_presence_of :url, :api_user, :api_key, :api_url, :version

  def platform_name
    "Magento"  
  end

  def worker
    "MagentoWorker"
  end

  def synchronizer
    MagentoSynchronizer.new(self)
  end

  def version_enum
    ["1.X", "2.X"]
  end

  def magento_adapter
    @magento_adapter ||= MagentoAdapter.new(self)
  end

  def get_specific_version
    response = magento_adapter.magento_info
    "#{response[:magento_version]} - #{response[:magento_edition]}"
  end

  def fetch_customers
    magento_adapter.customer_list
  end

end
