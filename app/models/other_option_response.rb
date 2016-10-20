 class OtherOptionResponse < QuestionResponse

  field :response,  type: String

  validates_presence_of   :response

  def self.type
    :other_option
  end

  def other_option_response?
    true
  end

end