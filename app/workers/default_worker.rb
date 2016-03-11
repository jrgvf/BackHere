class DefaultWorker
  include Sidekiq::Worker

  sidekiq_options :retry => 5, :queue => :default

  # The current retry count is yielded. The return value of the block must be 
  # an integer. It is used as the delay, in seconds. 
  sidekiq_retry_in do |count|
    10 * (count + 1) # (i.e. 10, 20, 30, 40)
  end

  def perform(task_id)
    task = Task.find(task_id)
    return if task.nil?

    Mongoid::Multitenancy.with_tenant(task.account) do
      task.execute
    end
  end

end