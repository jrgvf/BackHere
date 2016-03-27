class TaskFactory

  TASKS = [
    CustomerTask, OrderTask
  ]

  def self.build(type, params = {})
    TASKS.each do |task|
      if task.same_type?(type)
        params.merge!({type: task.type})
        return task.new(params)
      end
    end
    false
  end

  def self.find_or_initialize_by(type, params = {})
    TASKS.each do |task|
      if task.same_type?(type)
        params.merge!({type: task.type})
        return task.find_or_initialize_by(params)
      end
    end
    false
  end

end