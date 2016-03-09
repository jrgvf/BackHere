class Customer
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic
  include Mongoid::Multitenancy::Document

  tenant(:account)

  field :remote_id,         type: String
  field :name,              type: String

  embeds_many :emails, cascade_callbacks: true
  embeds_many :phones, cascade_callbacks: true

  accepts_nested_attributes_for :emails, :phones

  validates_presence_of :remote_id, :name

  ##
  # Create a dynamic attributes for customer.
  #
  # @param [ Hash { Symbol => String } ] dynamic_attributes - The Hash of dynamic attributes.
  #
  # @example customer.create_dynamic_attributes({ :first_name => "Jorge", :last_name => "Rodrigues" })
  #
  # @return [ Boolean ] - Result of save object before actions.
  def create_dynamic_attributes(dynamic_attributes = {})
    dynamic_attributes.reject! { |attribute, value| black_listed_attributes.include?(attribute) }
    dynamic_attributes.each { |attribute, value| self[attribute] = value }
    self.save
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
    self.save
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
      :emails,
      :phones,
      :email,
      :phone,
      :_id
    ]
    black_list | other_attributes
  end

end
