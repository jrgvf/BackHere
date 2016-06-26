class Notification
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Multitenancy::Document
  include ActiveModel::SecureToken

  tenant(:account)

  field :status,    type: Symbol,   default: :pending
  field :token,     type: String
  field :services,  type: Array
  field :type,      type: Symbol

  belongs_to :order
  belongs_to :customer
  belongs_to :status_type,       inverse_of: nil

  has_secure_token :token

  validates_uniqueness_of :token
  validates_presence_of   :order, :customer, :status_type, :services, :type
  validates_inclusion_of  :status,  in: :status_enum

  scope :pending,  -> { where(status: :pending) }
  scope :answered, -> { where(status: :answered) }

  def status_enum
    [:pending, :sent, :answered, :error]
  end

  def self.status_enum
    new().status_enum
  end

  def status_name
    status_names[self[:status]]
  end

  def of_email?
    self[:services].include?("email")
  end

  def of_sms?
    self[:services].include?("sms")
  end

  Notification.status_enum.each do |status|
    define_method("#{status}?") do
      status == self.status
    end
  end

  private

    def status_names
      {
        pending:  "Envio Pendente",
        sent:     "Enviado",
        answered: "Respondida",
        error:    "Erro"
      }
    end

end