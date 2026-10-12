Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.action_dispatch.show_exceptions = :none
  config.action_controller.allow_forgery_protection = false
  config.active_support.deprecation = :notify
  config.log_level = :error
end
