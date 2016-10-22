 class Kpi
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Multitenancy::Document

  tenant(:account)

  field :qualifies, type: Integer,  default: 9
  field :detracts,  type: Integer,  default: 6

  belongs_to :question

  validates_presence_of :question_id, allow_blank: false
  validates_inclusion_of :qualifies, :detracts, in: :notes_enum

  def responses
    LinearScaleResponse.where(question_id: self.question_id)
  end

  def notes_enum
    (0..10)
  end

end