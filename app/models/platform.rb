class Platform
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Multitenancy::Document

  tenant(:account)

  field :name,                 type: String
  field :url,                  type: String
  field :specific_version,     type: String

  validates_presence_of :name, :url

  def platform_name
    raise NotImplementedError 
  end

  def name
    self[:name]
  end

end
