class TaskTrigger
  include Sidekiq::Worker

  sidekiq_options retry: 1,
    queue: :cron_jobs,
    unique: :until_and_while_executing,
    run_lock_expiration: 24*60*60,
    unique_expiration: 24*60*60,
    log_duplicate_payload: true,
    failures: true

  def self.try_execute(task, delay = 0)
    return if task.nil? || already_processing?(task)
    task.job_id = Sidekiq::Client.enqueue_to_in(Platform.queue(task.platform_id), delay.seconds, TaskWorker, task.id.to_s)
    task.status = :queued
    task.save
  end

  def self.already_processing?(task)
    TaskTrigger.new().already_processing?(task)
  end

  def already_processing?(task)
    Task.where(:id.nin => [task.id], account: task.account, type: task.type, :status.in => blocked_status).count > 0
  end

  def perform
    Account.each do |account|
      Mongoid::Multitenancy.with_tenant(account) do
        waiting_tasks.each do |task|
          next if already_processing?(task)
          task.job_id = Sidekiq::Client.enqueue_to(Platform.queue(task.platform_id), TaskWorker, task.id.to_s)
          task.status = :queued
          task.save!
        end

        blocked_tasks.each do |task|
          running_job = Sidekiq::Queue.new(Platform.queue(task.platform_id)).find_job(task.job_id)
          try_execute(task) if running_job.nil?
        end
      end
    end
  end

  private

    def waiting_tasks
      Task.where(:status.in => standby_status)
    end

    def blocked_tasks
      Task.where(:status.in => blocked_status, :started_at.lte => 1.hour.ago)
    end

    def blocked_status
      [:queued, :processing, :paused]
    end

    def standby_status
      [:pending, :paused]
    end

    def finished_status
      [:successfully_finished, :finished_with_error, :finished_with_failure]
    end

end