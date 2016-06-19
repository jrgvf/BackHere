class TaskTrigger
  include Sidekiq::Worker

  sidekiq_options retry: 1,
    queue: :cron_jobs,
    unique: :while_executing,
    run_lock_expiration: 24*60*60,
    log_duplicate_payload: true,
    failures: true

  def self.try_execute(task_id, delay = 0)
    task = Task.find_by(id: task_id)
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
        try_reload_losted_tasks if slow_tasks.count > 0
      end
    end
  end

  def try_reload_losted_tasks
    workers = Sidekiq::Workers.new
    jobs_id = workers.map { |process_id, thread_id, work| work["payload"]["jid"] } if workers.size > 0

    slow_tasks.each do |task|
      queued_job = Sidekiq::Queue.new(Platform.queue(task.platform_id)).find_job(task.job_id).present?
      running_job = Array.wrap(jobs_id).include?(task.job_id)

      if !queued_job && !running_job
        task.status = :pending
        task.save!
        TaskTrigger.try_execute(task.id)
      end
    end
  end

  private

    def waiting_tasks
      Task.where(:status.in => standby_status).asc(:id)
    end

    def slow_tasks
      Task.where(:status.in => [:queued, :processing], :started_at.lte => 1.hour.ago).asc(:id)
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