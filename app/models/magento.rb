class Magento < Platform
  include Mongoid::Document

  field :api_user,             type: String
  field :api_key,              type: String
  field :api_url,              type: String
  field :version,              type: String,  default: "1.X"

  def platform_name
    "Magento"  
  end

  def version_enum
    ["1.X", "2.X"]
  end

end
