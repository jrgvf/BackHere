Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'], network_timeout: 5, driver: :hiredis, size: 2 }
  # config.error_handlers << Proc.new {|ex,ctx_hash| MyErrorService.notify(ex, ctx_hash) }

  schedule_file = "config/schedule.yml"
  if File.exists?(schedule_file)
    Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'], network_timeout: 5, driver: :hiredis, size: 1 }
end

Sidekiq.default_worker_options = { 'backtrace' => true }