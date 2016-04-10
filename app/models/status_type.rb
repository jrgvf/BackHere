class StatusType
  include Mongoid::Document

  field :label,       type: String
  field :code,        type: Symbol

  validates_presence_of :label, :code
  validates_uniqueness_of :code

end