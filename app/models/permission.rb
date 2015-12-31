class Permission
  include Mongoid::Document
  
  embedded_in :account

  field :subject,       type: String
  field :action,        type: String, default: "manage"

  validates_presence_of :subject, :action

  def name
    subject
  end

  def subject_enum
    ["Magento", "BetaTest"]
  end

  def action_enum
    ["manage", "create", "edit", "destroy"]
  end

  def model_exists?
    !subject.blank? && Rails.const_defined?(subject.to_sym)
  end

end
