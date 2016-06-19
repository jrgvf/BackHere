class Task
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Multitenancy::Document
  include Backhere::Api::ExecutionResults

  tenant(:account)

  field :job_id,            type: String
  field :platform_id,       type: String
  field :platform_name,     type: String
  field :status,            type: Symbol,   default: :pending
  field :type,              type: Symbol
  field :iteration_index,   type: Integer,  default: 1
  field :full_task,         type: Boolean,  default: false
  field :is_visible,        type: Boolean,  default: true
  field :continue,          type: Boolean,  default: true
  field :started_at,        type: DateTime
  field :finished_at,       type: DateTime
  field :success_messages,  type: Array,    default: Array.new
  field :error_messages,    type: Array,    default: Array.new
  field :failure_messages,  type: Array,    default: Array.new

  validates_presence_of :platform_id, :platform_name, :type

  def self.type
    raise NotImplementedError
  end

  def self.generic_type
    raise NotImplementedError
  end

  def full_task?
    self[:full_task] ? "Sim" : "Não"
  end

  def self.same_type?(other_type)
    self.generic_type == other_type
  end

  def visible?
    self[:is_visible]
  end

  def self.visible?
    raise NotImplementedError
  end

  def self.task_name
    raise NotImplementedError
  end

  def task_name
    self.class.task_name
  end

  def execute
    raise NotImplementedError
  end

  private

  def started_before
    self.started_at.present?
  end

  def update_messages(execution_result)
    self.success_messages += execution_result.success_messages
    self.error_messages += execution_result.error_messages
    self.failure_messages += execution_result.failure_messages
    self.save!
  end

  def update_finished_task(execution_result, task_date_attribute = nil)
    update_messages(execution_result)

    platform = Platform.find(self.platform_id)
    finished_at = DateTime.now.in_time_zone('Brasilia')

    if all_successful?
      status = :successfully_finished
      platform.update_attributes!({ task_date_attribute => self.started_at.in_time_zone(platform.time_zone) }) unless task_date_attribute.nil?
    elsif has_error?
      status = :finished_with_error
    else
      status = :finished_with_failure
      platform.update_attributes!({ task_date_attribute => self.started_at.in_time_zone(platform.time_zone) }) unless task_date_attribute.nil?
    end

    self.finished_at = finished_at
    self.status = status
    self.save
  end

  private

  def all_successful?
    self.error_messages.count == 0 && self.failure_messages.count == 0
  end

  def has_error?
    self.error_messages.count > 0
  end
end