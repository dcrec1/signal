if RAILS_ENV == "test"

  require 'spec'
  require 'spec/rails'
  require 'remarkable_rails'

Remarkable.add_locale RAILS_ROOT + "/vendor/plugins/remarkable_extensions/locales/en.yml"
Remarkable.add_locale RAILS_ROOT + "/vendor/plugins/remarkable_extensions/locales/pt.yml"

  require File.join(File.dirname(__FILE__), "lib", "remarkable_extensions")
end
