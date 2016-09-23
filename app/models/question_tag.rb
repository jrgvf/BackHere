 class QuestionTag
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Multitenancy::Document

  tenant(:account)

  field :name,          type: String

  belongs_to :tag,       inverse_of: nil
  embedded_in :question, inverse_of: :tag

  validates_presence_of :name, :tag_id, allow_blank: false

  before_validation :find_or_create_tag

  private

    def find_or_create_tag
      return unless self.tag_id.nil?
      self.tag = Tag.find_or_create_by!({name: self.name})
    end

end