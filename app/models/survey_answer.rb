 class SurveyAnswer
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Multitenancy::Document
  include Mongoid::Slug

  tenant(:account)

  belongs_to :survey, inverse_of: :answer

  has_many :responses, class_name: "QuestionResponse", inverse_of: :answer

  validates_presence_of :responses

end