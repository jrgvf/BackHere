class Message
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Multitenancy::Document

  tenant(:account)

  field :identifier,    type: String
  field :external_id,   type: String
  field :type,          type: Symbol
  field :status,        type: String
  field :status_code,   type: String
  field :description,   type: String
  field :operator,      type: String

  belongs_to :notification

  embeds_many :responses, class_name: "ResponseMessage", cascade_callbacks: true

  validates_presence_of   :identifier, :type, :status
  validates_presence_of   :external_id, if: :of_sms?

  validates_inclusion_of  :type,        in: :type_enum
  validates_inclusion_of  :status,      in: :status_enum

  scope :of_email, -> { where(type: :email) }
  scope :of_sms,   -> { where(type: :sms) }

  def type_enum
    [:email, :sms]
  end

  def status_enum
    Message.sent_statuses + Message.not_sent_statuses
  end

  def of_sms?
    self[:type] == :sms
  end

  def sent?
    Message.sent_statuses.include?(self[:status])
  end

  def self.sent_statuses
    [ "Ok", "Scheduled", "Sent", "Delivered", "Not Received", "Blocked", "Error" ]
  end

  def self.not_sent_statuses
    [ "Failure Sent", "Erro Sent" ]
  end

end