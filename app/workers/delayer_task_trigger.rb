class DelayerTaskTrigger
  include Sidekiq::Worker

  sidekiq_options retry: 1,
    queue: :cron_jobs,
    unique: :while_executing,
    run_lock_expiration: 24*60*60,
    log_duplicate_payload: true,
    failures: true

  def perform
    return
    DelayerTask.run_all
  end

end