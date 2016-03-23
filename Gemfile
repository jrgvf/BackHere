source 'https://rubygems.org'

  #ruby '2.2.0'                                                                                     # A Ruby version for Heroku
  
  gem 'rails', '4.2.0'                                                                              # Bundle edge Rails instead: gem 'rails', github: 'rails/rails'

# Gems for General Use
  gem 'faraday', '~> 0.9.2'                                                                         # Faraday for communication with API REST
  gem 'savon', '~> 2.0'                                                                             # Savon for communication with API SOAP
  gem 'devise', '~> 3.5', '>= 3.5.2'                                                                # Devise for Generate users access
  gem 'rails_admin', '~> 0.7.0'                                                                     # For Admin Control
  gem 'sdoc', '~> 0.4.0', group: :doc                                                               # bundle exec rake doc:rails generates the API under doc/api.
  gem 'jbuilder', '~> 2.0'                                                                          # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
  gem 'simplecov', :require => false, :group => :test                                               # For generate resume to tests
  gem 'newrelic_rpm'                                                                                # Gem for support NewRelic
  gem "figaro"                                                                                      # Gem for support for ENV
  # gem 'axlsx', '~> 2.0', '>= 2.0.1'                                                               # For generate xlsx files
  gem 'aws-sdk', '~> 1.3.4'                                                                         # SDK with custom features of AWS
  gem 'sidekiq'                                                                                     # For use Sidekiq
  gem "sidekiq-cron"                                                                                # Scheduler for Sidekiq
  gem 'sinatra', :require => nil                                                                    # For Sidekiq Web UI
  gem 'redis'                                                                                       # For use Redis
  gem "hiredis"                                                                                     # Driver for Redis communication

# Gems For MongoDB Support
  gem 'mongoid', '~> 5.0.0'                                                                         # For integration with MongoDB
  gem 'mongoid-multitenancy', '~> 1.1', '>= 1.1.2'                                                  # For Multitenanty with Mongoid
  gem "mongo_session_store-rails4"                                                                  # For store Sessions into MongoDB
  # gem 'mongoid_search', '~> 0.3.2'                                                                # For simplify search text with MongoID
  # gem 'mongoid_slug', '~> 4.0'                                                                    # For a use Slug with MongoID
  # gem 'mongoid-history', '~> 0.5.0'                                                               # For version control of models
  gem "mongoid-paperclip", :require => "mongoid_paperclip"                                          # For use paperclip with MongoID
  # gem 'mongoid-rspec', '3.0.0'                                                                    # For matchers of MongoID
  # gem 'mongoid_relations_dirty_tracking', github: 'versative/mongoid_relations_dirty_tracking'    # For verify relations changes
  gem "will_paginate_mongoid"                                                                       # For will_paginate with mongoid
  
# For use CanCan for manage permissions
  gem 'cancancan', '~> 1.10'                                                                        # For Permissions

# Gems For Assets
  gem 'bootstrap-sass', '~> 3.3', '>= 3.3.5.1'                                                      # For use Bootstrap (Unnecessary because adminlte2 use bootstrap)
  gem 'simple_form', '~> 3.2'                                                                       # For create forms
  gem 'font-awesome-sass', '~> 4.4.0'                                                               # For use FontAwesome
  gem 'adminlte2-rails'                                                                             # For use AdminTLE Template ~> https://almsaeedstudio.com/
  gem 'sass-rails', '~> 5.0'                                                                        # Use SCSS for stylesheets
  gem 'uglifier', '>= 1.3.0'                                                                        # Use Uglifier as compressor for JavaScript assets
  gem 'coffee-rails', '~> 4.1.0'                                                                    # Use CoffeeScript for .coffee assets and views
  gem 'therubyracer', platforms: :ruby                                                              # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'jquery-rails'                                                                                # Use jquery as the JavaScript library
  gem 'turbolinks'                                                                                  # Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
  gem 'jquery-turbolinks', '~> 2.1'                                                                 # For resolve problem with turbolinks and jquery
  gem 'bootbox-rails', '~> 0.5.0'                                                                   # For easy and custom Prompt
  gem 'icheck-rails'                                                                                # For use iCheck in Rails
  gem 'ionicons-rails'                                                                              # For use Ion Icons in Rails
  gem 'jquery-slimscroll-rails'                                                                     # For use SlimScroll in Rails
  gem 'jquery-ui-rails'                                                                             # For use JQueryUI in Rails
  # gem 'htmlentities', '~> 4.3', '>= 4.3.4'                                                        # For encode and decode String safety for html
  # gem 'rails-html-sanitizer', '~> 1.0', '>= 1.0.2'                                                # For sanitizer html
  # gem 'nprogress-rails', '~> 0.1.6.7'                                                             # For progress bar using ajax
  # gem 'select2-rails', '~> 4.0'                                                                   # For Jquery select field


# Gems For Tests and Development
group :development, :test do
  gem 'rspec-rails', '~> 3.0'                                                                       # For create tests
  gem 'capybara'                                                                                    # For create testes using browser
  gem 'selenium-webdriver', '~> 2.48', '>= 2.48.1'                                                  # For support use  js: true in tests
  gem 'timecop', '~> 0.8.0'                                                                         # For freeze time in tests
  gem 'factory_girl_rails', '~> 4.5'                                                                # For create factores
  gem 'database_cleaner', '~> 1.5', '>= 1.5.1'                                                      # For clear database in tests
  gem 'pry-rails', '~> 0.3.4'                                                                       # For debugger
  gem 'pry-byebug', '~> 3.3'                                                                        # For debugger
  gem 'web-console', '~> 2.0'                                                                       # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'spring'                                                                                      # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'byebug'                                                                                    # Call 'byebug' anywhere in the code to stop execution and get a debugger console
end

# Gems For Development
group :development do
  gem 'flay'                                                                                        # For DRY!
  gem 'better_errors', '~> 2.1', '>= 2.1.1'                                                         # For show better errors
end

# Gems For Production
group :production do
  gem 'rails_12factor', '>= 0.0.2'
  gem "passenger"
end

# Other Gems Suggest of Rails
  # gem 'bcrypt', '~> 3.1.7'                                                                        # Use ActiveModel has_secure_password
  # gem 'unicorn'                                                                                   # Use Unicorn as the app server
  # gem 'capistrano-rails', group: :Development                                                     # Use Capistrano for deployment
