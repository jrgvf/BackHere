class Customer
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic
  include Mongoid::Multitenancy::Document

  tenant(:account)

  field :remote_id,         type: String
  field :first_name,        type: String
  field :last_name,         type: String
  field :document,          type: String
  field :is_guest,          type: Boolean,    default: false

  has_many :orders

  embeds_many :emails, cascade_callbacks: true
  embeds_many :phones, cascade_callbacks: true

  accepts_nested_attributes_for :emails, :phones

  validates_presence_of :first_name, :last_name

  validates :remote_id, uniqueness: { case_sensitive: false }, allow_blank: true
  validates_presence_of :remote_id, unless: :is_guest?

  validates :document, uniqueness: { case_sensitive: false }, allow_blank: true

  def is_guest?
    self[:is_guest]
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
