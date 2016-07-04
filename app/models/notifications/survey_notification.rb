class SurveyNotification < Notification

  belongs_to :survey

  validates_presence_of :survey

end