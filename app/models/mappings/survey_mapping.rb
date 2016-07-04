class SurveyMapping < Mapping

  belongs_to :survey,  inverse_of: nil

  validates_presence_of :survey

  accepts_nested_attributes_for :survey

  def statuses
    Status.where(account: account, status_type: status_type)
  end

end