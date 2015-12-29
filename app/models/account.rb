class Account
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name,              type: String
  field :default_email,     type: String
  field :blocked,           type: Boolean,    default: false

  has_many :sellers, dependent: :destroy
  accepts_nested_attributes_for :sellers, allow_destroy: true

  embeds_many :permissions
  accepts_nested_attributes_for :permissions, allow_destroy: true

  validates_presence_of :name, :default_email
  validates_format_of :default_email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create
  validate :verify_email

  def blocked?
    blocked
  end

  def active?
    !blocked
  end

  private

  def verify_email
    result = EmailChecker.check_email(default_email) if default_email.present? && errors[:default_email].empty? && self.changes["default_email"].present?
    errors.add(:default_email, "precisa ser válido.") if result.present? && result["result"] == "invalid"
  end
end
