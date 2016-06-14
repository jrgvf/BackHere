class StatusHistory
  include Mongoid::Document

  field :tracking_date,     type: DateTime
  field :remote_status,     type: String
  field :comment,           type: String

  embedded_in :order, inverse_of: :tracking

  validates_presence_of :tracking_date, :remote_status

end