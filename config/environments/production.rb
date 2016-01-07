MyBackend::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.
  config.action_mailer.default_url_options = { host: "kep.thesponge.eu" }
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

  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.log_level = :debug
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.autoflush_log = false
  config.log_formatter = ::Logger::Formatter.new
end
