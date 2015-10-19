require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module MyBackend
  class Application < Rails::Application

    # don't generate RSpec tests for views and helpers
  config.generators do |g|
    g.test_framework :rspec, fixture: true
    g.fixture_replacement :factory_girl, dir: 'spec/factories'
    g.view_specs false
    g.helper_specs false
    g.stylesheets = false
    g.javascripts = false
    g.helper = false
  end

  config.autoload_paths += %W(#{config.root}/lib)

  config.middleware.insert 0, Rack::Cors do
    allow do
      origins "*"
      resource "*", headers: :any, methods: [:get, :post, :put, :patch, :delete, :options]
    end
  end

  config.active_job.queue_adapter = :sidekiq
  config.active_record.raise_in_transactional_callbacks = true
  config.action_mailer.raise_delivery_errors = true
  config.time_zone = 'UTC'

  end
end
