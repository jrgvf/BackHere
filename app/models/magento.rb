class Magento < Platform
  include Mongoid::Document

  field :api_user,             type: String
  field :api_key,              type: String
  field :api_url,              type: String
  field :version,              type: String

  validates_presence_of :api_user, :api_key, :api_url, :version

  def platform_name
    "Magento"  
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

end
