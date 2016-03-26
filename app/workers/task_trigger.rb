class TaskTrigger
  include Sidekiq::Worker

  sidekiq_options :retry => 1, :queue => :cron_jobs

  def self.try_execute(task)
    return if task.nil? || already_processing?(task, [:paused])
    task.job_id = Sidekiq::Client.enqueue_to(Platform.queue(task.platform_id), TaskWorker, task.id.to_s)
    task.status = :queued
    task.save
  end

  def self.already_processing?(task, others_statuses = [])
    TaskTrigger.new().already_processing?(task, others_statuses)
  end

  def already_processing?(task, others_statuses = [])
    Task.where(account: task.account, type: task.type, :status.in => (blocked_statuses | others_statuses)).count > 0
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
      end
    end
  end

  private

    def waiting_tasks
      Task.where(:status.in => standby_statuses)
    end

    def blocked_statuses
      [:queued, :processing]
    end

    def standby_statuses
      [:pending, :paused]
    end

end