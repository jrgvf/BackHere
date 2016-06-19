class Customer
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic
  include Mongoid::Multitenancy::Document

  tenant(:account)

  field :remote_id,         type: String
  field :imported_from,     type: String
  field :first_name,        type: String
  field :last_name,         type: String
  field :document,          type: String
  field :date_of_birth,     type: Date
  field :is_guest,          type: Boolean,    default: false

  embeds_many :emails, cascade_callbacks: true
  embeds_many :phones, cascade_callbacks: true

  accepts_nested_attributes_for :emails, :phones

  validates_presence_of :first_name, :last_name

  validates :remote_id, uniqueness: { scope: :imported_from, case_sensitive: false }, allow_blank: true
  validates_presence_of :remote_id, unless: :is_guest?

  validates :document, uniqueness: { scope: :imported_from, case_sensitive: false }, allow_blank: true
  

  def self.with_unchecked_email
    self.elem_match(emails: {verified: false})
  end

  def self.with_unchecked_phone
    self.elem_match(phones: {verified: false})
  end

  def self.with_valid_email
    self.elem_match(emails: {is_valid: true})
  end

  def self.with_valid_phone
    self.elem_match(phones: {is_valid: true})
  end

  def self.with_valid_mobile_phone
    self.elem_match(phones: {is_valid: true, is_mobile: true})
  end

  def self.with_invalid_email
    self.elem_match(emails: {verified: true, is_valid: false})
  end

  def self.with_invalid_phone
    self.elem_match(phones: {verified: true, is_valid: false})
  end

  def self.available_for_surveys
    self.or(self.with_valid_email.selector, self.with_valid_mobile_phone.selector)
  end

  def orders
    Order.where(customer: self)
  end

  def is_guest?
    self[:is_guest]
  end

  def imported_name
    Platform.find_by(id: self[:imported_from])&.name
  end

  def dynamic_attributes
    self.attributes.symbolize_keys.reject { |attribute, value| black_listed_attributes.include?(attribute) }
  end

  ##
  # Mount a customer name
  #
  # @return [ String ] - Result of concat first_name with last_name
  def name
    "#{first_name} #{last_name}"
  end

  ##
  # Fill a dynamic attributes for customer.
  #
  # @param [ Hash { Symbol => String } ] dynamic_attributes - The Hash of dynamic attributes.
  #
  # @example customer.fill_dynamic_attributes({ :first_name => "Jorge", :last_name => "Rodrigues" })
  #
  # @return [ Boolean ] - Result of save object before actions.
  def fill_dynamic_attributes(dynamic_attributes = {})
    dynamic_attributes.reject! { |attribute, value| black_listed_attributes.include?(attribute) }
    dynamic_attributes.each { |attribute, value| self[attribute] = value }
    true
  end

  ##
  # Remove batch of attributes.
  #
  # @param [ Array of Symbols ] attribute - Array with names of attributes for remove.
  #
  # @example customer.remove_attributes([:first_name, :last_name])
  #
  # @return [ Boolean ] - Result of save object before actions.
  def remove_attributes(attributes = [])
    attributes.each { |attribute| self.remove_attribute(attribute) }
    self.save!
  end

  private

  ##
  # List of attributes name to reject.
  #
  # @param [ Array of Symbols ] other_attributes - Array with names of other attributes to reject.
  #
  # @example nothing - It's a private method, see call in create_dynamic_attributes.
  #
  # @return [ Array ] - Array with names of attributes for reject.
  def black_listed_attributes(other_attributes = [])
    black_list = [
      :remote_id,
      :imported_from,
      :first_name,
      :last_name,
      :emails,
      :phones,
      :account_id,
      :created_at,
      :updated_at,
      :is_guest,
      :document,
      :_id
    ]
    black_list | other_attributes
  end

end
