class HomeMessage
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :email, type: String
  field :fone, type: Integer
  field :message, type: String

  validates_presence_of :name, :email, :message
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create
  validates :fone, numericality: true, length: { minimum: 10, maximum: 12 }, allow_blank:true
  validates_uniqueness_of :message, scope: [:email, :name]

  validate :unique_errors

  private

    def unique_errors
      errors.messages.each do |field, erro|
        erro.uniq!
        erro.pop while erro.count > 1
      end
    end

end