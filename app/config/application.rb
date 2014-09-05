require File.expand_path('../boot', __FILE__)

require 'action_controller/railtie'
require 'action_mailer/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Tester
  class Application < Rails::Application
    config.eager_load = false
    config.secret_key_base = '37ceb075066e48d67b8d409fd43e91dee4be553274d919441ecb72f930196ac5dd255eb336e59f1d18679c06ed4f7681a3a729d01aef70761d90330cfe9c537b'
  end
end
