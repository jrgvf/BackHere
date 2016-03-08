class Seller
  include Mongoid::Document
  include Mongoid::Paperclip
  include Mongoid::Timestamps
  include Mongoid::Multitenancy::Document
  include Backhere::CurrentUserHelper

  belongs_to :account
  # For define tenant
  tenant(:account)

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :recoverable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  # field :reset_password_token,   type: String
  # field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Custom fields
  field :name,               type: String
  field :position,           type: String

  has_mongoid_attached_file :avatar,
    :styles => {
      :profile  => '160x160'
    },
    :convert_options => { :all => '-background white -flatten +matte' }

  # For remover image in Rails_Admin
  attr_accessor :delete_avatar
  before_validation { self.avatar.clear if self.delete_avatar == '1' }

  validates_attachment_content_type :avatar, content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  validates :name, presence: true

  validates :position, presence: true, length: { maximum: 30 }

  after_validation :clean_paperclip_errors

  private

    def clean_paperclip_errors
      errors.delete(:avatar)
    end

end