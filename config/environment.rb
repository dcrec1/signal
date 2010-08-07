# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

MAILER = YAML.load_file("#{RAILS_ROOT}/config/mailer.yml")

Rails::Initializer.run do |config|
  
  config.time_zone = 'UTC'

  config.action_controller.page_cache_directory = RAILS_ROOT + "/public/cache"

  config.action_mailer.smtp_settings = {
    :address          => MAILER['address'],
    :port             => MAILER['port'],
    :domain           => MAILER['domain']
  }
end
