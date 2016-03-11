Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'], network_timeout: 5, driver: :hiredis }
  # config.error_handlers << Proc.new {|ex,ctx_hash| MyErrorService.notify(ex, ctx_hash) }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'], network_timeout: 5, driver: :hiredis }
end

Sidekiq.default_worker_options = { 'backtrace' => true }