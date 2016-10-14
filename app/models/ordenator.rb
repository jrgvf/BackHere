 class Ordenator
  include Mongoid::Document
  include Mongoid::Multitenancy::Document

  tenant(:account)

  belongs_to :survey
  belongs_to :question

  field :position,  type: Integer

end