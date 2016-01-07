MyBackend::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.
  config.action_mailer.default_url_options = { host: "localhost:4200" }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
#    tls: true,
    address: "mail.thesponge.eu",
    port: 25,
    domain: "mothership.thesponge.eu",
    authentication: :login,
    user_name: ENV["SMTP_USERNAME"],
    password: ENV["SMTP_PASSWORD"],
    openssl_verify_mode: "none"
  }

  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = true
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load

end
