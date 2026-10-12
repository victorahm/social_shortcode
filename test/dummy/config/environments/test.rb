Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  config.cache_classes = true
  config.eager_load = true
  config.log_level = :warn
  config.public_file_server.enabled = true
  config.static_cache_control = 'public, max-age=3600'

  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.assets.check_precompiled_asset = false

  config.action_dispatch.show_exceptions = :none
  config.action_controller.allow_forgery_protection = false
  config.action_mailer.delivery_method = :test

  config.active_support.test_order = :random
  config.active_support.deprecation = :stderr
end
