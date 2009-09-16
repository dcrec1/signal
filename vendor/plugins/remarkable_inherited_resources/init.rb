if RAILS_ENV == "test"

  require 'remarkable_activerecord'

  require File.join(File.dirname(__FILE__), "lib", "remarkable_inherited_resources")

  require 'spec'
  require 'spec/rails'

  Remarkable.include_matchers!(Remarkable::InheritedResources, Spec::Rails::Example::ModelExampleGroup)

end