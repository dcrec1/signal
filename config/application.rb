require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module SignalCI
  class Application < Rails::Application
    MAILER = YAML.load_file Rails.root.join("config/mailer.yml")
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.action_controller.page_cache_directory = Rails.root.join("public/cache")
    config.action_mailer.smtp_settings = {
      :address          => MAILER['address'],
      :port             => MAILER['port'],
      :domain           => MAILER['domain'],
      :enable_starttls_auto => false
    }
  end
end
