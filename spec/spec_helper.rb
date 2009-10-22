# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)
require 'spec/autorun'
require 'spec/rails'

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
end

require File.expand_path(File.dirname(__FILE__) + '/resource_helper')
require File.expand_path(File.dirname(__FILE__) + '/shared_examples')

require "email_spec/helpers"
require "email_spec/matchers"

require 'fakefs'

def random_word
  Faker::Lorem.words(1).first
end

def build_author
  object = Git::Author.new ''
  object.stub!(:name).and_return(@author = Faker::Name.name)
  object
end

def build_commit
  object = mock(Object)
  object.stub!(:author).and_return(build_author)
  object.stub!(:message).and_return(@comment = random_word)
  object.stub!(:sha).and_return(@commit = random_word)
  object
end

def build_repo_for(project)
  @commits = [build_commit, build_commit].reverse
  Git.stub!(:open).with(project.send :path).and_return(mock(Object, :log => @commits))
end

def expect_for(command)
  Kernel.should_receive(:system).with command
end

def on_command_return(result)
  Kernel.stub!(:system).and_return(result)
end

def fail_on_command
  on_command_return false
end

def success_on_command
  on_command_return true
end

def file_exists(file, opts = {})
  File.open(file, 'w') { |f| f.write(opts[:content] || '') }
end
