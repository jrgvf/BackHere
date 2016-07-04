 class QuestionResponse
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Multitenancy::Document

  tenant(:account)

  field :type,        type: Symbol
  field :text,        type: String
  field :option_id,   type: BSON::ObjectId

  belongs_to :answer, class_name: "SurveyAnswer" ,inverse_of: :response

  belongs_to :question, inverse_of: nil

  validates_presence_of :answer, :question, allow_blank: false
  validates_presence_of :option_id, allow_blank: false, if: :require_option?
  validates_presence_of :text

  scope :by_question, -> (question_id) { where(question_id: question_id) }

  def option
    self.question.options.find_by(original_id: self.option_id)
  end

  def require_option?
    option_response?
  end

  def option_response?
    self[:type] == :option
  end

  def text_response?
    self[:type] == :text
  end

  def other_option_response?
    self[:type] == :other_option
  end

end