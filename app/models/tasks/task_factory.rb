class TaskFactory

  TASKS = [
    CustomerTask, OrderTask, CustomerEmailVerificationTask, CustomerPhoneVerificationTask,
    CreateSurveyNotificationsTask, SendNotificationsTask
  ]

  def self.build(generic_type, params = {})
    TASKS.each do |task|
      if task.same_type?(generic_type)
        params.merge!({type: task.type})
        return task.new(params)
      end
    end
    false
  end

  def self.find_or_initialize_by(generic_type, params = {})
    TASKS.each do |task|
      if task.same_type?(generic_type)
        params.merge!({type: task.type})
        return task.find_or_initialize_by(params)
      end
    end
    false
  end


  def self.find_by_generic_type(generic_type)
    TASKS.each { |task| return task if task.same_type?(generic_type) }
  end

end