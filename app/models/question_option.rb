 class QuestionOption
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Multitenancy::Document

  tenant(:account)

  field :original_id,   type: BSON::ObjectId
  field :text,          type: String

  embedded_in :question, inverse_of: :option

  validates_presence_of :text, :original_id, allow_blank: false
  validates_uniqueness_of :original_id

  before_validation :set_original_id

  private

    def set_original_id
      self.original_id ||= self.id
    end

end