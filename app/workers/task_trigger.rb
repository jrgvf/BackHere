class TaskTrigger
  include Sidekiq::Worker

  sidekiq_options :retry => 1, :queue => :cron_jobs

  def self.try_execute(task)
    return if task.nil? || already_processing?(task)
    task.job_id = Sidekiq::Client.enqueue(task.executed_by, task.id.to_s)
    task.status = :queued
    task.save
  end

  def self.already_processing?(task)
    TaskTrigger.new().already_processing?(task)
  end

  def already_processing?(task)
    Task.where(account: task.account, type: task.type, :status.in => running_status).count > 0
  end

  def perform
    Account.each do |account|
      Mongoid::Multitenancy.with_tenant(account) do
        tasks_waiting.each do |task|
          next if already_processing?(task)
          task.job_id = Sidekiq::Client.enqueue(task.executed_by, task.id.to_s)
          task.status = :queued
          task.save
        end
      end
    end
  end

  private

    def tasks_waiting
      Task.where(:status.in => waiting_status)
    end

    def running_status
      [:queued, :processing]
    end

    def waiting_status
      [:pending]
    end

end