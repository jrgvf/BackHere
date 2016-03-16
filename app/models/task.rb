class Task
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Multitenancy::Document
  include Backhere::Api::ExecutionResults

  tenant(:account)

  field :platform_id,       type: String
  field :platform_name,     type: String
  field :status,            type: Symbol,   default: :pending
  field :type,              type: Symbol
  field :full_task,         type: Boolean,  default: false
  field :is_visible,        type: Boolean,  default: true
  field :executed_by,       type: String
  field :started_at,        type: DateTime
  field :finished_at,       type: DateTime
  field :success_messages,  type: Array,    default: Array.new
  field :error_messages,    type: Array,    default: Array.new
  field :failure_messages,  type: Array,    default: Array.new

  validates_presence_of :platform_id, :platform_name, :executed_by, :type

  def self.type
    raise NotImplementedError
  end

  def self.same_type?(other_type)
    self.type == other_type
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
    Task.task_name
  end

  def execute
    raise NotImplementedError
  end

  def executed_by
    self[:executed_by].constantize
  end

  private

  def update_finished_task(execution_result)
    finished_at = DateTime.now.in_time_zone('Brasilia')

    if execution_result.all_successful?
      status = :successfully_finished
    elsif execution_result.has_error?
      status = :finished_with_error
    else
      status = :finished_with_failure
    end

    self.finished_at = finished_at
    self.status = status
    self.success_messages += execution_result.success_messages
    self.error_messages += execution_result.error_messages
    self.failure_messages += execution_result.failure_messages
    self.save!     
  end
end