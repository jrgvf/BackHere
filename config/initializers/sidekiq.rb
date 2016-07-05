Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'], password: ENV['REDIS_PASSWORD'], network_timeout: 5, driver: :hiredis }
  # config.error_handlers << Proc.new {|ex,ctx_hash| MyErrorService.notify(ex, ctx_hash) }

  schedule_file = "config/schedule.yml"
  if File.exists?(schedule_file)
    Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'], password: ENV['REDIS_PASSWORD'], network_timeout: 5, driver: :hiredis }
end

Sidekiq.default_worker_options = { 'backtrace' => true }

Sidekiq::Statistic.configure do |config|
  config.log_file = 'log/sidekiq.log'
end