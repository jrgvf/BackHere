require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

ENV['RAILS_ADMIN_THEME'] = 'rollincode'

module BackHere
  class Application < Rails::Application

    config.autoload_paths << Rails.root.join('lib')
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{**/}', '{**/}')]

    # For don't show any logs on Console
    Mongoid.logger.level = Logger::INFO
    Mongo::Logger.logger.level = Logger::INFO

    # config.mongoid.logger = Logger.new($stdout, :warn)
    
    config.to_prepare do
      Devise::SessionsController.layout 'login'
    end

    config.serve_static_files = true

    config.relative_url_root = '/'
      
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Brasilia'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :'pt-BR'

    config.after_initialize do |app|
      app.routes.append{ get '*a', :to => 'application#not_found' } unless config.consider_all_requests_local
    end

    config.active_job.queue_adapter = :sidekiq
  end
end
