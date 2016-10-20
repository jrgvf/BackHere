 class TextResponse < QuestionResponse

  field :response,  type: String

  validates_presence_of   :response

  def self.type
    :text
  end

  def text_response?
    true
  end

end