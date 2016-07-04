class ResponseMessage
  include Mongoid::Document

  field :external_id,   type: String
  field :number,        type: String
  field :short_code,    type: String
  field :body,          type: String
  field :received,      type: DateTime

  embedded_in :message, inverse_of: :response

  validates_presence_of   :external_id, :number, :body, :received

end