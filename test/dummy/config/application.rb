require File.expand_path('boot', __dir__)

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'

Bundler.require(*Rails.groups)
require 'camaleon_cms'
require 'social_shortcode'

module Dummy
  class Application < Rails::Application
    config.load_defaults Rails.version.to_f
    config.root = File.expand_path('..', __dir__)
  end
end
