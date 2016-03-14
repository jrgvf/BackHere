class TaskFactory

  TASKS = [
    ClientTask
  ]

  def self.build(type, params = {})
    TASKS.each do |sync|
      return sync.new(params) if sync.same_type?(type)
    end
    false
  end

  def self.find_or_initialize_by(type, params = {})
    TASKS.each do |sync|
      return sync.find_or_initialize_by(params) if sync.same_type?(type)
    end
    false
  end

  def self.define_executed_by(platform)
    
  end

end