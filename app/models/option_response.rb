 class OptionResponse < QuestionResponse

  field :response,  type: String
  field :option_id, type: BSON::ObjectId

  validates_presence_of   :option_id, allow_blank: false

  def self.type
    :option
  end

  def option
    self.question.options.find_by(original_id: self.option_id)
  end

  def option_response?
    true
  end

end