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

  has_many :questions

  has_many :answers, class_name: "SurveyAnswer"

  has_many :notifications, class_name: "SurveyNotification"

  validates_presence_of :name, :description, :active, :questions, allow_blank: false
  validates :name, uniqueness: { scope: [:account], case_sensitive: false }

  after_validation :handle_post_validation

  scope :actives,    -> { where(active: true) }
  scope :inactives,  -> { where(active: false) }

  def active_enum
    [["Ativo", true], ["Inativo", false]]
  end

  def active?
    self[:active]
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