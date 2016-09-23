 class Tag
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Multitenancy::Document

  tenant(:account)

  field :name,          type: String

  validates_presence_of :name, allow_blank: false
  validates_uniqueness_of :name

end