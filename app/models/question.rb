 class Question
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Multitenancy::Document

  tenant(:account)

  field :text,            type: String
  field :type,            type: Symbol
  field :other_option,    type: Boolean,    default: false

  embeds_many :options, class_name: "QuestionOption", cascade_callbacks: true
  accepts_nested_attributes_for :options, reject_if: :all_blank, allow_destroy: true

  belongs_to :survey

  validates_presence_of :text, allow_blank: false
  validates_inclusion_of :type, in: :type_values

  validates_presence_of :options, if: :allow_options?
  before_save :clear_options, unless: :allow_options?

  def other_option_enum
    [["Sim", true], ["Não", false]]
  end

  def type_enum
    [
      ["Resposta curta", :short_answer],
      ["Resposta longa", :long_answer],
      ["Múltipla escolha", :multi_choice],
      ["Única escolha", :choice]
      # ["Escala linear", :linear_scale]
      # ["Lista suspensa", :list_select],
      # ["Grade de múltipla escolha", :grad_multi_choice],
      # ["Data", :date],
      # ["Horário", :time],
      # ["Data e horário", :date_time]
    ]
  end

  def self.type_enum
    new().type_enum
  end

  def self.other_option_enum
    new().other_option_enum
  end

  def self.type_values
    type_enum.map(&:last)
  end

  def with_options?
    allow_options?
  end

  def without_options?
    !with_options?
  end

  def include_other_option?
    self[:other_option]
  end

  Question.type_values.each do |type|
    define_method("#{type}?") do
      type == self.type
    end
  end

private

  def allow_options?
    [:multi_choice, :choice, :linear_scale].include?(self[:type])
  end

  def type_values
    type_enum.map(&:last)
  end

  def clear_options
    self.options.delete_all
  end

end