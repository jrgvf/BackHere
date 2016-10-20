 class SurveyAnswer
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Multitenancy::Document

  tenant(:account)

  belongs_to :survey,   inverse_of: :answer
  belongs_to :customer, inverse_of: :answer

  has_many :responses, class_name: "QuestionResponse", inverse_of: :answer, dependent: :destroy

  validates_presence_of :responses

end