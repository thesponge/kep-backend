source 'https://rubygems.org'

gem 'bundler'
gem 'rails', '4.2.0'
gem 'rails-api'
gem 'active_model_serializers', '0.9.3'
gem 'ffaker'
gem 'devise', '~>3.4.1'
gem 'sidekiq', '~>3.4.0'
gem 'sidekiq-superworker'
#For sidekiq web interface
gem 'sinatra', require: false

gem 'exception_handler'
gem 'figaro'
gem 'seed-fu', '~> 2.3'
gem 'geocoder'
gem 'public_activity'
#For the list of languages in language model
gem 'language_list'
#For cors operations
gem 'rack-cors'
gem 'mina'
gem 'wisper'
gem 'state_machines-activerecord'
gem 'addressable'

group :development do
  gem 'byebug'
  gem 'sqlite3'
  gem 'pry-rails'
  gem 'rails-erd'
end


group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :test do
  gem "rspec-rails"
  gem "factory_girl_rails"
  gem 'capybara'
#  gem 'debugger'
  gem "shoulda-matchers"
end


gem 'pg', group: :production
gem 'rails_12factor', group: :production
