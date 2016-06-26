 class Survey
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Multitenancy::Document
  include Mongoid::Slug

  tenant(:account)

  field :name,          type: String
  slug  :name, scope: :account, max_length: 24

  field :description,   type: String
  field :active,        type: Boolean,    default: true

  has_many :questions, dependent: :destroy
  accepts_nested_attributes_for :questions, reject_if: :all_blank, allow_destroy: true

  has_many :answers, class_name: "SurveyAnswer"

  has_many :notifications, class_name: "SurveyNotification"

  validates_presence_of :name, :description, :active, :questions, allow_blank: false
  validates_uniqueness_of :name, case_sensitive: false

  after_validation :handle_post_validation

  scope :actives,    -> { where(active: true) }
  scope :inactives,  -> { where(active: false) }

  def active_enum
    [["Ativo", true], ["Inativo", false]]
  end

  private

    def handle_post_validation
      if self.errors[:questions].present?
        
        self.questions.each do |question|
          question.errors.each{ |attr,msg| self.errors.add(attr, msg) }
          self.errors.delete(:questions) unless question.errors.blank?
        end
      end
    end

end