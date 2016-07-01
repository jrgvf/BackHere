class Status
  include Mongoid::Document
  include Mongoid::Multitenancy::Document

  tenant(:account)

  field :code,            type: String
  field :label,           type: String

  belongs_to :status_type, inverse_of: nil

  validates_presence_of :code, :label, :status_type
  validates :code, uniqueness: { scope: [:account] }

  accepts_nested_attributes_for :status_type

  after_initialize :set_status_type

  def type
    status_type.code
  end

  def orders
    Order.where(status: self)
  end

  private

    def set_status_type
      if self.status_type.nil?
        self.status_type = StatusType.find_by(code: :undefined)
        self.save
      end
    end

end