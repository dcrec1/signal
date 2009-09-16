require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Project do
  should_validate_presence_of :name, :url, :email
end
