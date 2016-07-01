require 'autoinc'

class Account
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps
  include Mongoid::Autoinc
  
  field :name,              type: String
  field :default_email,     type: String
  field :blocked,           type: Boolean,    default: false
  field :aggregate_id,      type: Integer

  increments :aggregate_id, seed: 100

  has_mongoid_attached_file :logo,
    :styles => {
      :logo  => '234x234'
    },
    :convert_options => { :all => '-background white -flatten +matte' }

  validates_attachment_content_type :logo, content_type: ["image/jpg", "image/jpeg", "image/png"]

  has_many :users, dependent: :destroy
  accepts_nested_attributes_for :users, allow_destroy: true

  has_many :platforms, dependent: :destroy
  accepts_nested_attributes_for :platforms, allow_destroy: true

  embeds_many :permissions
  accepts_nested_attributes_for :permissions, allow_destroy: true

  embeds_many :social_infos
  accepts_nested_attributes_for :social_infos, allow_destroy: true

  validates_presence_of :name, :default_email, :logo
  validates :name, length: { maximum: 20 }
  validates_uniqueness_of :aggregate_id
  validates_format_of :default_email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create
  validate :verify_email

  after_validation :clean_paperclip_errors

  scope :actives,    -> { where(blocked: false) }
  scope :inactives,  -> { where(blocked: true) }

  rails_admin do
    configure :platforms do
      read_only true
    end
  end

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

  def clean_paperclip_errors
    errors.delete(:logo)
  end
end
