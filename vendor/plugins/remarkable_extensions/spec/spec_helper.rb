require 'rubygems'

RAILS_ENV     = 'test'
RAILS_VERSION = ENV['RAILS_VERSION'] || '2.3.2'
RSPEC_VERSION = ENV['RSPEC_VERSION'] || Spec::VERSION::STRING

# Load Rails
gem 'activesupport', RAILS_VERSION
require 'active_support'

gem 'actionpack', RAILS_VERSION
require 'action_controller'

gem 'actionmailer', RAILS_VERSION
require 'action_mailer'

gem 'rails', RAILS_VERSION
require 'rails/version'

# Load Remarkable core on place to avoid gem to be loaded
dir = File.dirname(__FILE__)
#require File.join(dir, '..', '..', 'remarkable', 'lib', 'remarkable')

# Add spec/application to load path and set view_paths
RAILS_ROOT = File.join(dir, 'application')
$:.unshift(RAILS_ROOT)

ActionController::Base.view_paths = RAILS_ROOT
require File.join(RAILS_ROOT, 'application')
require File.join(RAILS_ROOT, 'tasks_controller')

# Load Remarkable Rails
require File.join(dir, 'functional_builder')

# Load spec-rails
gem 'rspec-rails', RSPEC_VERSION
require 'spec/rails'

require 'remarkable_rails'
require File.join(dir, "..", "lib", "remarkable_extensions")

# Register folders to example groups
Spec::Example::ExampleGroupFactory.register(:action_controller, Spec::Rails::Example::ControllerExampleGroup)

Remarkable.add_locale File.join(dir, '..', 'locales', 'en.yml')
