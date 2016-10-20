class QuestionResponseFactory

  QUESTION_RESPONSES = [
    OptionResponse, OtherOptionResponse, TextResponse, LinearScaleResponse
  ]

  def self.build(answer, type, params = {})
    QUESTION_RESPONSES.each do |response_class|
      return answer.responses.build(params, response_class) if response_class.same_type?(type)
    end
    false
  end

end