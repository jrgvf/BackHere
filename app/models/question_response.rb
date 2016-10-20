 class QuestionResponse
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Multitenancy::Document

  tenant(:account)

  belongs_to :answer, class_name: "SurveyAnswer" ,inverse_of: :response
  belongs_to :question, inverse_of: nil

  validates_presence_of :answer_id, :question_id, allow_blank: false

  scope :by_question, -> (question_id) { where(question_id: question_id) }

  def self.type
    raise NotImplementedError
  end

  def self.same_type?(type)
    self.type == type
  end

  def option_response?
    false
  end

  def text_response?
    false
  end

  def other_option_response?
    false
  end

  def linear_scale_response?
    false
  end

end