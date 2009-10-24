# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] ||= "cucumber"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'cucumber/rails/world'

# Comment out the next line if you don't want Cucumber Unicode support
require 'cucumber/formatter/unicode'

require 'webrat'
require 'cucumber/webrat/element_locator' # Lets you do table.diff!(element_at('#my_table_or_dl_or_ul_or_ol').to_table)

Webrat.configure do |config|
  config.mode = :rails
end

require 'cucumber/rails/rspec'
require 'webrat/core/matchers'

require 'spec/stubs/cucumber'

Before do
  Kernel.stub!(:system)
  repo = Git.open RAILS_ROOT
  Git.stub!(:open).and_return(repo)
  File.open(RAILS_ROOT + "/tmp/whatever", 'w') { |f| f.write "fqwfwefwejkiwegw" }
end
