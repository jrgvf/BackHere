class TaskWorker
  include Sidekiq::Worker

  sidekiq_options retry: 2,
    unique: :until_and_while_executing,
    run_lock_expiration: 24*60*60,
    unique_expiration: 24*60*60,
    log_duplicate_payload: true,
    failures: true

  # The current retry count is yielded. The return value of the block must be 
  # an integer. It is used as the delay, in seconds. 
  sidekiq_retry_in do |count|
    10 * (count + 1) # (i.e. 10, 20, 30, 40)
  end

  def perform(task_id)
    task = Task.find(task_id)
    return if task.nil? || finished_status.include?(task.status)

    Mongoid::Multitenancy.with_tenant(task.account) do
      task.execute
      TaskTrigger.try_execute(task, 10) unless finished_status.include?(task.status)
    end
  end

  private

    def finished_status
      [:successfully_finished, :finished_with_error, :finished_with_failure]
    end

end