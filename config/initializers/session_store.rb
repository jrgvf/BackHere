# Be sure to restart your server when you modify this file.

# Rails.application.config.session_store :cookie_store, key: '_back-here_session'

# For Session Storage With MongoID
# Rails.application.config.session_store :mongoid_store , {
#   expire_after: 2.hours
# }

# For Session Storage With Redis
Rails.application.config.session_store :redis_store , servers: {
  host: ENV['REDIS_HOST'],
  port: 6379,
  db: 0,
  password: ENV['REDIS_PASSWORD'],
  namespace: "backhere:session",
  driver: :hiredis
},
expires_in: 60.minutes