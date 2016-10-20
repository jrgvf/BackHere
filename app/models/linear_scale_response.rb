 class LinearScaleResponse < QuestionResponse

  field :response,  type: Integer

  validates_presence_of   :response
  validates_inclusion_of  :response, in: :response_enum

  def self.type
    :linear_scale
  end

  def response_enum
    (0..10).to_a
  end

  def linear_scale_response?
    true
  end

end