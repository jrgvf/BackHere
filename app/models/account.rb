class Account
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name,              type: String
  field :email,             type: String
  field :blocked,           type: Boolean,    default: false

  has_many :sellers, dependent: :destroy
  accepts_nested_attributes_for :sellers, allow_destroy: true

  embeds_many :permissions
  accepts_nested_attributes_for :permissions, allow_destroy: true

  validates_presence_of :name, :email
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create
  validate :verify_email

  def blocked?
    blocked
  end

  def active?
    !blocked
  end

  private

  def verify_email
    result = EmailChecker.check_email(email) if email.present? && errors[:email].empty? && self.changes["email"].present?
    errors.add(:email, "precisa ser válido.") if result.present? && result["result"] == "invalid"
  end
end
