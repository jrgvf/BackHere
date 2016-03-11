class TaskFactory

  SYNCS = [
    ClientTask
  ]

  def self.build(type, params = {})
    SYNCS.each do |sync|
      return sync.new(params) if sync.same_type?(type)
    end
    false
  end

  def self.find_or_initialize_by(type, params = {})
    SYNCS.each do |sync|
      return sync.find_or_initialize_by(params) if sync.same_type?(type)
    end
    false
  end

end