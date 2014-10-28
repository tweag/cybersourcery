require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

require 'slim-rails'
require 'bootstrap-sass'
require 'simple_form'
require 'sass-rails'
require 'coffee-rails'
require 'jquery-rails'
require 'dotenv-rails'

Bundler.require(*Rails.groups)

# For a typical rails app this line is not needed.
# It's only needed here because dotenv-rails is looking for it in the gem root, not spec/demo.
# By default the proxy servers started in the rake task *will* automatically find it in spec/demo.
Dotenv.load "spec/demo/.env" if defined? Dotenv

module Demo
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end

